import 'package:easy_localization/easy_localization.dart';

enum PlanType {
  private,
  group,
}

class BookingPlanModel {
  final PlanType type;
  final String nameAr;
  final String descriptionAr;
  final int priceEgp;
  final int sessionsPerWeek;
  final int totalSessionsPerMonth;

  const BookingPlanModel({
    required this.type,
    required this.nameAr,
    required this.descriptionAr,
    required this.priceEgp,
    required this.sessionsPerWeek,
    required this.totalSessionsPerMonth,
  });

  // Get localized name based on plan type
  String get localizedName {
    switch (type) {
      case PlanType.private:
        return 'booking_plan_private_name'.tr();
      case PlanType.group:
        return 'booking_plan_group_name'.tr();
    }
  }

  // Get localized description based on plan type
  String get localizedDescription {
    switch (type) {
      case PlanType.private:
        return 'booking_plan_private_description'.tr();
      case PlanType.group:
        return 'booking_plan_group_description'.tr();
    }
  }

  static const List<BookingPlanModel> availablePlans = [
    BookingPlanModel(
      type: PlanType.private,
      nameAr: 'الخطة الفردية',
      descriptionAr: 'جلسات خاصة مع الشيخ',
      priceEgp: 400,
      sessionsPerWeek: 2,
      totalSessionsPerMonth: 8,
    ),
    BookingPlanModel(
      type: PlanType.group,
      nameAr: 'الخطة الجماعية',
      descriptionAr: 'جلسات جماعية مع مجموعة',
      priceEgp: 250,
      sessionsPerWeek: 2,
      totalSessionsPerMonth: 8,
    ),
  ];

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'name_ar': nameAr,
      'description_ar': descriptionAr,
      'price_egp': priceEgp,
      'sessions_per_week': sessionsPerWeek,
      'total_sessions_per_month': totalSessionsPerMonth,
    };
  }

  factory BookingPlanModel.fromJson(Map<String, dynamic> json) {
    return BookingPlanModel(
      type: PlanType.values.firstWhere((e) => e.name == json['type']),
      nameAr: json['name_ar'],
      descriptionAr: json['description_ar'],
      priceEgp: json['price_egp'],
      sessionsPerWeek: json['sessions_per_week'],
      totalSessionsPerMonth: json['total_sessions_per_month'],
    );
  }
}