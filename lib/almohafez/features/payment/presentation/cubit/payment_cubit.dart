import 'package:almohafez/almohafez/core/data/network/web_service/api_service.dart';
import 'package:almohafez/almohafez/core/utils/app_consts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          "payment_method_id": 2,

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
      // Assuming the API returns the URL in this structure
      // Adjust based on actual API response if needed
      final paymentUrl = response.data["data"]["payment_data"]["redirectTo"];
      emit(PaymentInitiated(paymentUrl));
    } catch (e) {
      emit(PaymentFailure("حدث خطأ اثناء معالجة الدفع"));
    }
  }
}
