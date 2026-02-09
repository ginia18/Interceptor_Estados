import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'package:dio/dio.dart';

enum PostState { initial, loading, success, empty, error }

class PostProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  PostState _state = PostState.initial;
  List<Post> _posts = [];
  String? _errorMessage;

  PostState get state => _state;
  List<Post> get posts => _posts;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPosts() async {
  print("→ Iniciando fetchPosts()");
  _state = PostState.loading;
  _errorMessage = null;
  _posts = [];
  notifyListeners();

  try {
    print("  Enviando petición GET /posts");
    final data = await _apiService.getPosts();
    print("  Respuesta recibida. Tipo: ${data.runtimeType}");
    print("  Cantidad de items crudos: ${data.length}");

    final mapped = data.map((json) {
      try {
        return Post.fromJson(json as Map<String, dynamic>);
      } catch (e) {
        print("  Error mapeando un post: $e → $json");
        return Post(id: 0, title: "Error en dato", body: "");
      }
    }).toList();

    _posts = mapped;
    print("  Posts mapeados: ${_posts.length}");

    _state = _posts.isEmpty ? PostState.empty : PostState.success;
  } on DioException catch (e) {
    print("  DioException: ${e.type} - ${e.message}");
    if (e.response != null) {
      print("  Status: ${e.response?.statusCode}");
      print("  Datos error: ${e.response?.data}");
    }
    _state = PostState.error;
    _errorMessage = _getErrorMessage(e);
  } catch (e, stack) {
    print("  Error inesperado: $e");
    print("  Stack: $stack");
    _state = PostState.error;
    _errorMessage = 'Error inesperado: $e';
  }

  notifyListeners();
  print("→ Finalizó fetchPosts() → estado: $_state, posts: ${_posts.length}");
}

  String _getErrorMessage(DioException e) {
    switch (e.response?.statusCode) {
      case 401:
        return 'Error de autorización (401).';
      case 500:
        return 'Error del servidor (500).';
      default:
        return e.message ?? 'Error de conexión';
    }
  }

  // Para pruebas del estado Empty (obligatorio para el reto)
  void simulateEmptyState() {
    _posts = [];
    _state = PostState.empty;
    notifyListeners();
  }
}