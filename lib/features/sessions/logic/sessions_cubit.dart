import 'package:flutter_bloc/flutter_bloc.dart';
import 'sessions_state.dart';
import '../data/repos/sessions_repo.dart';
import '../data/models/session_model.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final SessionsRepo _sessionsRepo;

  SessionsCubit(this._sessionsRepo) : super(SessionsInitial());

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
      emit(SessionsError(e.toString()));
    }
  }
}
