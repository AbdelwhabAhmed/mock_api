import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  const ApiClient(this.dio);

  Future<Options> baseOptions({bool attachToken = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    return Options(
      headers: headers,
      followRedirects: false,
      responseType: ResponseType.json,
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      // only 2xx and 1xx
      validateStatus: (status) => (status ?? 0) < 300,
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic> query = const {},
    CancelToken? cancelToken,
  }) async => await dio.get(
    path,
    cancelToken: cancelToken,
    queryParameters: query,
    options: await baseOptions(),
  );

  Future<Response<T>> post<T>(String path, {Object body = const {}}) async =>
      await dio.post(path, data: body, options: await baseOptions());

  Future<Response<T>> put<T>(String path, {Object body = const {}}) async =>
      await dio.put(path, data: body, options: await baseOptions());

  Future<Response> delete(
    String path, {
    Map<String, dynamic> query = const {},
  }) async =>
      dio.delete(path, queryParameters: query, options: await baseOptions());
}

Dio get dioInstance {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      contentType: 'application/json',
      headers: {'Accept': 'application/json'},
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  dio.interceptors.addAll([
    // LogInterceptor(),
    // UnAuthInterceptor(),
  ]);

  return dio;
}
