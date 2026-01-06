import 'package:nb_utils/nb_utils.dart';

import '../views/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/tutor_model.dart';
import '../../data/models/booking_plan_model.dart';
import '../../data/models/pricing_plan_model.dart';
import '../../data/models/booking_response_model.dart';
import '../../data/models/weekly_schedule_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/booking_cubit.dart';
import '../../logic/pricing_plans_cubit.dart';
import '../../logic/pricing_plans_state.dart';
import '../../data/repos/bookings_repo.dart';

class BookingBottomSheet extends StatefulWidget {
  final TutorModel tutor;

  const BookingBottomSheet({super.key, required this.tutor});

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  final _notesController = TextEditingController();

  PricingPlanModel? _selectedPlan;
  bool _isLoading = false;
  WeeklyScheduleModel? _weeklySchedule;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Load pricing plans from database
    context.read<PricingPlansCubit>().loadActivePlans();
    //! pymint get cards
    context.read<PricingPlansCubit>().getCardPymint();
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
                  child: ClipOval(
                    child: widget.tutor.profilePictureUrl.isNotEmpty
                        ? Image.network(
                            widget.tutor.profilePictureUrl,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                                  'assets/images/placeholder.png', // Ensure this asset exists or use a generic icon fallback
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  ),
                                ),
                          )
                        : const Icon(Icons.person, color: Colors.grey),
                  ),
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
                      // Explicit name display
                      Text(
                        widget.tutor.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00E0FF),
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
          70.height,
        ],
      ),
    );
  }

  Widget _buildPlanSelection() {
    return BlocBuilder<PricingPlansCubit, PricingPlansState>(
      builder: (context, state) {
        if (state is PricingPlansLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PricingPlansError) {
          return Text(state.message, style: const TextStyle(color: Colors.red));
        }

        if (state is PricingPlansLoaded) {
          final plans = state.plans;

          // Set default plan if none selected
          if (_selectedPlan == null && plans.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _selectedPlan = plans.first;
                });
              }
            });
          }

          return Column(
            children: plans.map((plan) {
              final isSelected = _selectedPlan?.id == plan.id;
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
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan.nameAr,
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
                                plan.descriptionAr,
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
                              const SizedBox(height: 4),
                              Text(
                                '${plan.priceEgp.toInt()} EGP',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00E0FF),
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

        return const SizedBox.shrink();
      },
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
                            ? Colors.grey[300]! // Lighter grey for available
                            : Colors
                                  .red[100]!, // Should actually disable interaction if not selectable, but here it's about day limit
                      ),
                    ),
                    child: Text(
                      _formatSlotForDisplay(timeSlot),
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
      // Fetch existing bookings for this teacher
      final bookingsRepo = BookingsRepo();
      final existingBookings = await bookingsRepo.getTeacherBookings(
        widget.tutor.id,
      );

      final daysMap = <String, List<String>>{};

      // Initialize all days with English keys
      final weekDays = [
        'Saturday',
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
      ];
      final weekDaysAr = [
        'السبت',
        'الأحد',
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
      ];

      for (var day in weekDays) {
        daysMap[day] = [];
      }

      // Map for normalizing input day names to English keys
      final dayNameMap = <String, String>{};
      for (int i = 0; i < weekDays.length; i++) {
        dayNameMap[weekDays[i]] = weekDays[i]; // English -> English
        dayNameMap[weekDays[i].toLowerCase()] =
            weekDays[i]; // lowercase -> English
        dayNameMap[weekDaysAr[i]] = weekDays[i]; // Arabic -> English
      }

      // Populate slots from tutor availability
      for (var slot in widget.tutor.availabilitySlots) {
        final normalizedDay =
            dayNameMap[slot.day] ?? dayNameMap[slot.day.trim()];

        if (normalizedDay != null && daysMap.containsKey(normalizedDay)) {
          // DIRECT SLOT USAGE: No generation loop.
          // We assume slot.start and slot.end are already 35-min restricted (or whatever the teacher set).
          // We use the 24h format "HH:mm - HH:mm" for internal consistency and storage.
          final slotString = '${slot.start} - ${slot.end}';

          // Get the actual date for this instance of the day
          final dateForDay = getNextDateForDay(normalizedDay);

          // Check if this specific slot is blocked
          final isBlocked = _isSlotBlocked(
            dateForDay,
            slotString,
            existingBookings,
          );

          if (!isBlocked) {
            daysMap[normalizedDay]!.add(slotString);
          }
        } else {
          print('Warning: Could not map day "${slot.day}" to a valid day.');
        }
      }

      final days = List<DaySchedule>.generate(weekDays.length, (index) {
        final dayEn = weekDays[index];
        final dayAr = weekDaysAr[index];
        final slots = daysMap[dayEn] ?? [];

        return DaySchedule(
          dayName: dayAr,
          dayNameEn: dayEn,
          isAvailable: slots.isNotEmpty,
          timeSlots: slots,
        );
      });

      setState(() {
        _weeklySchedule = WeeklyScheduleModel(
          days: days,
          maxDaysAllowed: 2,
          maxSlotsPerDay: 1,
        );
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading schedule: $e');
      setState(() {
        _errorMessage = 'booking_schedule_error'.tr();
        _isLoading = false;
      });
    }
  }

  // Robust check for slot blocking
  bool _isSlotBlocked(
    DateTime dateForDay,
    String timeSlot,
    List<dynamic> existingBookings,
  ) {
    // Helper to normalize date to YYYY-MM-DD string to avoid timezone issues
    String formatDate(DateTime dt) {
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    }

    final targetDateStr = formatDate(dateForDay);

    // Parse the candidate slot start time
    final parts = timeSlot.split(' - ');
    if (parts.isEmpty) return false;

    final slotStartTime = _parseTime(parts[0]);
    if (slotStartTime == null) return false;

    for (var booking in existingBookings) {
      final bookingDateStr = formatDate(booking.selectedDate.toLocal());
      if (bookingDateStr != targetDateStr) continue;

      final bookingSlotStr = booking.selectedTimeSlot.toString();
      // Handle "HH:mm - HH:mm" or simple "HH:mm"
      final bookingParts = bookingSlotStr.contains('-')
          ? bookingSlotStr.split('-')
          : [bookingSlotStr]; // explicit start time

      final bookingStartTime = _parseTime(bookingParts[0]);

      if (bookingStartTime != null &&
          bookingStartTime.hour == slotStartTime.hour &&
          bookingStartTime.minute == slotStartTime.minute) {
        return true;
      }
    }

    return false;
  }

  // Robust time parser helper
  TimeOfDay? _parseTime(String input) {
    input = input.trim().toLowerCase();
    // Normalize Arabic digits to English digits
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < arabicDigits.length; i++) {
      input = input.replaceAll(arabicDigits[i], englishDigits[i]);
    }

    // Normalize input: remove spaces around colon
    input = input.replaceAll(RegExp(r'\s+(?=[:])|(?<=[:])\s+'), '');

    bool isPm = input.contains('pm') || input.contains('م');
    bool isAm = input.contains('am') || input.contains('ص');

    // Remove non-time characters
    String raw = input.replaceAll(RegExp(r'[^0-9:]'), '');

    List<String> parts = raw.split(':');
    int hour = 0;
    int minute = 0;

    try {
      if (parts.isNotEmpty && parts[0].isNotEmpty) {
        hour = int.parse(parts[0]);
      }
      if (parts.length > 1 && parts[1].isNotEmpty) {
        minute = int.parse(parts[1]);
      }
    } catch (e) {
      return null;
    }

    if (isPm && hour < 12) hour += 12;
    if (isAm && hour == 12) hour = 0;

    if (hour > 23 || minute > 59) return null;

    return TimeOfDay(hour: hour, minute: minute);
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

    if (_weeklySchedule == null || !_weeklySchedule!.isValidSelection) {
      setState(() {
        _errorMessage = 'booking_select_time_error'.tr();
      });
      return;
    }

    // Find the selected slot and date
    DateTime? selectedDate;
    String? selectedTimeSlot;
    List<Map<String, dynamic>> selectedSchedules = [];

    // Iterate over the selectedSlots map from the model
    if (_weeklySchedule!.selectedSlots.isNotEmpty) {
      _weeklySchedule!.selectedSlots.forEach((dayName, slots) {
        if (slots.isNotEmpty) {
          final daySchedule = _weeklySchedule!.days.firstWhere(
            (d) => d.dayName == dayName,
            orElse: () => _weeklySchedule!.days.first, // Fallback
          );

          final date = getNextDateForDay(daySchedule.dayNameEn);

          for (var slot in slots) {
            selectedSchedules.add({
              'date': date.toIso8601String(),
              'time': slot,
            });
          }
        }
      });

      // Set primary selection for backward compatibility / display if needed
      if (selectedSchedules.isNotEmpty) {
        selectedDate = DateTime.parse(selectedSchedules.first['date']);
        selectedTimeSlot = selectedSchedules.first['time'];
      }
    }

    if (selectedSchedules.isEmpty) {
      setState(() {
        _errorMessage = 'booking_error_select_schedule'.tr();
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Create booking response model
      final bookingResponse = BookingResponseModel(
        selectedSchedules: selectedSchedules,
        selectedTime: selectedDate?.toIso8601String(),
        planPriceEgp: _selectedPlan!.priceEgp.toInt(),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        error: null,
        transition: 'proceed_to_payment',
        planType: _selectedPlan!.planType == 'private'
            ? PlanType.private
            : PlanType.group,
      );

      // Navigate to payment screen
      Navigator.of(context).pop(); // Close bottom sheet

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => BookingCubit(BookingsRepo()),
            child: PaymentScreen(
              bookingResponse: bookingResponse,
              tutorName: widget.tutor.fullName,
              selectedSchedule: selectedTimeSlot, // Pass specific slot
              selectedDate: selectedDate, // Pass specific date
              tutorId: widget.tutor.id,
            ),
          ),
        ),
      );
      // //! pymint get cards
      // context.read<BookingCubit>().getCardPymint();
    } catch (e) {
      setState(() {
        _errorMessage = 'booking_error_general'.tr();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  DateTime getNextDateForDay(String dayNameEn) {
    final now = DateTime.now();
    // Normalize 'now' to start of day to avoid issues with time comparison
    final today = DateTime(now.year, now.month, now.day);

    int targetWeekday;
    switch (dayNameEn) {
      case 'Monday':
        targetWeekday = DateTime.monday;
        break;
      case 'Tuesday':
        targetWeekday = DateTime.tuesday;
        break;
      case 'Wednesday':
        targetWeekday = DateTime.wednesday;
        break;
      case 'Thursday':
        targetWeekday = DateTime.thursday;
        break;
      case 'Friday':
        targetWeekday = DateTime.friday;
        break;
      case 'Saturday':
        targetWeekday = DateTime.saturday;
        break;
      case 'Sunday':
        targetWeekday = DateTime.sunday;
        break;
      default:
        targetWeekday = DateTime.monday; // Fallback
    }

    int daysToAdd = (targetWeekday - today.weekday + 7) % 7;
    return today.add(Duration(days: daysToAdd));
  }

  // Helper to format "13:00 - 13:35" (24h) to "01:00 PM - 01:35 PM" (12h)
  String _formatSlotForDisplay(String slot24h) {
    if (!slot24h.contains('-')) return slot24h;
    final parts = slot24h.split('-');
    if (parts.length != 2) return slot24h;

    String to12h(String time) {
      time = time.trim();
      final p = time.split(':');
      if (p.length < 2) return time;
      try {
        int h = int.parse(p[0]);
        String m = p[1];
        String period = h >= 12 ? 'PM' : 'AM';
        if (h > 12) h -= 12;
        if (h == 0) h = 12;
        return '$h:$m $period';
      } catch (e) {
        return time;
      }
    }

    return '${to12h(parts[0])} - ${to12h(parts[1])}';
  }
}
