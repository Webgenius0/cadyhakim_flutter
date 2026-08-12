import 'dart:developer';
import 'package:get/get.dart';
import 'package:numynd/constants/app_constants.dart';
import 'package:numynd/features/social_login/data/social_login_api.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/dio/dio.dart';
import 'package:numynd/networks/exception_handler/data_source.dart';
import 'package:numynd/networks/rx_base.dart';
import 'package:rxdart/rxdart.dart';

import '../../../helpers/di.dart';

final class PostSocailLoginRX extends RxResponseInt<Map> {
  final api = SocialLoginApi.instance;
  String message = "Can't login!".tr;

  PostSocailLoginRX({required super.empty, required super.dataFetcher});

  ValueStream get getSocaialLoginRes => dataFetcher.stream;

  Future<void> postSocailLogin({
    required String registerType,
    required String token,
  }) async {
    try {
      Map resdata = await api.signInApi(
        token: token,
        provider: registerType,
      );
      log(" from response : $resdata");
      return handleSuccessWithReturn(resdata);
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(Map data) async {
    message = data["message"];
    if (data["success"] == true) {
      // * Extract access token and other relevant data from the response
      String accesstoken = data["access_token"];
      String message = data["message"];

      // * Extract user details from the response
      String userId = data["data"]["id"].toString();
      String userName = data["data"]["name"].toString();
      String userEmail = data["data"]["email"].toString();
      String userRole = data["data"]["role"].toString();

      // * save some data from API
      await appData.write(kKeyIsLoggedIn, true);
      await appData.write(kKeyAccessToken, accesstoken);
      await appData.write(kKeyUserID, userId);
      await appData.write(kKeyUserName, userName);
      await appData.write(kKeyUserEmail, userEmail);
      await appData.write(kKeyUserRole, userRole);

      DioSingleton.instance.update(accesstoken);
      dataFetcher.sink.add(data);
      ToastUtil.showShortToast(message);
      return data;
      // return true;
    } else {
      throw DataSource.DEFAULT.getFailure();
    }
  }
}
