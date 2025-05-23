import 'package:flutter/material.dart';
import 'models.dart';  // import your models.dart
import 'mock_data.dart'; // shared message list
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;


class ChatScreen extends StatefulWidget {
  final String phoneNumber;
  final String contactName;
  final String conversationId;

  const ChatScreen({
    super.key,
    required this.phoneNumber,
    required this.contactName,
    required this.conversationId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      allMessages.add(Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: widget.phoneNumber,
        conversationId: widget.conversationId,
        text: text,
        timestamp: DateTime.now(),
      ));
      _controller.clear();
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 50));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void addMessageWithFile(File file, String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    final isImage = ['jpg', 'jpeg', 'png'].contains(ext);
    final isVideo = ['mp4'].contains(ext);

    allMessages.add(Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: widget.phoneNumber,
      conversationId: widget.conversationId,
      timestamp: DateTime.now(),
      file: file,
      fileName: fileName,
      isImage: isImage,
      isVideo: isVideo,
    ));

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final messages = allMessages
        .where((msg) => msg.conversationId == widget.conversationId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactName),
      ),
      body: Container(
        color: const Color(0xFFECE5DD), // WhatsApp-style background
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];

                  // ✅ Si es un archivo
                  if (msg.file != null) {
                    final file = msg.file as File;
                    final fileName = msg.fileName;
                    final isImage = msg.isImage ?? false;
                    final isVideo = msg.isVideo ?? false;

                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isImage)
                              Image.file(file, width: 150, height: 150, fit: BoxFit.cover)
                            else if (isVideo)
                              Column(
                                children: [
                                  const Icon(Icons.videocam, size: 40),
                                  const SizedBox(height: 5),
                                  Text(fileName!),
                                ],
                              )
                            else
                              Row(
                                children: [
                                  const Icon(Icons.insert_drive_file),
                                  const SizedBox(width: 8),
                                  Text(fileName!),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  }

                  // ✅ Si es un mensaje normal (texto)
                  final isMe = msg.sender == widget.phoneNumber;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: isMe ? const Color(0xFFE1FFC7) : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft:
                                  isMe ? const Radius.circular(12) : const Radius.circular(0),
                              bottomRight:
                                  isMe ? const Radius.circular(0) : const Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                msg.text ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),

                              const SizedBox(height: 4),
                              Text(
                                msg.timestamp != null
                                    ? '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}'
                                    : '',
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),


            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send, // Allows Enter to send on desktop/web
                      onSubmitted: (_) => _sendMessage(),    // Called when Enter is pressed
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'xlsx', 'xls', 'jpg', 'png', 'mp4'],
                      );

                      if (result != null && result.files.single.path != null) {
                        final file = File(result.files.single.path!);
                        final fileName = result.files.single.name;

                        // Aquí mandamos el archivo al chat
                        addMessageWithFile(file, fileName);
                      }
                    },
                  ),

                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.green),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


