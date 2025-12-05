import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'http://10.0.2.2:8080',
          connectTimeout: Duration(milliseconds: 10000),
          receiveTimeout: Duration(milliseconds: 10000),
        ),
      );

  Future<Response> get(String path) async {
    return await dio.get(path);
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    return await dio.post(path, data: data);
  }

  Future<Response> put(String path, Map<String, dynamic> data) async {
    return await dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await dio.delete(path);
  }
}
