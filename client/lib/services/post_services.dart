import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:client/models/post.dart';

class PostService {
  Dio dio = new Dio();

  Future<Response?> getAllPost() async {
    try {
      return await dio.get('http://localhost:5000/getallpost');
    } on DioError catch (err) {
      return err.response;
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  Future<Response?> searchPost(String searchKey) async {
    try {
      return await dio.get('http://localhost:5000/searchpost/$searchKey');
    } on DioError catch (err) {
      return err.response;
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  Future<Response?> deletePost(String id) async {
    try {
      return await dio.delete('http://localhost:5000/deletepost/$id');
    } on DioError catch (err) {
      return err.response;
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  Future<Response?> createPost(
      String title, String body, String author, String authorId) async {
    print(title);
    print(body);
    print(author);
    print(authorId);
    try {
      return await dio.post(
        'http://localhost:5000/addpost',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode({
          'title': title,
          'body': body,
          'author': author,
          'author_id': authorId
        }),
      );
    } on DioError catch (err) {
      return err.response;
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  Future<Response?> updatePost(Post post) async {
    try {
      return await dio.put(
        'http://localhost:5000/updatepost/${post.id}',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode({
          'title': post.title,
          'body': post.body,
          'author': post.author,
          'author_id': post.authorId
        }),
      );
    } on DioError catch (err) {
      return err.response;
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }
}
