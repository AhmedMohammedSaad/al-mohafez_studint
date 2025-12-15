class BookingModel {
  final String id;
  final String teacherId;
  final String studentId;
  final String studentName;
  final DateTime selectedDate;
  final String selectedTimeSlot;
  final String notes;
  final String? meetingUrl;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double sessionPrice;

  const BookingModel({
    required this.id,
    required this.teacherId,
    required this.studentId,
    required this.studentName,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.notes,
    this.meetingUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.sessionPrice,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      teacherId: json['teacher_id'] as String,
      studentId: json['student_id'] as String,
      studentName: json['student_name'] as String,
      selectedDate: DateTime.parse(json['selected_date'] as String),
      selectedTimeSlot: json['selected_time_slot'] as String,
      notes: json['notes'] as String? ?? '',
      meetingUrl: json['meeting_url'] as String?,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      sessionPrice: (json['session_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'student_id': studentId,
      'student_name': studentName,
      'selected_date': selectedDate.toIso8601String().split('T')[0],
      'selected_time_slot': selectedTimeSlot,
      'notes': notes,
      'meeting_url': meetingUrl,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'session_price': sessionPrice,
    };
  }

  BookingModel copyWith({
    String? id,
    String? teacherId,
    String? studentId,
    String? studentName,
    DateTime? selectedDate,
    String? selectedTimeSlot,
    String? notes,
    String? meetingUrl,
    BookingStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? sessionPrice,
  }) {
    return BookingModel(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      notes: notes ?? this.notes,
      meetingUrl: meetingUrl ?? this.meetingUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sessionPrice: sessionPrice ?? this.sessionPrice,
    );
  }
}

enum BookingStatus {
  pending, // في انتظار الموافقة
  confirmed, // مؤكد
  cancelled, // ملغي
  completed, // مكتمل
  rejected, // مرفوض
}

extension BookingStatusExtension on BookingStatus {
  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'في انتظار الموافقة';
      case BookingStatus.confirmed:
        return 'مؤكد';
      case BookingStatus.cancelled:
        return 'ملغي';
      case BookingStatus.completed:
        return 'مكتمل';
      case BookingStatus.rejected:
        return 'مرفوض';
    }
  }

  String get color {
    switch (this) {
      case BookingStatus.pending:
        return '#FFB800'; // أصفر
      case BookingStatus.confirmed:
        return '#00E0FF'; // أزرق
      case BookingStatus.cancelled:
        return '#FF4444'; // أحمر
      case BookingStatus.completed:
        return '#4CAF50'; // أخضر
      case BookingStatus.rejected:
        return '#FF4444'; // أحمر
    }
  }
}
