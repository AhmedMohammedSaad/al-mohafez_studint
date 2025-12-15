import 'package:flutter/material.dart';

/// نموذج البيانات لصفحة الـ Onboarding
class OnboardingModel {
  /// العنوان الرئيسي للصفحة
  final String title;

  /// العنوان الفرعي
  final String subtitle;

  /// الوصف التفصيلي
  final String description;

  /// مسار الصورة أو الأيقونة
  final String imagePath;

  /// لون خلفية الصفحة
  final Color backgroundColor;

  /// لون النص (اختياري)
  final Color? textColor;

  const OnboardingModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    this.textColor,
  });

  /// إنشاء نسخة من النموذج مع تعديل بعض الخصائص
  OnboardingModel copyWith({
    String? title,
    String? subtitle,
    String? description,
    String? imagePath,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return OnboardingModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
    );
  }

  /// تحويل النموذج إلى Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'imagePath': imagePath,
      'backgroundColor': backgroundColor.value,
      'textColor': textColor?.value,
    };
  }

  /// إنشاء النموذج من Map
  factory OnboardingModel.fromMap(Map<String, dynamic> map) {
    return OnboardingModel(
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      description: map['description'] ?? '',
      imagePath: map['imagePath'] ?? '',
      backgroundColor: Color(map['backgroundColor']),
      textColor: map['textColor'] != null ? Color(map['textColor']) : null,
    );
  }

  @override
  String toString() {
    return 'OnboardingModel(title: $title, subtitle: $subtitle, description: $description, imagePath: $imagePath, backgroundColor: $backgroundColor, textColor: $textColor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OnboardingModel &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.description == description &&
        other.imagePath == imagePath &&
        other.backgroundColor == backgroundColor &&
        other.textColor == textColor;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        subtitle.hashCode ^
        description.hashCode ^
        imagePath.hashCode ^
        backgroundColor.hashCode ^
        textColor.hashCode;
  }
}
