import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../authentication/screens/login/login.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    // Show a SnackBar with a "Signing out" message in white text on an orange background
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Signing out...',
          style: TextStyle(color: Colors.white), // White text color
        ),
        duration: const Duration(seconds: 2), // Adjust the duration as needed
        backgroundColor: Colors.orange, // Background color of the SnackBar
        behavior: SnackBarBehavior.floating,
      ),
    );

    try {
      // Perform the sign-out operation
      await FirebaseAuth.instance.signOut();
      // Navigate to the LoginScreen after successful sign-out
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (e) {
      // Handle errors, e.g., show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error signing out: $e',
            style: TextStyle(color: Colors.white), // White text color for errors
          ),
          backgroundColor: Colors.red, // Background color of the SnackBar
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the current theme mode
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Choose the image based on the theme mode
    final imagePath = isDarkMode
        ? 'assets/logos/dark1.jpg' // Image for dark mode
        : 'assets/logos/light1.jpg'; // Image for light mode

    // Choose AppBar colors based on the theme mode
    final appBarColor = isDarkMode ? Colors.black : Colors.white; // AppBar background color
    final appBarTextColor = isDarkMode ? Colors.white : Colors.black; // AppBar text color based on theme

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: appBarColor, // AppBar color based on theme
        foregroundColor: appBarTextColor, // AppBar icon color based on theme
        titleTextStyle: TextStyle(
          color: appBarTextColor, // Ensure the title is the correct color
          fontSize: 20, // Adjust font size as needed
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image at the top, with slight vertical offset
            SizedBox(
              height: 200, // Add extra height for offset
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  imagePath,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between image and text
            // Text message with two lines and bold styling
            const Text(
              'Oh no! Are you sure you\'re leaving? This action will log you out of your account.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20), // Space between text and button
            // Sign out button
            ElevatedButton(
              onPressed: () => _signOut(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Button color
                minimumSize: Size(double.infinity, 50), // Full-width button
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
