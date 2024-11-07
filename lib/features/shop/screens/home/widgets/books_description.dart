import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url launcher
import 'package:iconsax/iconsax.dart'; // Import Iconsax package for heart icon
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import the rating bar package
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class BookDetailPage extends StatefulWidget {
  final String thumbnailUrl;
  final String title;
  final String authorName;
  final String price;
  final String downloadUrl;
  final bool isFavorite; // Added isFavorite parameter
  final Function(bool)? onFavoriteToggle; // Added callback

  const BookDetailPage({
    Key? key,
    required this.thumbnailUrl,
    required this.title,
    required this.authorName,
    required this.price,
    required this.downloadUrl,
    required this.isFavorite, // Initialize the isFavorite parameter
    this.onFavoriteToggle, // Initialize the callback
  }) : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late bool _isFavorite; // Local variable to hold the favorite state
  bool _isDownloaded = false; // Track if the book is downloaded
  double _currentRating = 0.0; // Hold the current rating
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase auth instance

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite; // Initialize the local favorite state
    _checkDownloadStatus(); // Check if the book is already downloaded
    _loadSavedRating(); // Load saved rating from SharedPreferences
  }

  // Check if the book is already downloaded by looking at SharedPreferences
  Future<void> _checkDownloadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDownloaded = prefs.getBool(widget.downloadUrl) ?? false; // Check download status using downloadUrl as key
    });
  }

  // Save the download status to SharedPreferences
  Future<void> _saveDownloadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(widget.downloadUrl, true); // Mark the book as downloaded using downloadUrl as key
  }

  Future<void> _launchURL() async {
    final Uri _url = Uri.parse(widget.downloadUrl);

    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }

    // After launching the URL, assume the book is downloaded
    setState(() {
      _isDownloaded = true; // Mark the book as downloaded
    });
    _saveDownloadStatus(); // Save the download status
  }

  // Function to toggle the favorite status (no-op when from favorites)
  void _toggleFavorite() {
    if (widget.isFavorite) return; // Do nothing if already a favorite

    final newFavoriteState = !_isFavorite; // Toggle the favorite state
    setState(() {
      _isFavorite = newFavoriteState; // Update local state
    });
    widget.onFavoriteToggle?.call(newFavoriteState); // Notify parent about the change
  }

  // Save the rating to Firestore and SharedPreferences
// Save the rating to Firestore and SharedPreferences
  Future<void> _saveRating(double rating) async {
    try {
      // Get the currently authenticated user
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception("No user is currently signed in.");
      }

      final String email = user.email!; // Get the user's email from Firebase Authentication

      // Construct the rating details
      final Map<String, dynamic> ratingDetails = {
        'bookUrl': widget.downloadUrl,
        'bookTitle': widget.title,
        'rating': rating,

      };

      // Reference to the user's document in the 'rating' collection
      final DocumentReference userDocRef = FirebaseFirestore.instance.collection('rating').doc(email);

      // Use Firestore's arrayUnion to add the new rating details to the existing 'ratings' array
      await userDocRef.set({
        'email': email, // Ensure the email field exists in the document
        'ratings': FieldValue.arrayUnion([ratingDetails]), // Append the new rating to the 'ratings' array
      }, SetOptions(merge: true)); // Merge with existing document

      // Optionally, save the rating locally in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setDouble('${widget.downloadUrl}_rating', rating);
    } catch (error) {
      print('Error saving rating: $error');
    }
  }




  // Load the saved rating from SharedPreferences
  Future<void> _loadSavedRating() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentRating = prefs.getDouble('${widget.downloadUrl}_rating') ?? 0.0; // Load the saved rating or default to 0.0
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0), // Add padding
            child: IconButton(
              icon: Icon(
                _isFavorite ? Iconsax.heart5 : Iconsax.heart, // Change icon based on local favorite state
                color: _isFavorite ? Colors.red : Colors.grey, // Change color based on local favorite state
                size: 24,
              ),
              // Disable toggle if opened from favorites
              onPressed: (widget.isFavorite) ? null : _toggleFavorite,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              widget.thumbnailUrl,
              height: 300.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Author: ${widget.authorName}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Price: ${widget.price}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _launchURL,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Download',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 30.0), // Space before the rating section
            // Show the rating bar only if the book is downloaded
            if (_isDownloaded) ...[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: [
                    const Text(
                      'Rate it:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    RatingBar.builder(
                      initialRating: _currentRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.orange, // Changed the rating star color to orange
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _currentRating = rating; // Update the rating
                        });
                        _saveRating(rating); // Save the rating to Firestore and SharedPreferences
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
