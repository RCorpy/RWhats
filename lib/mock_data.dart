import 'models.dart'; // ✅ import the Message model

final List<Conversation> allConversations = [
  Conversation(id: "chat1", name: "Alice", profilePic: "assets/alice.png"),
  Conversation(id: "chat2", name: "Bob", profilePic: "assets/bob.png"),
];

final List<Message> allMessages = [  // <-- Asegura tipo explícito
  Message(
    id: 'm1',
    conversationId: 'chat1', // Ojo: asegurarte que coincida con Conversation.id
    sender: '123456789',
    text: 'Hello!',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    read: false,
  ),
  Message(
    id: 'm2',
    conversationId: 'chat1',
    sender: 'me',
    text: 'Hi, how are you?',
    timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    read: true,
  ),
];

