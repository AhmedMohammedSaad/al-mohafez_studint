import 'dart:convert';

import 'package:almohafez/core/data/local_data/caching_helper.dart';
import 'package:flutter/foundation.dart';

class AppConst {
  static bool isDark = false;

  static String accessToken = '';
  static String refreshToken = '';
  static String verificationId = '';
  static String resetToken = '';
  static bool onBoarding = false;
  static int currentProfileInfoStep = 0;

  static List<String> get recentSearches {
    final jsonString = AppCacheHelper.getCacheString(
      key: AppCacheHelper.recentSearchKey,
    );
    if (jsonString.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<String>();
    } catch (e) {
      return [];
    }
  }

  /// Adds a single recent search
  static set addRecentSearch(String term) {
    final trimmedTerm = term.trim();
    if (trimmedTerm.isEmpty) return;

    final List<String> current = recentSearches;

    final seen = <String>{};
    final updated = [
      trimmedTerm,
      ...current.map((e) => e.trim()),
    ].where((item) => seen.add(item.toLowerCase())).toList();

    final limited = updated.take(10).toList();

    AppCacheHelper.cacheString(
      key: AppCacheHelper.recentSearchKey,
      value: jsonEncode(limited),
    );
  }

  /// Overwrites the full recent search list
  static set overwriteRecentSearches(List<String> newList) {
    final cleaned = newList
        .where((e) => e.trim().isNotEmpty)
        .toSet()
        .toList()
        .take(10)
        .toList();

    AppCacheHelper.cacheString(
      key: AppCacheHelper.recentSearchKey,
      value: jsonEncode(cleaned),
    );
  }

  /// Removes one item from recent search
  static set removeRecentSearch(String term) {
    final List<String> current = recentSearches;

    current.remove(term);

    AppCacheHelper.cacheString(
      key: AppCacheHelper.recentSearchKey,
      value: jsonEncode(current),
    );
  }
  //
  // static User? get userProfile {
  // final jsonString = AppCacheHelper.getCacheString(
  // key: AppCacheHelper.userKey,
  // );
  // if (jsonString.isEmpty) return null;
  // try {
  // return User.fromJson(jsonDecode(jsonString));
  // } catch (e) {
  // return null;
  // }
  // }

  // static set userProfile(User? user) {
  // if (user == null) {
  // AppCacheHelper.deleteCache(key: AppCacheHelper.userKey);
  // } else {
  // final data = user.toJson();
  // AppCacheHelper.cacheString(
  // key: AppCacheHelper.userKey,
  // value: jsonEncode(data),
  // );
  // }
  // }
}

void printFullText(String text, {int chunkSize = 800}) {
  final pattern = RegExp('.{1,$chunkSize}');
  for (final match in pattern.allMatches(text)) {
    if (kDebugMode) {
      print(match.group(0));
    }
  }
}
