class Student {
  final String id;
  final String name;
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
    required this.name,
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
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profile_image'],
      joinDate: DateTime.parse(json['join_date'] ?? DateTime.now().toIso8601String()),
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
      'name': name,
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
    String? name,
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
      name: name ?? this.name,
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
    return 'Student(id: $id, name: $name, level: $level, currentPart: $currentPart)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}