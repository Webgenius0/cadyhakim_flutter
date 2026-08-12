// ignore_for_file: avoid_log

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:numynd/constants/app_constants.dart';
import 'package:numynd/features/auth/data/login_data/login_api.dart';
import 'package:numynd/helpers/di.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/dio/dio.dart';
import 'package:numynd/networks/rx_base.dart';
import 'package:rxdart/streams.dart';

final class PostSigninRX extends RxResponseInt<Map<String, dynamic>> {
  final api = PostSigninAPI.instance;

  PostSigninRX({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> postSigninRX({
    required dynamic email,
    required dynamic password,
  }) async {
    try {
      Map<String, dynamic> data = await api.postSigninAPI(
        email: email,
        password: password,
      );

      //String token = data['data']['token']['access'];
      // log(">>>>>>>>>>>>>>> login token is : $token");
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

    log(">>>>>>>>>>>>>>>>>>>>>>> Here is the id:$userId");
    log(">>>>>>>>>>>>>>>>>>>>>>> Here is the id:$userEmail");
    log(">>>>>>>>>>>>>>>>>>>>>>> Here is the id:$userName");
    log(">>>>>>>>>>>>>>>>>>>>>>> Here is the token:$token");

    // Save the token and login status using appData
    appData.write(kKeyAccessToken, token);
    appData.write(kKeyUserID, userId);
    appData.write(kKeyUserName, userName);
    appData.write(kKeyEmail, userEmail);
    appData.write(kKeyIsLoggedIn, true);

    log(">>> Here is the access info rx :${appData.read(kKeyIsLoggedIn)}");
    log(">>> Here is the user id :${appData.read(kKeyUserID)}");
    log(">>>> Here is the access info rx :${appData.read(kKeyIsLoggedIn)}");

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
