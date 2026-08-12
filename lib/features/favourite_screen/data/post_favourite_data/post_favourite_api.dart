import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:numynd/networks/dio/dio.dart';
import 'package:numynd/networks/endpoints.dart';
import 'package:numynd/networks/exception_handler/data_source.dart';

final class PostFavouriteAPI {
  static final PostFavouriteAPI _singleton = PostFavouriteAPI._internal();

  PostFavouriteAPI._internal();

  static PostFavouriteAPI get instance => _singleton;

  Future<Map<String, dynamic>> postFavouriteAPI({
    required dynamic id,
  }) async {
    try {
      // Create the request data map
      Map<String, dynamic> data = {
        "audio_id": id,
      };
      // Make the POST request
      Response response = (await postHttp(Endpoints.postFavouriteURL(), data));

      if (response.statusCode == 200) {
        final data = json.decode(json.encode(response.data));
        // ToastUtil.showShortToast('Added to Favourite');
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      print("Error during added to favourite section: $error");
      rethrow;
    }
  }
}
