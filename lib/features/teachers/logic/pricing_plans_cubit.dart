import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/pricing_plans_repo.dart';
import 'pricing_plans_state.dart';

class PricingPlansCubit extends Cubit<PricingPlansState> {
  final PricingPlansRepo _repo;

  PricingPlansCubit(this._repo) : super(PricingPlansInitial());

  Future<void> loadActivePlans() async {
    emit(PricingPlansLoading());
    try {
      final plans = await _repo.getActivePlans();
      emit(PricingPlansLoaded(plans));
    } catch (e) {
      emit(PricingPlansError(e.toString()));
    }
  }

  Future<void> loadPlanByType(String planType) async {
    emit(PricingPlansLoading());
    try {
      final plan = await _repo.getPlanByType(planType);
      if (plan != null) {
        emit(PricingPlansLoaded([plan]));
      } else {
        emit(PricingPlansError('Plan not found'));
      }
    } catch (e) {
      emit(PricingPlansError(e.toString()));
    }
  }
}
