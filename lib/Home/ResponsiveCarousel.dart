import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ResponsiveCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Determine the screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    // Set height based on screen width
    double carouselHeight;
    double carouselWidth;
    if (screenWidth <= 600) {
      // Mobile screen
      carouselHeight = screenHeight / 4;
      carouselWidth = screenWidth * 0.9; // Occupy 90% of the width
    }
    else if (screenWidth <= 1024) {
      // Tablet screen
      carouselHeight = screenHeight / 3;
      carouselWidth = screenWidth * 0.85; // Occupy 85% of the width
    }
    else {
      // PC screen
      carouselHeight = screenHeight / 2.3;
      carouselWidth = screenWidth * 0.7; // Occupy 80% of the width
    }

    return SizedBox(
      width: carouselWidth, // Dynamic width
      child: CarouselSlider(
        items: [
          Image.asset(
            'assets/images/imageAutoScroll/hostel.jpg',
            fit: BoxFit.cover,
            width: carouselWidth, // Set dynamic width for each image
          ),
          Image.asset(
            'assets/images/imageAutoScroll/hotel.jpg',
            fit: BoxFit.cover,
            width: carouselWidth, // Set dynamic width for each image
          ),
          Image.asset(
            'assets/images/imageAutoScroll/house_balcony.jpg',
            fit: BoxFit.cover,
            width: carouselWidth, // Set dynamic width for each image
          ),
          Image.asset(
            'assets/images/imageAutoScroll/lift.jpg',
            fit: BoxFit.cover,
            width: carouselWidth, // Set dynamic width for each image
          ),
          Image.asset(
            'assets/images/imageAutoScroll/meeting_room.jpg',
            fit: BoxFit.cover,
            width: carouselWidth, // Set dynamic width for each image
          ),
        ],
        options: CarouselOptions(
          height: carouselHeight, // Set height dynamically
          autoPlay: true, // Enable auto-scroll
          enlargeCenterPage: true, // Highlight the center image
          viewportFraction: 1.0, // Full width for each image
          aspectRatio: carouselWidth / carouselHeight, // Dynamic aspect ratio
        ),
      ),
    );
  }
}
