class PaymentRecordModel {
  final String? id;

  final String studentId;
  final double amount;
  final String currency;
  final String status;
  final String paymentMethod;
  final String? transactionId;
  final Map<String, dynamic>? paymentDetails;
  final DateTime? createdAt;
  final DateTime? paymentTime;
  final DateTime? expiredDate;
  final String? notes;

  PaymentRecordModel({
    this.id,

    required this.studentId,
    required this.amount,
    this.currency = 'EGP',
    this.status = 'pending',
    required this.paymentMethod,
    this.transactionId,
    this.paymentDetails,
    this.createdAt,
    this.paymentTime,
    this.expiredDate,
    this.notes,
  });

  factory PaymentRecordModel.fromJson(Map<String, dynamic> json) {
    // Extract details from the JSONB column or use empty map
    final details = json['payment_details'] as Map<String, dynamic>? ?? {};

    return PaymentRecordModel(
      id: json['id'],

      studentId: json['student_id'],
      amount: (json['amount'] as num).toDouble(),
      transactionId: json['transaction_id'],

      // Extract fields from payment_details JSONB
      currency: details['currency'] ?? 'EGP',
      status: details['status'] ?? 'pending',
      paymentMethod: details['payment_method'] ?? 'unknown',
      notes: details['notes'],
      paymentDetails: details, // Store the whole map
      // Timestamps
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      paymentTime: details['payment_time'] != null
          ? DateTime.parse(details['payment_time'])
          : null,
      expiredDate: json['expired_date'] != null
          ? DateTime.parse(json['expired_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    // 1. Prepare the JSONB content
    final Map<String, dynamic> details = Map<String, dynamic>.from(
      paymentDetails ?? {},
    );

    // Add fields that don't have their own columns in the DB
    details['currency'] = currency;
    details['status'] = status;
    details['payment_method'] = paymentMethod;
    if (notes != null) details['notes'] = notes;
    if (paymentTime != null)
      details['payment_time'] = paymentTime!.toIso8601String();

    // 2. Prepare the top-level DB row
    final Map<String, dynamic> data = {
      'student_id': studentId,
      'amount': amount,
      'transaction_id': transactionId,
      'payment_details': details, // Insert as JSONB
    };

    if (expiredDate != null) {
      data['expired_date'] = expiredDate!.toIso8601String();
    }

    // 'created_at' and 'id' are auto-generated
    return data;
  }
}
