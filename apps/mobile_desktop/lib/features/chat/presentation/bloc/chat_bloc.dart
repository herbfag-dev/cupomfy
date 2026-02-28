import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this._chatRepository) : super(const ChatState.initial()) {
    on<LoadHistory>(_onLoadHistory);
    on<SendMessage>(_onSendMessage);
    on<ClearChat>(_onClearChat);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<ProviderChanged>(_onProviderChanged);
  }

  final ChatRepository _chatRepository;
  StreamSubscription? _messagesSubscription;

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatState.loading());

    // Subscribe to message stream for real-time updates
    _messagesSubscription?.cancel();
    _messagesSubscription = _chatRepository
        .watchMessages(event.sessionId)
        .listen(
          (result) => result.fold(
            (failure) => add(ChatEvent.messagesUpdated(messages: [])),
            (messages) => add(ChatEvent.messagesUpdated(messages: messages)),
          ),
        );

    // Load initial history
    final result = await _chatRepository.getHistory(event.sessionId);

    result.fold(
      (failure) => emit(ChatState.error(message: _mapFailureToMessage(failure))),
      (messages) => emit(ChatState.loaded(
        messages: messages,
        provider: 'groq',
        isSending: false,
      )),
    );
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatLoaded) return;

    // Optimistically add user message
    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: event.userId,
      sessionId: event.sessionId,
      role: 'user',
      content: event.content,
      provider: event.provider ?? currentState.provider,
      createdAt: DateTime.now(),
    );

    final updatedMessages = [...currentState.messages, userMessage];
    emit(currentState.copyWith(
      messages: updatedMessages,
      isSending: true,
    ));

    // Send to AI
    final result = await _chatRepository.sendMessage(
      content: event.content,
      sessionId: event.sessionId,
      userId: event.userId,
      provider: event.provider ?? currentState.provider,
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isSending: false));
        emit(ChatState.error(message: _mapFailureToMessage(failure)));
      },
      (assistantMessage) {
        // The real-time stream will update the messages
        emit(currentState.copyWith(isSending: false));
      },
    );
  }

  Future<void> _onClearChat(
    ClearChat event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatState.initial());
  }

  void _onMessagesUpdated(
    MessagesUpdated event,
    Emitter<ChatState> emit,
  ) {
    final currentState = state;
    if (currentState is ChatLoaded) {
      emit(currentState.copyWith(messages: event.messages));
    } else if (currentState is! ChatLoading) {
      emit(ChatState.loaded(
        messages: event.messages,
        provider: 'groq',
        isSending: false,
      ));
    }
  }

  void _onProviderChanged(
    ProviderChanged event,
    Emitter<ChatState> emit,
  ) {
    final currentState = state;
    if (currentState is ChatLoaded) {
      emit(currentState.copyWith(provider: event.provider));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.when(
      server: (message) => message ?? 'Server error occurred',
      cache: (message) => message ?? 'Cache error occurred',
      network: () => 'Network error. Please check your connection',
      notFound: (message) => message ?? 'Resource not found',
      unauthorized: () => 'Unauthorized access',
      forbidden: () => 'Access forbidden',
      validation: (message) => message ?? 'Validation error',
      unknown: (message) => message ?? 'An unexpected error occurred',
      ai: (message) => message ?? 'AI service error',
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
