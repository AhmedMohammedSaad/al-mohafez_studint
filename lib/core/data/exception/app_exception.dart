import 'package:dio/dio.dart';
import 'package:almohafez/core/utils/app_strings.dart';

abstract class Failure {
  const Failure(this.errorMessage);
  final String errorMessage;
}

class ServerFailure extends Failure {
  ServerFailure(super.errorMessage);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(AppStrings.connectionTimeout);
      case DioExceptionType.sendTimeout:
        return ServerFailure(AppStrings.sendTimeout);
      case DioExceptionType.receiveTimeout:
        return ServerFailure(AppStrings.receiveTimeout);
      case DioExceptionType.badCertificate:
        return ServerFailure(AppStrings.badCertificate);
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(dioError.response!);
      case DioExceptionType.cancel:
        return ServerFailure(AppStrings.requestCancelled);
      case DioExceptionType.connectionError:
        return ServerFailure(AppStrings.connectionError);
      case DioExceptionType.unknown:
        if (dioError.message!.contains('SocketException')) {
          return ServerFailure(AppStrings.noInternet);
        } else {
          return ServerFailure(AppStrings.unexpectedError);
        }
      // default:
      //   return ServerFailure.fromResponse(dioError.response!);
    }
  }

  factory ServerFailure.fromResponse(Response response) {
    final statusCode = response.statusCode;
    final responseData = response.data;

    // Handle 'error' response
    if (responseData is Map && responseData.containsKey('error')) {
      final error = responseData['error'];

      if (error is Map && error['message'] is List) {
        final messages = error['message'] as List;
        if (messages.isNotEmpty) {
          final firstError = messages[0];
          return ServerFailure(
            AppStrings.errorMessage(
              firstError['message'] ?? AppStrings.unexpectedError,
            ),
          );
        }
      } else if (error is String) {
        return ServerFailure(AppStrings.errorMessage(error));
      }
    }

    // Handle 'detail' key like the example you shared
    if (responseData is Map && responseData.containsKey('detail')) {
      final detail = responseData['detail'];

      if (detail is String) {
        return ServerFailure(AppStrings.errorMessage(detail));
      } else if (detail is List && detail.isNotEmpty && detail[0] is String) {
        return ServerFailure(AppStrings.errorMessage(detail[0]));
      }
    }

    // Handle common status codes
    switch (statusCode) {
      case 400:
        return ServerFailure(AppStrings.badRequest);
      case 401:
        return ServerFailure(AppStrings.unauthorized);
      case 403:
        return ServerFailure(AppStrings.forbidden);
      case 404:
        return ServerFailure(AppStrings.notFound);
      case 429:
        return ServerFailure(AppStrings.waitBeforeResend);
      case 500:
        return ServerFailure(AppStrings.serverError);
      case 433:
        return ServerFailure(AppStrings.validation);
      default:
        return ServerFailure(AppStrings.unexpectedError);
    }
  }
}
