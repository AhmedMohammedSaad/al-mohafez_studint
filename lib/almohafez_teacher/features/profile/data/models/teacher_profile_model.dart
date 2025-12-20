class TeacherProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? profilePictureUrl;
  final String? bio;
  final String? gender;
  final double sessionPrice;
  final double overallRating;
  final int numSessions;
  final bool isAvailable;
  final List<String> qualifications;
  final List<dynamic> availabilitySlots;

  TeacherProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profilePictureUrl,
    this.bio,
    this.gender,
    required this.sessionPrice,
    required this.overallRating,
    required this.numSessions,
    required this.isAvailable,
    required this.qualifications,
    required this.availabilitySlots,
  });

  factory TeacherProfileModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profilePictureUrl: json['profile_picture_url'] as String?,
      bio: json['bio'] as String?,
      gender: json['gender'] as String?,
      sessionPrice: (json['session_price'] as num?)?.toDouble() ?? 0.0,
      overallRating: (json['overall_rating'] as num?)?.toDouble() ?? 5.0,
      numSessions: (json['num_sessions'] as num?)?.toInt() ?? 0,
      isAvailable: json['is_available'] as bool? ?? true,
      qualifications:
          (json['qualifications'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      availabilitySlots: json['availability_slots'] as List<dynamic>? ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'profile_picture_url': profilePictureUrl,
      'bio': bio,
      'gender': gender,
      'session_price': sessionPrice,
      'overall_rating': overallRating,
      'num_sessions': numSessions,
      'is_available': isAvailable,
      'qualifications': qualifications,
      'availability_slots': availabilitySlots,
    };
  }

  TeacherProfileModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? profilePictureUrl,
    String? bio,
    String? gender,
    double? sessionPrice,
    double? overallRating,
    int? numSessions,
    bool? isAvailable,
    List<String>? qualifications,
    List<dynamic>? availabilitySlots,
  }) {
    return TeacherProfileModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      sessionPrice: sessionPrice ?? this.sessionPrice,
      overallRating: overallRating ?? this.overallRating,
      numSessions: numSessions ?? this.numSessions,
      isAvailable: isAvailable ?? this.isAvailable,
      qualifications: qualifications ?? this.qualifications,
      availabilitySlots: availabilitySlots ?? this.availabilitySlots,
    );
  }
}
