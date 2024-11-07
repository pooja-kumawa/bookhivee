import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shikha/bindings/general_bbindings.dart';
import 'package:shikha/features/authentication/screens/onboarding/onboarding.dart';
import 'package:shikha/utils/constants/colors.dart';
import 'package:shikha/utils/theme/theme.dart';

import 'features/shop/screens/store/store_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBindings(),

      //show loader or circular progress indicator meanwhile authentication repository is deciding to show relevant screen
      home: const Scaffold(backgroundColor: TColors.primary,body:Center(child: CircularProgressIndicator(color: Colors.white,),)),

    );
  }
}
