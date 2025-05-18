import 'package:flutter/material.dart';
import 'models.dart';  // import your models.dart

class ChatScreen extends StatefulWidget {
  final String phoneNumber;
  final String contactName;
  final String conversationId; // Add conversation ID to identify conversation

  const ChatScreen({
    super.key,
    required this.phoneNumber,
    required this.contactName,
    required this.conversationId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Dummy data — in a real app, you'd fetch these from backend
  List<Message> allMessages = [
    Message(
      id: 'm1',
      conversationId: '1',
      sender: 'Alice',
      text: 'Hey, how are you?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Message(
      id: 'm2',
      conversationId: '1',
      sender: 'Me',
      text: 'I’m good, thanks!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    Message(
      id: 'm3',
      conversationId: '2',
      sender: 'Bob',
      text: 'Let’s meet tomorrow!',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  List<Message> get _messagesForCurrentConversation {
    return allMessages
        .where((msg) => msg.conversationId == widget.conversationId)
        .toList();
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: widget.conversationId,
        sender: 'Me', // In a real app this would be the logged-in user
        text: messageText,
        timestamp: DateTime.now(),
      );

      setState(() {
        allMessages.add(newMessage);
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = _messagesForCurrentConversation;

    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.contactName}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final msg = messages[index];
                bool isMe = msg.sender == 'Me';

                return ListTile(
                  title: Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue[200] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(msg.text),
                    ),
                  ),
                  subtitle: Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(
                      '${msg.sender} • ${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _messageController)),
                IconButton(
                  icon: const Icon(Icons.send),
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
