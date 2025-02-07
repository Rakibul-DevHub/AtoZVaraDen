import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RentDetails extends StatefulWidget {
  final String title;
  final String description;
  final String bedroom;
  final String bathroom;
  final List<String>? images; // List of Base64 image strings
  final double price;
  final String address;
  final String contactInfo;

  const RentDetails({
    Key? key,
    required this.title,
    required this.description,
    required this.bedroom,
    required this.bathroom,
    this.images,
    required this.price,
    required this.address,
    required this.contactInfo,
  }) : super(key: key);

  @override
  _RentDetailsState createState() => _RentDetailsState();
}

class _RentDetailsState extends State<RentDetails> {
  late PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentImageIndex);
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
    if (_currentImageIndex < (widget.images?.length ?? 1) - 1) {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade300,
        title: const Text("Rent Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Navigation Buttons
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (widget.images != null && widget.images!.isNotEmpty)
                    Container(
                      height: 250, // Constrain the height of the image display
                      width: 300, // Constrain the width of the image display
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemCount: widget.images!.length,
                        itemBuilder: (context, index) {
                          final String base64Image = widget.images![index];
                          final image = base64Decode(base64Image);
                          final imageProvider = MemoryImage(image);

                          return GestureDetector(
                            onTap: () {
                              // Show full image in a dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child:
                                    InteractiveViewer(
                                      child: FractionallySizedBox(
                                        heightFactor: 0.7, // 70% of the parent's height
                                        widthFactor: 0.7,  // 70% of the parent's width
                                        child: Image(
                                          image: imageProvider,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),

                                  );
                                },
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0), // Rounded corners
                              child: Image(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 200,
                        color: Colors.grey,
                      ),
                    ),

                  // Previous Button
                  if (widget.images != null && widget.images!.isNotEmpty)
                    Positioned(
                      left: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5), // Semi-transparent black background
                          shape: BoxShape.circle, // Circular shape for the button
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: _goToPreviousImage,
                        ),
                      ),
                    ),

                  // Next Button
                  if (widget.images != null && widget.images!.isNotEmpty)
                    Positioned(
                      right: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5), // Semi-transparent black background
                          shape: BoxShape.circle, // Circular shape for the button
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                          onPressed: _goToNextImage,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            // Price Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "\$${widget.price.toStringAsFixed(2)} / month",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Location Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.teal),
                  const SizedBox(width: 8.0),
                  Text(
                    widget.address,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Description Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.bed, color: Color(0xFFc68c53)),
                  const SizedBox(width: 8.0),
                  Text(
                    widget.bedroom,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.bathroom, color: Color(0xFF666666)),
                  const SizedBox(width: 8.0),
                  Text(
                    widget.bedroom,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Contact Info Section
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Row(
            //     children: [
            //       const Icon(Icons.phone, color: Colors.blue),
            //       const SizedBox(width: 8.0),
            //       Text(
            //         widget.contactInfo,
            //         style: const TextStyle(
            //           fontSize: 16.0,
            //           decoration: TextDecoration.underline,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.phone, color: Colors.blue),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () async {
                      final Uri url = Uri(
                        scheme: 'tel',
                        path: widget.contactInfo,
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        // Handle error if the phone number cannot be launched
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Unable to make a call')),
                        );
                      }
                    },
                    child: Text(
                      widget.contactInfo,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),



            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}

