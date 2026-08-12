import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:numynd/features/profile_screen.dart/model/profile_model.dart';
import '/networks/endpoints.dart';
import '../../../../../../../networks/dio/dio.dart';
import '../../../../../networks/exception_handler/data_source.dart';
// Import DataSource for failure handling

class GetProfileInfoAPI {
  static final GetProfileInfoAPI _singleton = GetProfileInfoAPI._internal();
  GetProfileInfoAPI._internal();

  // Singleton getter
  static GetProfileInfoAPI get instance => _singleton;

  // * Method to fetch profile data
  Future<GetProfile> getProfileInfoAPI() async {
    try {
      Response response = await getHttp(
        Endpoints.getProfileURL(),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(json.encode(response.data));

        return GetProfile.fromJson(data);
      } else {
        // * Handle non-200 status code errors, like 404, 500, etc.
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      // * Handle generic errors (like network failures, timeouts, etc.)
      throw ErrorHandler.handle(error).failure;
    }
  }
}
