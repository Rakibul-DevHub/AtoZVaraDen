
import 'package:atoz_vara_den/Home/homeScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../LoginOut_Signup/loginLogoutScreen.dart';// Import your LoginScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for pop-up effect
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Tween for scaling animation (0 means small, 1 means full size)
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Start the animation
    _controller.forward();

    // Navigate to LoginScreen after 2 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homescreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ScaleTransition(
                scale: _scaleAnimation,
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centers both text and image
                  children: [
                    const Text(
                      'The Place to Find\nEverything for Rent!', // Your desired text
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24, // Adjust the font size as needed
                        fontWeight: FontWeight.bold, // Make the text bold
                      ),
                    ),
                    SizedBox(height: 20), // Adds some space between the text and the image
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset(
                        'assets/images/splash_photo.jpg', // Path to your splash image
                        fit: BoxFit.cover,  // Ensures the image covers the box
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ],
                )




              // SizedBox(
              //   height: 200,
              //   width: 200,
              //   child: Image.asset(
              //     'splash_photo.png', // Path to your splash image
              //     fit: BoxFit.cover,  // Ensures the image covers the screen
              //     width: double.infinity,
              //     height: double.infinity,
              //   ),
              // ),
            );
          },
        ),
      ),
    );
  }
}
