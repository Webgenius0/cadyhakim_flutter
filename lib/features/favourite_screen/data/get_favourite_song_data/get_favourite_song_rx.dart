// import 'package:numynd/features/home_screen/data/get_all_song_api.dart';
// import 'package:numynd/features/home_screen/model/get_all_song_model.dart';
// import 'package:rxdart/rxdart.dart';

// import '../../../../../networks/rx_base.dart';

// final class GetFavouriteSongRX extends RxResponseInt<GetAllMusic> {
//   final api = GetFavouriteSongAPI.instance;

//   GetFavouriteSongRX({required super.empty, required super.dataFetcher});

//   ValueStream<GetAllMusic> get GetFavouriteSongRX => dataFetcher.stream;

//   Future<void> getAllSongs() async {
//     try {
//       GetAllMusic allData = await api.GetFavouriteSongAPI();
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

import 'package:numynd/features/favourite_screen/data/get_favourite_song_data/get_favourite_song_api.dart';
import 'package:numynd/features/favourite_screen/model/get_favourite_song_model.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../../networks/rx_base.dart';

/// ✅ Reactive (Rx) layer for songs with pagination
final class GetFavouriteSongRX extends RxResponseInt<GetFavouriteSong> {
  final api = GetFavouriteSongAPI.instance;

  GetFavouriteSongRX({required super.empty, required super.dataFetcher});

  ValueStream<GetFavouriteSong> get getFavouriteSongRX => dataFetcher.stream;

  /// Fetch songs with pagination, update Stream & return data
  Future<GetFavouriteSong?> getAllSongs({int page = 1}) async {
    try {
      final newData = await api.getFavouriteSongAPI(page: page);

      // ✅ If not first page, append new items to existing stream
      if (page > 1 && dataFetcher.hasValue) {
        final oldData = dataFetcher.value;

        final List<Favorite> oldList = oldData.data?.favorites ?? [];
        final List<Favorite> newList = newData.data?.favorites ?? [];

        // Merge old + new
        final merged = List<Favorite>.from(oldList)..addAll(newList);

        // Create updated data
        final updated = GetFavouriteSong(
          success: newData.success,
          message: newData.message,
          data: Data(
            favorites: merged,
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
final GetFavouriteSongRXObj = GetFavouriteSongRX(
  empty: GetFavouriteSong(),
  dataFetcher: BehaviorSubject<GetFavouriteSong>(),
);
