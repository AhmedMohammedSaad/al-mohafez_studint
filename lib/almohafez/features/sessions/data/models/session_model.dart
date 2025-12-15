enum SessionStatus {
  upcoming,
  ongoing,
  completed,
  cancelled,
}

enum SessionType {
  recitation, // تلاوة
  review, // مراجعة
  tajweed, // تجويد
  memorization, // حفظ
}

enum SessionMode {
  online,
  inPerson, // حضوري
}

class SessionModel {
  final String id;
  final String tutorId;
  final String tutorName;
  final String tutorImageUrl;
  final String studentId;
  final SessionType type;
  final SessionMode mode;
  final DateTime scheduledDateTime;
  final int durationMinutes;
  final SessionStatus status;
  final String? meetingUrl;
  final String? notes;
  final String? tutorNotes;
  final double? rating;
  final String? feedback;
  final DateTime? actualStartTime;
  final DateTime? actualEndTime;
  final bool notificationSent;
  final int? countdownSeconds;

  SessionModel({
    required this.id,
    required this.tutorId,
    required this.tutorName,
    required this.tutorImageUrl,
    required this.studentId,
    required this.type,
    required this.mode,
    required this.scheduledDateTime,
    required this.durationMinutes,
    required this.status,
    this.meetingUrl,
    this.notes,
    this.tutorNotes,
    this.rating,
    this.feedback,
    this.actualStartTime,
    this.actualEndTime,
    this.notificationSent = false,
    this.countdownSeconds,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] ?? '',
      tutorId: json['tutor_id'] ?? '',
      tutorName: json['tutor_name'] ?? '',
      tutorImageUrl: json['tutor_image_url'] ?? '',
      studentId: json['student_id'] ?? '',
      type: SessionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SessionType.recitation,
      ),
      mode: SessionMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => SessionMode.online,
      ),
      scheduledDateTime: DateTime.parse(json['scheduled_date_time']),
      durationMinutes: json['duration_minutes'] ?? 45,
      status: SessionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SessionStatus.upcoming,
      ),
      meetingUrl: json['meeting_url'],
      notes: json['notes'],
      tutorNotes: json['tutor_notes'],
      rating: json['rating']?.toDouble(),
      feedback: json['feedback'],
      actualStartTime: json['actual_start_time'] != null
          ? DateTime.parse(json['actual_start_time'])
          : null,
      actualEndTime: json['actual_end_time'] != null
          ? DateTime.parse(json['actual_end_time'])
          : null,
      notificationSent: json['notification_sent'] ?? false,
      countdownSeconds: json['countdown_seconds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tutor_id': tutorId,
      'tutor_name': tutorName,
      'tutor_image_url': tutorImageUrl,
      'student_id': studentId,
      'type': type.name,
      'mode': mode.name,
      'scheduled_date_time': scheduledDateTime.toIso8601String(),
      'duration_minutes': durationMinutes,
      'status': status.name,
      'meeting_url': meetingUrl,
      'notes': notes,
      'tutor_notes': tutorNotes,
      'rating': rating,
      'feedback': feedback,
      'actual_start_time': actualStartTime?.toIso8601String(),
      'actual_end_time': actualEndTime?.toIso8601String(),
      'notification_sent': notificationSent,
      'countdown_seconds': countdownSeconds,
    };
  }

  // Helper methods for business logic
  bool get isUpcoming => status == SessionStatus.upcoming;
  bool get isOngoing => status == SessionStatus.ongoing;
  bool get isCompleted => status == SessionStatus.completed;
  bool get isCancelled => status == SessionStatus.cancelled;

  bool get canJoin {
    final now = DateTime.now();
    final sessionStart = scheduledDateTime;
    final sessionEnd = scheduledDateTime.add(Duration(minutes: durationMinutes));
    
    return now.isAfter(sessionStart.subtract(Duration(minutes: 10))) &&
           now.isBefore(sessionEnd) &&
           status == SessionStatus.upcoming;
  }

  bool get shouldShowCountdown {
    final now = DateTime.now();
    final timeDifference = scheduledDateTime.difference(now);
    return timeDifference.inMinutes <= 10 && timeDifference.inMinutes > 0;
  }

  int get remainingMinutes {
    final now = DateTime.now();
    final timeDifference = scheduledDateTime.difference(now);
    return timeDifference.inMinutes;
  }

  String get typeDisplayName {
    switch (type) {
      case SessionType.recitation:
        return 'تلاوة';
      case SessionType.review:
        return 'مراجعة';
      case SessionType.tajweed:
        return 'تجويد';
      case SessionType.memorization:
        return 'حفظ';
    }
  }

  String get modeDisplayName {
    switch (mode) {
      case SessionMode.online:
        return 'أونلاين';
      case SessionMode.inPerson:
        return 'حضوري';
    }
  }

  SessionModel copyWith({
    String? id,
    String? tutorId,
    String? tutorName,
    String? tutorImageUrl,
    String? studentId,
    SessionType? type,
    SessionMode? mode,
    DateTime? scheduledDateTime,
    int? durationMinutes,
    SessionStatus? status,
    String? meetingUrl,
    String? notes,
    String? tutorNotes,
    double? rating,
    String? feedback,
    DateTime? actualStartTime,
    DateTime? actualEndTime,
    bool? notificationSent,
    int? countdownSeconds,
  }) {
    return SessionModel(
      id: id ?? this.id,
      tutorId: tutorId ?? this.tutorId,
      tutorName: tutorName ?? this.tutorName,
      tutorImageUrl: tutorImageUrl ?? this.tutorImageUrl,
      studentId: studentId ?? this.studentId,
      type: type ?? this.type,
      mode: mode ?? this.mode,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      meetingUrl: meetingUrl ?? this.meetingUrl,
      notes: notes ?? this.notes,
      tutorNotes: tutorNotes ?? this.tutorNotes,
      rating: rating ?? this.rating,
      feedback: feedback ?? this.feedback,
      actualStartTime: actualStartTime ?? this.actualStartTime,
      actualEndTime: actualEndTime ?? this.actualEndTime,
      notificationSent: notificationSent ?? this.notificationSent,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
    );
  }
}