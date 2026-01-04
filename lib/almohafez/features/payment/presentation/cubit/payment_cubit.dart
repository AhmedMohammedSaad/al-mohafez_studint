import 'package:almohafez/almohafez/core/data/network/web_service/api_service.dart';
import 'package:almohafez/almohafez/core/utils/app_consts.dart';
import 'package:almohafez/almohafez/core/utils/urls.dart';
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
  }) async {
    emit(PaymentLoading());
    try {
      if (_selectedMethod == PaymentMethodType.creditCard &&
          cardDetails == null) {
        emit(const PaymentFailure("Invalid Card Details"));
        return;
      }
      if (_selectedMethod == PaymentMethodType.mobileWallet &&
          (walletNumber == null || walletNumber.isEmpty)) {
        emit(const PaymentFailure("Invalid Wallet Number"));
        return;
      }

      final response = await appDio.post(
        path: AppConst.apiUrlPayment,
        data: {
          "amount": amount,
          "couponCode": couponCode,
          "paymentMethod": _selectedMethod.name,
        },
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConst.accessToken}',
        },
      );
      emit(const PaymentSuccess("TRANS_MOCK_123456"));
    } catch (e) {
      emit(PaymentFailure("حدث خطأ اثناء معالجة الدفع"));
    }
  }
}
