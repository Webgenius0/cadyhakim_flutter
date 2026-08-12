// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:numynd/constants/app_constants.dart';
import 'package:numynd/features/auth/data/forget_pass_data/forget_pass_api.dart';
import 'package:numynd/helpers/di.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/dio/dio.dart';
import 'package:numynd/networks/rx_base.dart';
import 'package:rxdart/streams.dart';

final class PostForgetPassRX extends RxResponseInt<Map<String, dynamic>> {
  final api = PostForgetPassAPI.instance;

  PostForgetPassRX({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> postForgetPassRX({
    required dynamic email,
  }) async {
    try {
      Map<String, dynamic> data = await api.postForgetPassAPI(
        email: email,
      );

      await handleSuccessWithReturn(data);

      return true;
    } catch (error) {
      // Handle error
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(Map<String, dynamic> data) {
    // Extract the token from the response
    String token = data['access_token'];
    dynamic userId = data['data']['id'];
    dynamic userEmail = data['data']['email'];
    dynamic userName = data['data']['name'];

    print(">>>>>>>>>>>>>>>>>>>>>>> Here is the token:$token");
    print(">>>>>>>>>>>>>>>>>>>>>>> Here is the id:$userId");

    // Save the token and login status using appData
    appData.write(kKeyAccessToken, token);

    appData.write(kKeyUserID, userId);
    appData.write(kKeyUserName, userName);
    appData.write(kKeyEmail, userEmail);
    print(">>> Here is the access info rx :${appData.read(kKeyIsLoggedIn)}");
    print(">>> Here is the user id :${appData.read(kKeyUserID)}");
    appData.write(kKeyIsLoggedIn, true);
    print(">>>> Here is the access info rx :${appData.read(kKeyIsLoggedIn)}");

    // Update DioSingleton with the new token
    DioSingleton.instance.update(token);
    // Add the data to the stream
    dataFetcher.sink.add(data);

    return data;
  }

  @override
  handleErrorWithReturn(dynamic error) {
    // Handle API error using DioException
    if (error is DioException) {
      if (error.response!.statusCode == 400) {
        ToastUtil.showShortToast(error.response!.data["error"]);
      } else {
        ToastUtil.showShortToast(error.response!.data["message"]);
      }
    }

    log(error.toString());
    dataFetcher.sink.addError(error);

    return false;
  }
}
