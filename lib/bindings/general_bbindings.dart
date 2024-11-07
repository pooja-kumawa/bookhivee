import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:shikha/utils/constants/network_manager.dart';

class GeneralBindings extends Bindings {


  @override
 void dependencies(){
    Get.put(NetworkManager());
  }
}
