import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service to listen for new booking notifications in realtime
class BookingNotificationService {
  static final BookingNotificationService _instance =
      BookingNotificationService._internal();
  factory BookingNotificationService() => _instance;
  BookingNotificationService._internal();

  RealtimeChannel? _channel;
  final _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();

  /// Stream of new booking notifications
  Stream<Map<String, dynamic>> get onNewBooking =>
      _notificationController.stream;

  /// Initialize the realtime listener for the current teacher
  void initialize() {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      debugPrint('BookingNotificationService: User not logged in');
      return;
    }

    // Dispose existing channel if any
    dispose();

    // Subscribe to INSERT events on bookings table for this teacher
    _channel = supabase
        .channel('teacher_bookings_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'bookings',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'teacher_id',
            value: userId,
          ),
          callback: (payload) {
            debugPrint('New booking received: ${payload.newRecord}');
            _notificationController.add(payload.newRecord);
          },
        )
        .subscribe();

    debugPrint('BookingNotificationService: Listening for new bookings...');
  }

  /// Dispose the realtime channel
  void dispose() {
    _channel?.unsubscribe();
    _channel = null;
  }

  /// Show an in-app notification snackbar
  static void showNotification(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 5),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(message),
          ],
        ),
        backgroundColor: const Color(0xFF667EEA),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'حسناً',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
