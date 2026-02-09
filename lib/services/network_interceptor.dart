import 'dart:math';
import 'package:dio/dio.dart';

class NetworkInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Retraso aleatorio 1-4 segundos
    final delaySeconds = Random().nextInt(4) + 1;
    await Future.delayed(Duration(seconds: delaySeconds));

    // 2. 20% de probabilidad de error (500 o 401)
    if (Random().nextDouble() < 0.20) {
      final isServerError = Random().nextBool();
      final statusCode = isServerError ? 500 : 401;
      final message = isServerError
          ? 'Error interno del servidor (simulado)'
          : 'No autorizado (simulado)';

      handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            data: {'message': message},
            statusCode: statusCode,
            requestOptions: options,
          ),
          type: DioExceptionType.badResponse,
        ),
      );
      return;
    }

    // Si todo bien → continuar
    handler.next(options);
  }
}