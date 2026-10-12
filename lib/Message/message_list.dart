import 'package:flutter/material.dart';
import 'message.dart';
import 'messageSender_Model.dart';

class MessageListScreen extends StatelessWidget {
  const MessageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text("Rental Inquiries & Chats"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView.separated(
            itemCount: chatUsers.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final chatUser = chatUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade400,
                  foregroundColor: Colors.white,
                  child: Text(
                    chatUser.name[0],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  chatUser.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  chatUser.message,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  chatUser.time,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MessageScreen(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MessageScreen(),
            ),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
