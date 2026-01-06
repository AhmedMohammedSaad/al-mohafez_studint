import 'dart:developer';

import 'package:almohafez/almohafez/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:almohafez/almohafez/features/payment/presentation/cubit/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:almohafez/almohafez/features/profile/logic/profile_bloc.dart';
import 'package:almohafez/almohafez/features/profile/logic/profile_state.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.amount,
    required this.onPaymentSuccess,
  });
  final double amount;
  final Function() onPaymentSuccess;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final WebViewController _controller;
  bool _isWebPageLoading = true;
  getprofielPostData() async {
    final profileState = context.read<ProfileBloc>().state;
    String name = "Test User";
    String email = "test@example.com";
    String phone = "0123456789";

    if (profileState is ProfileLoaded) {
      final user = profileState.profile;
      name = "${user.firstName} ${user.lastName}";
      email = user.email;
      phone = user.phoneNumber ?? "0123456789";
    }

    await context.read<PaymentCubit>().processPayment(
      amount: widget.amount,
      name: name,
      email: email,
      phone: phone,
      address: "N/A", // Address is not available in ProfileModel
    );
  }

  @override
  void initState() {
    super.initState();
    getprofielPostData();

    // Get user data from ProfileBloc
    // Future.delayed(const Duration(seconds: 5), () {

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الدفع"), centerTitle: true),
      body: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          return BlocListener<PaymentCubit, PaymentState>(
            listener: (context, state) {
              if (state is PaymentInitiated) {
                _controller = WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onProgress: (int progress) {
                        // Update loading bar.
                      },
                      onPageStarted: (String url) {
                        if (mounted) {
                          setState(() {
                            _isWebPageLoading = true;
                          });
                        }
                      },
                      onPageFinished: (String url) {
                        if (mounted) {
                          setState(() {
                            _isWebPageLoading = false;
                          });
                        }
                      },
                      onHttpError: (HttpResponseError error) {
                        Fluttertoast.showToast(
                          msg: "حدث خطأ اعد المحاولة",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        Navigator.pop(context);
                      },
                      onNavigationRequest: (NavigationRequest request) {
                        if (request.url.startsWith(
                          "https://dev.fawaterk.com/success",
                        )) {
                          widget.onPaymentSuccess();
                          Fluttertoast.showToast(
                            msg: "      تم الدفع بنجاح      ",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          Navigator.pop(context);
                        } else if (request.url.startsWith(
                          "https://dev.fawaterk.com/fail",
                        )) {
                          Fluttertoast.showToast(
                            msg: "        فشل الدفع        ",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          Navigator.pop(context);
                        }
                        return NavigationDecision.navigate;
                      },
                    ),
                  )
                  ..setBackgroundColor(Colors.transparent)
                  ..loadRequest(Uri.parse(state.paymentUrl));
              }
            },
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Column(
                children: [
                  Text(
                    "الدفع عن طريق ماستركارد",
                    style: AppTextStyle.textStyle16Bold.copyWith(
                      color: AppColors.primaryBlueViolet,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: state is PaymentInitiated
                          ? Stack(
                              children: [
                                AnimatedOpacity(
                                  opacity: _isWebPageLoading ? 0.0 : 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: WebViewWidget(controller: _controller),
                                ),
                                if (_isWebPageLoading)
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: AppColors.primaryBlueViolet,
                                        ),
                                        SizedBox(height: 16.h),
                                        Text(
                                          "...جاري تحويلك لصفحة الدفع",
                                          style: AppTextStyle.textStyle14Medium
                                              .copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: AppColors.primaryBlueViolet,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    "...جاري الاتصال",
                                    style: AppTextStyle.textStyle14Medium
                                        .copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
