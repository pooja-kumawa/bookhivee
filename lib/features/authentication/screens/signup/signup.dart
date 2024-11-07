import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shikha/common/widgets/social_buttons.dart';
import 'package:shikha/features/authentication/screens/signup/signup_form.dart';
import 'package:shikha/utils/constants/colors.dart';
import 'package:shikha/utils/helpers/helper_functions.dart';

import '../../../../common/widgets/form_divider.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                TTexts.signUpTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              // Form
              TSignUpForm(),

              //divider
              TFormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections,),


              //social buttons
              const TSocialButtons(),
              const SizedBox(height: TSizes.spaceBtwSections,),



            ],
          ),
        ),
      ),
    );
  }
}

