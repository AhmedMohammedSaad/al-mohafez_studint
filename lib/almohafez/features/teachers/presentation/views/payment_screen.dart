import 'package:almohafez/almohafez/core/presentation/view/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/booking_response_model.dart';
import '../../data/models/booking_request_model.dart';
import '../../logic/booking_cubit.dart';
import '../../logic/booking_state.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
// Import the new feature
import 'package:almohafez/almohafez/features/payment/presentation/screens/payment_screen.dart'
    as feature;

class PaymentScreen extends StatefulWidget {
  final BookingResponseModel bookingResponse;
  final String tutorName;
  final String tutorId;
  final String? selectedSchedule;
  final DateTime? selectedDate;

  const PaymentScreen({
    super.key,
    required this.bookingResponse,
    required this.tutorName,
    required this.tutorId,
    this.selectedSchedule,
    this.selectedDate,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingCreated) {
          _showPaymentSuccessDialog();
        } else if (state is BookingError) {
          Fluttertoast.showToast(
            msg: state.message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryError,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      child: feature.PaymentScreen(
        amount: widget.bookingResponse.planPriceEgp.toDouble(),
        onPaymentSuccess: () {
          _processBooking();
        },
      ),
    );
  }

  Future<void> _processBooking() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      Fluttertoast.showToast(
        msg: 'error_login_required'.tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryError,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    final userId = user.id;

    // Fetch user name from metadata or use fallback
    final studentName =
        user.userMetadata?['full_name'] as String? ??
        user.userMetadata?['name'] as String? ??
        'Unknown Student';

    if (widget.bookingResponse.selectedSchedules != null &&
        widget.bookingResponse.selectedSchedules!.isNotEmpty) {
      final requests = widget.bookingResponse.selectedSchedules!.map((
        schedule,
      ) {
        return BookingRequestModel(
          teacherId: widget.tutorId,
          studentId: userId,
          selectedDate: DateTime.parse(schedule['date']),
          selectedTimeSlot: schedule['time'],
          studentName: studentName,
          sessionPrice: widget.bookingResponse.planPriceEgp.toDouble(),
          notes: widget.bookingResponse.notes,
        );
      }).toList();

      context.read<BookingCubit>().createBatchBookings(requests);
    } else {
      // Fallback for single selection
      final request = BookingRequestModel(
        teacherId: widget.tutorId,
        studentId: userId,
        selectedDate: widget.selectedDate ?? DateTime.now(),
        selectedTimeSlot: widget.selectedSchedule ?? '',
        studentName: studentName,
        sessionPrice: widget.bookingResponse.planPriceEgp.toDouble(),
        notes: widget.bookingResponse.notes,
      );

      context.read<BookingCubit>().createBooking(request);
    }
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.green[600], size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                'payment_success_title'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'payment_success_message'.tr(
                  namedArgs: {'tutorName': widget.tutorName},
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppDefaultButton(
                  colors: AppColors.primary,
                  backgroundColor: AppColors.primary,
                  buttonText: 'payment_return_home'.tr(),
                  ontap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
