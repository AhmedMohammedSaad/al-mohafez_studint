enum SessionStatus {
  scheduled, // مجدولة
  inProgress, // جارية
  completed, // مكتملة
  cancelled, // ملغاة
  missed, // فائتة
}

enum SessionType {
  memorization, // حفظ
  review, // مراجعة
  evaluation, // تقييم
  general, // عامة
}

class Session {
  final String id;
  final String studentId;
  final String studentName;
  final DateTime scheduledDate;
  final Duration duration;
  final SessionType type;
  final SessionStatus status;
  final String? notes;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? topic; // الموضوع أو الجزء المدروس
  final bool isRecurring; // هل الجلسة متكررة
  final String? recurringPattern; // نمط التكرار (يومي، أسبوعي، إلخ)

  const Session({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.scheduledDate,
    required this.duration,
    this.type = SessionType.memorization,
    this.status = SessionStatus.scheduled,
    this.notes,
    this.startTime,
    this.endTime,
    this.topic,
    this.isRecurring = false,
    this.recurringPattern,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      scheduledDate: DateTime.parse(json['scheduled_date'] ?? DateTime.now().toIso8601String()),
      duration: Duration(minutes: json['duration_minutes'] ?? 60),
      type: SessionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => SessionType.memorization,
      ),
      status: SessionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => SessionStatus.scheduled,
      ),
      notes: json['notes'],
      startTime: json['start_time'] != null ? DateTime.parse(json['start_time']) : null,
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      topic: json['topic'],
      isRecurring: json['is_recurring'] ?? false,
      recurringPattern: json['recurring_pattern'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'scheduled_date': scheduledDate.toIso8601String(),
      'duration_minutes': duration.inMinutes,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'notes': notes,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'topic': topic,
      'is_recurring': isRecurring,
      'recurring_pattern': recurringPattern,
    };
  }

  Session copyWith({
    String? id,
    String? studentId,
    String? studentName,
    DateTime? scheduledDate,
    Duration? duration,
    SessionType? type,
    SessionStatus? status,
    String? notes,
    DateTime? startTime,
    DateTime? endTime,
    String? topic,
    bool? isRecurring,
    String? recurringPattern,
  }) {
    return Session(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      duration: duration ?? this.duration,
      type: type ?? this.type,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      topic: topic ?? this.topic,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPattern: recurringPattern ?? this.recurringPattern,
    );
  }

  // Helper methods
  bool get isToday {
    final now = DateTime.now();
    return scheduledDate.year == now.year &&
        scheduledDate.month == now.month &&
        scheduledDate.day == now.day;
  }

  bool get isUpcoming {
    return scheduledDate.isAfter(DateTime.now()) && status == SessionStatus.scheduled;
  }

  bool get isPast {
    return scheduledDate.isBefore(DateTime.now());
  }

  String get statusText {
    switch (status) {
      case SessionStatus.scheduled:
        return 'مجدولة';
      case SessionStatus.inProgress:
        return 'جارية';
      case SessionStatus.completed:
        return 'مكتملة';
      case SessionStatus.cancelled:
        return 'ملغاة';
      case SessionStatus.missed:
        return 'فائتة';
    }
  }

  String get typeText {
    switch (type) {
      case SessionType.memorization:
        return 'حفظ';
      case SessionType.review:
        return 'مراجعة';
      case SessionType.evaluation:
        return 'تقييم';
      case SessionType.general:
        return 'عامة';
    }
  }

  @override
  String toString() {
    return 'Session(id: $id, studentName: $studentName, date: $scheduledDate, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Session && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}