import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/dio/dio.dart';
import 'package:numynd/networks/endpoints.dart';
import 'package:numynd/networks/exception_handler/data_source.dart';

final class PostSignupAPI {
  static final PostSignupAPI _singleton = PostSignupAPI._internal();

  PostSignupAPI._internal();

  static PostSignupAPI get instance => _singleton;

  Future<Map<String, dynamic>> postSignupAPI({
    required dynamic email,
    required dynamic password,
    required dynamic name,
  }) async {
    try {
      // Create the request data map
      Map<String, dynamic> data = {
        "email": email,
        "password": password,
        "name": name,
      };
      // Make the POST request
      Response response = (await postHttp(Endpoints.signUpUrl(), data));

      if (response.statusCode == 200) {
        final data = json.decode(json.encode(response.data));
        ToastUtil.showShortToast('Login Successfully');
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
