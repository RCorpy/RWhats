// Conversation model
class Conversation {
  final String id;
  final String name;
  final String profilePic;

  Conversation({
    required this.id,
    required this.name,
    required this.profilePic,
  });
}

// Message model
class Message {
  final String id;
  final String conversationId;
  final String sender;
  final String text;
  final DateTime timestamp;
  bool read;

  Message({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.read = false,
  });
}





