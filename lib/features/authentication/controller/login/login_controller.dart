import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shikha/common/data/repository/authentication/authentication_repository.dart';
import 'package:shikha/utils/popups/full_screen_loader.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/loaders.dart';
import '../../../../utils/constants/network_manager.dart';
import '../../../personalization/controllers/user_controller.dart';

class LoginController extends GetxController {
  // Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();


  final userController=Get.put(UserController());

  @override
  void onInit() {
    super.onInit();
    // Initialize the text controllers with stored values if available
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
  }

  // Email and password sign in
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Start loading
      TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'No Internet', message: 'Please check your internet connection.');
        return;
      }

      // Form validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Save data if remember me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      } else {
        // Clear stored data if remember me is not selected
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
      }

      // Login user using email and password authentication
      final userCredentials = await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      // Remove loader
      TFullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: 'An error occurred: ${e.toString()}');
    }
  }

  Future<void> googleSignIn() async{
    try{
      TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.docerAnimation1);

      //check internet connectivity
      final isConnected= await NetworkManager.instance.isConnected();
      if(! isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }


      //goggle authentication
      final userCredentials=await AuthenticationRepository.instance.signInWithGoogle();


      //save user record
      await userController.saveUserRecord(userCredentials);

      //remove loader
      TFullScreenLoader.stopLoading();

      //redirect
      AuthenticationRepository.instance.screenRedirect();


    } catch(e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap',message: e.toString());
    }

  }

}
