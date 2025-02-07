class ChatUser {
  final String name;
  final String message;
  final String time;

  ChatUser({required this.name, required this.message, required this.time});
}

final List<ChatUser> chatUsers = [
  ChatUser(name: "John Doe", message: "Hey, how are you?", time: "10:30 AM"),
  ChatUser(name: "Jane Smith", message: "Let's catch up soon!", time: "09:15 AM"),
  ChatUser(name: "Alex Johnson", message: "Did you finish the project?", time: "Yesterday"),
  ChatUser(name: "Emily Davis", message: "Happy Birthday!", time: "2 days ago"),
];