import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../utils/response_processor.dart';
import '../components/chat_message.dart';
import '../utils/extensions/scroll_controller_ext.dart';
import '../components/horizontal_orbit_loader.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'dart:ui';

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
  final FocusNode _textFocusNode = FocusNode();

  bool _isTyping = false;

  // Theme colors
  final Color _darkestColor = Colors.black;
  final Color _darkBlue = const Color(0xFF051525);
  final Color _accentColor = const Color(0xFF3498FF);
  final Color _subtleAccent = const Color(0xFF1A65A3);
  final Color _darkAccent = const Color(0xFF0A4070);

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
      duration: const Duration(milliseconds: 400),
    );

    _titleAlignment = Tween<Alignment>(
      begin: Alignment(-0.2, 0),
      end: Alignment.centerLeft,
    ).animate(
      CurvedAnimation(
        parent: _titleAnimationController,
        curve: Curves.easeOutQuint,
      ),
    );

    _textFocusNode.addListener(() {
      if (_textFocusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _typingController.dispose();
    _scrollController.dispose();
    _titleAnimationController.dispose();
    _textFocusNode.dispose();
    _chatService.cancelRequest();
    super.dispose();
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _messageController.clear();
    _addUserMessage(text);

    setState(() => _isTyping = true);

    // Scroll to show the user message immediately.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
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

  void _scrollToBottom() {
    final bottomOffset = _scrollController.position.maxScrollExtent + 80;
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        bottomOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
      );
    }
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    child: HorizontalOrbitLoader(
                      size: 30,
                      color: Colors.white70,
                      speed: 2.5,
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
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 0.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  focusNode: _textFocusNode,
                  controller: _messageController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Message CEASAR...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: _handleSubmitted,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutQuint,
                margin: const EdgeInsets.only(right: 4, bottom: 4),
                decoration: BoxDecoration(
                  color: _isTyping
                      ? Colors.redAccent.withOpacity(0.7)
                      : Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _isTyping
                          ? Colors.redAccent.withOpacity(0.2)
                          : _accentColor.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if (_isTyping) {
                        _chatService.cancelRequest();
                        setState(() => _isTyping = false);
                      } else {
                        _handleSubmitted(_messageController.text);
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: CurvedAnimation(
                            parent: animation,
                            curve: Curves.elasticOut,
                            reverseCurve: Curves.easeInQuint,
                          ),
                          child: child,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          _isTyping ? Icons.close : Icons.send,
                          color: Colors.white,
                          size: 18,
                          key: ValueKey<bool>(_isTyping),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
