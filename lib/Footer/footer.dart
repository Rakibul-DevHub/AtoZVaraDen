import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  void _showNotice(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title section coming soon.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.teal.shade800,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.home_work_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                "A to Z Vara Den",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "© 2024-2026 A to Z Vara Den. All rights reserved.",
            style: TextStyle(fontSize: 13, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 8,
            children: [
              FooterLink(
                text: "Privacy Policy",
                onPressed: () => _showNotice(context, "Privacy Policy"),
              ),
              FooterLink(
                text: "Terms of Service",
                onPressed: () => _showNotice(context, "Terms of Service"),
              ),
              FooterLink(
                text: "Help & FAQ",
                onPressed: () => _showNotice(context, "Help & FAQ"),
              ),
              FooterLink(
                text: "Contact Support",
                onPressed: () => _showNotice(context, "Contact Support"),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              IconButton(
                onPressed: () => _showNotice(context, "Facebook"),
                icon: const Icon(Icons.facebook, color: Colors.white70),
                tooltip: 'Facebook',
              ),
              IconButton(
                onPressed: () => _showNotice(context, "Email"),
                icon: const Icon(Icons.email_outlined, color: Colors.white70),
                tooltip: 'Email Us',
              ),
              IconButton(
                onPressed: () => _showNotice(context, "Share"),
                icon: const Icon(Icons.share, color: Colors.white70),
                tooltip: 'Share App',
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
  final VoidCallback? onPressed;

  const FooterLink({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.white70,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
