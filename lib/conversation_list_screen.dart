import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_screen.dart';
import 'login_screen.dart';

class ConversationListScreen extends StatelessWidget {
  final String phoneNumber;

  const ConversationListScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mockConversations = [
    {'name': 'Alice', 'conversationId': '1'},
    {'name': 'Bob', 'conversationId': '2'},
    {'name': 'Charlie', 'conversationId': '3'},
    ];

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
        itemCount: mockConversations.length,
        itemBuilder: (context, index) {
          final convo = mockConversations[index];
          String name = convo['name']!;
          return ListTile(
            title: Text(name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    phoneNumber: phoneNumber,
                    contactName: convo['name']!,
                    conversationId: convo['conversationId']!, // pass correct ID
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
