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
  final String? meetingUrl;
  final String? notes;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? topic;
  final bool isRecurring;
  final String? recurringPattern;
  final String? timeSlot; // e.g. "00:41 - 01:41"

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
    this.meetingUrl,
    this.timeSlot,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      scheduledDate: DateTime.parse(
        json['selected_date'] ?? DateTime.now().toIso8601String(),
      ),
      duration: const Duration(minutes: 60), // Default or fetch if available
      type: SessionType.memorization, // Default as not in bookings
      status: SessionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => SessionStatus.scheduled,
      ),
      notes: json['notes'],
      // Logic for start time can be improved if selected_time_slot format is known
      startTime: null,
      endTime: null,
      topic: null, // Not in bookings
      isRecurring: false,
      recurringPattern: null,
      meetingUrl: json['meeting_url'],
      timeSlot: json['selected_time_slot'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'selected_date': scheduledDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'notes': notes,
      'meeting_url': meetingUrl,
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
    String? meetingUrl,
    String? timeSlot,
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
      meetingUrl: meetingUrl ?? this.meetingUrl,
      timeSlot: timeSlot ?? this.timeSlot,
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
    return scheduledDate.isAfter(DateTime.now()) &&
        status == SessionStatus.scheduled;
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
