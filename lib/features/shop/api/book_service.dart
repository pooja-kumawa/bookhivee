import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// Your API key
const String apiKey = 'AIzaSyCBQs0BByHm8Wj3BGDncdjxKndyyldLnLM';

// Function to fetch books from the API and filter for free PDFs
Future<List<dynamic>> fetchBooks(String query) async {
  final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey&filter=free-ebooks');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> books = data['items'] ?? [];

      // Filter books to only those that have a free downloadable PDF
      final List<dynamic> downloadableBooks = books.where((book) {
        final accessInfo = book['accessInfo'];
        return accessInfo['pdf'] != null &&
            accessInfo['pdf']['isAvailable'] == true &&
            accessInfo['pdf']['downloadLink'] != null;
      }).toList();

      // Print the filtered books for debugging
      print('Filtered books with download links: ${downloadableBooks.length}');
      downloadableBooks.forEach((book) {
        print('Title: ${book['volumeInfo']['title']}, Download Link: ${book['accessInfo']['pdf']['downloadLink']}');
      });

      return downloadableBooks;
    } else {
      throw Exception('Failed to load books');
    }
  } catch (e) {
    print('Error fetching books: $e');
    return [];
  }
}

Future<void> downloadBook(BuildContext context, String url, String fileName) async {
  if (url.isEmpty || !Uri.tryParse(url)!.isAbsolute) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invalid download URL.')),
    );
    return;
  }

  // Request storage permission
  var status = await Permission.storage.request();

  if (status.isGranted) {
    try {
      final dio = Dio();
      final directory = await getExternalStorageDirectory();

      if (directory != null) {
        final downloadDir = Directory('${directory.path}/Download');
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
        final filePath = '${downloadDir.path}/$fileName';

        await dio.download(url, filePath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download completed: $filePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to get storage directory')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download the book: $e')),
      );
    }
  } else {
    // If permission is denied, show a message and guide to settings
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Storage permission is required to download files.')),
    );
    // Optionally open app settings if permission is permanently denied
    await openAppSettings();
  }
}
