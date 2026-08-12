import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:numynd/helpers/all_routes.dart';
import 'package:numynd/helpers/navigation_service.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/api_acess.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthApple {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  static Future<UserCredential?> signInWithApple(BuildContext context) async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Print tokens
      debugPrint("🆔 ID Token: ${appleCredential.identityToken}");
      debugPrint("🔑 Authorization Code: ${appleCredential.authorizationCode}");

      // Sign in with Firebase
      final userCredential = await _auth.signInWithCredential(oauthCredential);

      // Get user details
      final user = userCredential.user;

      if (user != null) {
        String? displayName = appleCredential.givenName != null
            ? "${appleCredential.givenName} ${appleCredential.familyName}"
            : user.displayName;
        String? email = appleCredential.email ?? user.email;

        debugPrint("✅ Apple Login Success:");
        debugPrint("👤 Display Name: $displayName");
        debugPrint("📧 Email: $email");
        debugPrint("🆔 UID: ${user.uid}");
        debugPrint("🖼️ Photo URL: ${user.photoURL}");
        log('auth user not null ');

         await postSocailLoginRX.postSocailLogin(
          token: appleCredential.identityToken.toString(),
          registerType: "apple",
        );
        debugPrint(
            "=======================================>>>>>> >>>>>  Go to navigation screen");
        NavigationService.navigateTo(Routes.navigationScreen);
        ToastUtil.showLongToast('Login Successfully');
      }
      return userCredential;
    } catch (e) {
      debugPrint("❌ Apple Sign-In Error: $e");
      return null;
    }
  }
}
