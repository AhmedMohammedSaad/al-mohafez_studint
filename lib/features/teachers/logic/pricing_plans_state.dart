import '../data/models/pricing_plan_model.dart';

abstract class PricingPlansState {}

class PricingPlansInitial extends PricingPlansState {}

class PricingPlansLoading extends PricingPlansState {}

class PricingPlansLoaded extends PricingPlansState {
  final List<PricingPlanModel> plans;

  PricingPlansLoaded(this.plans);
}

class PricingPlansError extends PricingPlansState {
  final String message;

  PricingPlansError(this.message);
}
