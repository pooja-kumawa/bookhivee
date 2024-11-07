import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shikha/features/authentication/controller/forget_password/forget_password_controller.dart';
import 'package:shikha/features/authentication/controller/forget_password/reset_password.dart';
import 'package:shikha/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:shikha/utils/constants/sizes.dart';
import 'package:shikha/utils/validators/validation.dart';

import '../../../../utils/constants/text_strings.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
final controller=Get.put(ForgetPasswordController());

    return Scaffold(
      appBar: AppBar(
        title: Text(TTexts.forgetPasswordTitle), // Optional: Add title to the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            Text(
              TTexts.forgetPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              TTexts.forgetPasswordSubTitle, // Assuming a subtitle exists
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections * 2),

            // Text field
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: TValidator.validateEmail,
                decoration: InputDecoration(
                  labelText: TTexts.email,
                  prefixIcon: const Icon(Iconsax.direct_right),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>controller.sendPasswordResetEmail(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Set background color here
                ),
                child: Text(TTexts.submit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
