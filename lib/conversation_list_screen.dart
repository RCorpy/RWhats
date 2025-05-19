import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_screen.dart';
import 'login_screen.dart';
import 'mock_data.dart';
import 'models.dart';

class ConversationListScreen extends StatelessWidget {
  final String phoneNumber;

  const ConversationListScreen({super.key, required this.phoneNumber});

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

          final lastMessages = allMessages
              .where((msg) => msg.conversationId == convoId)
              .toList()
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
          final lastMessage = lastMessages.isNotEmpty ? lastMessages.first : null;

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(convo.profilePic),
            ),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              lastMessage?.text ?? 'No messages yet',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
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
                    phoneNumber: phoneNumber,
                    contactName: name,
                    conversationId: convoId,
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
