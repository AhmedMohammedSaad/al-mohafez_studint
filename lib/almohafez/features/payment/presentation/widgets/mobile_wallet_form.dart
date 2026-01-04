import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/presentation/view/widgets/app_default_text_form_field.dart';

class MobileWalletForm extends StatelessWidget {
  final TextEditingController controller;

  const MobileWalletForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDefaultTextFormField(
          controller: controller,
          label: "payment_wallet_number_label".tr(),
          hint: "payment_wallet_number_hint".tr(),
          type: TextInputType.phone,
          prefixIcon: const PrefixIconData(icon: Icons.phone_android),
          validate: (value) {
            if (value == null || value.isEmpty || value.length < 11) {
              return "payment_error_invalid_wallet_number".tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
