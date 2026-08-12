// ignore_for_file: avoid_log

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:numynd/features/favourite_screen/data/post_favourite_data/post_favourite_api.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/rx_base.dart';
import 'package:rxdart/streams.dart';

final class PostFavouriteRX extends RxResponseInt<Map<String, dynamic>> {
  final api = PostFavouriteAPI.instance;

  PostFavouriteRX({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> postFavouriteRX({
    required dynamic id,
  }) async {
    try {
      Map<String, dynamic> data = await api.postFavouriteAPI(
        id: id,
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
