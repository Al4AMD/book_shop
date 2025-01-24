import 'package:dio/dio.dart';

class ApiClient {
  static Dio dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.1.36:3000/api/v1',
    connectTimeout: const Duration(milliseconds: 1000),
    receiveTimeout: const Duration(milliseconds: 3500),
  ))
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        return handler.next(error);
      },
    ));
}
