import 'dart:async';
import 'package:almohafez/almohafez_teacher/core/services/booking_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Widget that listens to new booking notifications and shows alerts
class BookingNotificationListener extends StatefulWidget {
  final Widget child;

  const BookingNotificationListener({super.key, required this.child});

  @override
  State<BookingNotificationListener> createState() =>
      _BookingNotificationListenerState();
}

class _BookingNotificationListenerState
    extends State<BookingNotificationListener> {
  late final BookingNotificationService _service;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  @override
  void initState() {
    super.initState();
    _service = BookingNotificationService();
    _service.initialize();

    // Listen for new bookings
    _subscription = _service.onNewBooking.listen((booking) {
      _showNewBookingNotification(booking);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _service.dispose();
    super.dispose();
  }

  void _showNewBookingNotification(Map<String, dynamic> booking) {
    if (!mounted) return;

    final studentName = booking['student_name'] ?? 'طالب جديد';
    final selectedDate = booking['selected_date'];
    final timeSlot = booking['selected_time_slot'] ?? '';

    String dateFormatted = '';
    if (selectedDate != null) {
      try {
        final date = DateTime.parse(selectedDate);
        dateFormatted = DateFormat('dd/MM/yyyy', 'ar').format(date);
      } catch (_) {
        dateFormatted = selectedDate.toString();
      }
    }

    final message = timeSlot.isNotEmpty
        ? '📅 $dateFormatted\n⏰ $timeSlot'
        : '📅 $dateFormatted';

    BookingNotificationService.showNotification(
      context,
      title: '🎉 حجز جديد من $studentName',
      message: message,
      duration: const Duration(seconds: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
