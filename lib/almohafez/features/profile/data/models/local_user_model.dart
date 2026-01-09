import 'dart:convert';

class LocalUserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? profileImagePath;

  LocalUserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.profileImagePath,
  });

  factory LocalUserModel.fromJson(Map<String, dynamic> json) {
    return LocalUserModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImagePath: json['profileImagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'profileImagePath': profileImagePath,
    };
  }

  static LocalUserModel? tryParse(String jsonString) {
    if (jsonString.isEmpty) return null;
    try {
      return LocalUserModel.fromJson(jsonDecode(jsonString));
    } catch (_) {
      return null;
    }
  }
}
