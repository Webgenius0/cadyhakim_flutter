import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:numynd/features/home_screen/model/get_today_model.dart';
import '/networks/endpoints.dart';
import '../../../../../../../networks/dio/dio.dart';
import '../../../../../networks/exception_handler/data_source.dart';

/// ✅ Handles all API requests for Songs (with Pagination)
class GetTodaySongAPI {
  static final GetTodaySongAPI _singleton = GetTodaySongAPI._internal();
  GetTodaySongAPI._internal();

  /// Singleton getter
  static GetTodaySongAPI get instance => _singleton;

  /// Fetch songs (paginated)
  Future<GetTodaySongModel> getTodaySongAPI({int page = 1}) async {
    try {
      // 🧠 Make GET request with page parameter
      Response response =
          await getHttp("${Endpoints.getTodaySongURL()}?page=$page");

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(json.encode(response.data));
        return GetTodaySongModel.fromJson(data);
      } else {
        // ❌ Non-200 HTTP code
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      // ⚠️ Network / timeout / parsing error
      throw ErrorHandler.handle(error).failure;
    }
  }
}
