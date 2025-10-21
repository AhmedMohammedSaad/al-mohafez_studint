class TutorModel {
  final String id;
  final String fullName;
  final String gender;
  final String profilePictureUrl;
  final double overallRating;
  final int numSessions;
  final bool isAvailable;
  final String bio;
  final List<String> qualifications;
  final List<AvailabilitySlot> availabilitySlots;
  final List<String> contactMethods;
  final List<ReviewModel> reviews;
  final double sessionPrice;

  TutorModel({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.profilePictureUrl,
    required this.overallRating,
    required this.numSessions,
    required this.isAvailable,
    required this.bio,
    required this.qualifications,
    required this.availabilitySlots,
    required this.contactMethods,
    required this.reviews,
    required this.sessionPrice,
  });

  factory TutorModel.fromJson(Map<String, dynamic> json) {
    return TutorModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      gender: json['gender'] ?? '',
      profilePictureUrl: json['profile_picture_url'] ?? '',
      overallRating: (json['overall_rating'] ?? 0.0).toDouble(),
      numSessions: json['num_sessions'] ?? 0,
      isAvailable: json['is_available'] ?? false,
      bio: json['bio'] ?? '',
      qualifications: List<String>.from(json['qualifications'] ?? []),
      availabilitySlots: (json['availability_slots'] as List<dynamic>?)
              ?.map((slot) => AvailabilitySlot.fromJson(slot))
              .toList() ??
          [],
      contactMethods: List<String>.from(json['contact_methods'] ?? []),
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((review) => ReviewModel.fromJson(review))
              .toList() ??
          [],
      sessionPrice: (json['session_price'] ?? 100.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'gender': gender,
      'profile_picture_url': profilePictureUrl,
      'overall_rating': overallRating,
      'num_sessions': numSessions,
      'is_available': isAvailable,
      'bio': bio,
      'qualifications': qualifications,
      'availability_slots': availabilitySlots.map((slot) => slot.toJson()).toList(),
      'contact_methods': contactMethods,
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'session_price': sessionPrice,
    };
  }

  TutorModel copyWith({
    String? id,
    String? fullName,
    String? gender,
    String? profilePictureUrl,
    double? overallRating,
    int? numSessions,
    bool? isAvailable,
    String? bio,
    List<String>? qualifications,
    List<AvailabilitySlot>? availabilitySlots,
    List<String>? contactMethods,
    List<ReviewModel>? reviews,
    double? sessionPrice,
  }) {
    return TutorModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      overallRating: overallRating ?? this.overallRating,
      numSessions: numSessions ?? this.numSessions,
      isAvailable: isAvailable ?? this.isAvailable,
      bio: bio ?? this.bio,
      qualifications: qualifications ?? this.qualifications,
      availabilitySlots: availabilitySlots ?? this.availabilitySlots,
      contactMethods: contactMethods ?? this.contactMethods,
      reviews: reviews ?? this.reviews,
      sessionPrice: sessionPrice ?? this.sessionPrice,
    );
  }
}

class AvailabilitySlot {
  final String day;
  final String start;
  final String end;

  AvailabilitySlot({
    required this.day,
    required this.start,
    required this.end,
  });

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlot(
      day: json['day'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'start': start,
      'end': end,
    };
  }
}

class ReviewModel {
  final String reviewer;
  final double rating;
  final String comment;
  final String date;

  ReviewModel({
    required this.reviewer,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewer: json['reviewer'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewer': reviewer,
      'rating': rating,
      'comment': comment,
      'date': date,
    };
  }
}