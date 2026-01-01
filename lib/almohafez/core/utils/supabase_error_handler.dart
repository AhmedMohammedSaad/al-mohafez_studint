import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseErrorHandler {
  static String getErrorMessage(Object exception) {
    if (exception is AuthException) {
      switch (exception.message) {
        case 'Invalid login credentials':
          return 'invalid_credentials'.tr();
        case 'User already registered':
          return 'user_already_exists'.tr();
        case 'Password should be at least 6 characters':
          return 'password_too_short_supabase'.tr();
        case 'Email not confirmed':
          return 'email_not_confirmed'.tr();
        default:
          if (exception.message.contains('Network request failed')) {
            return 'network_error'.tr();
          }
          return exception.message;
      }
    } else if (exception is SocketException) {
      return 'network_error'.tr();
    } else if (exception is PostgrestException) {
      // Handle Supabase Database errors
      return 'unknown_error'.tr();
    } else if (exception is DioException) {
      if (exception.type == DioExceptionType.connectionTimeout ||
          exception.type == DioExceptionType.receiveTimeout ||
          exception.type == DioExceptionType.sendTimeout ||
          exception.type == DioExceptionType.connectionError) {
        return 'network_error'.tr();
      }
      return 'unknown_error'.tr();
    } else {
      return 'unknown_error'.tr();
    }
  }
}
