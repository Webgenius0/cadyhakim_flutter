import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/dio/dio.dart';
import 'package:numynd/networks/endpoints.dart';
import 'package:numynd/networks/exception_handler/data_source.dart';

final class PostSendAudioAPI {
  static final PostSendAudioAPI _singleton = PostSendAudioAPI._internal();

  PostSendAudioAPI._internal();

  static PostSendAudioAPI get instance => _singleton;

  Future<Map<String, dynamic>> postSendAudioAPI({
    dynamic audioId,
    dynamic listenDuration,
    dynamic totalDuration,
    dynamic completed,
  }) async {
    try {
      // Create the request data map
      Map<String, dynamic> data = {
        "audio_id": audioId,
        "listen_duration": listenDuration,
        "total_duration": totalDuration,
        "completed": completed,
      };
      // Make the POST request
      Response response = (await postHttp(Endpoints.postListerURL(), data));

      if (response.statusCode == 200) {
        final data = json.decode(json.encode(response.data));
        ToastUtil.showShortToast('Listened Successfully');
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      print("Error during listened: $error");
      rethrow;
    }
  }
}
