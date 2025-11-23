class PricingPlanModel {
  final String id;
  final String planType; // 'private' or 'group'
  final String nameAr;
  final String? nameEn;
  final String descriptionAr;
  final String? descriptionEn;
  final double priceEgp;
  final int sessionsPerWeek;
  final int totalSessionsPerMonth;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  PricingPlanModel({
    required this.id,
    required this.planType,
    required this.nameAr,
    this.nameEn,
    required this.descriptionAr,
    this.descriptionEn,
    required this.priceEgp,
    required this.sessionsPerWeek,
    required this.totalSessionsPerMonth,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PricingPlanModel.fromJson(Map<String, dynamic> json) {
    return PricingPlanModel(
      id: json['id'] ?? '',
      planType: json['plan_type'] ?? '',
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'],
      descriptionAr: json['description_ar'] ?? '',
      descriptionEn: json['description_en'],
      priceEgp: (json['price_egp'] ?? 0).toDouble(),
      sessionsPerWeek: json['sessions_per_week'] ?? 0,
      totalSessionsPerMonth: json['total_sessions_per_month'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_type': planType,
      'name_ar': nameAr,
      'name_en': nameEn,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'price_egp': priceEgp,
      'sessions_per_week': sessionsPerWeek,
      'total_sessions_per_month': totalSessionsPerMonth,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  PricingPlanModel copyWith({
    String? id,
    String? planType,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? descriptionEn,
    double? priceEgp,
    int? sessionsPerWeek,
    int? totalSessionsPerMonth,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PricingPlanModel(
      id: id ?? this.id,
      planType: planType ?? this.planType,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      priceEgp: priceEgp ?? this.priceEgp,
      sessionsPerWeek: sessionsPerWeek ?? this.sessionsPerWeek,
      totalSessionsPerMonth:
          totalSessionsPerMonth ?? this.totalSessionsPerMonth,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
