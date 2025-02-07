
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensures the footer takes full width of the screen
      color: Colors.teal.shade200, // Background color for the footer
      padding: const EdgeInsets.all(3), // Padding around the footer content
      child: Column(
        mainAxisSize: MainAxisSize.min, // Shrink-wrap the content
        children: [
          const Text(
            "© 2024 Vhara Din. All rights reserved.",
            style: TextStyle(fontSize: 14, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3), // Spacing between elements
          Wrap(
            alignment: WrapAlignment.center, // Center the wrapped items
            spacing: 20, // Space between items horizontally
            runSpacing: 3, // Space between items vertically
            children: [
              FooterLink(
                text: "Privacy Policy",
                onPressed: () {
                  // Handle privacy policy click
                  print("Privacy Policy clicked!");
                },
              ),
              FooterLink(
                text: "Terms of Service",
                onPressed: () {
                  // Handle terms of service click
                  print("Terms of Service clicked!");
                },
              ),
              FooterLink(
                text: "Contact Us",
                onPressed: () {
                  // Handle contact us click
                  if (kDebugMode) {
                    print("Contact Us clicked!");
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 3),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20, // Space between icons horizontally
            runSpacing: 3, // Space between icons vertically
            children: [
              IconButton(
                onPressed: () {
                  // Handle Facebook click
                  print("Facebook clicked!");
                },
                icon: const Icon(Icons.facebook, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  // Handle Twitter click
                  print("Twitter clicked!");
                },
                icon: const Icon(Icons.alternate_email, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  // Handle LinkedIn click
                  print("LinkedIn clicked!");
                },
                icon: const Icon(Icons.link, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FooterLink extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const FooterLink({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          decoration: TextDecoration.underline, // Makes the link look clickable
        ),
      ),
    );
  }
}




//todo: fixing

