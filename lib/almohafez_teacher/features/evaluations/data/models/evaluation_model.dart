class Evaluation {
  final String id;
  final String sessionId;
  final String studentId;
  final String studentName;
  final DateTime evaluationDate;
  final double memorizationScore; // درجة الحفظ (من 5)
  final double tajweedScore; // درجة التجويد (من 5)
  final double overallPerformance; // الأداء العام (من 5)
  final String? notes; // ملاحظات الشيخ
  final String? strengths; // نقاط القوة
  final String? improvements; // نقاط التحسين
  final String? nextSessionGoals; // أهداف الجلسة القادمة
  final List<String> topics; // المواضيع المدروسة
  final bool isCompleted;

  const Evaluation({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.studentName,
    required this.evaluationDate,
    required this.memorizationScore,
    required this.tajweedScore,
    required this.overallPerformance,
    this.notes,
    this.strengths,
    this.improvements,
    this.nextSessionGoals,
    this.topics = const [],
    this.isCompleted = false,
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      id: json['id'] ?? '',
      sessionId: json['session_id'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      evaluationDate: DateTime.parse(json['evaluation_date'] ?? DateTime.now().toIso8601String()),
      memorizationScore: (json['memorization_score'] ?? 0.0).toDouble(),
      tajweedScore: (json['tajweed_score'] ?? 0.0).toDouble(),
      overallPerformance: (json['overall_performance'] ?? 0.0).toDouble(),
      notes: json['notes'],
      strengths: json['strengths'],
      improvements: json['improvements'],
      nextSessionGoals: json['next_session_goals'],
      topics: List<String>.from(json['topics'] ?? []),
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'student_id': studentId,
      'student_name': studentName,
      'evaluation_date': evaluationDate.toIso8601String(),
      'memorization_score': memorizationScore,
      'tajweed_score': tajweedScore,
      'overall_performance': overallPerformance,
      'notes': notes,
      'strengths': strengths,
      'improvements': improvements,
      'next_session_goals': nextSessionGoals,
      'topics': topics,
      'is_completed': isCompleted,
    };
  }

  Evaluation copyWith({
    String? id,
    String? sessionId,
    String? studentId,
    String? studentName,
    DateTime? evaluationDate,
    double? memorizationScore,
    double? tajweedScore,
    double? overallPerformance,
    String? notes,
    String? strengths,
    String? improvements,
    String? nextSessionGoals,
    List<String>? topics,
    bool? isCompleted,
  }) {
    return Evaluation(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      evaluationDate: evaluationDate ?? this.evaluationDate,
      memorizationScore: memorizationScore ?? this.memorizationScore,
      tajweedScore: tajweedScore ?? this.tajweedScore,
      overallPerformance: overallPerformance ?? this.overallPerformance,
      notes: notes ?? this.notes,
      strengths: strengths ?? this.strengths,
      improvements: improvements ?? this.improvements,
      nextSessionGoals: nextSessionGoals ?? this.nextSessionGoals,
      topics: topics ?? this.topics,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Helper methods
  double get averageScore {
    return (memorizationScore + tajweedScore + overallPerformance) / 3;
  }

  String get averageScoreText {
    final avg = averageScore;
    if (avg >= 4.5) return 'ممتاز';
    if (avg >= 3.5) return 'جيد جداً';
    if (avg >= 2.5) return 'جيد';
    if (avg >= 1.5) return 'مقبول';
    return 'يحتاج تحسين';
  }

  String get performanceLevel {
    final avg = averageScore;
    if (avg >= 4.0) return 'متقدم';
    if (avg >= 3.0) return 'متوسط';
    return 'مبتدئ';
  }

  bool get isExcellent => averageScore >= 4.5;
  bool get isGood => averageScore >= 3.0;
  bool get needsImprovement => averageScore < 2.5;

  @override
  String toString() {
    return 'Evaluation(id: $id, studentName: $studentName, averageScore: ${averageScore.toStringAsFixed(1)})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Evaluation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// نموذج لإحصائيات التقييم
class EvaluationStatistics {
  final int totalEvaluations;
  final double averageMemorizationScore;
  final double averageTajweedScore;
  final double averageOverallScore;
  final int excellentCount;
  final int goodCount;
  final int needsImprovementCount;
  final Map<String, int> topicsFrequency;

  const EvaluationStatistics({
    required this.totalEvaluations,
    required this.averageMemorizationScore,
    required this.averageTajweedScore,
    required this.averageOverallScore,
    required this.excellentCount,
    required this.goodCount,
    required this.needsImprovementCount,
    required this.topicsFrequency,
  });

  factory EvaluationStatistics.fromEvaluations(List<Evaluation> evaluations) {
    if (evaluations.isEmpty) {
      return const EvaluationStatistics(
        totalEvaluations: 0,
        averageMemorizationScore: 0.0,
        averageTajweedScore: 0.0,
        averageOverallScore: 0.0,
        excellentCount: 0,
        goodCount: 0,
        needsImprovementCount: 0,
        topicsFrequency: {},
      );
    }

    final total = evaluations.length;
    final avgMem = evaluations.map((e) => e.memorizationScore).reduce((a, b) => a + b) / total;
    final avgTaj = evaluations.map((e) => e.tajweedScore).reduce((a, b) => a + b) / total;
    final avgOverall = evaluations.map((e) => e.overallPerformance).reduce((a, b) => a + b) / total;

    int excellent = 0, good = 0, needsImprovement = 0;
    Map<String, int> topics = {};

    for (final eval in evaluations) {
      if (eval.isExcellent) {
        excellent++;
      } else if (eval.isGood) good++;
      else if (eval.needsImprovement) needsImprovement++;

      for (final topic in eval.topics) {
        topics[topic] = (topics[topic] ?? 0) + 1;
      }
    }

    return EvaluationStatistics(
      totalEvaluations: total,
      averageMemorizationScore: avgMem,
      averageTajweedScore: avgTaj,
      averageOverallScore: avgOverall,
      excellentCount: excellent,
      goodCount: good,
      needsImprovementCount: needsImprovement,
      topicsFrequency: topics,
    );
  }
}