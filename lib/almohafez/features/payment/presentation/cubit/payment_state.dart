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
  final String transactionId;

  const PaymentSuccess(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}

class PaymentFailure extends PaymentState {
  final String message;

  const PaymentFailure(this.message);

  @override
  List<Object> get props => [message];
}
