
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/formatters/formatter.dart';
import 'dart:convert';

// UserModel class

class UserModel {
  final String id;
  String firstName;
  String lastName;
  final String username;
  final String email;
  String phoneNumber;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
  });

  String get fullName => '$firstName $lastName';

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  static List<String> nameParts(String fullName) => fullName.split(" ");

  static String generateUsername(String fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() :"";

    String camelCaseUsername = '$firstName$lastName';
    String usernameWithPrefix = 'cwt_$camelCaseUsername';
    return usernameWithPrefix;
  }

  static UserModel empty() => UserModel(
    id: '',
    firstName: '',
    lastName: '',
    username: '',
    email: '',
    phoneNumber: '',
  );

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {

      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
    };
  }

  // Create UserModel from Firestore document snapshot
  factory UserModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data == null) {
      throw Exception("Document data is null");
    }


    return UserModel(
      id: document.id ,

      firstName: data['FirstName'] ?? '',
      lastName: data['LastName'] ?? '',
      email: data['Email'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      username: data['Username'] ?? '',
    );

  }

  factory UserModel.fromJson(String jsonString) {
    final jsonData = jsonDecode(jsonString);
    return UserModel(
      id: jsonData['id'],
      email: jsonData['Email'],
      firstName: jsonData['FirstName'],
      lastName: jsonData['LastName'],
      phoneNumber: jsonData['PhoneNumber'],
      username: jsonData['Username'],
    );
  }



}

// Assuming TFormatter is a class with a static method formatPhoneNumber


