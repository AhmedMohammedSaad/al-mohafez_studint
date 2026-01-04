import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/presentation/view/widgets/simple_appbar.dart';
import '../../../../core/presentation/view/widgets/main_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/visa_payment_form.dart';
import '../widgets/mobile_wallet_form.dart';
import '../../../../core/presentation/view/widgets/app_default_text_form_field.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final Function(String transactionId) onPaymentSuccess;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Forms Controllers
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _walletNumberController = TextEditingController();
  final _promoCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    _walletNumberController.dispose();
    _promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentCubit(),
      child: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            widget.onPaymentSuccess(state.transactionId);
          } else if (state is PaymentFailure) {
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 4,
              backgroundColor: AppColors.primaryError,
              textColor: AppColors.primaryWhite,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<PaymentCubit>();
          // Default to credit card if state is initial
          PaymentMethodType currentMethod = PaymentMethodType.creditCard;
          if (state is PaymentMethodChanged) {
            currentMethod = state.method;
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppSimpleAppBar(
              title: "payment_page_title".tr(),
            ), // Using Core SimpleAppBar
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Amount Display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlueViolet.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "payment_total_amount_text".tr(),
                              style: AppTextStyle.textStyle14Regular.copyWith(
                                color: AppColors.primaryBlueViolet,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${widget.amount} ${"egyptianPounds".tr()}",
                              style: AppTextStyle.textStyle24Bold.copyWith(
                                color: AppColors.primaryBlueViolet,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Method Selector
                      Text(
                        "payment_method".tr(), // using existing key
                        style: AppTextStyle.textStyle18Bold,
                      ),
                      const SizedBox(height: 16),
                      PaymentMethodSelector(
                        selectedMethod: currentMethod,
                        onMethodSelected: cubit.changePaymentMethod,
                      ),
                      const SizedBox(height: 32),

                      // Payment Form
                      Text(
                        currentMethod == PaymentMethodType.creditCard
                            ? "payment_card_details_title".tr()
                            : "payment_wallet_details_title".tr(),
                        style: AppTextStyle.textStyle18Bold,
                      ),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: currentMethod == PaymentMethodType.creditCard
                            ? VisaPaymentForm(
                                cardNumberController: _cardNumberController,
                                expiryDateController: _expiryDateController,
                                cvvController: _cvvController,
                                cardHolderController: _cardHolderController,
                              )
                            : MobileWalletForm(
                                controller: _walletNumberController,
                              ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "payment_promo_code_label".tr(),
                        style: AppTextStyle.textStyle16Bold,
                      ),
                      const SizedBox(height: 8),
                      AppDefaultTextFormField(
                        borderColor: AppColors.primaryTurquoise,
                        controller: _promoCodeController,
                        hint: "payment_promo_code_hint".tr(),
                        type: TextInputType.text,
                        validate: (value) => null, // Optional
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      AppDefaultButton(
                        width: double.infinity,
                        colors: AppColors.primaryTurquoise,
                        buttonText: "payment_confirm_action".tr(),
                        ontap: () {
                          if (_formKey.currentState!.validate()) {
                            cubit.processPayment(
                              amount: widget.amount,
                              cardDetails:
                                  currentMethod == PaymentMethodType.creditCard
                                  ? {
                                      'number': _cardNumberController.text,
                                      'expiry': _expiryDateController.text,
                                      'cvv': _cvvController.text,
                                      'holder': _cardHolderController.text,
                                    }
                                  : null,
                              walletNumber:
                                  currentMethod ==
                                      PaymentMethodType.mobileWallet
                                  ? _walletNumberController.text
                                  : null,
                              couponCode: _promoCodeController.text.isNotEmpty
                                  ? _promoCodeController.text
                                  : null,
                            );
                          }
                        },
                        isLoading: state is PaymentLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
