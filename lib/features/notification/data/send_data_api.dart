import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/dio/dio.dart';
import 'package:numynd/networks/endpoints.dart';
import 'package:numynd/networks/exception_handler/data_source.dart';

final class PostFCMAPI {
  static final PostFCMAPI _singleton = PostFCMAPI._internal();

  PostFCMAPI._internal();

  static PostFCMAPI get instance => _singleton;

  Future<Map<String, dynamic>> postFCMAPI({
    dynamic token,
    dynamic deviceId,
  }) async {
    try {
      // Create the request data map
      Map<String, dynamic> data = {
        "token": token,
        "device_id": deviceId,
      };
      // Make the POST request
      Response response = (await postHttp(Endpoints.postFCMURL(), data));

      if (response.statusCode == 200) {
        final data = json.decode(json.encode(response.data));
        ToastUtil.showShortToast('FCM Token Sent Successfully');
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      print("Error during sending FCM token: $error");
      rethrow;
    }
  }
}
