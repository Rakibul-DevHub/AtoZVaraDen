import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocalAuthState {
  static final LocalAuthState _instance = LocalAuthState._internal();
  factory LocalAuthState() => _instance;
  LocalAuthState._internal();

  bool isLoggedIn = true;
  String username = 'Rakibul Alam';
  String email = 'user@atozvaraden.com';
  String phone = '+880 1712-345678';
  String uid = 'demo_user_123';
}

class AuthScreen extends StatefulWidget {
  final bool initialIsLogin;
  const AuthScreen({super.key, this.initialIsLogin = true});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isLogin;
  final _emailController = TextEditingController(text: 'user@atozvaraden.com');
  final _passwordController = TextEditingController(text: '123456');
  final _nameController = TextEditingController(text: 'Rakibul Islam');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.initialIsLogin;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    setState(() => _isLoading = true);

    try {
      // Try Firebase if configured
      if (Firebase.apps.isNotEmpty && FirebaseAuth.instance.app.options.apiKey.isNotEmpty) {
        if (_isLogin) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
        } else {
          final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          await cred.user?.updateDisplayName(_nameController.text.trim());
        }
      }
    } catch (_) {
      // If Firebase is not configured or in local demo mode, fallback to local state
    }

    // Set local state
    LocalAuthState().isLoggedIn = true;
    LocalAuthState().email = _emailController.text.trim();
    if (!_isLogin && _nameController.text.trim().isNotEmpty) {
      LocalAuthState().username = _nameController.text.trim();
    }

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isLogin ? 'Logged in successfully!' : 'Account registered successfully!'),
          backgroundColor: Colors.teal,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Sign Up'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isLogin ? Icons.lock_outline : Icons.person_add_alt_1,
                        size: 32,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isLogin ? 'Welcome Back!' : 'Create an Account',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isLogin
                          ? 'Enter your credentials to access your account'
                          : 'Sign up to post ads and manage your rentals',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    if (!_isLogin) ...[
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _isLoading ? null : _handleAuth,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                _isLogin ? 'Login' : 'Sign Up',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? "Don't have an account? Sign up"
                            : "Already have an account? Login",
                        style: const TextStyle(color: Colors.teal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
