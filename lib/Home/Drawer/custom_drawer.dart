import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../../LoginOut_Signup/signupScreen.dart';
import '../../LoginOut_Signup/loginLogoutScreen.dart';
import '../../Profile/profile.dart';
import '../../Rent/addRent.dart';
import '../../Footer/footer.dart'; // Import Footer widget

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: Colors.teal,
            ),
            child: Row(
              children: [
                // Profile Image
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircleAvatar(
                          radius: 40,
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                        return const CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person, size: 40),
                        );
                      }

                      final data = snapshot.data!.data() as Map<String, dynamic>;
                      final profileImage = data['profileImage'] ?? '';

                      return CircleAvatar(
                        radius: 40,
                        backgroundImage: profileImage.isNotEmpty
                            ? MemoryImage(base64Decode(profileImage))
                            : null,
                        child: profileImage.isEmpty
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      );
                    },
                  ),
                ),

                // Username
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }

                        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                          return const Text(
                            "User Not Logged In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }

                        final data = snapshot.data!.data() as Map<String, dynamic>;
                        final username = data['username'] ?? 'No Name';

                        return Text(
                          username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Drawer Menu Items
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () async {
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Profile(userId: userId)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User is not logged in")),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text('Add Rent'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AddRent()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.move_up_sharp),
            title: const Text('Sign up'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Login'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const loginLogoutScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const loginLogoutScreen()),
                    (route) => false,
              );
            },
          ),




          // Divider
          const Divider(),


          if (!kIsWeb && Platform.isIOS)
          ListTile(
            leading: const Icon(Icons.web),
            title: const Text('Open in Web'),
            onTap: () async {
              const url = 'https://www.net.twistbazar.com/'; // Replace with actual URL
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          if (!kIsWeb && Platform.isAndroid)


          ListTile(
            leading: const Icon(Icons.web),
            title: const Text('Open in Web'),
            onTap: () async {
              const url = 'https://www.net.twistbazar.com/'; // Replace with actual URL
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {
                throw 'Could not launch $url';
              }
            },
          ),


          ListTile(
            leading: const Icon(Icons.android),
            title: const Text('Install Android App'),
            onTap: () async {
              const url = 'https://github.com/Rakibul-E404/AtoZ_Vara_Den/releases/download/v1.0-beta.1/AtoZVaraDen.android.apk';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {
                throw 'Could not launch $url';
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.apple),
            title: const Text('Install iOS App'),
            onTap: ()  {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('iOS will be available soon!'), // Wrap the Text widget inside the SnackBar
                ),
              );
            },
          ),

          // Footer Section
          const Expanded(child: SizedBox()), // Pushes footer to the bottom
          const Footer(), // Your existing footer widget
        ],
      ),
    );
  }
}



