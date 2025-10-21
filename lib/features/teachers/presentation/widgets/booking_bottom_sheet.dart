import 'package:nb_utils/nb_utils.dart';

import '../views/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/tutor_model.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/booking_plan_model.dart';
import '../../data/models/booking_response_model.dart';
import '../../data/models/weekly_schedule_model.dart';
import '../../data/services/booking_service.dart';

class BookingBottomSheet extends StatefulWidget {
  final TutorModel tutor;

  const BookingBottomSheet({super.key, required this.tutor});

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  final _notesController = TextEditingController();

  BookingPlanModel? _selectedPlan;
  bool _isLoading = false;
  WeeklyScheduleModel? _weeklySchedule;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Set default plan to private
    _selectedPlan = BookingPlanModel.availablePlans.first;
    _loadWeeklySchedule();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(widget.tutor.profilePictureUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'booking_session_with'.tr(
                          namedArgs: {'name': widget.tutor.fullName},
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'booking_choose_plan'.tr(),
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          const Divider(height: 30),

          // Error Message
          if (_errorMessage != null) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red[600], fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan Selection
                  Text(
                    'booking_choose_plan_title'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPlanSelection(),

                  const SizedBox(height: 24),

                  // Weekly Schedule Selection
                  Row(
                    children: [
                      Text(
                        'booking_choose_days_times'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'booking_two_days_only'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'booking_schedule_description'.tr(),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  _buildWeeklySchedule(),

                  const SizedBox(height: 24),

                 // Notes
                  // Text(
                    // 'booking_notes_title'.tr(),
                    // style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  // ),
                  // const SizedBox(height: 8),
                  // TextFormField(
                    // controller: _notesController,
                    // maxLines: 3,
                    // decoration: InputDecoration(
                      // hintText: 'booking_notes_hint'.tr(),
                      // border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(12),
                      // ),
                      // prefixIcon: const Icon(Icons.note_add),
                    // ),
                  // ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // Book Button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E0FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'booking_confirm'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          50.height,
        ],
      ),
    );
  }

  Widget _buildPlanSelection() {
    return Column(
      children: BookingPlanModel.availablePlans.map((plan) {
        final isSelected = _selectedPlan?.type == plan.type;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedPlan = plan;
                _errorMessage = null;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF00E0FF).withOpacity(0.1)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF00E0FF)
                      : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? const Color(0xFF00E0FF)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF00E0FF)
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 12)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.localizedName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? const Color(0xFF00E0FF)
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          plan.localizedDescription,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${plan.sessionsPerWeek} ${'booking_sessions_weekly'.tr()} (${plan.totalSessionsPerMonth} ${'booking_sessions_monthly'.tr()})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeeklySchedule() {
    if (_weeklySchedule == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.schedule, color: Colors.grey[400], size: 32),
            const SizedBox(height: 8),
            Text(
              'booking_loading_schedule'.tr(),
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Selection Summary
        if (_weeklySchedule!.selectedSlots.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF00E0FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF00E0FF).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: const Color(0xFF00E0FF),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'booking_selected_times'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00E0FF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _weeklySchedule!.getSelectionSummary(),
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Days List
        ...(_weeklySchedule!.days.where((day) => day.hasAvailableSlots).map((
          day,
        ) {
          return _buildDaySchedule(day);
        }).toList()),
      ],
    );
  }

  Widget _buildDaySchedule(DaySchedule day) {
    final isDaySelected = _weeklySchedule!.isDaySelected(day.dayName);
    final selectedSlotsForDay =
        _weeklySchedule!.selectedSlots[day.dayName] ?? [];
    final canSelectDay = _weeklySchedule!.canSelectMoreDays || isDaySelected;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDaySelected
            ? const Color(0xFF00E0FF).withOpacity(0.05)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDaySelected
              ? const Color(0xFF00E0FF).withOpacity(0.3)
              : Colors.grey[300]!,
          width: isDaySelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDaySelected
                  ? const Color(0xFF00E0FF).withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: isDaySelected
                      ? const Color(0xFF00E0FF)
                      : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  day.dayName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDaySelected
                        ? const Color(0xFF00E0FF)
                        : Colors.black,
                  ),
                ),
                const Spacer(),
                if (selectedSlotsForDay.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E0FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${selectedSlotsForDay.length}/1',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Time Slots
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: day.timeSlots.map((timeSlot) {
                final isSlotSelected = _weeklySchedule!.isTimeSlotSelected(
                  day.dayName,
                  timeSlot,
                );
                final canSelectSlot =
                    canSelectDay &&
                    (_weeklySchedule!.canSelectMoreSlotsForDay(day.dayName) ||
                        isSlotSelected);

                return InkWell(
                  onTap: canSelectSlot
                      ? () {
                          setState(() {
                            _weeklySchedule = _weeklySchedule!.toggleTimeSlot(
                              day.dayName,
                              timeSlot,
                            );
                            _errorMessage = null;
                          });
                        }
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSlotSelected
                          ? const Color(0xFF00E0FF)
                          : canSelectSlot
                          ? Colors.white
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSlotSelected
                            ? const Color(0xFF00E0FF)
                            : canSelectSlot
                            ? Colors.grey[400]!
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      timeSlot,
                      style: TextStyle(
                        color: isSlotSelected
                            ? Colors.white
                            : canSelectSlot
                            ? Colors.black
                            : Colors.grey[500],
                        fontWeight: isSlotSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadWeeklySchedule() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate backend call to get weekly schedule
      await Future.delayed(const Duration(seconds: 1));

      // Load mock weekly schedule - in real app, this would come from backend
      setState(() {
        _weeklySchedule = WeeklyScheduleModel.createMockSchedule();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'booking_schedule_error'.tr();
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmBooking() async {
    // Validate selections
    if (_selectedPlan == null) {
      setState(() {
        _errorMessage = 'booking_error_select_plan'.tr();
      });
      return;
    }

    if (_weeklySchedule == null || !_weeklySchedule!.isValidSelection) {
      setState(() {
        _errorMessage = 'booking_error_select_schedule'.tr();
      });
      return;
    }

    // Validate minimum selection requirements
    if (_weeklySchedule!.selectedDays.isEmpty) {
      setState(() {
        _errorMessage = 'booking_error_select_day'.tr();
      });
      return;
    }

    // Check if each selected day has at least one time slot
    for (final day in _weeklySchedule!.selectedDays) {
      final slots = _weeklySchedule!.selectedSlots[day] ?? [];
      if (slots.isEmpty) {
        setState(() {
          _errorMessage = 'booking_error_select_time'.tr();
        });
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate backend validation
      await Future.delayed(const Duration(seconds: 1));

      // Create booking response model with selected schedule
      final bookingResponse = BookingResponseModel(
        selectedTime: DateTime.now()
            .add(const Duration(days: 1))
            .toIso8601String(),
        planPriceEgp: _selectedPlan!.priceEgp,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        error: null,
        transition: 'proceed_to_payment',
        planType: _selectedPlan!.type == PlanType.private
            ? PlanType.private
            : PlanType.group,
      );

      // Navigate to payment screen
      Navigator.of(context).pop(); // Close bottom sheet
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            bookingResponse: bookingResponse,
            tutorName: widget.tutor.fullName,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'booking_error_general'.tr();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
