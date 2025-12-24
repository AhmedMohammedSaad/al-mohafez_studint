import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/progress_model.dart';
import '../../data/repos/progress_repo.dart';

part 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final ProgressRepo _progressRepo;

  ProgressCubit(this._progressRepo) : super(ProgressInitial());

  Future<void> loadProgressData() async {
    emit(ProgressLoading());
    try {
      final data = await _progressRepo.getStudentProgress();
      if (data.hasError) {
        emit(ProgressError(data.errorMessage ?? 'Unknown error occurred'));
      } else {
        emit(ProgressLoaded(data));
      }
    } catch (e) {
      emit(ProgressError(e.toString()));
    }
  }
}
