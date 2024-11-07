import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'common/data/repository/authentication/authentication_repository.dart';
import 'features/shop/screens/wishlist/wihslist.dart';
import 'firebase_options.dart';


Future<void> main() async {

  //widgets binding
  final WidgetsBinding widgetsBinding=WidgetsFlutterBinding.ensureInitialized();
  //local storage
  await GetStorage.init();


  //await native splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //initialize firebase and authentication repository

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform ).then
    ((FirebaseApp value)=> Get.put(AuthenticationRepository()),
  );



  runApp(const App());
}



//ios AIzaSyCWFQbdOGxDJL9tcxRRm1WpvcfKLyUzOx4
//android AIzaSyCBQs0BByHm8Wj3BGDncdjxKndyyldLnLM
//browser AIzaSyAI5wtJ5P8OA8-1ql2DWWv3u8yBOg_6UHw

