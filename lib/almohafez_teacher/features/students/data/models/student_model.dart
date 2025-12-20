class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? profileImage;
  final DateTime joinDate;
  final String level; // المستوى في الحفظ
  final int totalSessions;
  final double averageRating;
  final String currentPart; // الجزء الحالي
  final List<String> completedParts; // الأجزاء المكتملة
  final bool isActive;
  final String? notes; // ملاحظات الشيخ

  const Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.joinDate,
    required this.level,
    this.totalSessions = 0,
    this.averageRating = 0.0,
    required this.currentPart,
    this.completedParts = const [],
    this.isActive = true,
    this.notes,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profile_image'],
      joinDate: DateTime.parse(
        json['join_date'] ?? DateTime.now().toIso8601String(),
      ),
      level: json['level'] ?? 'مبتدئ',
      totalSessions: json['total_sessions'] ?? 0,
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
      currentPart: json['current_part'] ?? 'الجزء الأول',
      completedParts: List<String>.from(json['completed_parts'] ?? []),
      isActive: json['is_active'] ?? true,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'join_date': joinDate.toIso8601String(),
      'level': level,
      'total_sessions': totalSessions,
      'average_rating': averageRating,
      'current_part': currentPart,
      'completed_parts': completedParts,
      'is_active': isActive,
      'notes': notes,
    };
  }

  Student copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? profileImage,
    DateTime? joinDate,
    String? level,
    int? totalSessions,
    double? averageRating,
    String? currentPart,
    List<String>? completedParts,
    bool? isActive,
    String? notes,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      joinDate: joinDate ?? this.joinDate,
      level: level ?? this.level,
      totalSessions: totalSessions ?? this.totalSessions,
      averageRating: averageRating ?? this.averageRating,
      currentPart: currentPart ?? this.currentPart,
      completedParts: completedParts ?? this.completedParts,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'Student(id: $id, firstName: $firstName, lastName: $lastName, level: $level, currentPart: $currentPart)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
