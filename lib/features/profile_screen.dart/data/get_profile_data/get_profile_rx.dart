import 'package:numynd/features/profile_screen.dart/data/get_profile_data/get_profile_api.dart';
import 'package:numynd/features/profile_screen.dart/model/profile_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../networks/rx_base.dart';

final class GetProfileInfoRX extends RxResponseInt<GetProfile> {
  final api = GetProfileInfoAPI.instance;

  GetProfileInfoRX({required super.empty, required super.dataFetcher});

  ValueStream<GetProfile> get getProfileInfoRx => dataFetcher.stream;

  Future<void> getProfileInfoRX() async {
    try {
      GetProfile allData = await api.getProfileInfoAPI();
      handleSuccessWithReturn(allData);
    } catch (error) {
      handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(dynamic data) {
    dataFetcher.sink.add(data);
    return data;
  }
}
