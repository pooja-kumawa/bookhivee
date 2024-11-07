import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shikha/features/authentication/controller/login/login_controller.dart';
import 'package:shikha/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:shikha/features/authentication/screens/signup/signup.dart';
import 'package:shikha/navigation_menu.dart';
import 'package:shikha/utils/validators/validation.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(LoginController());

    return Form(
      key:controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            // Email field
            TextFormField(
              controller: controller.email,
              validator: (value)=> TValidator.validateEmail(value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.arrow_right),
                labelText: TTexts.email,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Password field
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
            const SizedBox(height: TSizes.spaceBtwItems / 2),

            // Remember me and forget password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Obx(()=> Checkbox(value: controller.rememberMe.value, onChanged: (value) => controller.rememberMe.value = value ?? false)),
                    const Text(TTexts.rememberMe),
                  ],
                ),
                TextButton(
                  onPressed: () => Get.to(()=> const ForgetPassword()),
                  child: const Text(TTexts.forgetPassword),
                ),
              ],
            ),

            const SizedBox(height:TSizes.spaceBtwSections),

            // sign in button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>controller.emailAndPasswordSignIn(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Set background color here
                ),
                child: const Text(TTexts.signIn),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),


            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(()=> const SignupScreen()),

                child: const Text(TTexts.createAccount),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),



          ],
        ),
      ),
    );
  }
}
