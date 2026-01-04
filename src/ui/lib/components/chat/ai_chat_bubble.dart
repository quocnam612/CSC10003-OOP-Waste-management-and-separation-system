import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ui/services/ai_assistant_api.dart';

class AiChatBubble extends StatefulWidget {
  const AiChatBubble({super.key, required this.authToken});

  final String authToken;

  @override
  State<AiChatBubble> createState() => _AiChatBubbleState();
}

class _AiChatBubbleState extends State<AiChatBubble> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = <_ChatMessage>[
    _ChatMessage(
      text: 'Xin chào! Tôi là trợ lý AI GreenRoute.',
      isUser: false,
    ),
    _ChatMessage(
      text: 'Bạn có thể đặt câu hỏi về hệ thống ở đây.',
      isUser: false,
    ),
  ];
  bool _isOpen = false;
  bool _isSending = false;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() => _isOpen = !_isOpen);
  }

  void _showSystemMessage(String text, {bool isError = false}) {
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: false, isError: isError));
    });
    _scrollToBottom();
  }

  Future<void> _handleSend() async {
    final String prompt = _inputController.text.trim();
    if (prompt.isEmpty || _isSending) return;

    final token = widget.authToken.trim();
    if (token.isEmpty) {
      _showSystemMessage(
        'Không tìm thấy mã xác thực. Vui lòng đăng nhập lại.',
        isError: true,
      );
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(text: prompt, isUser: true));
      _inputController.clear();
      _isSending = true;
    });
    _scrollToBottom();

    late int pendingIndex;
    setState(() {
      _messages.add(const _ChatMessage(
        text: 'GreenRoute AI đang phản hồi...',
        isUser: false,
        isPending: true,
      ));
      pendingIndex = _messages.length - 1;
    });
    _scrollToBottom();

    try {
      final payload = await AiAssistantApi.sendPrompt(
        prompt: prompt,
        token: token,
      );

      final responseText = payload['response'] as String? ?? 'AI chưa phản hồi.';
      final model = payload['model'] as String?;
      final formatted = (model != null && model.isNotEmpty)
          ? '$responseText\n\n(Mô hình: $model)'
          : responseText;

      if (!mounted) return;
      setState(() {
        _messages[pendingIndex] =
            _ChatMessage(text: formatted.trim(), isUser: false);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _messages[pendingIndex] = _ChatMessage(
          text: _friendlyError(error),
          isUser: false,
          isError: true,
        );
      });
    } finally {
      if (!mounted) return;
      setState(() => _isSending = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future<void>.delayed(const Duration(milliseconds: 50), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _friendlyError(Object error) {
    final raw = error.toString();
    const prefix = 'Exception: ';
    if (raw.startsWith(prefix)) {
      return raw.substring(prefix.length);
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: SafeArea(
        bottom: true,
        minimum: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (_isOpen)
              _ChatWindow(
                messages: _messages,
                controller: _scrollController,
                onSend: _handleSend,
                inputController: _inputController,
                isSending: _isSending,
              ),
            const SizedBox(height: 12),
            _ChatToggleButton(isOpen: _isOpen, onPressed: _toggleChat),
          ],
        ),
      ),
    );
  }
}

class _ChatWindow extends StatelessWidget {
  const _ChatWindow({
    required this.messages,
    required this.controller,
    required this.onSend,
    required this.inputController,
    required this.isSending,
  });

  final List<_ChatMessage> messages;
  final ScrollController controller;
  final Future<void> Function() onSend;
  final TextEditingController inputController;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Colors.black.withOpacity(0.08);

    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 340,
        height: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Row(
                children: [
                  const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'GreenRoute AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFF7F8F9),
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final _ChatMessage message = messages[index];
                    final bool isUser = message.isUser;
                    final bool isError = message.isError;
                    final bool isPending = message.isPending;
                    final Color bubbleColor;
                    final Color textColor;

                    if (isUser) {
                      bubbleColor = Theme.of(context).colorScheme.primary;
                      textColor = Colors.white;
                    } else if (isError) {
                      bubbleColor = const Color(0xFFFFEAEA);
                      textColor = const Color(0xFFB3261E);
                    } else {
                      bubbleColor = Colors.white;
                      textColor = Colors.black87;
                    }

                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        constraints: const BoxConstraints(maxWidth: 260),
                        decoration: BoxDecoration(
                          color: bubbleColor,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(isUser ? 18 : 4),
                            bottomRight: Radius.circular(isUser ? 4 : 18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12,
                              color: Colors.black.withOpacity(0.05),
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (isPending)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                                  ),
                                ),
                              ),
                            Flexible(
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontStyle:
                                      isPending ? FontStyle.italic : FontStyle.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: inputController,
                      decoration: const InputDecoration(
                        hintText: 'Nhập câu hỏi của bạn...',
                        isDense: true,
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Color(0xFFF2F4F7),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                      minLines: 1,
                      maxLines: 3,
                      onSubmitted: (_) => onSend(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: isSending ? null : () => onSend(),
                    icon: isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.send_rounded, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatToggleButton extends StatelessWidget {
  const _ChatToggleButton({
    required this.isOpen,
    required this.onPressed,
  });

  final bool isOpen;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'ai-chat-bubble',
      onPressed: onPressed,
      icon: Icon(isOpen ? Icons.close : Icons.chat),
      label: Text(isOpen ? 'Đóng chat' : 'Hỏi GreenRoute AI'),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isUser,
    this.isPending = false,
    this.isError = false,
  });

  final String text;
  final bool isUser;
  final bool isPending;
  final bool isError;
}
