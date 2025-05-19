import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_screen.dart';
import 'login_screen.dart';
import 'mock_data.dart';
import 'models.dart';

/// Helper to group messages by conversation
Map<String, List<Message>> groupMessagesByConversation(List<Message> messages) {
  final map = <String, List<Message>>{};
  for (var msg in messages) {
    map.putIfAbsent(msg.conversationId, () => []).add(msg);
  }
  return map;
}

class ConversationListScreen extends StatefulWidget {
  final String phoneNumber;

  const ConversationListScreen({super.key, required this.phoneNumber});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  late Map<String, List<Message>> groupedMessages;

  @override
  void initState() {
    super.initState();
    groupedMessages = groupMessagesByConversation(allMessages);
  }

  @override
  Widget build(BuildContext context) {
    final List<Conversation> conversations = allConversations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RWhats - Conversations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('phone');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final convo = conversations[index];
          final convoId = convo.id;
          final name = convo.name;

          final lastMessages = groupedMessages[convoId] ?? [];
          lastMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          final lastMessage = lastMessages.isNotEmpty ? lastMessages.first : null;

          final isUnread = lastMessage != null && !lastMessage.read && lastMessage.sender != widget.phoneNumber;
          final isSentByYou = lastMessage != null && lastMessage.sender == widget.phoneNumber;

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(convo.profilePic),
            ),
            title: Text(
              name,
              style: TextStyle(
                fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: lastMessage != null
                ? Row(
                    children: [
                      if (!isSentByYou)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            lastMessage.sender,
                            style: const TextStyle(fontSize: 10, color: Colors.blue),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          lastMessage.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isUnread ? Colors.black : Colors.grey,
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  )
                : const Text('No messages yet'),
            trailing: lastMessage != null
                ? Text(
                    '${lastMessage.timestamp.hour}:${lastMessage.timestamp.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  )
                : null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    phoneNumber: widget.phoneNumber,
                    contactName: name,
                    conversationId: convoId,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
