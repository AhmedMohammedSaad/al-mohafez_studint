import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/presentation/view/widgets/app_default_text_form_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class VisaPaymentForm extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController expiryDateController;
  final TextEditingController cvvController;
  final TextEditingController cardHolderController;

  const VisaPaymentForm({
    super.key,
    required this.cardNumberController,
    required this.expiryDateController,
    required this.cvvController,
    required this.cardHolderController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Visual Card
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [AppColors.primaryBlueViolet, Color(0xFF6A11CB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlueViolet.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Credit Card",
                    style: AppTextStyle.textStyle14Medium.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const Icon(Icons.credit_card, color: Colors.white),
                ],
              ),
              const SizedBox(height: 20),
              ListenableBuilder(
                listenable: cardNumberController,
                builder: (context, _) {
                  return Text(
                    cardNumberController.text.isEmpty
                        ? "**** **** **** ****"
                        : cardNumberController.text,
                    style: AppTextStyle.textStyle24Bold.copyWith(
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Card Holder",
                        style: AppTextStyle.textStyle12Regular.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      ListenableBuilder(
                        listenable: cardHolderController,
                        builder: (context, _) {
                          return Text(
                            cardHolderController.text.isEmpty
                                ? "YOUR NAME"
                                : cardHolderController.text.toUpperCase(),
                            style: AppTextStyle.textStyle14Bold.copyWith(
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Expires",
                        style: AppTextStyle.textStyle12Regular.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      ListenableBuilder(
                        listenable: expiryDateController,
                        builder: (context, _) {
                          return Text(
                            expiryDateController.text.isEmpty
                                ? "MM/YY"
                                : expiryDateController.text,
                            style: AppTextStyle.textStyle14Bold.copyWith(
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Card Number
        AppDefaultTextFormField(
          controller: cardNumberController,
          label: "cardNumber".tr(),
          hint: "enterCardNumber".tr(),
          type: TextInputType.number,
          validate: (value) {
            if (value == null || value.isEmpty || value.length < 16) {
              return "invalidCardNumber".tr();
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppDefaultTextFormField(
                controller: expiryDateController,
                label: "expiryDate".tr(),
                hint: "MM/YY",
                type: TextInputType.datetime,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return "invalidDate".tr();
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppDefaultTextFormField(
                controller: cvvController,
                label: "cvv".tr(),
                hint: "123",
                type: TextInputType.number,
                validate: (value) {
                  if (value == null || value.isEmpty || value.length < 3) {
                    return "invalidCVV".tr();
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppDefaultTextFormField(
          controller: cardHolderController,
          label: "cardholderName".tr(),
          hint: "enterCardholderName".tr(), // Using existing key
          type: TextInputType.name,
          validate: (value) {
            if (value == null || value.isEmpty) {
              return "payment_error_empty_holder_name".tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
