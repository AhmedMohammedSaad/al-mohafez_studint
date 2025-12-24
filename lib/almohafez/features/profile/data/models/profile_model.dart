class ProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String? avatarUrl;

  final int totalSessions;
  final double averageScore;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.avatarUrl,
    this.totalSessions = 0,
    this.averageScore = 0.0,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email:
          json['email'] ??
          '', // Email might come from auth.users not profiles table usually
      phoneNumber: json['phone_number'],
      avatarUrl: json['avatar_url'],
      totalSessions: json['total_sessions'] ?? 0,
      averageScore: (json['average_score'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
      'total_sessions': totalSessions,
      'average_score': averageScore,
    };
  }

  String get fullName => '$firstName $lastName';
}
