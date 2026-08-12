// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:numynd/features/home_screen/model/get_all_song_model.dart';
// import '/networks/endpoints.dart';
// import '../../../../../../../networks/dio/dio.dart';
// import '../../../../../networks/exception_handler/data_source.dart';
// // Import DataSource for failure handling

// class GetAllSongAPI {
//   static final GetAllSongAPI _singleton = GetAllSongAPI._internal();
//   GetAllSongAPI._internal();

//   // Singleton getter
//   static GetAllSongAPI get instance => _singleton;

//   // * Method to fetch profile data
//   Future<GetAllMusic> getAllSongAPI() async {
//     try {
//       Response response = await getHttp(
//         Endpoints.getAllSongURL(),
//       );

//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(json.encode(response.data));

//         return GetAllMusic.fromJson(data);
//       } else {
//         // * Handle non-200 status code errors, like 404, 500, etc.
//         throw DataSource.DEFAULT.getFailure();
//       }
//     } catch (error) {
//       // * Handle generic errors (like network failures, timeouts, etc.)
//       throw ErrorHandler.handle(error).failure;
//     }
//   }
// }


import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:numynd/features/home_screen/model/get_all_song_model.dart';
import '/networks/endpoints.dart';
import '../../../../../../../networks/dio/dio.dart';
import '../../../../../networks/exception_handler/data_source.dart';

/// ✅ Handles all API requests for Songs (with Pagination)
class GetAllSongAPI {
  static final GetAllSongAPI _singleton = GetAllSongAPI._internal();
  GetAllSongAPI._internal();

  /// Singleton getter
  static GetAllSongAPI get instance => _singleton;

  /// Fetch songs (paginated)
  Future<GetAllMusic> getAllSongAPI({int page = 1}) async {
    try {
      // 🧠 Make GET request with page parameter
      Response response = await getHttp("${Endpoints.getAllSongURL()}?page=$page");

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(json.encode(response.data));
        return GetAllMusic.fromJson(data);
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
