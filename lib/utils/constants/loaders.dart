import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import 'colors.dart';

class TLoaders extends StatelessWidget {
  const TLoaders({super.key});

  static successSnackBAr({required title,message='',duration=3}){
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText:
        Colors.white,
      backgroundColor: TColors.primary,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10),
      icon: const Icon(Iconsax.check,color: TColors.white,)

    );
  }

  static warningSnackBar({required title,message=''}){
    Get.snackbar(title, message,
    isDismissible: true,
    shouldIconPulse: true,
    colorText: TColors.white,
    backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2,color: TColors.white,)

    );
  }

  static errorSnackBar({required title,message=''}){
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: TColors.white,
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2,color: TColors.white,)

    );
  }



  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
