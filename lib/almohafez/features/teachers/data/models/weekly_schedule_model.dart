class WeeklyScheduleModel {
  final List<DaySchedule> days;
  final Map<String, List<String>>
  selectedSlots; // day -> list of selected time slots
  final int maxDaysAllowed;
  final int maxSlotsPerDay;

  WeeklyScheduleModel({
    required this.days,
    Map<String, List<String>>? selectedSlots,
    this.maxDaysAllowed = 2,
    this.maxSlotsPerDay = 1,
  }) : selectedSlots = selectedSlots ?? {};

  // Get list of selected days
  List<String> get selectedDays => selectedSlots.keys.toList();

  // Check if a day is selected
  bool isDaySelected(String dayName) => selectedSlots.containsKey(dayName);

  // Check if a time slot is selected for a specific day
  bool isTimeSlotSelected(String dayName, String timeSlot) {
    return selectedSlots[dayName]?.contains(timeSlot) ?? false;
  }

  // Check if we can select more days
  bool get canSelectMoreDays => selectedDays.length < maxDaysAllowed;

  // Check if we can select more time slots for a specific day
  bool canSelectMoreSlotsForDay(String dayName) {
    final currentSlots = selectedSlots[dayName]?.length ?? 0;
    return currentSlots < maxSlotsPerDay;
  }

  // Get total selected slots count
  int get totalSelectedSlots {
    return selectedSlots.values.fold(0, (sum, slots) => sum + slots.length);
  }

  // Check if selection is valid (at least one day with one slot)
  bool get isValidSelection {
    return selectedSlots.isNotEmpty &&
        selectedSlots.values.any((slots) => slots.isNotEmpty);
  }

  // Add a time slot selection (only one slot per day allowed)
  WeeklyScheduleModel selectTimeSlot(String dayName, String timeSlot) {
    final newSelectedSlots = Map<String, List<String>>.from(selectedSlots);

    if (!newSelectedSlots.containsKey(dayName)) {
      // Check if we can add a new day
      if (!canSelectMoreDays) {
        return this; // Cannot select more days
      }
      newSelectedSlots[dayName] = [];
    }

    // For each day, allow only one time slot
    // If the same slot is selected, deselect it; otherwise replace with new slot
    if (newSelectedSlots[dayName]!.contains(timeSlot)) {
      // If clicking the same slot, deselect it
      newSelectedSlots[dayName] = [];
    } else {
      // Replace with the new time slot (only one allowed per day)
      newSelectedSlots[dayName] = [timeSlot];
    }

    // Remove empty days from selection
    if (newSelectedSlots[dayName]!.isEmpty) {
      newSelectedSlots.remove(dayName);
    }

    return WeeklyScheduleModel(
      days: days,
      selectedSlots: newSelectedSlots,
      maxDaysAllowed: maxDaysAllowed,
      maxSlotsPerDay: 1, // Force max slots per day to 1
    );
  }

  // Remove a time slot selection
  WeeklyScheduleModel deselectTimeSlot(String dayName, String timeSlot) {
    final newSelectedSlots = Map<String, List<String>>.from(selectedSlots);

    if (newSelectedSlots.containsKey(dayName)) {
      newSelectedSlots[dayName] = newSelectedSlots[dayName]!
          .where((slot) => slot != timeSlot)
          .toList();

      // Remove day if no slots are selected
      if (newSelectedSlots[dayName]!.isEmpty) {
        newSelectedSlots.remove(dayName);
      }
    }

    return WeeklyScheduleModel(
      days: days,
      selectedSlots: newSelectedSlots,
      maxDaysAllowed: maxDaysAllowed,
      maxSlotsPerDay: maxSlotsPerDay,
    );
  }

  // Toggle time slot selection
  WeeklyScheduleModel toggleTimeSlot(String dayName, String timeSlot) {
    if (isTimeSlotSelected(dayName, timeSlot)) {
      return deselectTimeSlot(dayName, timeSlot);
    } else {
      return selectTimeSlot(dayName, timeSlot);
    }
  }

  // Clear all selections
  WeeklyScheduleModel clearSelections() {
    return WeeklyScheduleModel(
      days: days,
      selectedSlots: {},
      maxDaysAllowed: maxDaysAllowed,
      maxSlotsPerDay: maxSlotsPerDay,
    );
  }

  // Get formatted selection summary
  String getSelectionSummary() {
    if (selectedSlots.isEmpty) return 'لم يتم اختيار أي أوقات';

    final summaryParts = <String>[];
    for (final entry in selectedSlots.entries) {
      final dayName = entry.key;
      final slots = entry.value;
      if (slots.isNotEmpty) {
        for (int i = 0; i < slots.length; i++) {
          final timeSlot = slots[i];
          summaryParts.add('اليوم $dayName الساعة $timeSlot');
        }
      }
    }

    return summaryParts.join('\n');
  }

  // Create mock weekly schedule
  static WeeklyScheduleModel createMockSchedule({
    int maxDaysAllowed = 2,
    int maxSlotsPerDay = 1,
  }) {
    final days = [
      DaySchedule(
        dayName: 'السبت',
        dayNameEn: 'Saturday',
        isAvailable: true,
        timeSlots: [
          '09:00 - 10:00',
          '10:00 - 11:00',
          '11:00 - 12:00',
          '14:00 - 15:00',
          '15:00 - 16:00',
          '16:00 - 17:00',
          '19:00 - 20:00',
          '20:00 - 21:00',
        ],
      ),
      DaySchedule(
        dayName: 'الأحد',
        dayNameEn: 'Sunday',
        isAvailable: true,
        timeSlots: [
          '09:00 - 10:00',
          '10:00 - 11:00',
          '11:00 - 12:00',
          '14:00 - 15:00',
          '15:00 - 16:00',
          '16:00 - 17:00',
          '19:00 - 20:00',
          '20:00 - 21:00',
        ],
      ),
      DaySchedule(
        dayName: 'الاثنين',
        dayNameEn: 'Monday',
        isAvailable: true,
        timeSlots: [
          '09:00 - 10:00',
          '10:00 - 11:00',
          '14:00 - 15:00',
          '15:00 - 16:00',
          '16:00 - 17:00',
          '19:00 - 20:00',
          '20:00 - 21:00',
        ],
      ),
      DaySchedule(
        dayName: 'الثلاثاء',
        dayNameEn: 'Tuesday',
        isAvailable: true,
        timeSlots: [
          '09:00 - 10:00',
          '10:00 - 11:00',
          '14:00 - 15:00',
          '15:00 - 16:00',
          '16:00 - 17:00',
          '19:00 - 20:00',
          '20:00 - 21:00',
        ],
      ),
      DaySchedule(
        dayName: 'الأربعاء',
        dayNameEn: 'Wednesday',
        isAvailable: true,
        timeSlots: [
          '09:00 - 10:00',
          '10:00 - 11:00',
          '11:00 - 12:00',
          '14:00 - 15:00',
          '16:00 - 17:00',
          '19:00 - 20:00',
          '20:00 - 21:00',
        ],
      ),
      DaySchedule(
        dayName: 'الخميس',
        dayNameEn: 'Thursday',
        isAvailable: true,
        timeSlots: [
          '09:00 - 10:00',
          '10:00 - 11:00',
          '14:00 - 15:00',
          '15:00 - 16:00',
          '16:00 - 17:00',
          '19:00 - 20:00',
          '20:00 - 21:00',
        ],
      ),
      DaySchedule(
        dayName: 'الجمعة',
        dayNameEn: 'Friday',
        isAvailable: true,
        timeSlots: [
          '14:00 - 15:00',
          '15:00 - 16:00',
          '16:00 - 17:00',
          '17:00 - 18:00',
        ], // Friday now has available slots
      ),
    ];

    return WeeklyScheduleModel(
      days: days,
      maxDaysAllowed: maxDaysAllowed,
      maxSlotsPerDay: maxSlotsPerDay,
    );
  }
}

class DaySchedule {
  final String dayName;
  final String dayNameEn;
  final bool isAvailable;
  final List<String> timeSlots;

  DaySchedule({
    required this.dayName,
    required this.dayNameEn,
    required this.isAvailable,
    required this.timeSlots,
  });

  // Check if this day has any available time slots
  bool get hasAvailableSlots => isAvailable && timeSlots.isNotEmpty;

  String? selectedSlot; // Added to track selection for this day
}
