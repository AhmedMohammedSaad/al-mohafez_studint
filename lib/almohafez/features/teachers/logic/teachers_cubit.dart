import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/teachers_repo.dart';
import 'teachers_state.dart';
import '../../../core/utils/supabase_error_handler.dart';

class TeachersCubit extends Cubit<TeachersState> {
  final TeachersRepo _teachersRepo;

  TeachersCubit(this._teachersRepo) : super(TeachersInitial());

  Future<void> fetchTeachers({String? gender}) async {
    emit(TeachersLoading());
    try {
      final teachers = await _teachersRepo.getTeachers(gender: gender);
      emit(TeachersLoaded(teachers));
    } catch (e) {
      emit(TeachersError(SupabaseErrorHandler.getErrorMessage(e)));
    }
  }
}
