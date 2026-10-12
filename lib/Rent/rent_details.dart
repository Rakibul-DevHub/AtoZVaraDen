import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Message/message.dart';

class RentDetails extends StatefulWidget {
  final String title;
  final String description;
  final String bedroom;
  final String bathroom;
  final List<String>? images; // Base64 image strings
  final List<String>? imageUrls; // Network image URLs
  final double price;
  final String address;
  final String contactInfo;

  const RentDetails({
    super.key,
    required this.title,
    required this.description,
    required this.bedroom,
    required this.bathroom,
    this.images,
    this.imageUrls,
    required this.price,
    required this.address,
    required this.contactInfo,
  });

  @override
  State<RentDetails> createState() => _RentDetailsState();
}

class _RentDetailsState extends State<RentDetails> {
  late PageController _pageController;
  int _currentImageIndex = 0;

  List<ImageProvider> _resolvedImages = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentImageIndex);
    _resolveImages();
  }

  void _resolveImages() {
    final List<ImageProvider> providers = [];

    if (widget.imageUrls != null && widget.imageUrls!.isNotEmpty) {
      for (final url in widget.imageUrls!) {
        providers.add(NetworkImage(url));
      }
    }

    if (widget.images != null && widget.images!.isNotEmpty) {
      for (final base64Str in widget.images!) {
        try {
          final decoded = base64Decode(base64Str);
          providers.add(MemoryImage(decoded));
        } catch (_) {}
      }
    }

    _resolvedImages = providers;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousImage() {
    if (_currentImageIndex > 0) {
      setState(() {
        _currentImageIndex--;
      });
      _pageController.animateToPage(
        _currentImageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextImage() {
    if (_currentImageIndex < _resolvedImages.length - 1) {
      setState(() {
        _currentImageIndex++;
      });
      _pageController.animateToPage(
        _currentImageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text("Rent Details", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : 16,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image gallery Section
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_resolvedImages.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: SizedBox(
                            height: isDesktop ? 400 : 260,
                            width: double.infinity,
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                              itemCount: _resolvedImages.length,
                              itemBuilder: (context, index) {
                                final imageProvider = _resolvedImages[index];
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: InteractiveViewer(
                                            child: Image(
                                              image: imageProvider,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Image(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 240,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.home_work_outlined,
                              size: 100,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                      // Previous Button
                      if (_resolvedImages.length > 1 && _currentImageIndex > 0)
                        Positioned(
                          left: 16,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                              onPressed: _goToPreviousImage,
                            ),
                          ),
                        ),

                      // Next Button
                      if (_resolvedImages.length > 1 &&
                          _currentImageIndex < _resolvedImages.length - 1)
                        Positioned(
                          right: 16,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                              onPressed: _goToNextImage,
                            ),
                          ),
                        ),

                      // Page indicator badge
                      if (_resolvedImages.length > 1)
                        Positioned(
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_currentImageIndex + 1} / ${_resolvedImages.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Title Section & Price Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.teal.shade200),
                      ),
                      child: Text(
                        "৳ ${widget.price.toStringAsFixed(0)} / mo",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),

                // Location Section
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.teal, size: 20),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        widget.address,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                // Key specs cards (Bed, Bath, Category)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.bed, color: Color(0xFFc68c53)),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Bedrooms', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text(widget.bedroom, style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.bathtub_outlined, color: Colors.blueGrey),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Bathrooms', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text(widget.bathroom, style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // Description Section
                const Text(
                  "Property Description",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 15.0,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32.0),

                // Contact & Action Buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.teal.shade100),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.teal.shade600,
                        radius: 24,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Owner / Agent Contact",
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                            Text(
                              widget.contactInfo,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.phone, size: 18),
                            label: const Text('Call'),
                            onPressed: () async {
                              final Uri url = Uri(
                                scheme: 'tel',
                                path: widget.contactInfo.replaceAll(RegExp(r'[^0-9+]'), ''),
                              );
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Contact: ${widget.contactInfo}')),
                                  );
                                }
                              }
                            },
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.teal,
                              side: const BorderSide(color: Colors.teal),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.chat_bubble_outline, size: 18),
                            label: const Text('Chat'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MessageScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
