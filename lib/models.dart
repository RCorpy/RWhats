import 'dart:io';

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



class Message {
  final String id;
  final String sender;
  final String conversationId;
  final String? text;
  final DateTime timestamp;

  final File? file;
  final String? fileName;
  final bool? isImage;
  final bool? isVideo;
  final bool read; // <-- NUEVO

  Message({
    required this.id,
    required this.sender,
    required this.conversationId,
    this.text,
    required this.timestamp,
    this.file,
    this.fileName,
    this.isImage,
    this.isVideo,
    this.read = false, // <-- default to false
  });
}






