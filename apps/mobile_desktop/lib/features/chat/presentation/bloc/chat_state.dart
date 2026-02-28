import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.initial() = ChatInitial;

  const factory ChatState.loading() = ChatLoading;

  const factory ChatState.loaded({
    required List<dynamic> messages,
    required String provider,
    required bool isSending,
  }) = ChatLoaded;

  const factory ChatState.error({
    required String message,
  }) = ChatError;
}
