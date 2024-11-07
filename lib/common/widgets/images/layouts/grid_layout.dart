import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For user authentication

import '../../../../features/shop/screens/home/widgets/books_description.dart';
import '../../products_cart/product_card_vertical.dart';
import '../../../../utils/constants/sizes.dart';

class TGridLayout extends StatefulWidget {
  final List<dynamic> books;

  const TGridLayout({super.key, required this.books});

  @override
  _TGridLayoutState createState() => _TGridLayoutState();
}

class _TGridLayoutState extends State<TGridLayout> {
  Map<int, bool> favoriteStates = {};
  List<dynamic> favoriteBooks = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStates();
  }

  Future<void> _loadFavoriteStates() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < widget.books.length; i++) {
      favoriteStates[i] = prefs.getBool('favorite_$i') ?? false; // Load favorite states
    }
    String? savedFavorites = prefs.getString('favorite_books');
    if (savedFavorites != null) {
      setState(() {
        favoriteBooks = jsonDecode(savedFavorites);
      });
    }
    setState(() {});
  }

  Future<void> _saveFavoriteState(int index, dynamic book) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('favorite_$index', favoriteStates[index]!);

    if (favoriteStates[index]!) {
      // Add the book to the favorite list
      favoriteBooks.add(book);
      _addBookToWishlist(book); // Save in Firestore wishlist
    } else {
      // Remove the book from the favorite list
      favoriteBooks.removeWhere((item) =>
      item['volumeInfo']['title'] == book['volumeInfo']['title']);
      _removeBookFromWishlist(book); // Remove from Firestore wishlist
    }

    await prefs.setString('favorite_books', jsonEncode(favoriteBooks));
  }

  void toggleFavorite(int index, dynamic book) {
    setState(() {
      favoriteStates[index] = !favoriteStates[index]!; // Toggle favorite state
      _saveFavoriteState(index, book); // Save the updated state
    });
  }

  Future<void> _addBookToWishlist(dynamic book) async {
    // Get the current user's email
    final User? user = _auth.currentUser;
    final String? userEmail = user?.email;

    if (userEmail != null) {
      // Prepare book details
      final String title = book['volumeInfo']['title'] ?? 'No Title';
      final String author = book['volumeInfo']['authors']?[0] ?? 'Unknown Author';

      // Create or update the user's wishlist collection in Firestore
      await _firestore.collection('wishlist').doc(userEmail).set({
        'favorites': FieldValue.arrayUnion([
          {'title': title, 'author': author}
        ]),
      }, SetOptions(merge: true));
    }
  }

  Future<void> _removeBookFromWishlist(dynamic book) async {
    // Get the current user's email
    final User? user = _auth.currentUser;
    final String? userEmail = user?.email;

    if (userEmail != null) {
      // Prepare book details
      final String title = book['volumeInfo']['title'] ?? 'No Title';
      final String author = book['volumeInfo']['authors']?[0] ?? 'Unknown Author';

      // Remove the book from the user's wishlist in Firestore
      await _firestore.collection('wishlist').doc(userEmail).update({
        'favorites': FieldValue.arrayRemove([
          {'title': title, 'author': author}
        ]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.books.isEmpty) {
      return const Center(child: Text('No books found'));
    } else {
      return GridView.builder(
        itemCount: widget.books.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: TSizes.gridViewSpacing,
          crossAxisSpacing: TSizes.gridViewSpacing,
          mainAxisExtent: 288,
        ),
        itemBuilder: (context, index) {
          final book = widget.books[index];
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
            isFavorite: favoriteStates[index] ?? false,
            toggleFavorite: () => toggleFavorite(index, book),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailPage(
                    title: title,
                    thumbnailUrl: thumbnail,
                    authorName: book['volumeInfo']['authors']?[0] ?? 'Unknown Author',
                    price: price,
                    downloadUrl: downloadUrl,
                    isFavorite: favoriteStates[index] ?? false,
                    onFavoriteToggle: (isFav) {
                      toggleFavorite(index, book);
                    },
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }
}
