import 'package:easy_localization/easy_localization.dart';

import '../almohafez/core/utils/app_strings.dart';

enum ValidationType {
  none,
  email,
  text,
  phone,
  emailAndPhone,
  password,
  confirmPassword,
  birthDate,
  name,
  price,
  refrence,
  age,
}

class AppTextFieldValidation {
  static final RegExp emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  static final RegExp regexPhone = RegExp(r'^01[0125][0-9]{8}$');

  static bool isValidBirthdate(DateTime birthdate) {
    final DateTime currentDate = DateTime.now();
    final DateTime minBirthdate = currentDate.subtract(
      const Duration(days: 365 * 100),
    );
    final DateTime maxBirthdate = currentDate;
    return birthdate.isAfter(minBirthdate) && birthdate.isBefore(maxBirthdate);
  }

  static bool isContainSpecialCharacters(String input) {
    for (int i = 0; i < input.length; ++i) {
      final int ascii = input.codeUnitAt(i);
      if ((ascii >= 65 && ascii <= 90) ||
          (ascii >= 97 && ascii <= 122) ||
          ascii == 32) {
        continue;
      }
      return true;
    }
    return false;
  }

  static bool isContainNumbers(String input) {
    for (int i = 0; i < input.length; ++i) {
      final int ascii = input.codeUnitAt(i);
      if ((ascii >= 48 && ascii <= 57)) return true;
    }
    return false;
  }

  static String? isRequired(String val, String fieldName) {
    if (val.trim().isEmpty) {
      return 'requiredError'.tr(namedArgs: {'fieldName': fieldName.tr()});
    }
    return null;
  }

  static String? checkPasswordLength(String val) {
    if (val.length < 6) {
      return AppStrings.passLenError;
    }
    return null;
  }

  static String? checkFieldValidation({
    required String? val,
    required String fieldName,
    required ValidationType fieldType,
    String? confirmPass,
  }) {
    String? errorMsg;

    if (fieldType == ValidationType.text) {
      errorMsg = isRequired(val!, fieldName);
    }

    if (fieldType == ValidationType.name) {
      if (isRequired(val!, fieldName) != null) {
        errorMsg = isRequired(val, fieldName);
      } else if (isContainNumbers(val)) {
        errorMsg = AppStrings.digitText;
      } else if (isContainSpecialCharacters(val)) {
        errorMsg = AppStrings.specialText;
      }
    }

    if (fieldType == ValidationType.birthDate) {
      if (isRequired(val!, fieldName) != null) {
        errorMsg = isRequired(val, fieldName);
      } else {
        final DateTime? parsedDate = DateTime.tryParse(val);
        if (parsedDate == null) {
          errorMsg = AppStrings.dateError;
        } else if (!isValidBirthdate(parsedDate)) {
          errorMsg = AppStrings.birthDateError;
        }
      }
    }

    if (fieldType == ValidationType.age) {
      if (val == null || val.isEmpty) {
        errorMsg = AppStrings.requiredError;
      } else if (!RegExp(r'^\d+$').hasMatch(val)) {
        errorMsg = AppStrings.ageError;
      } else if (int.tryParse(val) == null) {
        errorMsg = AppStrings.ageError;
      }
    }

    if (fieldType == ValidationType.email) {
      if (isRequired(val!, fieldName) != null) {
        errorMsg = isRequired(val, fieldName);
      } else if (!emailRegex.hasMatch(val)) {
        errorMsg = AppStrings.emailError;
      }
    }

    if (fieldType == ValidationType.emailAndPhone) {
      if (isRequired(val!, fieldName) != null) {
        errorMsg = isRequired(val, fieldName);
      } else if (num.tryParse(val) is num) {
        if (val.length != 11 || !regexPhone.hasMatch(val)) {
          errorMsg = AppStrings.phoneNotMatch;
        }
      } else if (!emailRegex.hasMatch(val)) {
        errorMsg = AppStrings.emailError;
      }
    }

    if (fieldType == ValidationType.password) {
      if (isRequired(val!, fieldName) != null) {
        errorMsg = isRequired(val, fieldName);
      } else {
        errorMsg = checkPasswordLength(val);
      }
    }

    if (fieldType == ValidationType.confirmPassword) {
      if (isRequired(val!, fieldName) != null) {
        errorMsg = isRequired(val, fieldName);
      } else if (checkPasswordLength(val) != null) {
        errorMsg = checkPasswordLength(val);
      } else if (val != confirmPass) {
        errorMsg = AppStrings.passNotMatch;
      }
    }

    if (fieldType == ValidationType.price) {
      if (isRequired(val!, fieldName) != null) {
        errorMsg = isRequired(val, fieldName);
      } else if (double.tryParse(val) == null || double.parse(val) < 0) {
        errorMsg = AppStrings.priceError;
      }
    }

    if (fieldType == ValidationType.phone) {
      if (isRequired(val!, fieldName) != null) {
        errorMsg = isRequired(val, fieldName);
      } else if (val.length != 11 || !regexPhone.hasMatch(val)) {
        errorMsg = AppStrings.phoneError;
      }
    }

    if (fieldType == ValidationType.refrence) {
      if (isRequired(val!, fieldName) != null) {
        errorMsg = isRequired(val, fieldName);
      } else if (val.length < 8) {
        errorMsg = AppStrings.referenceError;
      }
    }

    return errorMsg;
  }
}
