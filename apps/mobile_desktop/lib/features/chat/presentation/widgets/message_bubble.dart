import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
  });

  final Message message;

  bool get _isUser => message.role == 'user';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeFormat = DateFormat.Hm();

    return Align(
      alignment: _isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: _isUser ? 64 : 16,
          right: _isUser ? 16 : 64,
          top: 4,
          bottom: 4,
        ),
        child: Column(
          crossAxisAlignment:
              _isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _isUser
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(_isUser ? 16 : 4),
                  bottomRight: Radius.circular(_isUser ? 4 : 16),
                ),
              ),
              child: _isUser
                  ? Text(
                      message.content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : MarkdownBody(
                      data: message.content,
                      styleSheet: MarkdownStyleSheet(
                        p: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        code: theme.textTheme.bodySmall?.copyWith(
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          fontFamily: 'monospace',
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeFormat.format(message.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                    fontSize: 11,
                  ),
                ),
                if (!_isUser && message.modelUsed != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      message.modelUsed!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
