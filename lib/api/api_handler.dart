import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:luckystone/extra/app_variables.dart';
import 'package:luckystone/extra/flutter_toast.dart';
import 'package:luckystone/extra/shared_preferences.dart';

class ApiHandler {
  static ApiHandler handler = ApiHandler();
  late Dio dio;

  ApiHandler() {
    initDio();
  }

  // ---------------- INIT DIO ----------------

  void initDio() {
    dio = Dio();
    setHeaders();

    dio.options
      ..connectTimeout = const Duration(seconds: 60)
      ..receiveTimeout = const Duration(seconds: 60);

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  // ---------------- HEADERS ----------------

  void setHeaders() {
    dio.options.headers = {
      if (accessToken.isNotEmpty) 'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'User-Agent': 'LuckyStoneApp_ver-1.0',
    };
  }

  // ---------------- GET API ----------------

  Future<dynamic> getApi(String url, {Map<String, dynamic>? queryParams}) async {
    try {
      initDio();
      final Response response =
          await dio.get(url, queryParameters: queryParams);
      log("response $response");
      return response;
    } on DioException catch (e) {
      await _handleError(e);
    }
  }

  // ---------------- POST API ----------------

  Future<dynamic> postApi(String url, data, {CancelToken? cancelToken}) async {
    try {
      initDio();
      final response =
          await dio.post(url, data: data, cancelToken: cancelToken);
      log("response $response");
      return response;
    } on DioException catch (e) {
      await _handleError(e);
    }
  }

  // ---------------- PUT API ----------------

  Future<dynamic> putApi(String url, data) async {
    try {
      initDio();
      final response = await dio.put(url, data: data);
      log("response $response");
      return response;
    } on DioException catch (e) {
      await _handleError(e);
    }
  }

  // ---------------- DELETE API ----------------

  Future<dynamic> deleteApi(String url, {data}) async {
    try {
      initDio();
      final response = await dio.delete(url, data: data);
      log("response $response");
      return response;
    } on DioException catch (e) {
      await _handleError(e);
    }
  }

  // ---------------- MULTIPART API ----------------

  Future<dynamic> imagePostApi(String url, FormData data) async {
    try {
      initDio();
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      final Response response = await dio.post(url, data: data);
      log("response $response");
      return response;
    } on DioException catch (e) {
      await _handleError(e);
    }
  }

  // ---------------- ERROR HANDLING ----------------
  // Backend always answers errors as {"success": false, "message": "..."}

  Future _handleError(DioException e) async {
    final dynamic body = e.response?.data;
    final String? message =
        body is Map && body['message'] != null ? body['message'].toString() : null;

    if (e.error is SocketException ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      FlutterToast.showToast("Network error");
    } else if (CancelToken.isCancel(e)) {
      throw ("cancel request");
    } else if (e.response?.statusCode == 401) {
      await AppPreferences.shared.clearLogin();
      FlutterToast.showToast(message ?? "Session expired, please login again");
    } else if (e.response?.statusCode == 400 ||
        e.response?.statusCode == 403 ||
        e.response?.statusCode == 404 ||
        e.response?.statusCode == 409 ||
        e.response?.statusCode == 422) {
      FlutterToast.showToast(message ?? "Bad Request");
    } else if (e.response?.statusCode == 500 || e.response?.statusCode == 502) {
      FlutterToast.showToast("Internal Server Error");
    } else {
      FlutterToast.showToast("Something went wrong. Please try again.");
    }
  }
}
