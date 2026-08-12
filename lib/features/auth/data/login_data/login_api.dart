import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/dio/dio.dart';
import 'package:numynd/networks/endpoints.dart';
import 'package:numynd/networks/exception_handler/data_source.dart';

final class PostSigninAPI {
  static final PostSigninAPI _singleton = PostSigninAPI._internal();

  PostSigninAPI._internal();

  static PostSigninAPI get instance => _singleton;

  Future<Map<String, dynamic>> postSigninAPI({
    required dynamic email,
    required dynamic password,
  }) async {
    try {
      // Create the request data map
      Map<String, dynamic> data = {
        "email": email,
        "password": password,
      };
      // Make the POST request
      Response response = (await postHttp(Endpoints.logInUrl(), data));

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
