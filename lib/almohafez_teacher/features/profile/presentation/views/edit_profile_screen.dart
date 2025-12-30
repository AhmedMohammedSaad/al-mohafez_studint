import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';

import '../../data/models/teacher_profile_model.dart';
import '../cubit/teacher_profile_cubit.dart';
import '../cubit/teacher_profile_state.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfileScreen extends StatefulWidget {
  final TeacherProfileModel profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  List<AvailabilitySlot> _availabilitySlots = [];

  File? _profileImageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.profile.fullName);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
    _availabilitySlots = List.from(widget.profile.availabilitySlots);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImageFile = File(picked.path));
    }
  }

  List<Map<String, String>> _generateDailySlots() {
    List<Map<String, String>> slots = [];
    int currentMinutes = 4 * 60; // Start at 04:00 AM
    const int sessionDuration = 60;
    const int endOfDay = 24 * 60; // End at midnight

    while (currentMinutes + sessionDuration <= endOfDay) {
      int endMinutes = currentMinutes + sessionDuration;

      final startHour = (currentMinutes ~/ 60).toString().padLeft(2, '0');
      final startMinute = (currentMinutes % 60).toString().padLeft(2, '0');
      final endHour = (endMinutes ~/ 60).toString().padLeft(2, '0');
      final endMinute = (endMinutes % 60).toString().padLeft(2, '0');

      // Helper to format 12h time
      String format12h(int totalMinutes) {
        int h = totalMinutes ~/ 60;
        int m = totalMinutes % 60;
        String period = h >= 12 ? 'PM' : 'AM';
        if (h > 12) h -= 12;
        if (h == 0) h = 12;
        return '$h:${m.toString().padLeft(2, '0')} $period';
      }

      slots.add({
        'start': '$startHour:$startMinute', // 24h format for storage
        'end': '$endHour:$endMinute', // 24h format for storage
        'display':
            '${format12h(currentMinutes)} - ${format12h(endMinutes)}', // 12h format for UI display
      });

      currentMinutes = endMinutes;
    }
    return slots;
  }

  Future<void> _addAvailabilitySlot() async {
    String? selectedDay;
    List<Map<String, String>> selectedTimeSlots = [];
    final List<Map<String, String>> allDailySlots = _generateDailySlots();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('add_availability'.tr()),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<String>(
                        value: selectedDay,
                        isExpanded: true,
                        hint: Text('select_day'.tr()),
                        items:
                            [
                                  'Monday',
                                  'Tuesday',
                                  'Wednesday',
                                  'Thursday',
                                  'Friday',
                                  'Saturday',
                                  'Sunday',
                                ]
                                .map(
                                  (day) => DropdownMenuItem(
                                    value: day,
                                    child: Text(
                                      'days_${day.toLowerCase()}'.tr(),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setState(() => selectedDay = v),
                      ),
                      SizedBox(height: 16.h),
                      if (selectedDay != null) ...[
                        Text('select_time_slots'.tr()),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: allDailySlots.map((slot) {
                            final isSelected = selectedTimeSlots.any(
                              (s) =>
                                  s['start'] == slot['start'] &&
                                  s['end'] == slot['end'],
                            );
                            return ChoiceChip(
                              label: Text(slot['display']!),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedTimeSlots.add(slot);
                                  } else {
                                    selectedTimeSlots.removeWhere(
                                      (s) =>
                                          s['start'] == slot['start'] &&
                                          s['end'] == slot['end'],
                                    );
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('cancel'.tr()),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedDay != null && selectedTimeSlots.isNotEmpty) {
                      final newSlots = selectedTimeSlots.map((slot) {
                        return AvailabilitySlot(
                          day: selectedDay!,
                          start: slot['start']!,
                          end: slot['end']!,
                        );
                      }).toList();

                      Navigator.pop(context, newSlots);
                    }
                  },
                  child: Text('add'.tr()),
                ),
              ],
            );
          },
        );
      },
    ).then((result) {
      if (result != null && result is List<AvailabilitySlot>) {
        setState(() {
          _availabilitySlots.addAll(result);
        });
      }
    });
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    // If image changed, upload it first (or concurrently, but simple here)
    if (_profileImageFile != null) {
      context.read<TeacherProfileCubit>().uploadProfileImage(
        _profileImageFile!,
      );
    }

    final updatedProfile = widget.profile.copyWith(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      bio: _bioController.text.trim(),
      availabilitySlots: _availabilitySlots,
    );

    context.read<TeacherProfileCubit>().updateProfile(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('edit_profile'.tr())),
      body: BlocListener<TeacherProfileCubit, TeacherProfileState>(
        listener: (context, state) {
          if (state is TeacherProfileUpdateSuccess) {
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.pop(context);
          } else if (state is TeacherProfileError) {
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 90.w,
                    height: 90.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryBlueViolet,
                        width: 2,
                      ),
                    ),
                    child: _profileImageFile != null
                        ? ClipOval(
                            child: Image.file(
                              _profileImageFile!,
                              width: 90.w,
                              height: 90.w,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipOval(
                            child: AppCustomImageView(
                              imagePath: widget.profile.profilePictureUrl,
                              width: 90.w,
                              height: 90.w,
                              fit: BoxFit.cover,
                              placeHolder: 'assets/images/placeholder.webp',
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'full_name'.tr(),
                  ), // Changed key to generic full name
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'field_required'.tr()
                      : null,
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'email'.tr()),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'field_required'.tr()
                      : null,
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'phone_number'.tr()),
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _bioController,
                  decoration: InputDecoration(labelText: 'Bio'),
                  maxLines: 3,
                ),
                SizedBox(height: 16.h),
                Text(
                  'availability'.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                // Display existing slots
                ..._availabilitySlots.map(
                  (slot) => Card(
                    child: ListTile(
                      title: Text('days_${slot.day.toLowerCase()}'.tr()),
                      subtitle: Builder(
                        builder: (context) {
                          // Helper to convert stored 24h to 12h for display
                          String to12h(String time24) {
                            if (!time24.contains(':')) return time24;
                            final parts = time24.split(':');
                            int h = int.parse(parts[0]);
                            int m = int.parse(parts[1]);
                            String period = h >= 12 ? 'PM' : 'AM';
                            if (h > 12) h -= 12;
                            if (h == 0) h = 12;
                            return '$h:${m.toString().padLeft(2, '0')} $period';
                          }

                          return Text(
                            '${to12h(slot.start)} - ${to12h(slot.end)}',
                          );
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _availabilitySlots.remove(slot);
                          });
                        },
                      ),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _addAvailabilitySlot,
                  icon: const Icon(Icons.add),
                  label: Text('add_slot'.tr()),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<TeacherProfileCubit, TeacherProfileState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is TeacherProfileUpdating
                            ? null
                            : _saveProfile,
                        child: state is TeacherProfileUpdating
                            ? const CircularProgressIndicator()
                            : Text('save'.tr()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 70.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
