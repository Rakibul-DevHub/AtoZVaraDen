import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:atoz_vara_den/data/sample_data.dart';
import 'package:atoz_vara_den/main.dart';

void main() {
  testWidgets('App renders SplashScreen with branding and tagline', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify splash screen elements
    expect(find.text('A to Z Vara Den'), findsOneWidget);
    expect(find.text('ভাড়া দিন ও নিন সহজে'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  test('ListingRepository manages rental properties correctly', () {
    final repo = ListingRepository();
    expect(repo.listings.isNotEmpty, true);

    final initialCount = repo.listings.length;
    final newProperty = {
      'id': 'test_123',
      'title': 'Test Flat in Banani',
      'description': 'A nice 2-bed apartment',
      'category': 'Family Flat',
      'bedroom': '2 Beds',
      'bathroom': '2 Baths',
      'price': 25000.0,
      'address': 'Road 11, Banani, Dhaka',
      'contact_info': '+880 1700-000000',
      'imageUrls': <String>[],
      'images': <String>[],
    };

    repo.addListing(newProperty);
    expect(repo.listings.length, initialCount + 1);
    expect(repo.listings.first['id'], 'test_123');
    expect(repo.listings.first['title'], 'Test Flat in Banani');
  });
}
