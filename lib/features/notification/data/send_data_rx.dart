// ignore_for_file: avoid_log
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:numynd/features/notification/data/send_data_api.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/rx_base.dart';
import 'package:rxdart/streams.dart';

final class PostFCMRX extends RxResponseInt<Map<String, dynamic>> {
  final api = PostFCMAPI.instance;

  PostFCMRX({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> postFCMRX({
    required dynamic token,
    required dynamic deviceId,
  }) async {
    try {
      Map<String, dynamic> data = await api.postFCMAPI(
        token: token,
        deviceId: deviceId,
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
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  handleErrorWithReturn(dynamic error) {
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
