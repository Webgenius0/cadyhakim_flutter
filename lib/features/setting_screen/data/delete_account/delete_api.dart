import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class DeleteAPI {
  static final DeleteAPI _singleton = DeleteAPI._internal();
  DeleteAPI._internal();

  static DeleteAPI get instance => _singleton;

  Future<Map> deleteAPI() async {
    try {
      Response response = await deleteHttp(Endpoints.deleteAccountUrl());

      if (response.statusCode == 200) {
        Map data = json.decode(json.encode(response.data));
        return data;
      } else {
        // Handle non-200 status code errors
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow; // Rethrow the error to be caught in the calling method
    }
  }
}
