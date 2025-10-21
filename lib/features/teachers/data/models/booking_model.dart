class BookingModel {
  final String id;
  final String tutorId;
  final String studentId;
  final String studentName;
  final String studentPhone;
  final DateTime selectedDate;
  final String selectedTimeSlot;
  final String sessionType; // 'online' or 'offline'
  final String notes;
  final BookingStatus status;
  final DateTime createdAt;
  final double sessionPrice;

  const BookingModel({
    required this.id,
    required this.tutorId,
    required this.studentId,
    required this.studentName,
    required this.studentPhone,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.sessionType,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.sessionPrice,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      tutorId: json['tutor_id'] as String,
      studentId: json['student_id'] as String,
      studentName: json['student_name'] as String,
      studentPhone: json['student_phone'] as String,
      selectedDate: DateTime.parse(json['selected_date'] as String),
      selectedTimeSlot: json['selected_time_slot'] as String,
      sessionType: json['session_type'] as String,
      notes: json['notes'] as String,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      sessionPrice: (json['session_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tutor_id': tutorId,
      'student_id': studentId,
      'student_name': studentName,
      'student_phone': studentPhone,
      'selected_date': selectedDate.toIso8601String(),
      'selected_time_slot': selectedTimeSlot,
      'session_type': sessionType,
      'notes': notes,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'session_price': sessionPrice,
    };
  }

  BookingModel copyWith({
    String? id,
    String? tutorId,
    String? studentId,
    String? studentName,
    String? studentPhone,
    DateTime? selectedDate,
    String? selectedTimeSlot,
    String? sessionType,
    String? notes,
    BookingStatus? status,
    DateTime? createdAt,
    double? sessionPrice,
  }) {
    return BookingModel(
      id: id ?? this.id,
      tutorId: tutorId ?? this.tutorId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentPhone: studentPhone ?? this.studentPhone,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      sessionType: sessionType ?? this.sessionType,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      sessionPrice: sessionPrice ?? this.sessionPrice,
    );
  }
}

enum BookingStatus {
  pending,    // في انتظار الموافقة
  confirmed,  // مؤكد
  cancelled,  // ملغي
  completed,  // مكتمل
  rejected,   // مرفوض
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