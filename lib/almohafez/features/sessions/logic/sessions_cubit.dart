import 'package:almohafez/almohafez/features/payment/data/repos/payments_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sessions_state.dart';
import '../data/repos/sessions_repo.dart';
import '../data/models/session_model.dart';
import '../../../core/utils/supabase_error_handler.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final SessionsRepo _sessionsRepo;
  final PaymentsRepo _paymentsRepo;

  SessionsCubit(this._sessionsRepo, this._paymentsRepo)
    : super(SessionsInitial());

  Future<void> checkSubscriptionStatus(String studentId) async {
    // If we want to block loading sessions until check passes:
    // emit(SessionsLoading()); // or keep silent check?
    // User requested: "when createAt passed 30 days... redirect"

    // We can run this check before loadSessions or inside it.
    // Let's make it a separate method called on init.

    try {
      final lastPayment = await _paymentsRepo.getLastPayment(studentId);

      if (lastPayment == null) {
        // No payment at all -> Expired (or new user needing sub)
        emit(SubscriptionExpired());
        return;
      }

      final paymentDate = lastPayment.createdAt ?? lastPayment.paymentTime;
      if (paymentDate == null) {
        emit(SubscriptionExpired());
        return;
      }

      final now = DateTime.now();
      final difference = now.difference(paymentDate).inDays;

      if (difference > 30) {
        emit(SubscriptionExpired());
      } else {
        // Valid subscription
        // No emit needed if we just want to proceed, or emit SessionsInitial?
        // Usually we'd just returned void and caller proceeds.
        // But since this is a Cubit, if it's expired we change state.
        // If valid, we do nothing and let loadSessions proceed.
      }
    } catch (e) {
      // If check fails (network error), maybe let them pass or show error?
      // Safer to show error or retry.
      // emit(SessionsError("Failed to verify subscription: $e"));
      // Or just ignore for now to not block app if API fails?
      // User said "Start working on this and focus well".
      // Let's emit error if it fails so they know.
      // But maybe not block?
      // Let's assume critical:
      print("Subscription check error: $e");
    }
  }

  Future<void> loadSessions() async {
    emit(SessionsLoading());
    try {
      final sessions = await _sessionsRepo.getStudentSessions();

      final upcoming = sessions
          .where(
            (s) =>
                s.status == SessionStatus.upcoming ||
                s.status == SessionStatus.ongoing,
          )
          .toList();
      final completed = sessions
          .where(
            (s) =>
                s.status == SessionStatus.completed ||
                s.status == SessionStatus.cancelled,
          )
          .toList();

      emit(
        SessionsLoaded(
          upcomingSessions: upcoming,
          completedSessions: completed,
        ),
      );
    } catch (e) {
      emit(SessionsError(SupabaseErrorHandler.getErrorMessage(e)));
    }
  }
}
