import '../models/tutor_model.dart';
import '../models/tutors_response_model.dart';
import 'package:easy_localization/easy_localization.dart';

class TutorsMockData {
  static List<TutorModel> get maleTutors => [
    TutorModel(
      id: '1',
      fullName: 'الشيخ أحمد محمد',
      gender: 'رجل',
      profilePictureUrl: 'assets/images/shaegh.jpg',
      overallRating: 4.9,
      numSessions: 150,
      isAvailable: true,
      bio:
          'حافظ لكتاب الله الكريم، خبرة 15 سنة في تحفيظ القرآن الكريم وتعليم التجويد',
      qualifications: [
        'إجازة في القراءات العشر',
        'دبلوم في علوم القرآن',
        'شهادة في التجويد',
      ],
      availabilitySlots: [
        AvailabilitySlot(day: 'السبت', start: '09:00', end: '12:00'),
        AvailabilitySlot(day: 'الأحد', start: '14:00', end: '17:00'),
        AvailabilitySlot(day: 'الاثنين', start: '09:00', end: '12:00'),
      ],
      contactMethods: ['واتساب', 'مكالمة صوتية'],
      reviews: [
        ReviewModel(
          reviewer: 'محمد علي',
          rating: 5.0,
          comment: 'معلم ممتاز، صبور ومتقن في التعليم',
          date: '2024-01-15',
        ),
        ReviewModel(
          reviewer: 'عبدالله أحمد',
          rating: 4.8,
          comment: 'استفدت كثيراً من دروسه في التجويد',
          date: '2024-01-10',
        ),
      ],
      sessionPrice: 120.0,
    ),
    TutorModel(
      id: '2',
      fullName: 'الشيخ عبدالرحمن سالم',
      gender: 'رجل',
      profilePictureUrl: 'assets/images/shaegh.jpg',
      overallRating: 4.7,
      numSessions: 120,
      isAvailable: true,
      bio: 'متخصص في تعليم القرآن الكريم للمبتدئين والمتقدمين',
      qualifications: [
        'إجازة في حفظ القرآن الكريم',
        'دبلوم في التربية الإسلامية',
      ],
      availabilitySlots: [
        AvailabilitySlot(day: 'الثلاثاء', start: '10:00', end: '13:00'),
        AvailabilitySlot(day: 'الأربعاء', start: '15:00', end: '18:00'),
      ],
      contactMethods: ['واتساب'],
      reviews: [
        ReviewModel(
          reviewer: 'يوسف محمد',
          rating: 4.7,
          comment: 'طريقة تعليم رائعة ومبسطة',
          date: '2024-01-12',
        ),
      ],
      sessionPrice: 100.0,
    ),
    TutorModel(
      id: '3',
      fullName: 'الشيخ خالد إبراهيم',
      gender: 'رجل',
      profilePictureUrl: 'assets/images/shaegh.jpg',
      overallRating: 4.5,
      numSessions: 80,
      isAvailable: false,
      bio: 'معلم قرآن كريم مع التركيز على الحفظ والمراجعة',
      qualifications: ['إجازة في القرآن الكريم', 'شهادة في أحكام التلاوة'],
      availabilitySlots: [],
      contactMethods: ['مكالمة صوتية'],
      reviews: [
        ReviewModel(
          reviewer: 'أحمد سعد',
          rating: 4.5,
          comment: 'معلم جيد ولكن أوقاته محدودة',
          date: '2024-01-08',
        ),
      ],
      sessionPrice: 90.0,
    ),
  ];

