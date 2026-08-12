import 'dart:developer';
import 'package:numynd/features/setting_screen/data/delete_account/delete_api.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../networks/rx_base.dart';

final class PostDeleteAccountRX extends RxResponseInt {
  final api = DeleteAPI.instance;

  String message = "Something went wrong";

  PostDeleteAccountRX({required super.empty, required super.dataFetcher});

  ValueStream get getDeleteAccountData => dataFetcher.stream;

  Future<bool> deleteAccount() async {
    try {
      Map resdata = await api.deleteAPI();
      return handleSuccessWithReturn(resdata);
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) {
    dataFetcher.sink.add(data);
    // message = data["message"];
    // if (data["success"] == false) throw Exception();
    log(">>>>>>>>>>>>>>>>>>> Delete Account success");
    ToastUtil.showShortToast("Delete Account Success");
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    String errorMessage = 'Something went wrong';
    log(error.toString());

    errorMessage = error.response?.data["message"] ?? "Something went wrong";
    return super.handleErrorWithReturn(errorMessage);
  }
}
