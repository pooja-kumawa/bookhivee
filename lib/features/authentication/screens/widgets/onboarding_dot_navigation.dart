import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shikha/features/authentication/controller/onborading_contoller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../../utils/helpers/helper_functions.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark=THelperFunctions.isDarkMode(context);
    final controller=OnBoardingController.instance;

    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: TSizes.defaultSpace,
      child: SmoothPageIndicator(

        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,

        count: 3,
        effect: ExpandingDotsEffect(
          activeDotColor:dark ? TColors.light:TColors.dark,
          dotHeight: 6,
        ),
      ),
    );
  }
}