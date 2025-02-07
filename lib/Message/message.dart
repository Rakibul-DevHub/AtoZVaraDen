import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final List<Map<String, String>> messages = []; // List to store messages
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    final String message = _messageController.text.trim();

    if (message.isNotEmpty) {
      setState(() {
        messages.add({"type": "sent", "text": message});
      });
      _messageController.clear();
    }

    // Simulate receiving a response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        messages.add({"type": "received", "text": "Got your message!"});
      });
    });
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.image, color: Colors.green.shade400),
                title: const Text('Attach Image'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement image selection logic
                  setState(() {
                    messages.add({
                      "type": "sent",
                      "text": "[Image Attached]"
                    }); // Placeholder for image
                  });
                },
              ),
              ListTile(
                leading:  Icon(Icons.videocam, color: Colors.green.shade400),
                title: const Text('Attach Video'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement video selection logic
                  setState(() {
                    messages.add({
                      "type": "sent",
                      "text": "[Video Attached]"
                    }); // Placeholder for video
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message"),
        backgroundColor: Colors.teal.shade400,
      ),
      body: Column(
        children: [
          // Message List
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              reverse: true, // Newest messages appear at the bottom
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return Align(
                  alignment: message["type"] == "sent"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: message["type"] == "sent"
                          ? Colors.deepPurple[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: message["type"] == "sent"
                            ? const Radius.circular(12)
                            : Radius.zero,
                        bottomRight: message["type"] == "sent"
                            ? Radius.zero
                            : const Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      message["text"]!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey[200],
            child: Row(
              children: [
                // Attach Button
                IconButton(
                  onPressed: _showAttachmentOptions,
                  icon: Icon(Icons.attach_file, color: Colors.green.shade600),
                ),

                // Message Input
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),

                // Send Button
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send, color: Colors.green.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
