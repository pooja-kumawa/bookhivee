import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shikha/data/repositories/user/user_repository.dart';

import '../../../data/repositories/user/user_model.dart';
import '../../../utils/constants/loaders.dart';

class UserController extends GetxController{
  static UserController get instance=>Get.find();

  final userRepository = Get.put(UserRepository());

  //save user record from any registration provider
Future<void> saveUserRecord(UserCredential? userCredentials) async{
  try{
    if(userCredentials != null){
      //convert name to first and last name
      final nameParts = UserModel.nameParts(userCredentials.user!.displayName ?? '');
      final username = UserModel.generateUsername(userCredentials.user!.displayName ?? '');

      //map data
      final user=UserModel(
        id:userCredentials.user!.uid,
        firstName:nameParts[0],
        lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' '):  "",
        username: username,
        email: userCredentials.user!.email ?? '',
        phoneNumber: userCredentials.user!.phoneNumber ?? '',
      );

      //save user data
      await userRepository.saveUserRecord(user);


    }
  } catch(e){
    TLoaders.warningSnackBar(title: 'data not saved',
    message: 'something went wrong while saving the information re-save it');
  }

}
}