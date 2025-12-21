import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/competitions_repo.dart';
import 'competitions_state.dart';

class CompetitionsCubit extends Cubit<CompetitionsState> {
  final CompetitionsRepo _repo;

  CompetitionsCubit(this._repo) : super(CompetitionsInitial());

  Future<void> loadCurrentCompetition() async {
    emit(CompetitionsLoading());
    try {
      final competition = await _repo.getCurrentCompetition();
      emit(CompetitionsLoaded(competition));
    } catch (e) {
      emit(CompetitionsError(e.toString()));
    }
  }
}
