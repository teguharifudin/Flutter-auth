import 'package:dio/dio.dart';

class AuthService {
  Dio dio = Dio();

  Future<Response?> login(String username, String password) async {
    try {
      return await dio.post('http://localhost:5000/authenticate',
          data: {'name': username, 'password': password},
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioException catch (ex) {
      return ex.response;
    }
  }

  Future<Response?> getInfo(String? token) async {
    try {
      return await dio.get('http://localhost:5000/getinfo',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
    } on DioException catch (ex) {
      return ex.response;
    }
  }

  Future<Response?> register(String username, String password) async {
    try {
      return await dio.post('http://localhost:5000/adduser',
          data: {'name': username, 'password': password},
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioException catch (ex) {
      return ex.response;
    }
  }
}
