import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
        baseUrl: 'https://maps.googleapis.com/maps/api/',
      ),
    );
  }

  static Future getData({
    Map<String,dynamic>? query ,
    required String path ,
})async {
   return await dio.get(
      path,
      queryParameters: query ,
    );
  }
}
