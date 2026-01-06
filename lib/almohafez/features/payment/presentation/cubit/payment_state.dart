import 'package:equatable/equatable.dart';

enum PaymentMethodType { creditCard, mobileWallet }

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentMethodChanged extends PaymentState {
  final PaymentMethodType method;

  const PaymentMethodChanged(this.method);

  @override
  List<Object> get props => [method];
}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  // final String url;

  const PaymentSuccess();

  @override
  List<Object> get props => [];
}

class PaymentFailure extends PaymentState {
  final String message;

  const PaymentFailure(this.message);

  @override
  List<Object> get props => [message];
}

// ignore: must_be_immutable
class PaymentInitiated extends PaymentState {
  String paymentUrl;

  PaymentInitiated(this.paymentUrl);

  @override
  List<Object> get props => [paymentUrl];
}
