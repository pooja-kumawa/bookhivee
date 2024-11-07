import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shikha/common/data/repository/authentication/authentication_repository.dart';
import 'package:shikha/features/authentication/controller/forget_password/reset_password.dart';
import 'package:shikha/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:shikha/utils/constants/loaders.dart';
import 'package:shikha/utils/constants/network_manager.dart';
import 'package:shikha/utils/popups/full_screen_loader.dart';

import '../../../../utils/constants/image_strings.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  // Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  // Send reset password email
  sendPasswordResetEmail() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Processing your request...', TImages.docerAnimation1);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      // Remove loader
      TFullScreenLoader.stopLoading();

      // Show success screen
      TLoaders.successSnackBAr(
          title: 'Email Sent',
          message: 'Email link sent to reset your password'.tr);

      // Redirect
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  // Resend reset password email
  resendPasswordResetEmail(String email) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Processing your request...', TImages.docerAnimation1);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }



      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      // Remove loader
      TFullScreenLoader.stopLoading();

      // Show success screen
      TLoaders.successSnackBAr(
          title: 'Email Sent',
          message: 'Email link sent to reset your password'.tr);


    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
