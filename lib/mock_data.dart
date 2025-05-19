import 'models.dart'; // ✅ import the Message model

final List<Conversation> allConversations = [
  Conversation(id: "chat1", name: "Alice", profilePic: "assets/alice.png"),
  Conversation(id: "chat2", name: "Bob", profilePic: "assets/bob.png"),
];

final List<Message> allMessages = [
  Message(
    sender: "123456789",
    conversationId: "chat1",
    text: "Hey Alice!",
    timestamp: DateTime.now().subtract(Duration(minutes: 5)),
  ),
  Message(
    sender: "987654321",
    conversationId: "chat2",
    text: "Hey Bob!",
    timestamp: DateTime.now().subtract(Duration(minutes: 2)),
  ),
];