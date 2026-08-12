// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/dio/dio.dart';
import 'package:numynd/networks/endpoints.dart';
import 'package:numynd/networks/exception_handler/data_source.dart';

final class PostUpdateProfileAPI {
  static final PostUpdateProfileAPI _singleton =
      PostUpdateProfileAPI._internal();

  PostUpdateProfileAPI._internal();

  static PostUpdateProfileAPI get instance => _singleton;

  Future<Map<String, dynamic>> postUpdateProfileAPI({
    required dynamic name,
    required dynamic email,
  }) async {
    try {
      // * Create the request data map
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
      };

      // * Make the POST request
      Response response = (await postHttp(Endpoints.updateProfileURL(), data));

      if (response.statusCode == 200) {
        final data = json.decode(json.encode(response.data));
        ToastUtil.showShortToast('Profile updated successfully');
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      print("Error during profile update: $error");
      rethrow;
    }
  }
}
