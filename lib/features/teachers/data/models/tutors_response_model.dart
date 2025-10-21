import 'tutor_model.dart';

class TutorsResponseModel {
  final List<TutorModel> tutors;
  final String? errorMessage;

  TutorsResponseModel({
    required this.tutors,
    this.errorMessage,
  });

  factory TutorsResponseModel.fromJson(Map<String, dynamic> json) {
    return TutorsResponseModel(
      tutors: (json['tutors'] as List<dynamic>?)
              ?.map((tutor) => TutorModel.fromJson(tutor))
              .toList() ??
          [],
      errorMessage: json['error_message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tutors': tutors.map((tutor) => tutor.toJson()).toList(),
      'error_message': errorMessage,
    };
  }

  TutorsResponseModel copyWith({
    List<TutorModel>? tutors,
    String? errorMessage,
  }) {
    return TutorsResponseModel(
      tutors: tutors ?? this.tutors,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
  bool get isEmpty => tutors.isEmpty;
  bool get isNotEmpty => tutors.isNotEmpty;
}