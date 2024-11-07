import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shikha/data/repositories/user/user_repository.dart';
import 'package:shikha/features/authentication/screens/login/login.dart';
import 'package:shikha/features/authentication/screens/onboarding/onboarding.dart';
import 'package:shikha/features/authentication/screens/signup/verify_email.dart';
import 'package:shikha/navigation_menu.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  @override
  void onReady() {

    FlutterNativeSplash.remove();
    screenRedirect();
  }

  void screenRedirect() async {
    final user=_auth.currentUser;

    if(user != null){
      if(user.emailVerified){
        Get.offAll(() =>  NavigationMenu());
      } else{
        Get.offAll(()=> VerifyEmailScreen(email:_auth.currentUser?.email));

      }

    } else {
      deviceStorage.writeIfNull('IsFirstTime', true);
       deviceStorage.read('IsFirstTime') != true ?
        Get.offAll(() => const LoginScreen())
           : Get.offAll( const OnBoardingScreen());

    }}

  // Email authentication log in
  Future<UserCredential> loginWithEmailAndPassword(String email,String password) async{
    try{
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    }  on FirebaseAuthException catch (e){
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }

  }


  // Email authentication Register
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  //email verification
Future<void> SendEmailVerification() async{
    try{
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e){
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
}


//forget password
  Future<void> sendPasswordResetEmail(String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e){
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }




  Future<UserCredential?> signInWithGoogle() async{
    try{
      //trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      //obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await userAccount?.authentication;

      //create a new credentials
      final credentials = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      //once signed in,return
      return await _auth.signInWithCredential(credentials);


    } on FirebaseAuthException catch (e){
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if(kDebugMode) print('something went wrong: $e');
      return null;
    }
  }



//logout user
Future<void> logout() async{
    try{

      await FirebaseAuth.instance.signOut();
      Get.offAll(()=> const LoginScreen());
    } on FirebaseAuthException catch(e){
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
}






}



// Assuming TFirebaseAuthException, TFirebaseException, TFormatException, and TPlatformException are defined elsewhere in your project.
class TFirebaseAuthException {
  final String code;
  TFirebaseAuthException(this.code);
  String get message => 'Firebase Auth error: $code';
}
