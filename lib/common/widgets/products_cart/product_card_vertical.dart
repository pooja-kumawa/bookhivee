import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TProductCartVertical extends StatelessWidget {
  final String title;
  final String? thumbnailUrl;
  final String price;
  final VoidCallback onTap;
  final String? downloadUrl;
  final bool isFavorite; // Indicates whether the book is a favorite
  final VoidCallback toggleFavorite; // Function to toggle the favorite state

  const TProductCartVertical({
    Key? key,
    required this.title,
    this.thumbnailUrl,
    required this.price,
    required this.onTap,
    this.downloadUrl,
    required this.isFavorite,
    required this.toggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Use the onTap prop from the widget
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: thumbnailUrl != null
                      ? Image.network(
                    thumbnailUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.book,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '\$$price', // Display the price
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Iconsax.heart5 : Iconsax.heart, // Change icon based on favorite state
                  color: isFavorite ? Colors.red : Colors.grey, // Change color based on favorite state
                  size: 24,
                ),
                onPressed: toggleFavorite, // Toggle favorite state on press
              ),
            ),
          ],
        ),
      ),
    );
  }
}
