import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._dioClient, this._supabaseClient);

  final DioClient _dioClient;
  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

  static const String _supabaseUrl =
      String.fromEnvironment('SUPABASE_URL');

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String content,
    required String sessionId,
    required String userId,
    String? provider,
  }) async {
    try {
      // Fetch existing history to build the messages array for the Edge Function
      final historyData = await _supabaseClient
          .from('chat_messages')
          .select()
          .eq('session_id', sessionId)
          .order('created_at');

      final history = (historyData as List<dynamic>)
          .map((row) => _rowToMessage(row as Map<String, dynamic>))
          .toList();

      // Call AI proxy edge function with the correct contract
      final response = await _dioClient.dio.post<Map<String, dynamic>>(
        '$_supabaseUrl/functions/v1/ai-proxy',
        data: {
          'feature': 'chat',
          'messages': [
            ...history.map((m) => {'role': m.role, 'content': m.content}),
            {'role': 'user', 'content': content},
          ],
          'provider': provider ?? 'groq',
          'session_id': sessionId,
        },
      );

      final data = response.data;
      if (data == null) {
        return const Left(Failure.ai(message: 'Empty response from AI'));
      }

      final assistantContent = data['content'] as String? ?? '';
      final modelUsed = data['model'] as String?;
      final tokensUsed = data['tokens_used'] as int?;

      // The Edge Function handles persistence; build the assistant message from the response
      final assistantMessageId = data['id'] as String? ?? _uuid.v4();
      final assistantNow = data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : DateTime.now();

      return Right(
        Message(
          id: assistantMessageId,
          userId: userId,
          sessionId: sessionId,
          role: 'assistant',
          content: assistantContent,
          modelUsed: modelUsed,
          provider: provider ?? 'groq',
          tokensUsed: tokensUsed,
          createdAt: assistantNow,
        ),
      );
    } catch (e, st) {
      AppLogger.error('sendMessage failed', e, st);
      return Left(Failure.ai(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getHistory(String sessionId) async {
    try {
      final data = await _supabaseClient
          .from('chat_messages')
          .select()
          .eq('session_id', sessionId)
          .order('created_at');

      final messages = (data as List<dynamic>)
          .map((row) => _rowToMessage(row as Map<String, dynamic>))
          .toList();

      return Right(messages);
    } catch (e, st) {
      AppLogger.error('getHistory failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearHistory(String sessionId) async {
    try {
      await _supabaseClient
          .from('chat_messages')
          .delete()
          .eq('session_id', sessionId);
      return const Right(unit);
    } catch (e, st) {
      AppLogger.error('clearHistory failed', e, st);
      return Left(Failure.server(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<Message>>> watchMessages(String sessionId) {
    return _supabaseClient
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('session_id', sessionId)
        .order('created_at')
        .map(
          (rows) => Right<Failure, List<Message>>(
            rows.map(_rowToMessage).toList(),
          ),
        )
        .handleError(
          (Object e) => Left<Failure, List<Message>>(
            Failure.server(message: e.toString()),
          ),
        );
  }

  Message _rowToMessage(Map<String, dynamic> row) {
    return Message(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      sessionId: row['session_id'] as String,
      role: row['role'] as String,
      content: row['content'] as String,
      modelUsed: row['model_used'] as String?,
      provider: row['provider'] as String?,
      tokensUsed: row['tokens_used'] as int?,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
