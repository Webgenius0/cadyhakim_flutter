import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:numynd/features/profile_screen.dart/data/change_pass_data/change_password_api.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/networks/rx_base.dart';
import 'package:rxdart/streams.dart';

final class PostResetPassApiRX extends RxResponseInt<Map<String, dynamic>> {
  final api = PostResetPassApi.instance;

  PostResetPassApiRX({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> postResetPassRx({
    required dynamic old_password,
    required dynamic new_password,
    required dynamic new_password_confirmation,
  }) async {
    try {
      final Map<String, dynamic> data = await api.postResetPass(
        old_password: old_password,
        new_password: new_password,
        new_password_confirmation: new_password_confirmation,
      );

      if (data['success'] == true) {
        await handleSuccessWithReturn(data);
        return true;
      } else {
        await handleErrorWithReturn(data['error'] ?? 'Password reset failed');
        return false;
      }
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  Future<void> handleSuccessWithReturn(Map<String, dynamic> data) async {
    try {
      final message = data['message'] ?? 'Password updated successfully.';
      log("Password reset success: $message");

      // You can show a toast here if needed
      ToastUtil.showShortToast(message);

      // No token, no login status changes, just add response to stream
      dataFetcher.sink.add(data);
    } catch (e) {
      log('Error in handleSuccessWithReturn: $e');
      dataFetcher.sink.addError(e);
      rethrow;
    }
  }

  @override
  Future<bool> handleErrorWithReturn(dynamic error) async {
    try {
      String errorMessage = 'An error occurred';

      if (error is DioException) {
        if (error.response != null) {
          final responseData = error.response?.data;
          errorMessage = responseData?['error'] ??
              responseData?['message'] ??
              error.response?.statusMessage ??
              'Server error';
        } else {
          errorMessage = error.message ?? 'Network error';
        }
      } else if (error is Map) {
        errorMessage =
            error['error'] ?? error['message'] ?? 'Password reset failed';
      } else if (error is String) {
        errorMessage = error;
      }

      log('Password Reset Error: $error');
      ToastUtil.showShortToast(errorMessage);
      dataFetcher.sink.addError(errorMessage);

      return false;
    } catch (e) {
      log('Error in handleErrorWithReturn: $e');
      return false;
    }
  }
}
