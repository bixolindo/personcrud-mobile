import 'package:dio/dio.dart';

class BaseAPI {
  static final BaseAPI _singleton = BaseAPI._internal();
  Dio dio;
  String baseUrl = "https://quarkus-crud-backend.herokuapp.com";

  factory BaseAPI() {
    return _singleton;
  }

  BaseAPI._internal();

  init() {
    var options = BaseOptions(
      baseUrl: this.baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    this.dio = Dio(options);
  }

  Future<Response> get(String path) => this.dio.get(this.baseUrl + path);

  Future<Response> post(String path, dynamic data) =>
      this.dio.post(path, data: data);

  Future<Response> put(String path, dynamic data) =>
      this.dio.put(path, data: data);

  Future<Response> delete(String path, int id) =>
      this.dio.delete(path + "/$id");
}
