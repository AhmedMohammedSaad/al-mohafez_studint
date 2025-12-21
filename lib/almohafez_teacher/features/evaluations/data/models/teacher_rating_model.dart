class TeacherRating {
  final String id;
  final String sessionId;
  final String studentId;
  final String studentName;
  final String teacherId;
  final int rating; // 1-5 stars
  final String? comment;
  final DateTime createdAt;

  const TeacherRating({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.studentName,
    required this.teacherId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory TeacherRating.fromJson(Map<String, dynamic> json) {
    return TeacherRating(
      id: json['id'] ?? '',
      sessionId: json['session_id'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      teacherId: json['teacher_id'] ?? '',
      rating: (json['rating'] ?? 0).toInt(),
      comment: json['comment'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'student_id': studentId,
      'student_name': studentName,
      'teacher_id': teacherId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get ratingDescription {
    if (rating >= 5) return 'ممتاز';
    if (rating >= 4) return 'جيد جداً';
    if (rating >= 3) return 'جيد';
    if (rating >= 2) return 'مقبول';
    return 'ضعيف';
  }

  @override
  String toString() {
    return 'TeacherRating(id: $id, studentName: $studentName, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeacherRating && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
