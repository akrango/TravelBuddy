import 'package:airbnb_app/components/animatied_dots.dart';
import 'package:airbnb_app/models/user.dart';
import 'package:airbnb_app/providers/user_provider.dart';
import 'package:airbnb_app/utils/system_prompt.dart';
import 'package:flutter/material.dart';
import 'package:ollama/ollama.dart';
import 'package:provider/provider.dart';

class HelpChatScreen extends StatefulWidget {
  @override
  _HelpChatScreenState createState() => _HelpChatScreenState();
}

class _HelpChatScreenState extends State<HelpChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _messages = [];
  bool _isTyping = false;

  final _ollama = Ollama(baseUrl: Uri.parse('http://10.0.2.2:11434'));

  final String userImage = 'assets/images/user_image.jpg';
  final String ollamaImage = 'assets/images/help_chat.png';

  String buildPrompt(List<String> messages) {
    return messages.map((m) {
      if (m.startsWith("You: ")) return "User: ${m.substring(5)}";
      if (m.startsWith("Ollama: ")) return m.substring(8);
      return m;
    }).join('\n');
  }

  Future<void> _sendMessage() async {
    final userInput = _messageController.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      _messages.add("You: $userInput");
      _messageController.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    final contextMessages = buildPrompt(_messages.takeLast(6));
    final prompt = '$systemPrompt\n$contextMessages';

    StringBuffer buffer = StringBuffer();

    try {
      final stream = _ollama.generate(
        prompt,
        model: 'llama2',
      );

      String partialResponse = "";
      bool firstChunk = true;
      await for (final chunk in stream) {
        final text = chunk.text ?? "";
        buffer.write(text);
        partialResponse += text;
        if (firstChunk) {
          firstChunk = false;
          setState(() {
            _isTyping = false;
          });
        }
        setState(() {
          if (_messages.isNotEmpty && _messages.last.startsWith("Ollama: ")) {
            _messages.removeLast();
          }
          _messages.add("Ollama: $partialResponse");
        });

        _scrollToBottom();
      }
    } catch (e) {
      setState(() {
        _messages.add("Ollama: Error: $e");
      });
    } finally {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(ollamaImage),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: AnimatedDots(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(String message, UserModel? user) {
    final isUser = message.startsWith("You: ");
    final displayText = isUser ? message.substring(5) : message.substring(7);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(ollamaImage),
            ),
          SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isUser ? Colors.blueAccent : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: isUser ? Radius.circular(16) : Radius.circular(0),
                  bottomRight:
                      isUser ? Radius.circular(0) : Radius.circular(16),
                ),
              ),
              child: Text(
                displayText,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          if (isUser)
            CircleAvatar(
              radius: 18,
              backgroundImage:
                  (user != null && user.photoURL.startsWith('http'))
                      ? NetworkImage(user.photoURL)
                      : AssetImage(userImage) as ImageProvider,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(title: Text("What do you need help with?")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessageItem(_messages[index], user ?? null);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.blueAccent,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension TakeLast<T> on List<T> {
  List<T> takeLast(int n) => skip((length - n).clamp(0, length)).toList();
}
