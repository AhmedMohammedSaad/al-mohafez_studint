class BookingRequestModel {
  final String teacherId;
  final String studentId;
  final DateTime selectedDate;
  final String selectedTimeSlot;
  final String studentName;
  final double sessionPrice;
  final String? notes;

  BookingRequestModel({
    required this.teacherId,
    required this.studentId,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.studentName,
    required this.sessionPrice,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'teacher_id': teacherId,
      'student_id': studentId,
      'selected_date': selectedDate.toIso8601String().split('T')[0],
      'selected_time_slot': selectedTimeSlot,
      'student_name': studentName,
      'session_price': sessionPrice,
      'notes': notes ?? '',
      'status': 'pending',
    };
  }
}
