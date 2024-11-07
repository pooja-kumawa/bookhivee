import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shikha/common/styles/spacing_styles.dart';
import 'package:shikha/common/widgets/form_divider.dart';
import 'package:shikha/common/widgets/social_buttons.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'login_form.dart';
import 'login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              //logo
              const TLoginHeader(),

              //form
              const TLoginForm(),

              //divider
              TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections,),

              //footer
              const TSocialButtons(),



            ],
          ),
        ),
      ),
    )
    ;
  }
}
