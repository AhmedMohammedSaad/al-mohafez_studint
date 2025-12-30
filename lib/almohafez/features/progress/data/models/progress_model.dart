class DailyPerformance {
  final String date;
  final double percentage;
  final String dayName;

  DailyPerformance({
    required this.date,
    required this.percentage,
    required this.dayName,
  });

  factory DailyPerformance.fromJson(Map<String, dynamic> json) {
    return DailyPerformance(
      date: json['date'] ?? '',
      percentage: (json['percentage'] ?? 0).toDouble(),
      dayName: json['dayName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'percentage': percentage, 'dayName': dayName};
  }
}

class RecentSession {
  final String date;
  final String teacherName;
  final int rating;
  final int maxRating;

  RecentSession({
    required this.date,
    required this.teacherName,
    required this.rating,
    required this.maxRating,
  });

  factory RecentSession.fromJson(Map<String, dynamic> json) {
    return RecentSession(
      date: json['date'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      rating: json['rating'] ?? 0,
      maxRating: json['max_rating'] ?? 5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'teacher_name': teacherName,
      'rating': rating,
      'max_rating': maxRating,
    };
  }
}

class TeacherNote {
  final String note;
  final String? timestamp;

  TeacherNote({required this.note, this.timestamp});

  factory TeacherNote.fromJson(Map<String, dynamic> json) {
    return TeacherNote(note: json['note'] ?? '', timestamp: json['timestamp']);
  }

  Map<String, dynamic> toJson() {
    return {'note': note, 'timestamp': timestamp};
  }
}

class ProgressModel {
  final double overallProgress;
  final List<DailyPerformance> dailyPerformance;
  final List<RecentSession> recentSessions;
  final List<TeacherNote> teacherNotes;
  final List<RecentSession> allEvaluations;
  final bool hasError;
  final String? errorMessage;

  ProgressModel({
    required this.overallProgress,
    required this.dailyPerformance,
    required this.recentSessions,
    required this.teacherNotes,
    required this.allEvaluations,
    this.hasError = false,
    this.errorMessage,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      overallProgress: (json['overallProgress'] ?? 0).toDouble(),
      dailyPerformance:
          (json['dailyPerformance'] as List<dynamic>?)
              ?.map((item) => DailyPerformance.fromJson(item))
              .toList() ??
          [],
      recentSessions:
          (json['recentSessions'] as List<dynamic>?)
              ?.map((item) => RecentSession.fromJson(item))
              .toList() ??
          [],
      teacherNotes:
          (json['teacherNotes'] as List<dynamic>?)
              ?.map((item) => TeacherNote.fromJson(item))
              .toList() ??
          [],
      allEvaluations:
          (json['allEvaluations'] as List<dynamic>?)
              ?.map((item) => RecentSession.fromJson(item))
              .toList() ??
          [],
      hasError: json['hasError'] ?? false,
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overallProgress': overallProgress,
      'dailyPerformance': dailyPerformance
          .map((item) => item.toJson())
          .toList(),
      'recentSessions': recentSessions.map((item) => item.toJson()).toList(),
      'teacherNotes': teacherNotes.map((item) => item.toJson()).toList(),
      'allEvaluations': allEvaluations.map((item) => item.toJson()).toList(),
      'hasError': hasError,
      'errorMessage': errorMessage,
    };
  }

  bool get isEmpty =>
      dailyPerformance.isEmpty &&
      recentSessions.isEmpty &&
      teacherNotes.isEmpty &&
      allEvaluations.isEmpty;
}
