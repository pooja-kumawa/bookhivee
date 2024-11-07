import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../common/widgets/products_cart/product_card_vertical.dart';
import '../../../../utils/constants/sizes.dart';
import '../home/widgets/books_description.dart'; // Import your BookDetailPage

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<dynamic> favoriteBooks = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteBooks();
  }

  Future<void> _loadFavoriteBooks() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedFavorites = prefs.getString('favorite_books');
    if (savedFavorites != null) {
      setState(() {
        favoriteBooks = jsonDecode(savedFavorites);
      });
    }
  }

  Future<void> _removeFavorite(int index) async {
    setState(() {
      favoriteBooks.removeAt(index); // Remove from favorites
    });

    await _saveFavoriteBooks(); // Save updated favorites to shared preferences
  }

  Future<void> _saveFavoriteBooks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('favorite_books', jsonEncode(favoriteBooks));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0), // Increase height for the curve
        child: Stack(
          children: [
            Container(
              height: 120, // Control the height
              decoration: const BoxDecoration(
                color: Colors.orange, // Set AppBar color to orange
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30), // Slight curve
                ),
              ),
            ),
            AppBar(
              backgroundColor: Colors.transparent, // Make AppBar transparent
              elevation: 0,
              title: Text(
                'Wishlist',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              centerTitle: true,
            ),
          ],
        ),
      ),
      body: favoriteBooks.isEmpty
          ? const Center(child: Text('No favorites added'))
          : GridView.builder(
        itemCount: favoriteBooks.length,
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: TSizes.gridViewSpacing,
          crossAxisSpacing: TSizes.gridViewSpacing,
          mainAxisExtent: 288,
        ),
        itemBuilder: (context, index) {
          final book = favoriteBooks[index];
          final title = book['volumeInfo']['title'] ?? 'No Title';
          final thumbnail = book['volumeInfo']['imageLinks']?['thumbnail'] ?? '';
          final price = book['saleInfo']['listPrice']?['amount']?.toString() ?? 'N/A';
          final pdfAccessInfo = book['accessInfo']?['pdf'];
          final downloadUrl = (pdfAccessInfo != null && pdfAccessInfo['isAvailable'] == true)
              ? pdfAccessInfo['downloadLink'] ?? ''
              : '';

          return TProductCartVertical(
            title: title,
            thumbnailUrl: thumbnail,
            price: price,
            downloadUrl: downloadUrl,
            isFavorite: true, // Always true for the favorites list
            toggleFavorite: () {}, // No action since we are not using the icon
            onTap: () {
              // Navigate to BookDetailPage when the book is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailPage(
                    title: title,
                    thumbnailUrl: thumbnail,
                    authorName: book['volumeInfo']['authors']?.join(', ') ?? 'Unknown Author',
                    price: price,
                    downloadUrl: downloadUrl,
                    isFavorite: true, // The book is a favorite when viewed from this screen
                    onFavoriteToggle: (isFav) {
                      if (!isFav) {
                         // Remove from favorites if unfavorited
                      }
                    },
                  ),
                ),
              ).then((_) {
                // Reload favorites when returning from BookDetailPage
                _loadFavoriteBooks();
              });
            },
          );
        },
      ),
    );
  }
}
