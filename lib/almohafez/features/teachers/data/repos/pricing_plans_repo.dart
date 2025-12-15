import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pricing_plan_model.dart';

class PricingPlansRepo {
  final _supabase = Supabase.instance.client;

  /// Fetch all active pricing plans
  Future<List<PricingPlanModel>> getActivePlans() async {
    try {
      final response = await _supabase
          .from('pricing_plans')
          .select()
          .eq('is_active', true)
          .order('price_egp');

      return (response as List)
          .map((json) => PricingPlanModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch pricing plans: $e');
    }
  }

  /// Fetch a specific plan by type
  Future<PricingPlanModel?> getPlanByType(String planType) async {
    try {
      final response = await _supabase
          .from('pricing_plans')
          .select()
          .eq('plan_type', planType)
          .eq('is_active', true)
          .maybeSingle();

      if (response == null) return null;
      return PricingPlanModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch plan: $e');
    }
  }

  /// Fetch a plan by ID
  Future<PricingPlanModel?> getPlanById(String id) async {
    try {
      final response = await _supabase
          .from('pricing_plans')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return PricingPlanModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch plan: $e');
    }
  }
}
