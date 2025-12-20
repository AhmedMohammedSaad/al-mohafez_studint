import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/sessions_repo.dart';

import 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final SessionsRepo _repo;

  SessionsCubit(this._repo) : super(SessionsInitial());

  Future<void> loadSessions() async {
    emit(SessionsLoading());
    try {
      final sessions = await _repo.getSessions();
      emit(SessionsLoaded(sessions));
    } catch (e) {
      emit(SessionsError(e.toString()));
    }
  }

  Future<void> startSession(String sessionId, String meetingUrl) async {
    try {
      await _repo.updateMeetingUrl(sessionId, meetingUrl);
      // Reload sessions to reflect changes
      await loadSessions();
    } catch (e) {
      emit(SessionsError(e.toString()));
    }
  }
}
