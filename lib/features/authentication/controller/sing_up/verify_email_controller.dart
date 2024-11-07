import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shikha/common/data/repository/authentication/authentication_repository.dart';
import 'package:shikha/common/widgets/success_screen.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/loaders.dart';
import '../../../../utils/constants/text_strings.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  //send email
  @override
  void onInit() {
    super.onInit();
    sendEmailVerification();
    setTimerForAutoRedirect();

  }


  //send email veriication link
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.SendEmailVerification();
      TLoaders.successSnackBAr(title: 'Oh snap!', message: e.toString());
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh snap!', message: e.toString());
    }
  }

  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(() =>
            SuccessScreen(image: TImages.successfullyRegisterAnimation,
                title: TTexts.yourAccountCreatedTitle,
                subTitle: TTexts.yourAccountCreatedSubTitle,
                onPressed: ()=> AuthenticationRepository.instance.screenRedirect(),
            )
        );
      }
    });
  }

  checkEmailVerificationStatus() async{
    final currentUser=FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified){
      Get.off(() =>
          SuccessScreen(image: TImages.successfullyRegisterAnimation,
            title: TTexts.yourAccountCreatedTitle,
            subTitle: TTexts.yourAccountCreatedSubTitle,
            onPressed: ()=> AuthenticationRepository.instance.screenRedirect(),
          )
      );


    }
  }
}
