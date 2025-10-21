import '../models/booking_model.dart';

class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  // قائمة الحجوزات المحلية (في التطبيق الحقيقي ستكون من قاعدة البيانات)
  final List<BookingModel> _bookings = [];

  /// إنشاء حجز جديد
  Future<bool> createBooking(BookingModel booking) async {
    try {
      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(seconds: 2));
      
      // التحقق من عدم تضارب الأوقات
      bool hasConflict = _bookings.any((existingBooking) =>
          existingBooking.tutorId == booking.tutorId &&
          existingBooking.selectedDate == booking.selectedDate &&
          existingBooking.selectedTimeSlot == booking.selectedTimeSlot &&
          existingBooking.status != BookingStatus.cancelled);

      if (hasConflict) {
        return false; // يوجد تضارب في الأوقات
      }

      // إضافة الحجز
      _bookings.add(booking);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// الحصول على جميع الحجوزات
  List<BookingModel> getAllBookings() {
    return List.from(_bookings);
  }

  /// الحصول على حجوزات طالب معين
  List<BookingModel> getStudentBookings(String studentId) {
    return _bookings
        .where((booking) => booking.studentId == studentId)
        .toList();
  }

  /// الحصول على حجوزات محفظ معين
  List<BookingModel> getTutorBookings(String tutorId) {
    return _bookings
        .where((booking) => booking.tutorId == tutorId)
        .toList();
  }

  /// تحديث حالة الحجز
  Future<bool> updateBookingStatus(String bookingId, BookingStatus newStatus) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final bookingIndex = _bookings.indexWhere((booking) => booking.id == bookingId);
      if (bookingIndex != -1) {
        _bookings[bookingIndex] = _bookings[bookingIndex].copyWith(status: newStatus);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// إلغاء الحجز
  Future<bool> cancelBooking(String bookingId) async {
    return await updateBookingStatus(bookingId, BookingStatus.cancelled);
  }

  /// التحقق من توفر الوقت
  bool isTimeSlotAvailable(String tutorId, String date, String timeSlot) {
    return !_bookings.any((booking) =>
        booking.tutorId == tutorId &&
        booking.selectedDate == date &&
        booking.selectedTimeSlot == timeSlot &&
        booking.status != BookingStatus.cancelled);
  }

  /// الحصول على الأوقات المتاحة لمحفظ في تاريخ معين
  List<String> getAvailableTimeSlots(String tutorId, String date, List<String> allTimeSlots) {
    return allTimeSlots.where((timeSlot) => 
        isTimeSlotAvailable(tutorId, date, timeSlot)).toList();
  }

  /// حذف حجز
  Future<bool> deleteBooking(String bookingId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      final bookingIndex = _bookings.indexWhere((booking) => booking.id == bookingId);
      if (bookingIndex != -1) {
        _bookings.removeAt(bookingIndex);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// الحصول على إحصائيات الحجوزات
  Map<String, int> getBookingStatistics() {
    return {
      'total': _bookings.length,
      'confirmed': _bookings.where((b) => b.status == BookingStatus.confirmed).length,
      'pending': _bookings.where((b) => b.status == BookingStatus.pending).length,
      'completed': _bookings.where((b) => b.status == BookingStatus.completed).length,
      'cancelled': _bookings.where((b) => b.status == BookingStatus.cancelled).length,
    };
  }
}