import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shikha/features/authentication/controller/onborading_contoller.dart'; // Corrected import path
import 'package:shikha/utils/helpers/helper_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shikha/utils/constants/image_strings.dart';
import 'package:shikha/utils/constants/sizes.dart';
import 'package:shikha/utils/constants/text_strings.dart';
import 'package:shikha/utils/constants/colors.dart';
import 'package:shikha/utils/device/device_utility.dart';
import 'package:shikha/utils/theme/custom_themes/text_theme.dart';
import '../widgets/onboarding_dot_navigation.dart';
import '../widgets/onboarding_next_button.dart';
import '../widgets/onboarding_skip.dart';
import '../widgets/onboarding_page.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController()); // Corrected class name

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: TImages.onboardingImage1,
                title: TTexts.onBoardingTitle1, // Corrected to use Title1
                subTitle: TTexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: TImages.onboardingImage2,
                title: TTexts.onBoardingTitle2, // Corrected to use Title2
                subTitle: TTexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: TImages.onboardingImage3,
                title: TTexts.onBoardingTitle3, // Corrected to use Title3
                subTitle: TTexts.onBoardingSubTitle3,
              ),
            ],
          ),

          // Skip button
          const OnBoardingSkip(),

          // Dot navigation smoothPageindicator
          const OnBoardingDotNavigation(),

          // Circular button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
