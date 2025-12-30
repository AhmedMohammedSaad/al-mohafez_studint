class SessionRatingModel {
  final String id;
  final String sessionId;
  final String studentId;
  final String tutorId;
  final double rating;
  final String? feedback;
  final DateTime createdAt;
  final List<String>? tags; // مثل: ["ممتاز", "واضح", "مفيد"]

  SessionRatingModel({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.tutorId,
    required this.rating,
    this.feedback,
    required this.createdAt,
    this.tags,
  });

  factory SessionRatingModel.fromJson(Map<String, dynamic> json) {
    return SessionRatingModel(
      id: json['id'] ?? '',
      sessionId: json['session_id'] ?? '',
      studentId: json['student_id'] ?? '',
      tutorId: json['tutor_id'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      feedback: json['feedback'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'student_id': studentId,
      'teacher_id': tutorId,
      'rating': rating,
      'comment': feedback,
      'created_at': createdAt.toIso8601String(),
      'tags': tags,
    };
  }

  bool get isPositiveRating => rating >= 4.0;
  bool get isNegativeRating => rating < 3.0;

  String get ratingDescription {
    if (rating >= 4.5) return 'ممتاز';
    if (rating >= 4.0) return 'جيد جداً';
    if (rating >= 3.0) return 'جيد';
    if (rating >= 2.0) return 'مقبول';
    return 'ضعيف';
  }

  SessionRatingModel copyWith({
    String? id,
    String? sessionId,
    String? studentId,
    String? tutorId,
    double? rating,
    String? feedback,
    DateTime? createdAt,
    List<String>? tags,
  }) {
    return SessionRatingModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      studentId: studentId ?? this.studentId,
      tutorId: tutorId ?? this.tutorId,
      rating: rating ?? this.rating,
      feedback: feedback ?? this.feedback,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
    );
  }
}
