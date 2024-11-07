import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:shikha/utils/constants/sizes.dart';
import '../../../../common/widgets/appbar/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/curved_edges.dart';
import '../../../../common/widgets/images/layouts/grid_layout.dart';
import '../../../../navigation_menu.dart';
import '../../api/book_service.dart';

class StoreScreen extends StatefulWidget {
  final String initialSearchQuery;

  const StoreScreen({super.key, this.initialSearchQuery = ''});

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _books = [];
  List<dynamic> _filteredBooks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialSearchQuery.isNotEmpty) {
      _searchController.text = widget.initialSearchQuery;
      _searchBooks(); // Automatically search for the initial query
    } else {
      _fetchDefaultBooks();
    }
  }

  void _fetchDefaultBooks() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final defaultBooks = await fetchBooks('some');
      setState(() {
        _books = defaultBooks;
        _filteredBooks = defaultBooks;
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchBooks() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      try {
        final books = await fetchBooks(query);
        setState(() {
          _books = books;
          _filteredBooks = books;
        });

        // Save the search query to Firestore
        await _saveSearchData(query);

      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _filteredBooks = _books;
      });
    }
  }

  Future<void> _saveSearchData(String searchQuery) async {
    // Get the current user from Firebase Auth
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the user's email from the authenticated user
      final userEmail = user.email;

      // Get a reference to the Firestore instance
      final firestore = FirebaseFirestore.instance;

      // Check if a document for this user already exists
      final userDoc = await firestore.collection('search').doc(userEmail).get();

      if (userDoc.exists) {
        // If the document exists, update it by appending the new search query to the array
        await firestore.collection('search').doc(userEmail).update({
          'search_queries': FieldValue.arrayUnion([searchQuery]),
          'timestamp': FieldValue.serverTimestamp(), // Optional: update the timestamp
        });
      } else {
        // If the document doesn't exist, create it with the search query
        await firestore.collection('search').doc(userEmail).set({
          'email': userEmail,
          'search_queries': [searchQuery], // Start with the first search query
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } else {
      print('No user is logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.find<NavigationController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: TCustomCurvedEdges(),
              child: Container(
                height: 230,
                color: Colors.orange,
                padding: const EdgeInsets.symmetric(
                    vertical: TSizes.defaultSpace,
                    horizontal: TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      'Search and Filter',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections / 2),
                    TSearchContainer(
                      controller: _searchController,
                      onSearch: _searchBooks,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: TGridLayout(
                books: _filteredBooks,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
