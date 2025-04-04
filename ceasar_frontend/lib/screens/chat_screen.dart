import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../utils/response_processor.dart';
import '../components/chat_message.dart';
import '../utils/extensions/scroll_controller_ext.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ChatService _chatService = ChatService();
  late AnimationController _typingController;
  late ScrollController _scrollController;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _typingController.dispose();
    _scrollController.dispose();
    _chatService.cancelRequest();
    super.dispose();
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _messageController.clear();
    _addUserMessage(text);
    
    setState(() => _isTyping = true);

    try {
      final response = await _chatService.sendMessage(
        text,
        _messages.map((m) => m.toMap()).toList(),
      );

      ResponseProcessor.processResponse(
        response: response,
        onText: _addBotMessage,
        onCards: _addBotCards,
      );
    } catch (e) {
      _addBotMessage('Error: $e');
    } finally {
      setState(() => _isTyping = false);
      _scrollController.scrollToBottom();
    }
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        content: text,
        isUser: true,
      ));
    });
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        content: text,
        isUser: false,
      ));
    });
  }

  void _addBotCards(List<Widget> cards) {
    setState(() {
      _messages.addAll(cards.map((card) => ChatMessage(
        contentWidget: card,
        isUser: false,
      )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CEASAR'),
        actions: [
          if (_messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => setState(() => _messages.clear()),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _messages.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _messages[index];
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Message CEASAR...',
                hintStyle: const TextStyle(color: Color(0xFF6B6B6B)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF2D2D2D),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onSubmitted: _handleSubmitted,
              maxLines: null,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3A),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _handleSubmitted(_messageController.text),
            ),
          ),
        ],
      ),
    );
  }
}