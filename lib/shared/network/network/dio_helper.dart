import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;
  static Map headers = <String, dynamic>{};
  static init() {
    print('Befor Dio Running....');

    dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      receiveDataWhenStatusError: true,
    ));

    print('After Dio Running....');
  }

  static Future<Response> getData({
    required String? path,
    Map<String, dynamic>? query,
  }) async {
    return await dio!.get(
      '$path',
      queryParameters: query,
    );
  }
}
