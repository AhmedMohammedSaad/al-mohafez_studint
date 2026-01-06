class PaymentMethodsResponse {
  final String status;
  final VendorSettingsData vendorSettingsData;
  final List<PaymentMethod> data;

  PaymentMethodsResponse({
    required this.status,
    required this.vendorSettingsData,
    required this.data,
  });

  factory PaymentMethodsResponse.fromJson(Map<String, dynamic> json) {
    return PaymentMethodsResponse(
      status: json['status'],
      vendorSettingsData: VendorSettingsData.fromJson(
        json['vendorSettingsData'],
      ),
      data: List<PaymentMethod>.from(
        json['data'].map((e) => PaymentMethod.fromJson(e)),
      ),
    );
  }
}

class VendorSettingsData {
  final String? customeIframeTitle;

  VendorSettingsData({this.customeIframeTitle});

  factory VendorSettingsData.fromJson(Map<String, dynamic> json) {
    return VendorSettingsData(customeIframeTitle: json['custome_iframe_title']);
  }
}

class PaymentMethod {
  final int paymentId;
  final String nameEn;
  final String nameAr;
  final bool redirect;
  final String logo;

  PaymentMethod({
    required this.paymentId,
    required this.nameEn,
    required this.nameAr,
    required this.redirect,
    required this.logo,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      paymentId: json['paymentId'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
      redirect: json['redirect'] == "true",
      logo: json['logo'],
    );
  }
}
