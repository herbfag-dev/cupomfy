import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_event.freezed.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.loadHistory({
    required String sessionId,
  }) = LoadHistory;

  const factory ChatEvent.sendMessage({
    required String content,
    required String sessionId,
    required String userId,
    String? provider,
  }) = SendMessage;

  const factory ChatEvent.clearChat() = ClearChat;

  const factory ChatEvent.messagesUpdated({
    required List<dynamic> messages,
  }) = MessagesUpdated;

  const factory ChatEvent.providerChanged({
    required String provider,
  }) = ProviderChanged;
}
