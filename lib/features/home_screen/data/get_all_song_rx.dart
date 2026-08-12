// import 'package:numynd/features/home_screen/data/get_all_song_api.dart';
// import 'package:numynd/features/home_screen/model/get_all_song_model.dart';
// import 'package:rxdart/rxdart.dart';

// import '../../../../../networks/rx_base.dart';

// final class GetAllSongRX extends RxResponseInt<GetAllMusic> {
//   final api = GetAllSongAPI.instance;

//   GetAllSongRX({required super.empty, required super.dataFetcher});

//   ValueStream<GetAllMusic> get getAllSongRX => dataFetcher.stream;

//   Future<void> getAllSongs() async {
//     try {
//       GetAllMusic allData = await api.getAllSongAPI();
//       handleSuccessWithReturn(allData);
//     } catch (error) {
//       handleErrorWithReturn(error);
//     }
//   }

//   @override
//   handleSuccessWithReturn(dynamic data) {
//     dataFetcher.sink.add(data);
//     return data;
//   }
// }

import 'package:numynd/features/home_screen/data/get_all_song_api.dart';
import 'package:numynd/features/home_screen/model/get_all_song_model.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../networks/rx_base.dart';

/// ✅ Reactive (Rx) layer for songs with pagination
final class GetAllSongRX extends RxResponseInt<GetAllMusic> {
  final api = GetAllSongAPI.instance;

  GetAllSongRX({required super.empty, required super.dataFetcher});

  ValueStream<GetAllMusic> get getAllSongRX => dataFetcher.stream;

  /// Fetch songs with pagination, update Stream & return data
  Future<GetAllMusic?> getAllSongs({int page = 1}) async {
    try {
      final newData = await api.getAllSongAPI(page: page);

      // ✅ If not first page, append new items to existing stream
      if (page > 1 && dataFetcher.hasValue) {
        final oldData = dataFetcher.value;

        final List<Audio> oldList = oldData.data?.audios ?? [];
        final List<Audio> newList = newData.data?.audios ?? [];

        // Merge old + new
        final merged = List<Audio>.from(oldList)..addAll(newList);

        // Create updated data
        final updated = GetAllMusic(
          success: newData.success,
          message: newData.message,
          data: Data(
            audios: merged,
            pagination: newData.data?.pagination,
          ),
        );

        dataFetcher.sink.add(updated);
      } else {
        // 🧩 First page → replace data
        dataFetcher.sink.add(newData);
      }

      return newData;
    } catch (error) {
      handleErrorWithReturn(error);
      return null;
    }
  }

  @override
  handleSuccessWithReturn(dynamic data) {
    dataFetcher.sink.add(data);
    return data;
  }
}

// * ✅ Global instance (you already use this in your project)
final getAllSongRXObj = GetAllSongRX(
  empty: GetAllMusic(),
  dataFetcher: BehaviorSubject<GetAllMusic>(),
);
