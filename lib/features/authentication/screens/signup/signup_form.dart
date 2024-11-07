import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shikha/features/authentication/controller/sing_up/signup_controller.dart';
import 'package:shikha/features/authentication/screens/signup/terms_condiitons_checkbox.dart';
import 'package:shikha/features/authentication/screens/signup/verify_email.dart';
import 'package:shikha/utils/validators/validation.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';

class TSignUpForm extends StatelessWidget {
  const TSignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(SignupController());

    final dark = THelperFunctions.isDarkMode(context);
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value)=>TValidator.validateEmptyText('First name',value),
                  decoration: const InputDecoration(
                    labelText: TTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value)=>TValidator.validateEmptyText('Last name',value),
                  decoration: const InputDecoration(
                    labelText: TTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.spaceBtwSections),

          //username
          TextFormField(
            controller: controller.username,
            validator: (value)=>TValidator.validateEmptyText('Username',value),
            decoration: const InputDecoration(
              labelText: TTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          //email
          TextFormField(
            controller: controller.email,
            validator: (value)=>TValidator.validateEmail(value),
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          //phone number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value)=>TValidator.validatePhoneNUmber(value),
            decoration: const InputDecoration(
              labelText: TTexts.PhoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          //password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value)=>TValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration:  InputDecoration(
                labelText: TTexts.password,
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                ),

              ),
            ),
          ),

          SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          //tems and condition checkbox

          const TTermsAndConditionCheckbox(),
          SizedBox(
            height: TSizes.spaceBtwItems,
          ),

          //sign up
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Set background color here
              ),
              child: const Text(TTexts.createAccount),
            ),
          ),
          SizedBox(
            height: TSizes.spaceBtwSections,
          ),

          // Add more form fields here as needed
        ],
      ),
    );
  }
}
