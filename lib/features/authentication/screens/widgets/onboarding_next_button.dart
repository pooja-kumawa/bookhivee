import 'package:flutter/material.dart';
import 'package:shikha/features/authentication/controller/onborading_contoller.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controller/onborading_contoller.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Positioned(right:TSizes.defaultSpace,
      bottom:TDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(onPressed: () => OnBoardingController.instance.nextPage(),style: ElevatedButton.styleFrom(shape: CircleBorder(),backgroundColor: Colors.orange),
        child:const Icon(Icons.arrow_forward,),
      ),
    );
  }
}