  static List<TutorModel> get femaleTutors => [
    TutorModel(
      id: '4',
      fullName: 'الأستاذة فاطمة أحمد',
      gender: 'امرأة',
      profilePictureUrl: 'assets/images/niqab-5.jpg',
      overallRating: 4.8,
      numSessions: 100,
      isAvailable: true,
      bio: 'معلمة قرآن كريم متخصصة في تعليم النساء والأطفال',
      qualifications: [
        'إجازة في القرآن الكريم',
        'دبلوم في التربية الإسلامية',
        'شهادة في تعليم الأطفال',
      ],
      availabilitySlots: [
        AvailabilitySlot(day: 'السبت', start: '16:00', end: '19:00'),
        AvailabilitySlot(day: 'الأحد', start: '10:00', end: '13:00'),
        AvailabilitySlot(day: 'الثلاثاء', start: '16:00', end: '19:00'),
      ],
      contactMethods: ['واتساب'],
      reviews: [
        ReviewModel(
          reviewer: 'عائشة محمد',
          rating: 4.9,
          comment: 'معلمة رائعة، صبورة ومتفهمة',
          date: '2024-01-14',
        ),
        ReviewModel(
          reviewer: 'زينب أحمد',
          rating: 4.7,
          comment: 'استفدت كثيراً من دروسها',
          date: '2024-01-11',
        ),
      ],
      sessionPrice: 110.0,
    ),
    TutorModel(
      id: '5',
      fullName: 'الأستاذة مريم سالم',
      gender: 'امرأة',
      profilePictureUrl: 'assets/images/niqab-5.jpg',
      overallRating: 4.6,
      numSessions: 75,
      isAvailable: true,
      bio: 'حافظة لكتاب الله، متخصصة في تحفيظ القرآن للسيدات',
      qualifications: ['إجازة في حفظ القرآن الكريم', 'شهادة في التجويد'],
      availabilitySlots: [
        AvailabilitySlot(day: 'الاثنين', start: '14:00', end: '17:00'),
        AvailabilitySlot(day: 'الأربعاء', start: '10:00', end: '13:00'),
      ],
      contactMethods: ['واتساب', 'مكالمة صوتية'],
      reviews: [
        ReviewModel(
          reviewer: 'خديجة علي',
          rating: 4.6,
          comment: 'معلمة متميزة في التحفيظ',
          date: '2024-01-09',
        ),
      ],
      sessionPrice: 95.0,
    ),
    TutorModel(
      id: '6',
      fullName: 'الأستاذة نور الهدى',
      gender: 'امرأة',
      profilePictureUrl: 'assets/images/niqab-5.jpg',
      overallRating: 4.4,
      numSessions: 60,
      isAvailable: false,
      bio: 'معلمة قرآن كريم مع خبرة في تعليم الأطفال',
      qualifications: ['إجازة في القرآن الكريم', 'دبلوم في تعليم الأطفال'],
      availabilitySlots: [],
      contactMethods: ['واتساب'],
      reviews: [
        ReviewModel(
          reviewer: 'أم محمد',
          rating: 4.4,
          comment: 'جيدة مع الأطفال ولكن أوقاتها قليلة',
          date: '2024-01-07',
        ),
      ],
      sessionPrice: 85.0,
    ),
  ];

  static TutorsResponseModel getTutorsByGender(String gender) {
    List<TutorModel> tutors;

    if (gender == 'رجل') {
      tutors = maleTutors;
    } else if (gender == 'امراة') {
      tutors = femaleTutors;
    } else {
      tutors = [...maleTutors, ...femaleTutors];
    }

    // ترتيب المحفظين حسب المعايير المطلوبة
    tutors.sort((a, b) {
      // أولاً: المتاحين أولاً
      if (a.isAvailable != b.isAvailable) {
        return b.isAvailable ? 1 : -1;
      }

      // ثانياً: حسب التقييم (تنازلي)
      if (a.overallRating != b.overallRating) {
        return b.overallRating.compareTo(a.overallRating);
      }

      // ثالثاً: أبجدياً
      return a.fullName.compareTo(b.fullName);
    });

    if (tutors.isEmpty) {
      return TutorsResponseModel(
        tutors: [],
        errorMessage: 'teachers_no_tutors_available'.tr(),
      );
    }

    return TutorsResponseModel(tutors: tutors);
  }

  static TutorModel? getTutorById(String id) {
    final allTutors = [...maleTutors, ...femaleTutors];
    try {
      return allTutors.firstWhere((tutor) => tutor.id == id);
    } catch (e) {
      return null;
    }
  }
}
