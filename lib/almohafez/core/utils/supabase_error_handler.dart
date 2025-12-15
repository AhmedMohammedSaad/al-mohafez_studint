import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseErrorHandler {
  static String getErrorMessage(AuthException exception) {
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
        return exception
            .message; // Return original message if no mapping found, or map to generic 'unknown_error'
    }
  }
}
