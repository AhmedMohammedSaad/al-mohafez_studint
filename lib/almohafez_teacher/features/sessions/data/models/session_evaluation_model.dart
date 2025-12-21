class SessionEvaluation {
  final String id;
  final String sessionId;
  final String studentId;
  final String studentName;
  final String teacherId;
  final int? memorizationScore; // 1-5
  final int? tajweedScore; // 1-5
  final int? overallScore; // 1-5
  final String? notes;
  final String? strengths;
  final String? improvements;
  final String? nextGoals;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SessionEvaluation({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.studentName,
    required this.teacherId,
    this.memorizationScore,
    this.tajweedScore,
    this.overallScore,
    this.notes,
    this.strengths,
    this.improvements,
    this.nextGoals,
    required this.createdAt,
    this.updatedAt,
  });

  factory SessionEvaluation.fromJson(Map<String, dynamic> json) {
    return SessionEvaluation(
      id: json['id'] ?? '',
      sessionId: json['session_id'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      teacherId: json['teacher_id'] ?? '',
      memorizationScore: json['memorization_score'],
      tajweedScore: json['tajweed_score'],
      overallScore: json['overall_score'],
      notes: json['notes'],
      strengths: json['strengths'],
      improvements: json['improvements'],
      nextGoals: json['next_goals'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'student_id': studentId,
      'student_name': studentName,
      'teacher_id': teacherId,
      'memorization_score': memorizationScore,
      'tajweed_score': tajweedScore,
      'overall_score': overallScore,
      'notes': notes,
      'strengths': strengths,
      'improvements': improvements,
      'next_goals': nextGoals,
    };
  }

  double get averageScore {
    int count = 0;
    int total = 0;
    if (memorizationScore != null) {
      total += memorizationScore!;
      count++;
    }
    if (tajweedScore != null) {
      total += tajweedScore!;
      count++;
    }
    if (overallScore != null) {
      total += overallScore!;
      count++;
    }
    return count > 0 ? total / count : 0;
  }

  String get averageScoreText {
    final avg = averageScore;
    if (avg >= 4.5) return 'ممتاز';
    if (avg >= 3.5) return 'جيد جداً';
    if (avg >= 2.5) return 'جيد';
    if (avg >= 1.5) return 'مقبول';
    return 'يحتاج تحسين';
  }

  @override
  String toString() {
    return 'SessionEvaluation(id: $id, studentName: $studentName, averageScore: $averageScore)';
  }
}
