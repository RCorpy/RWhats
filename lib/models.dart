class Conversation {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastTime;

  Conversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastTime,
  });
}

class Message {
  final String id;
  final String conversationId;
  final String sender;
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.text,
    required this.timestamp,
  });
}
