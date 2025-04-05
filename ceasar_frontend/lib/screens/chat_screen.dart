import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../utils/response_processor.dart';
import '../components/chat_message.dart';
import '../utils/extensions/scroll_controller_ext.dart';
import '../components/pulsing_circle.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ChatService _chatService = ChatService();
  late AnimationController _typingController;
  late ScrollController _scrollController;
  late AnimationController _titleAnimationController;
  late Animation<Alignment> _titleAlignment;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scrollController = ScrollController();
    
    _titleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _titleAlignment = Tween<Alignment>(
      begin: Alignment(-0.2, 0),
      end: Alignment.centerLeft,
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _typingController.dispose();
    _scrollController.dispose();
    _titleAnimationController.dispose();
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

      if (response != null) {
        ResponseProcessor.processResponse(
          response: response,
          onText: _addBotMessage,
          onCards: _addBotCards,
        );
      }
    } catch (e) {
      _addBotMessage('Error: $e');
    } finally {
      setState(() => _isTyping = false);
      _scrollController.scrollToBottom();
    }
  }

  void _updateTitleAnimation() {
    if (_messages.isEmpty && _titleAnimationController.value > 0) {
      _titleAnimationController.reverse();
    } else if (_messages.isNotEmpty && _titleAnimationController.value < 1) {
      _titleAnimationController.forward();
    }
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        content: text,
        isUser: true,
      ));
      _updateTitleAnimation();
    });
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        content: text,
        isUser: false,
      ));
      _updateTitleAnimation();
    });
  }

  void _addBotCards(List<Widget> cards) {
    setState(() {
      _messages.addAll(cards.map((card) => ChatMessage(
        contentWidget: card,
        isUser: false,
      )));
      _updateTitleAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userEmail = authProvider.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: AnimatedBuilder(
          animation: _titleAnimationController,
          builder: (context, child) {
            return Align(
              alignment: _titleAlignment.value,
              child: Text(
                'CEASAR',
                style: TextStyle(
                  fontSize: 24 - (8 * _titleAnimationController.value),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        actions: [
          if (_messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _messages.clear();
                  _updateTitleAnimation();
                });
              },
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'logout') {
                authProvider.signOut();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'email',
                child: Text(
                  userEmail,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                enabled: false,
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PulsingCircle(),
                        SizedBox(width: 8),
                        Text(
                          'CEASAR is thinking...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
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
              icon: Icon(
                _isTyping ? Icons.close : Icons.send,
                color: Colors.white,
              ),
              onPressed: () {
                if (_isTyping) {
                  _chatService.cancelRequest();
                  setState(() => _isTyping = false);
                } else {
                  _handleSubmitted(_messageController.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}