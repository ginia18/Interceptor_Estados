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
    _state = PostState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _apiService.getPosts();
      _posts = data.map((json) => Post.fromJson(json)).toList();

      _state = _posts.isEmpty ? PostState.empty : PostState.success;
    } on DioException catch (e) {
      _state = PostState.error;
      _errorMessage = _getErrorMessage(e);
    } catch (e) {
      _state = PostState.error;
      _errorMessage = 'Error inesperado: $e';
    }

    notifyListeners();
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