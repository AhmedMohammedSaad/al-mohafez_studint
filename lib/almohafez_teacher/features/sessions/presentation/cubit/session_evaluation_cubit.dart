import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/session_evaluation_model.dart';
import '../../data/repositories/session_evaluations_repo.dart';
import 'session_evaluation_state.dart';

class SessionEvaluationCubit extends Cubit<SessionEvaluationState> {
  final SessionEvaluationsRepo _repo;

  SessionEvaluationCubit(this._repo) : super(SessionEvaluationInitial());

  Future<void> loadEvaluation(String sessionId) async {
    emit(SessionEvaluationLoading());
    try {
      final evaluation = await _repo.getSessionEvaluation(sessionId);
      emit(SessionEvaluationLoaded(evaluation));
    } catch (e) {
      emit(SessionEvaluationError(e.toString()));
    }
  }

  Future<void> saveEvaluation(SessionEvaluation evaluation) async {
    emit(SessionEvaluationSaving());
    try {
      final success = await _repo.saveEvaluation(evaluation);
      if (success) {
        emit(SessionEvaluationSaved());
      } else {
        emit(SessionEvaluationError('Failed to save evaluation'));
      }
    } catch (e) {
      emit(SessionEvaluationError(e.toString()));
    }
  }
}
