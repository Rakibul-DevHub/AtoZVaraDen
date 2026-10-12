import 'dart:convert';
import 'package:flutter/material.dart';

import '../Auth/auth_screen.dart';
import '../Auth/auth_service.dart';
import '../Footer/footer.dart';
import '../Message/message_list.dart';
import '../Profile/profile.dart';
import '../Rent/rent_details.dart';
import '../data/sample_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AddRent/add_rent_screen.dart';
import 'Drawer/custom_drawer.dart';
import 'ResponsiveCarousel.dart';
import 'Search/searchScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ListingRepository _repository = ListingRepository();
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {'title': 'All', 'icon': Icons.apps},
    {'title': 'Family Flat', 'icon': Icons.family_restroom},
    {'title': 'Bachelor / Sublet', 'icon': Icons.person},
    {'title': 'Commercial / Office', 'icon': Icons.business},
    {'title': 'Hostel', 'icon': Icons.hotel},
    {'title': 'Garage / Parking', 'icon': Icons.directions_car},
  ];

  @override
  void initState() {
    super.initState();
    _repository.addListener(_onRepositoryChanged);
  }

  void _onRepositoryChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _repository.removeListener(_onRepositoryChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(listings: _repository.listings),
      ),
    );
  }

  void _openAddRent() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddRentScreen()),
    );
  }

  void _openProfile([int initialTabIndex = 0]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(
          userId: AuthService.currentUserId,
          initialTabIndex: initialTabIndex,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  Widget _buildProfileMenu(BuildContext context, bool isDesktop) {
    final bool isLoggedIn = AuthService.isLoggedIn;
    final String username = AuthService.currentUsername;
    final String email = AuthService.currentUserEmail;

    return PopupMenuButton<String>(
      tooltip: 'Profile & Settings',
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      color: Colors.white,
      onSelected: (value) async {
        switch (value) {
          case 'profile':
            _openProfile(0);
            break;
          case 'settings':
            _openProfile(1);
            break;
          case 'post_ad':
            _openAddRent();
            break;
          case 'messages':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MessageListScreen()),
            );
            break;
          case 'website':
            final Uri url = Uri.parse('https://www.net.twistbazar.com/');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
            break;
          case 'login':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AuthScreen(initialIsLogin: true),
              ),
            ).then((_) => setState(() {}));
            break;
          case 'signup':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AuthScreen(initialIsLogin: false),
              ),
            ).then((_) => setState(() {}));
            break;
          case 'logout':
            await AuthService.signOut();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
              setState(() {});
            }
            break;
        }
      },
      itemBuilder: (context) => [
        // User info header
        PopupMenuItem<String>(
          enabled: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.teal.shade50,
                  child: isLoggedIn && username.isNotEmpty && username != 'Guest User'
                      ? Text(
                          username[0].toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade800,
                            fontSize: 16,
                          ),
                        )
                      : Icon(Icons.person, color: Colors.teal.shade800, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        email,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person_outline, color: Colors.teal, size: 20),
              SizedBox(width: 12),
              Text('My Profile', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings_outlined, color: Colors.teal, size: 20),
              SizedBox(width: 12),
              Text('Settings & Preferences', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'post_ad',
          child: Row(
            children: [
              Icon(Icons.add_circle_outline, color: Colors.teal, size: 20),
              SizedBox(width: 12),
              Text('Post Rental Ad', style: TextStyle(color: Colors.black87)),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'messages',
          child: Row(
            children: [
              Icon(Icons.chat_outlined, color: Colors.teal, size: 20),
              SizedBox(width: 12),
              Text('Messages / Chats', style: TextStyle(color: Colors.black87)),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'website',
          child: Row(
            children: [
              Icon(Icons.language_rounded, color: Colors.teal, size: 20),
              SizedBox(width: 12),
              Text('Official Website', style: TextStyle(color: Colors.black87)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        if (isLoggedIn)
          const PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.redAccent, size: 20),
                SizedBox(width: 12),
                Text(
                  'Log Out',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
        else ...[
          const PopupMenuItem<String>(
            value: 'login',
            child: Row(
              children: [
                Icon(Icons.login, color: Colors.teal, size: 20),
                SizedBox(width: 12),
                Text('Log In', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.teal)),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'signup',
            child: Row(
              children: [
                Icon(Icons.person_add_outlined, color: Colors.teal, size: 20),
                SizedBox(width: 12),
                Text('Sign Up', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.teal)),
              ],
            ),
          ),
        ],
      ],
      child: isDesktop
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.menu, color: Colors.black87, size: 18),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.teal.shade700,
                    child: isLoggedIn && username.isNotEmpty && username != 'Guest User'
                        ? Text(
                            username[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Icon(Icons.person, color: Colors.white, size: 16),
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              child: CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.teal.shade800,
                  size: 20,
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    final listings = _repository.listings.where((item) {
      if (_selectedCategory == 'All') return true;
      return item['category'] == _selectedCategory;
    }).toList();

    return Scaffold(
      drawer: isDesktop ? null : const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.home_work_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'A to Z Vara Den',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'ভাড়া দিন ও নিন সহজে',
                  style: TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (isDesktop) ...[
            // Web Header Search Bar
            SizedBox(
              width: 280,
              height: 40,
              child: TextField(
                controller: _searchController,
                readOnly: true,
                onTap: _openSearch,
                decoration: InputDecoration(
                  hintText: 'Search properties...',
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, size: 18, color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.18),
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.teal.shade800,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Post Ad', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: _openAddRent,
            ),
            const SizedBox(width: 10),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: _openSearch,
            ),
          ],
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            tooltip: 'Messages',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MessageListScreen()),
              );
            },
          ),
          _buildProfileMenu(context, isDesktop),
          const SizedBox(width: 12),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Post Ad', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: _openAddRent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Responsive Carousel Banner
            const ResponsiveCarousel(),

            // Category Chips Row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.grey.shade50,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat['title'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat['title'] as String;
                            });
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.teal : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected ? Colors.teal : Colors.grey.shade300,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.teal.withValues(alpha: 0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  cat['icon'] as IconData,
                                  size: 18,
                                  color: isSelected ? Colors.white : Colors.teal,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  cat['title'] as String,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Content Section
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedCategory == 'All'
                                  ? 'Explore Available Rentals'
                                  : '$_selectedCategory Rentals',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Showing ${listings.length} verified properties across Bangladesh',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: _openSearch,
                          icon: const Icon(Icons.filter_list, size: 18),
                          label: const Text('Filter & Search'),
                          style: TextButton.styleFrom(foregroundColor: Colors.teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Responsive Grid of Listings
                    if (listings.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(40),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(Icons.home_outlined, size: 60, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            const Text(
                              'No listings found in this category.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                              onPressed: () {
                                setState(() => _selectedCategory = 'All');
                              },
                              child: const Text('View All Categories'),
                            ),
                          ],
                        ),
                      )
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = 1;
                          if (constraints.maxWidth > 950) {
                            crossAxisCount = 3;
                          } else if (constraints.maxWidth > 620) {
                            crossAxisCount = 2;
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: listings.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: crossAxisCount == 1 ? 1.05 : 0.78,
                            ),
                            itemBuilder: (context, index) {
                              final item = listings[index];
                              return _buildListingCard(item);
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Footer
            const SizedBox(height: 24),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildListingCard(Map<String, dynamic> data) {
    ImageProvider? imageProvider;
    final List<dynamic>? networkUrls = data['imageUrls'] as List<dynamic>?;
    final List<dynamic>? imagesList = data['images'] as List<dynamic>?;

    if (networkUrls != null && networkUrls.isNotEmpty) {
      imageProvider = NetworkImage(networkUrls[0] as String);
    } else if (imagesList != null && imagesList.isNotEmpty) {
      final firstImageBase64 = imagesList[0] as String?;
      if (firstImageBase64 != null && firstImageBase64.isNotEmpty) {
        try {
          imageProvider = MemoryImage(base64Decode(firstImageBase64));
        } catch (_) {}
      }
    }

    final String title = data['title'] ?? 'No Title';
    final String description = data['description'] ?? 'No Description';
    final double price = double.tryParse(data['price']?.toString() ?? '0.0') ?? 0.0;
    final String address = data['address'] ?? 'No Address';
    final String category = data['category'] ?? 'Rental';
    final String bedroom = data['bedroom'] ?? 'N/A';
    final String bathroom = data['bathroom'] ?? 'N/A';
    final String contactInfo = data['contact_info'] ?? 'Contact Available';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RentDetails(
                title: title,
                description: description,
                price: price,
                address: address,
                contactInfo: contactInfo,
                bedroom: bedroom,
                bathroom: bathroom,
                imageUrls: networkUrls?.cast<String>(),
                images: imagesList?.cast<String>(),
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Category Tag and Price Tag
            Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: imageProvider != null
                      ? Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(Icons.apartment, size: 50, color: Colors.grey),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.apartment, size: 50, color: Colors.grey),
                          ),
                        ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade700,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Text(
                      '৳ ${price.toStringAsFixed(0)} / mo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Card Body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.teal),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                address,
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.bed, size: 15, color: Colors.brown),
                            const SizedBox(width: 4),
                            Text(bedroom, style: const TextStyle(fontSize: 12)),
                            const SizedBox(width: 14),
                            const Icon(Icons.bathtub_outlined, size: 15, color: Colors.blueGrey),
                            const SizedBox(width: 4),
                            Text(bathroom, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          contactInfo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.teal.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'View Details →',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.teal.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
