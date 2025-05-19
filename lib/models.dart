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
  final String sender;
  final String conversationId; // should match a Conversation.id
  final String text;
  final DateTime timestamp;

  Message({
    required this.sender,
    required this.conversationId,
    required this.text,
    required this.timestamp,
  });
}




