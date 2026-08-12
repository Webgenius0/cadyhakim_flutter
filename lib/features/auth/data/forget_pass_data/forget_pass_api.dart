// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/dio/dio.dart';
import 'package:numynd/networks/endpoints.dart';
import 'package:numynd/networks/exception_handler/data_source.dart';

final class PostForgetPassAPI {
  static final PostForgetPassAPI _singleton = PostForgetPassAPI._internal();

  PostForgetPassAPI._internal();

  static PostForgetPassAPI get instance => _singleton;

  Future<Map<String, dynamic>> postForgetPassAPI({
    required dynamic email,
  }) async {
    try {
      // Create the request data map
      Map<String, dynamic> data = {
        "email": email,
      };
      // Make the POST request
      Response response = (await postHttp(Endpoints.logInUrl(), data));

      if (response.statusCode == 200) {
        final data = json.decode(json.encode(response.data));
        ToastUtil.showShortToast('Password Reset OTP Sent Successfully');
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      print("Error during password reset: $error");
      rethrow;
    }
  }
}
