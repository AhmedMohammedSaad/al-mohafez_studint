import 'booking_plan_model.dart';

class BookingResponseModel {
  final List<Map<String, dynamic>>?
  selectedSchedules; // New field for multiple slots
  final String? selectedTime;
  final PlanType planType;
  final int planPriceEgp;
  final String? notes;
  final String? error;
  final String? transition;

  const BookingResponseModel({
    this.selectedSchedules,
    this.selectedTime,
    required this.planType,
    required this.planPriceEgp,
    this.notes,
    this.error,
    this.transition,
  });

  Map<String, dynamic> toJson() {
    return {
      'selected_schedules': selectedSchedules,
      'selected_time': selectedTime,
      'plan_type': planType.name,
      'plan_price_egp': planPriceEgp,
      'notes': notes,
      'error': error,
      'transition': transition,
    };
  }

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingResponseModel(
      selectedSchedules: (json['selected_schedules'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      selectedTime: json['selected_time'],
      planType: PlanType.values.firstWhere((e) => e.name == json['plan_type']),
      planPriceEgp: json['plan_price_egp'],
      notes: json['notes'],
      error: json['error'],
      transition: json['transition'],
    );
  }

  BookingResponseModel copyWith({
    List<Map<String, dynamic>>? selectedSchedules,
    String? selectedTime,
    PlanType? planType,
    int? planPriceEgp,
    String? notes,
    String? error,
    String? transition,
  }) {
    return BookingResponseModel(
      selectedSchedules: selectedSchedules ?? this.selectedSchedules,
      selectedTime: selectedTime ?? this.selectedTime,
      planType: planType ?? this.planType,
      planPriceEgp: planPriceEgp ?? this.planPriceEgp,
      notes: notes ?? this.notes,
      error: error ?? this.error,
      transition: transition ?? this.transition,
    );
  }
}
