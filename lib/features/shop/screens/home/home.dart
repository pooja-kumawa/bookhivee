import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:shikha/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:shikha/features/shop/screens/home/widgets/home_categories.dart';
import 'package:shikha/features/shop/screens/home/widgets/promo_slider.dart';
import '../../../../common/widgets/appbar/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/images/layouts/grid_layout.dart';
import '../../../../common/widgets/primary_header_container.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../api/book_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _books = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDefaultBooks();
  }

  // Fetch default books to display initially
  void _fetchDefaultBooks() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final defaultBooks = await fetchBooks("some"); // Fetch popular books as default
      setState(() {
        _books = defaultBooks;
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetch books based on the user's search query
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
    }
  }

  // Method to save the search query to Firestore
  Future<void> _saveSearchData(String searchQuery) async {
    // Get the current user from Firebase Auth
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the user's email from the authenticated user
      final userEmail = user.email;

      // Get a reference to the Firestore instance
      final firestore = FirebaseFirestore.instance;

      // Create a document with the user's email in the "search" collection
      final docRef = firestore.collection('search').doc(userEmail);

      // Update the document to append the new search query to the array
      await docRef.set({
        'search_queries': FieldValue.arrayUnion([searchQuery]),
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp for ordering
      }, SetOptions(merge: true)); // Use merge to create if doesn't exist
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
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  // Appbar
                  const THomeAppBar(),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  // Searchbar
                  TSearchContainer(
                    controller: _searchController,
                    onSearch: _searchBooks,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  // Categories
                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TSectionHeading(
                          title: 'Popular Categories',
                          showActionButton: false,
                          textColor: Colors.white,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        const THomeCategories(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  TPromoSlider(
                    banners: [TImages.banner1, TImages.banner2, TImages.banner3],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  // Display loading indicator or grid view based on state
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : TGridLayout(
                    books: _books,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
