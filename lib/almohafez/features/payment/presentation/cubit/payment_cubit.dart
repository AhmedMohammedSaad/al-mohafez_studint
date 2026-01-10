import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:almohafez/almohafez/core/data/network/web_service/api_service.dart';
import 'package:almohafez/almohafez/core/utils/app_consts.dart';
import '../../data/models/payment_record_model.dart';
import '../../data/repos/payments_repo.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  PaymentMethodType _selectedMethod = PaymentMethodType.creditCard;
  final AppDio appDio = AppDio();

  void changePaymentMethod(PaymentMethodType method) {
    _selectedMethod = method;
    emit(PaymentMethodChanged(_selectedMethod));
  }

  Future<void> processPayment({
    String? couponCode,
    required double amount,
    Map<String, dynamic>? cardDetails,
    String? walletNumber,
    String? name,
    String? email,
    String? phone,
    String? address,
  }) async {
    emit(PaymentLoading());
    try {
      final response = await appDio.post(
        path: AppConst.apiUrlPostPayment,
        data: {
          "payment_method_id": 2, // 2 for Credit Card Fawaterek
          "cartTotal": amount,
          "currency": "EGP",
          "customer": {
            "first_name": name,
            "last_name": "",
            "email": email,
            "phone": phone,
            "address": address,
          },
          "redirectionUrls": {
            "successUrl": "https://dev.fawaterk.com/success",
            "failUrl": "https://dev.fawaterk.com/fail",
            "pendingUrl": "https://dev.fawaterk.com/pending",
          },
          "cartItems": [
            {"name": name, "price": amount, "quantity": "1"},
          ],
        },
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConst.accessToken}',
        },
      );

      final paymentUrl = response.data["data"]["payment_data"]["redirectTo"];
      emit(PaymentInitiated(paymentUrl));
    } catch (e) {
      emit(PaymentFailure("حدث خطأ اثناء معالجة الدفع: $e"));
    }
  }

  Future<void> savePaymentRecord(PaymentRecordModel paymentRecord) async {
    emit(PaymentLoading());
    try {
      final paymentsRepo = PaymentsRepoImpl(Supabase.instance.client);
      await paymentsRepo.savePaymentRecord(paymentRecord);
      emit(PaymentRecordSaved());
    } catch (e) {
      emit(PaymentFailure("فشل في حفظ سجل الدفع: $e"));
    }
  }
}
