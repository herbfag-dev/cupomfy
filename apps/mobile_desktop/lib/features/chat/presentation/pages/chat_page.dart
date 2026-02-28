import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final String sessionId;

  @override
  void initState() {
    super.initState();
    sessionId = const Uuid().v4();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => '',
    );

    return BlocProvider(
      create: (_) => getIt<ChatBloc>()
        ..add(ChatEvent.loadHistory(sessionId: sessionId)),
      child: _ChatView(userId: userId, sessionId: sessionId),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView({
    required this.userId,
    required this.sessionId,
  });

  final String userId;
  final String sessionId;

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  String _selectedProvider = 'groq';

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    _messageController.clear();
    context.read<ChatBloc>().add(
          ChatEvent.sendMessage(
            content: content,
            sessionId: widget.sessionId,
            userId: widget.userId,
            provider: _selectedProvider,
          ),
        );

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        actions: [
          // Provider selector
          PopupMenuButton<String>(
            initialValue: _selectedProvider,
            onSelected: (provider) {
              setState(() => _selectedProvider = provider);
              context.read<ChatBloc>().add(
                    ChatEvent.providerChanged(provider: provider),
                  );
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'groq',
                child: Text('Groq'),
              ),
              const PopupMenuItem(
                value: 'openrouter',
                child: Text('OpenRouter'),
              ),
              const PopupMenuItem(
                value: 'ollama',
                child: Text('Ollama (Local)'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _selectedProvider,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear Chat'),
                  content: const Text(
                    'Are you sure you want to clear the chat?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.read<ChatBloc>().add(
                              const ChatEvent.clearChat(),
                            );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                      ),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                state.whenOrNull(
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: theme.colorScheme.error,
                      ),
                    );
                  },
                );
              },
              builder: (context, state) {
                return state.when(
                  initial: () => _buildWelcomeState(context),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  loaded: (messages, provider, isSending) {
                    if (messages.isEmpty) {
                      return _buildWelcomeState(context);
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.jumpTo(
                          _scrollController.position.maxScrollExtent,
                        );
                      }
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return MessageBubble(message: messages[index]);
                      },
                    );
                  },
                  error: (message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(message),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                            context.read<ChatBloc>().add(
                                  ChatEvent.loadHistory(
                                    sessionId: widget.sessionId,
                                  ),
                                );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Typing indicator
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              final isSending = state.maybeWhen(
                loaded: (_, __, isSending) => isSending,
                orElse: () => false,
              );
              if (isSending) {
                return _buildTypingIndicator(context);
              }
              return const SizedBox.shrink();
            },
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask about your finances...',
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      enabled: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      final isSending = state.maybeWhen(
                        loaded: (_, __, isSending) => isSending,
                        orElse: () => false,
                      );
                      return isSending
                          ? const SizedBox(
                              width: 48,
                              height: 48,
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : IconButton.filled(
                              onPressed: _sendMessage,
                              icon: const Icon(Icons.send_rounded),
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'AI Financial Assistant',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me anything about your finances',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _SuggestionChip(
                label: 'Analyze my spending',
                onTap: () {
                  _messageController.text = 'Analyze my spending patterns';
                  _sendMessage();
                },
              ),
              _SuggestionChip(
                label: 'Budget tips',
                onTap: () {
                  _messageController.text = 'Give me budget tips';
                  _sendMessage();
                },
              ),
              _SuggestionChip(
                label: 'Save money',
                onTap: () {
                  _messageController.text = 'How can I save more money?';
                  _sendMessage();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: 0.3 + (value * 0.7),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: theme.colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: theme.colorScheme.onPrimaryContainer,
      ),
    );
  }
}
