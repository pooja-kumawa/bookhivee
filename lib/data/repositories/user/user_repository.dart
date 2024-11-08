import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shikha/data/repositories/user/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection('Users').doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, please try again';
    }
  }
}

// Assuming TFirebaseException, TFormatException, and TPlatformException are defined elsewhere in your project.
class TFirebaseException {
  final String code;
  TFirebaseException(this.code);
  String get message => 'Firebase error: $code';
}

class TFormatException {
  const TFormatException();
  String get message => 'Format error';
}

class TPlatformException {
  final String code;
  TPlatformException(this.code);
  String get message => 'Platform error: $code';
}