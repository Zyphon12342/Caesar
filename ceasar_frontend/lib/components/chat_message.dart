import 'package:flutter/material.dart';

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
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isUser 
                    ? const Color(0xFF3A3A3A) 
                    : const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: content is Widget 
                  ? content 
                  : Text(
                      content ?? '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}