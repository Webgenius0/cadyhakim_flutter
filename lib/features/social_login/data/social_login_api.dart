// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/dio/dio.dart';
import 'package:numynd/networks/endpoints.dart';
import 'package:numynd/networks/exception_handler/data_source.dart';

final class SocialLoginApi {
  static final SocialLoginApi _singleton = SocialLoginApi._internal();

  SocialLoginApi._internal();

  static SocialLoginApi get instance => _singleton;

  Future<Map> signInApi({
    required String token,
    required dynamic provider,
  }) async {
    try {
      // Create the request data map
      Map<String, dynamic> data = {
        "token": token,
        "provider": provider,
      };
      // Make the POST request
      Response response = await postHttp(Endpoints.socialLogin(), data);
      // Check the response status code

      if (response.statusCode == 200) {
        final data = json.decode(json.encode(response.data));
        ToastUtil.showShortToast('Verified Successfully');
        //NavigationService.navigateTo(Routes.navigationScreen);
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      print("Error during signup: $error");
      rethrow;
    }
  }
}
