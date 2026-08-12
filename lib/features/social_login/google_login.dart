// social_auth_data.dart

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:numynd/helpers/all_routes.dart';
import 'package:numynd/helpers/navigation_service.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/api_acess.dart';

class SocialAuthData {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  static Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      // Force account picker safely
      try {
        if (await googleSignIn.isSignedIn()) {
          await googleSignIn.disconnect();
        }
      } catch (e) {
        log('disconnect error ignored: $e');
      }

      await googleSignIn.signOut();

      // Trigger Google Sign-In
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return null;
      }

      // Get authentication
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Create credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      log('accesstoken is : ${credential.accessToken}');

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      if (authResult.user != null) {
        log('auth user not null');

        await postSocailLoginRX.postSocailLogin(
          token: credential.accessToken.toString(),
          registerType: "google",
        );

        NavigationService.navigateTo(Routes.navigationScreen);
        ToastUtil.showLongToast('Login Successfully');
      }

      log("google sign in info: $authResult");

      return authResult.user;
    } catch (error) {
      ToastUtil.showLongToast(error.toString());
      log("error: ${error.toString()}");
      return null;
    }
  }
}
