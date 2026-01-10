import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/payment_record_model.dart';

abstract class PaymentsRepo {
  Future<void> savePaymentRecord(PaymentRecordModel payment);
  Future<PaymentRecordModel?> getLastPayment(String studentId);
}

class PaymentsRepoImpl implements PaymentsRepo {
  final SupabaseClient supabaseClient;

  PaymentsRepoImpl(this.supabaseClient);

  @override
  Future<void> savePaymentRecord(PaymentRecordModel payment) async {
    try {
      await supabaseClient.from('payment_records').insert(payment.toJson());
      log("_______   saved  payment record ____________");
    } catch (e) {
      log("_______   failed to save  payment record ____________ $e");
      throw Exception('Failed to save payment record: $e');
    }
  }

  @override
  Future<PaymentRecordModel?> getLastPayment(String studentId) async {
    try {
      final response = await supabaseClient
          .from('payment_records')
          .select()
          .eq('student_id', studentId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return PaymentRecordModel.fromJson(response);
    } catch (e) {
      // If error occurs (e.g. valid connection but query error), rethrow or return null.
      // Returning null treats as no payment -> expired, which is safer for security.
      // But logging would be good.
      log('Error fetching last payment: $e');
      return null;
    }
  }
}
