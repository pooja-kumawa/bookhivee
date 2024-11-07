import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shikha/common/data/repository/authentication/authentication_repository.dart';
import 'package:shikha/common/widgets/success_screen.dart';
import 'package:shikha/features/authentication/controller/sing_up/verify_email_controller.dart';
import 'package:shikha/features/authentication/screens/login/login.dart';
import 'package:shikha/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key,this.email});

  final String? email;
  @override
  Widget build(BuildContext context) {
    final controller=Get.put( VerifyEmailController());

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () => AuthenticationRepository.instance.logout(),
                icon: const Icon(CupertinoIcons.clear))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                //image
                Image(
                    image: AssetImage(
                      TImages.deliveredEmailIllustration,
                    ),
                    width: THelperFunctions.screenWidth() * 0.6),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),

                //title & subtitle
                Text(
                  TTexts.confirmEmail,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),

                Text(
                  email ?? '',
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),

                Text(
                  TTexts.confirmEmailSubTitle,
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),

                //buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.checkEmailVerificationStatus(),

                    child: const Text(TTexts.tContinue),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Set background color here
                    ),
                  ),
                ),

                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => controller.sendEmailVerification(),
                    child: const Text(TTexts.resendEmail),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
