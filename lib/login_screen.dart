import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'conversation_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _login() async {
    final phone = _phoneController.text;
    if (phone.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone', phone);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationListScreen(phoneNumber: phone),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Enter your phone number:'),
            TextField(controller: _phoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
