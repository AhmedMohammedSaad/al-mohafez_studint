import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../cubit/payment_state.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethodType selectedMethod;
  final ValueChanged<PaymentMethodType> onMethodSelected;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMethodCard(
          context,
          type: PaymentMethodType.creditCard,
          title: "payment_method_credit_card".tr(),
          icon: Icons.credit_card,
          isSelected: selectedMethod == PaymentMethodType.creditCard,
        ),
        const SizedBox(height: 12),
        _buildMethodCard(
          context,
          type: PaymentMethodType.mobileWallet,
          title: "payment_method_mobile_wallet_label".tr(),
          icon: Icons.phone_android,
          isSelected: selectedMethod == PaymentMethodType.mobileWallet,
        ),
      ],
    );
  }

  Widget _buildMethodCard(
    BuildContext context, {
    required PaymentMethodType type,
    required String title,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onMethodSelected(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlueViolet.withOpacity(0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBlueViolet
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryBlueViolet.withOpacity(0.1)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primaryBlueViolet : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.textStyle16Bold.copyWith(
                  color: isSelected
                      ? AppColors.primaryBlueViolet
                      : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primaryBlueViolet),
          ],
        ),
      ),
    );
  }
}
