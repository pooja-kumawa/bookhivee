

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';

import '../screens/login/login.dart';


class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  void updatePageIndicator(int index) {
    currentPageIndex.value = index;
  }

  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index); // Corrected method call
  }

  void nextPage() {
    int currentPage = currentPageIndex.value;

    if (currentPage == 2) {
      final storage = GetStorage();


      if(kDebugMode){
        print('============GET STORGAE NEXT BUTTON ===========');
        print(storage.read('IsFirstTime'));
      }

      storage.write('IsFirstTime',false);


      if(kDebugMode){
        print('============GET STORGAE NEXT BUTTON ===========');
        print(storage.read('IsFirstTime'));
      }


      Get.offAll(() => LoginScreen());
    } else {
      pageController.jumpToPage(currentPage + 1);
      currentPageIndex.value = currentPage + 1; // Update the currentPageIndex
    }
  }


  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}
