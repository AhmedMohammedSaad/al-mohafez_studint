import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';

class AppCacheHelper {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Keys for secure storage (sensitive data)
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String resetTokenKey = 'resetToken';
  static const String userKey = 'localUser';
  static const String cartKey = 'cartKey';

  // Keys for regular storage (non-sensitive data)
  static const String onBoardingKey = 'onBoardingShow';
  static const String isDark = 'isDark';
  static const String userRoleKey = 'userRole';
  static const String userPhoneKey = 'userPhone';
  static const String hasCompletedProfileKey = 'hasCompletedProfile';
  static const String currentProfileInfoStepKey = 'currentProfileInfoStep';
  static const String guestKey = 'guest';
  static const String recentSearchKey = 'recentSearch';
  static const String selectedLangCode = 'selectedLangCode';
  static const String rememberMeKey = 'rememberMe';

  static Future<void> saveRegistrationData({
    required String token,
    required String refreshToken,
    required String userRole,
    required String userPhone,
  }) async {
    try {
      // Save tokens in secure storage
      await cacheSecureString(key: accessTokenKey, value: token);
      await cacheSecureString(key: refreshTokenKey, value: refreshToken);

      // Save user data in regular storage
      cacheString(key: userRoleKey, value: userRole);
      cacheString(key: userPhoneKey, value: userPhone);

      // Set profile completion status to false initially
      cacheString(key: hasCompletedProfileKey, value: false);
    } catch (e) {
      rethrow;
    }
  }

  // Add method to mark profile as completed
  static Future<void> markProfileCompleted() async {
    try {
      cacheString(key: hasCompletedProfileKey, value: true);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> saveRememberMe(bool value) async {
    try {
      cacheString(key: rememberMeKey, value: value);
    } catch (e) {
      rethrow;
    }
  }

  static bool getRememberMe() {
    return getCachedBool(key: rememberMeKey);
  }

  // Secure storage methods
  static Future<void> cacheSecureString({
    required String key,
    required String value,
  }) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      // Fallback to regular storage
      cacheString(key: key, value: value);
    }
  }

  static Future<String> getSecureString({required String key}) async {
    try {
      final token = await _storage.read(key: key) ?? '';
      return token;
    } catch (e) {
      return '';
    }
  }

  static Future<void> deleteSecureCache({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      // Fallback to regular storage
      deleteCache(key: key);
    }
  }

  // Regular storage methods (for non-sensitive data)
  static void cacheString({required String key, required dynamic value}) {
    setValue(key, value);
  }

  static String getCacheString({required String key}) {
    return getStringAsync(key);
  }

  static int getCacheInt({required String key}) {
    return getIntAsync(key);
  }

  static void deleteCache({required String key}) {
    removeKey(key);
  }

  static bool getCachedBool({required String key}) {
    return getBoolAsync(key);
  }

  // Helper methods
  static Future<void> clearAuthData() async {
    try {
      // Clear secure storage
      await deleteSecureCache(key: accessTokenKey);
      await deleteSecureCache(key: refreshTokenKey);

      // Clear regular storage
      deleteCache(key: userRoleKey);
      deleteCache(key: userPhoneKey);
      deleteCache(key: hasCompletedProfileKey);
    } catch (e) {
      // Fallback: clear all regular storage
      deleteCache(key: accessTokenKey);
      deleteCache(key: refreshTokenKey);
      deleteCache(key: userRoleKey);
      deleteCache(key: userPhoneKey);
      deleteCache(key: hasCompletedProfileKey);
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final token = await getSecureString(key: accessTokenKey);
      return token.isNotEmpty;
    } catch (e) {
      final token = getCacheString(key: accessTokenKey);
      return token.isNotEmpty;
    }
  }

  static Future<void> signOut() async {
    try {
      await deleteSecureCache(key: accessTokenKey);
      await deleteSecureCache(key: refreshTokenKey);
      await deleteSecureCache(key: userKey);

      deleteCache(key: userRoleKey);
      deleteCache(key: userPhoneKey);
      deleteCache(key: guestKey);
    } catch (e) {
      deleteCache(key: accessTokenKey);
      deleteCache(key: refreshTokenKey);
      deleteCache(key: userRoleKey);
      deleteCache(key: userPhoneKey);
      deleteCache(key: guestKey);
    }
  }

  // Cart caching methods
  // static Future<void> saveCartItems(List<OrderModel> cartItems) async {
  // try {
  // final String jsonString = jsonEncode(
  // cartItems.map((item) => item.toJson()).toList(),
  // );
  // await cacheSecureString(key: cartKey, value: jsonString);
  // } catch (e) {
  // print('Error saving cart items: $e');
  // rethrow;
  // }
  // }
  //
  // static Future<List<OrderModel>> getCartItems() async {
  // try {
  // final String? jsonString = await _storage.read(key: cartKey);
  // if (jsonString == null || jsonString.isEmpty) {
  // return [];
  // }
  // final List<dynamic> jsonList = jsonDecode(jsonString);
  // return jsonList.map((json) => OrderModel.fromJson(json)).toList();
  // } catch (e) {
  // print('Error getting cart items: $e');
  // return [];
  // }
  // }
  //
  // static Future<void> clearCartItems() async {
  // try {
  // await deleteSecureCache(key: cartKey);
  // } catch (e) {
  // print('Error clearing cart items: $e');
  // rethrow;
  // }
  // }
}
