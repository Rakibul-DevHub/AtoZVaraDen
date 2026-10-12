import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Auth/auth_screen.dart';
import '../../Auth/auth_service.dart';
import '../../Footer/footer.dart';
import '../../Message/message_list.dart';
import '../../Profile/profile.dart';
import '../AddRent/add_rent_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final bool isUserLoggedIn = AuthService.isLoggedIn;
    final String currentUserId = AuthService.currentUserId;
    final String currentUsername = AuthService.currentUsername;
    final String currentUserEmail = AuthService.currentUserEmail;

    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            onDetailsPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(userId: currentUserId)),
              ).then((_) => setState(() {}));
            },
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade600, Colors.teal.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 44, color: Colors.teal.shade700),
            ),
            accountName: Text(
              currentUsername,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(
              currentUserEmail,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ),

          // Drawer Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.teal),
                  title: const Text('Home'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.add_circle, color: Colors.teal),
                  title: const Text('Post Rental Ad'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddRentScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.chat_outlined, color: Colors.teal),
                  title: const Text('Messages / Chats'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MessageListScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline, color: Colors.teal),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile(userId: currentUserId, initialTabIndex: 0)),
                    ).then((_) => setState(() {}));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined, color: Colors.teal),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile(userId: currentUserId, initialTabIndex: 1)),
                    ).then((_) => setState(() {}));
                  },
                ),
                const Divider(),
                if (!isUserLoggedIn) ...[
                  ListTile(
                    leading: const Icon(Icons.login, color: Colors.teal),
                    title: const Text('Login'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AuthScreen(initialIsLogin: true)),
                      ).then((_) => setState(() {}));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_add_alt, color: Colors.teal),
                    title: const Text('Sign Up'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AuthScreen(initialIsLogin: false)),
                      ).then((_) => setState(() {}));
                    },
                  ),
                ] else ...[
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text('Logout'),
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);
                      await AuthService.signOut();
                      if (!mounted) return;
                      setState(() {});
                      navigator.pop();
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Logged out successfully')),
                      );
                    },
                  ),
                ],
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.teal),
                  title: const Text('Official Website'),
                  onTap: () async {
                    const url = 'https://www.net.twistbazar.com/';
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.android, color: Colors.green),
                  title: const Text('Get Android APK'),
                  onTap: () async {
                    const url =
                        'https://github.com/Rakibul-E404/AtoZ_Vara_Den/releases/download/v1.0-beta.1/AtoZVaraDen.android.apk';
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                ),
              ],
            ),
          ),

          // Footer
          const Footer(),
        ],
      ),
    );
  }
}
