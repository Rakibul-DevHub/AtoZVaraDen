import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ResponsiveCarousel extends StatelessWidget {
  const ResponsiveCarousel({super.key});

  final List<Map<String, String>> _bannerItems = const [
    {
      'imageUrl': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=1200&auto=format&fit=crop',
      'title': 'Find Premium Family Apartments',
      'subtitle': 'Verified rental homes with modern amenities across the city',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=1200&auto=format&fit=crop',
      'title': 'Commercial & Office Spaces',
      'subtitle': 'Ready workstations and executive offices for growing businesses',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=1200&auto=format&fit=crop',
      'title': 'Affordable Bachelor & Sublet Seats',
      'subtitle': 'Furnished rooms with utilities included for students & professionals',
    },
    {
      'imageUrl': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1200&auto=format&fit=crop',
      'title': 'Luxury Condos & Duplex Houses',
      'subtitle': 'Experience superior living in prime locations',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    double carouselHeight;
    double viewportFraction;

    if (screenWidth <= 600) {
      carouselHeight = 190;
      viewportFraction = 0.92;
    } else if (screenWidth <= 1024) {
      carouselHeight = 260;
      viewportFraction = 0.88;
    } else {
      carouselHeight = 340;
      viewportFraction = 0.80;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: CarouselSlider(
        items: _bannerItems.map((item) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  item['imageUrl']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.teal.shade700,
                      child: const Center(
                        child: Icon(Icons.apartment, size: 64, color: Colors.white70),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.75),
                        Colors.black.withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item['title']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth <= 600 ? 18 : 24,
                          shadows: const [
                            Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 4),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['subtitle']!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: screenWidth <= 600 ? 12 : 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: carouselHeight,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          enlargeCenterPage: true,
          viewportFraction: viewportFraction,
        ),
      ),
    );
  }
}
