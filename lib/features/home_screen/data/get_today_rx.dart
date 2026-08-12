import 'package:numynd/features/home_screen/data/get_today_api.dart';
import 'package:numynd/features/home_screen/model/get_today_model.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../networks/rx_base.dart';

/// ✅ Reactive (Rx) layer for Today Songs with pagination
final class GetTodaySongRX extends RxResponseInt<GetTodaySongModel> {
  final api = GetTodaySongAPI.instance;

  GetTodaySongRX({
    required super.empty,
    required super.dataFetcher,
  });

  ValueStream<GetTodaySongModel> get getTodaySongRX => dataFetcher.stream;

  /// Fetch songs with pagination
  Future<GetTodaySongModel?> getAllTodaySongs({int page = 1}) async {
    try {
      final newData = await api.getTodaySongAPI(page: page);

      /// 🔹 If next page → merge old + new data
      if (page > 1 && dataFetcher.hasValue) {
        final oldData = dataFetcher.value;

        final List<TodaysPick> oldList = oldData.data?.todaysPicks ?? [];
        final List<TodaysPick> newList = newData.data?.todaysPicks ?? [];

        final mergedList = [...oldList, ...newList];

        final updated = GetTodaySongModel(
          success: newData.success,
          message: newData.message,
          data: Data(
            todaysPicks: mergedList,
            pagination: newData.data?.pagination,
          ),
        );

        dataFetcher.sink.add(updated);
      } else {
        /// 🔹 First page → replace data
        dataFetcher.sink.add(newData);
      }

      return newData;
    } catch (error) {
      handleErrorWithReturn(error);
      return null;
    }
  }

  @override
  GetTodaySongModel handleSuccessWithReturn(dynamic data) {
    dataFetcher.sink.add(data);
    return data;
  }
}

/// ✅ Global instance
final GetTodaySongRXObj = GetTodaySongRX(
  empty: GetTodaySongModel(),
  dataFetcher: BehaviorSubject<GetTodaySongModel>(),
);
