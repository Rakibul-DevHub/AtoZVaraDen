import 'package:flutter/material.dart';
import '../../data/sample_data.dart';

class AddRentScreen extends StatefulWidget {
  const AddRentScreen({super.key});

  @override
  State<AddRentScreen> createState() => _AddRentScreenState();
}

class _AddRentScreenState extends State<AddRentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _bedroomController = TextEditingController(text: '3 Beds');
  final _bathroomController = TextEditingController(text: '2 Baths');
  final _contactController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController(
    text: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800&auto=format&fit=crop',
  );

  String _selectedCategory = 'Family Flat';
  final List<String> _categories = [
    'Family Flat',
    'Bachelor / Sublet',
    'Commercial / Office',
    'Hostel',
    'Garage / Parking',
    'Warehouse / Space',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _bedroomController.dispose();
    _bathroomController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitListing() {
    if (!_formKey.currentState!.validate()) return;

    final newListing = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'category': _selectedCategory,
      'bedroom': _bedroomController.text.trim(),
      'bathroom': _bathroomController.text.trim(),
      'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
      'address': _addressController.text.trim(),
      'contact_info': _contactController.text.trim(),
      'imageUrls': [
        _imageUrlController.text.trim().isNotEmpty
            ? _imageUrlController.text.trim()
            : 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800&auto=format&fit=crop',
      ],
      'images': <String>[],
    };

    ListingRepository().addListing(newListing);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rental listing posted successfully!'),
        backgroundColor: Colors.teal,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post New Rental Ad', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add_home_work, color: Colors.teal.shade700, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'List Your Property for Rent',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade900,
                                  fontSize: 16,
                                ),
                              ),
                              const Text(
                                'Fill details to reach thousands of potential tenants across the country.',
                                style: TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Property Category *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: _categories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCategory = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Listing Title *',
                      hintText: 'e.g. Spacious 3-Bed Flat in Dhanmondi',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (val) =>
                        (val == null || val.trim().isEmpty) ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 16),

                  // Price & Contact
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Monthly Rent (৳) *',
                            hintText: 'e.g. 25000',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.payments),
                          ),
                          validator: (val) =>
                              (val == null || val.trim().isEmpty) ? 'Enter price' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _contactController,
                          decoration: const InputDecoration(
                            labelText: 'Contact Phone *',
                            hintText: '+880 17...',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                          ),
                          validator: (val) =>
                              (val == null || val.trim().isEmpty) ? 'Enter contact' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Bedrooms & Bathrooms
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _bedroomController,
                          decoration: const InputDecoration(
                            labelText: 'Bedrooms',
                            hintText: 'e.g. 3 Beds',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.bed),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _bathroomController,
                          decoration: const InputDecoration(
                            labelText: 'Bathrooms',
                            hintText: 'e.g. 2 Baths',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.bathtub_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Address
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address / Location *',
                      hintText: 'e.g. Road 12, Banani, Dhaka',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (val) =>
                        (val == null || val.trim().isEmpty) ? 'Please enter location' : null,
                  ),
                  const SizedBox(height: 16),

                  // Image URL
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Photo Image URL',
                      hintText: 'https://...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.image),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Full Description *',
                      hintText: 'Detail features, amenities, rules, floor level, etc...',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    validator: (val) =>
                        (val == null || val.trim().isEmpty) ? 'Please enter description' : null,
                  ),
                  const SizedBox(height: 24),

                  // Submit button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _submitListing,
                      child: const Text(
                        'Submit Listing Ad',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
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
