import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shikha/data/repositories/user/user_repository.dart';
import 'package:shikha/features/authentication/screens/signup/verify_email.dart';
import 'package:shikha/utils/constants/network_manager.dart';


import '../../../../common/data/repository/authentication/authentication_repository.dart';
import '../../../../data/repositories/user/user_model.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/loaders.dart';
import '../../../../utils/popups/full_screen_loader.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // Variables
  var hidePassword = true.obs;
  var privacyPolicy = true.obs;


  final email = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // Signup method
  void signup() async {
    try {
      // Start loading
      TFullScreenLoader.openLoadingDialog(
          'we are processing your information....', TImages.docerAnimation1);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
          title: 'No Internet Connection',
          message: 'Please check your internet connection and try again.',
        );
        return;
      }

      // Form validation
      if (!signupFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Privacy policy check
      if (!privacyPolicy.value) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message:
          'In order to create an account, you must read and accept the Privacy Policy & Terms of Use.',
        );
        return;
      }

      // Register user in Firebase authentication
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(
          email.text.trim(), password.text.trim());

      // Check for null user
      if (userCredential.user == null) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'Registration Failed',
          message: 'User could not be registered. Please try again.',
        );
        return;
      }

      // Save authenticated user data
      final user = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(user);

      // Show success message
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBAr(
          title: 'Congratulations',
          message:
          'Your account has been created. Verify your email to continue.');

      // Move to verify email screen
      Get.to(() =>  VerifyEmailScreen(email: email.text.trim(),));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh snap!', message: e.toString());
    }
  }
}
