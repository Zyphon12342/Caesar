import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatMessage extends StatelessWidget {
  final dynamic content;
  final bool isUser;

  const ChatMessage({
    super.key,
    String? content,
    Widget? contentWidget,
    required this.isUser,
  }) : content = contentWidget ?? content;

  Map<String, dynamic> toMap() {
    return {
      'role': isUser ? 'user' : 'assistant',
      'content': content is String ? content : '[Card content]'
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF3A3A3A) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: content is Widget
                  ? content
                  : _buildMarkdownOrText(content ?? ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkdownOrText(String text) {
    try {
      // Render as Markdown
      return MarkdownBody(
        data: text,
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(color: Colors.white.withOpacity(0.9)),
          h1: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.bold),
          h2: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.bold),
          h3: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.bold),
          code: TextStyle(
            backgroundColor: Colors.grey.withOpacity(0.2),
            color: Colors.white.withOpacity(0.9),
            fontFamily: 'monospace',
          ),
          codeblockDecoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          blockquote: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontStyle: FontStyle.italic,
          ),
          listBullet: TextStyle(color: Colors.white.withOpacity(0.9)),
        ),
        selectable: true,
      );
    } catch (e) {
      // Fallback to plain text if markdown parsing fails
      return Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
        ),
      );
    }
  }
}
