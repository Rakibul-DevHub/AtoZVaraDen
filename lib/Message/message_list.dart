import 'package:flutter/material.dart';
import 'message.dart';
import 'messageSender_Model.dart';

class MessageListScreen extends StatelessWidget {
  const MessageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade300,
        title: const Text("Chats"),
        actions: [
          IconButton(
            onPressed: () {
              // Handle search action
              print("Search clicked!");
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              // Handle more options
              print("More clicked!");
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chatUsers.length,
        itemBuilder: (context, index) {
          final chatUser = chatUsers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade300,
              child: Text(chatUser.name[0]), // Display the first letter of the name
            ),
            title: Text(chatUser.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(chatUser.message, overflow: TextOverflow.ellipsis),
            trailing: Text(chatUser.time, style: const TextStyle(fontSize: 12)),
            onTap: () {
              // Navigate to the MessageScreen when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageScreen(),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade300,
        onPressed: () {
          // Handle new chat action
          print("New chat clicked!");
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}

