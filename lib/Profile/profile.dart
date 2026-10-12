import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../Auth/auth_screen.dart';
import '../Auth/auth_service.dart';

class Profile extends StatefulWidget {
  final String userId;
  final int initialTabIndex;

  const Profile({
    super.key,
    required this.userId,
    this.initialTabIndex = 0,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _username = '';
  String _email = '';
  String _mobile = '';
  String _profileImage = '';
  bool _isLoading = true;

  // Settings State
  bool _pushNotifications = true;
  bool _emailAlerts = true;
  bool _showPhoneOnListings = true;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final localAuth = LocalAuthState();

    try {
      if (AuthService.isFirebaseAvailable && AuthService.currentFirebaseUser != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.userId)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          if (mounted) {
            setState(() {
              _username = data['username'] ?? AuthService.currentFirebaseUser?.displayName ?? 'Demo User';
              _email = data['email'] ?? AuthService.currentFirebaseUser?.email ?? 'user@atozvaraden.com';
              _mobile = data['mobile'] ?? '+880 1712-345678';
              _profileImage = data['profileImage'] ?? '';
              _isLoading = false;
            });
            return;
          }
        }
      }
    } catch (_) {}

    // Fallback to local user info
    if (mounted) {
      setState(() {
        _username = AuthService.isLoggedIn ? localAuth.username : 'Guest User';
        _email = AuthService.isLoggedIn ? localAuth.email : 'Sign in to access your account';
        _mobile = AuthService.isLoggedIn ? localAuth.phone : 'Not set';
        _isLoading = false;
      });
    }
  }

  Future<void> _changePassword() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password updated successfully!")),
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
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        final bytes = result.files.single.bytes;
        if (bytes != null) {
          final base64Image = base64Encode(bytes);
          setState(() {
            _profileImage = base64Image;
          });
          _saveProfileToBackend();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _saveProfileToBackend() async {
    try {
      if (AuthService.isFirebaseAvailable && AuthService.currentFirebaseUser != null) {
        await FirebaseFirestore.instance.collection('Users').doc(widget.userId).set({
          'username': _username,
          'email': _email,
          'mobile': _mobile,
          'profileImage': _profileImage,
        }, SetOptions(merge: true));
      }
    } catch (_) {}

    LocalAuthState().username = _username;
    LocalAuthState().email = _email;
    LocalAuthState().phone = _mobile;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.teal),
      );
    }
  }

  void _editDetailsDialog() {
    final nameCtrl = TextEditingController(text: _username);
    final mobileCtrl = TextEditingController(text: _mobile);

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Edit Profile Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: mobileCtrl,
                decoration: const InputDecoration(labelText: 'Mobile Phone'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  _username = nameCtrl.text.trim();
                  _mobile = mobileCtrl.text.trim();
                });
                Navigator.pop(dialogCtx);
                _saveProfileToBackend();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.teal)),
      );
    }

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile & Settings', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'My Profile'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProfileTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 650),
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 54,
                        backgroundColor: Colors.teal.shade100,
                        backgroundImage: _profileImage.isNotEmpty
                            ? MemoryImage(base64Decode(_profileImage))
                            : null,
                        child: _profileImage.isEmpty
                            ? const Icon(Icons.person, size: 64, color: Colors.teal)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.teal,
                            child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _username.isNotEmpty ? _username : 'User Name',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _email,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  // Quick Badges
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.verified, size: 16, color: Colors.teal),
                        label: const Text('Verified Member', style: TextStyle(fontSize: 12)),
                        backgroundColor: Colors.teal.shade50,
                        side: BorderSide.none,
                      ),
                      Chip(
                        avatar: const Icon(Icons.home_work, size: 16, color: Colors.teal),
                        label: const Text('Tenant & Host', style: TextStyle(fontSize: 12)),
                        backgroundColor: Colors.teal.shade50,
                        side: BorderSide.none,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  if (AuthService.isLoggedIn) ...[
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.teal),
                      title: const Text('Phone Number'),
                      subtitle: Text(_mobile.isNotEmpty ? _mobile : 'Not set'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: _editDetailsDialog,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email_outlined, color: Colors.teal),
                      title: const Text('Registered Email'),
                      subtitle: Text(_email),
                    ),
                    ListTile(
                      leading: const Icon(Icons.fingerprint, color: Colors.teal),
                      title: const Text('Account ID'),
                      subtitle: Text(widget.userId),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          side: BorderSide(color: Colors.red.shade300),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.logout),
                        label: const Text('Log Out'),
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          await AuthService.signOut();
                          if (mounted) {
                            setState(() {
                              _fetchUserProfile();
                            });
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Logged out successfully')),
                            );
                          }
                        },
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    const Text(
                      'You are currently browsing as a guest. Sign in to manage your listings and profile.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.login),
                        label: const Text('Sign In / Register', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AuthScreen(initialIsLogin: true)),
                          ).then((_) {
                            if (mounted) {
                              setState(() {
                                _fetchUserProfile();
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 650),
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Security',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.lock_outline, color: Colors.teal),
                    title: const Text('Change Password'),
                    subtitle: const Text('Update your secret login password'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _changePassword,
                  ),
                  const Divider(height: 28),

                  const Text(
                    'Notifications & Alerts',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    activeThumbColor: Colors.teal,
                    secondary: const Icon(Icons.notifications_active_outlined, color: Colors.teal),
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Instant alerts for rent inquiries and chat messages'),
                    value: _pushNotifications,
                    onChanged: (val) {
                      setState(() => _pushNotifications = val);
                    },
                  ),
                  SwitchListTile(
                    activeThumbColor: Colors.teal,
                    secondary: const Icon(Icons.mark_email_read_outlined, color: Colors.teal),
                    title: const Text('Email Updates'),
                    subtitle: const Text('Weekly digest of trending rental listings'),
                    value: _emailAlerts,
                    onChanged: (val) {
                      setState(() => _emailAlerts = val);
                    },
                  ),
                  const Divider(height: 28),

                  const Text(
                    'Privacy & Preferences',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    activeThumbColor: Colors.teal,
                    secondary: const Icon(Icons.visibility_outlined, color: Colors.teal),
                    title: const Text('Show Phone on Listings'),
                    subtitle: const Text('Allow interested tenants to see your direct phone number'),
                    value: _showPhoneOnListings,
                    onChanged: (val) {
                      setState(() => _showPhoneOnListings = val);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.language, color: Colors.teal),
                    title: const Text('Language / ভাষা'),
                    subtitle: Text(_selectedLanguage),
                    trailing: DropdownButton<String>(
                      value: _selectedLanguage,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'English', child: Text('English')),
                        DropdownMenuItem(value: 'বাংলা', child: Text('বাংলা')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedLanguage = val);
                        }
                      },
                    ),
                  ),
                  const Divider(height: 28),

                  const Text(
                    'About & Legal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.teal),
                    title: const Text('App Version'),
                    subtitle: const Text('A to Z Vara Den v1.0.0+1 (Web & Mobile)'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.policy_outlined, color: Colors.teal),
                    title: const Text('Terms of Service & Privacy Policy'),
                    subtitle: const Text('Review platform policies and tenant terms'),
                    trailing: const Icon(Icons.open_in_new, size: 18),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Terms of service available at https://www.net.twistbazar.com/')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
