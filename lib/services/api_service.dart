import 'package:dio/dio.dart';
import 'network_interceptor.dart';

class ApiService {
  late final Dio dio;

  ApiService() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));

    dio.interceptors.add(NetworkInterceptor());
  }

  Future<List<dynamic>> getPosts() async {
    final response = await dio.get('/posts');
    return response.data as List<dynamic>;
  }
}