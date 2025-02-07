
import 'dart:convert'; // For Base64 encoding and decoding
import 'dart:io'; // For File operations
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import '../Home/homeScreen.dart';
import '../Rent/addRent.dart'; // For file picking

class Profile extends StatefulWidget {
  final String userId; // Dynamically passed userId
  const Profile({Key? key, required this.userId}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _username = '';
  String _email = '';
  String _mobile = '';
  String _profileImage = ''; // Base64 encoded profile image
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users') // Ensure this matches your Firestore collection
          .doc(widget.userId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _username = data['username'] ?? 'No Name';
          _email = data['email'] ?? 'No Email';
          _mobile = data['mobile'] ?? 'No Mobile';
          _profileImage = data['profileImage'] ?? ''; // Default to empty string
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No profile data found.')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile data: $e')),
      );
    }
  }


  Future<void> _changePassword() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: const InputDecoration(labelText: "Current Password"),
                obscureText: true,
              ),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(labelText: "New Password"),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    final credential = EmailAuthProvider.credential(
                      email: user.email!,
                      password: currentPasswordController.text,
                    );

                    // Reauthenticate the user
                    await user.reauthenticateWithCredential(credential);

                    // Update the password
                    await user.updatePassword(newPasswordController.text);

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Password updated successfully!")),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to update password: $e")),
                  );
                }
              },
              child: const Text("Change"),
            ),
          ],
        );
      },
    );
  }



  Future<void> _pickImage() async {
    try {
      // Use file_picker to pick an image file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        final bytes = result.files.single.bytes; // Access bytes directly
        if (bytes != null) {
          final base64Image = base64Encode(bytes);

          setState(() {
            _profileImage = base64Image;
          });

          await _saveProfileImage(base64Image);
        } else {
          throw Exception("File bytes are null.");
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }



  Future<void> _saveProfileImage(String base64Image) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .update({'profileImage': base64Image});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile photo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.teal.shade300,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Homescreen()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AddRent()));
          }, icon: Icon(Icons.add_box))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Profile Image
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage.isNotEmpty
                      ? MemoryImage(base64Decode(_profileImage))
                      : null,
                  child: _profileImage.isEmpty
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Change Photo'),
              ),
              const SizedBox(height: 30),
              // Profile Details
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Name",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(_username,
                    style: const TextStyle(fontSize: 18)),
              ),
              const Divider(height: 30, thickness: 1),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(_email, style: const TextStyle(fontSize: 18)),
              ),
              const Divider(height: 30, thickness: 1),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Mobile",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(_mobile, style: const TextStyle(fontSize: 18)),
              ),
              const Divider(height: 30, thickness: 1),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: _changePassword,
                  icon: const Icon(Icons.lock),
                  label: const Text('Change Password'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade300,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
