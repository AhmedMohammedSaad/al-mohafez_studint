// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:almohafez/almohafez/core/theme/app_colors.dart';
// import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

// class SessionControlsWidget extends StatelessWidget {
//   final bool isSessionActive;
//   final VoidCallback onStart;
//   final VoidCallback onPause;
//   final VoidCallback onEnd;

//   const SessionControlsWidget({
//     super.key,
//     required this.isSessionActive,
//     required this.onStart,
//     required this.onPause,
//     required this.onEnd,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // عنوان القسم
//           Text(
//             'أدوات التحكم في الجلسة',
//             style: AppTextStyle.textStyle18Bold.copyWith(
//               color: AppColors.textPrimary,
//             ),
//           ),

//           SizedBox(height: 16.h),

//           // أزرار التحكم الرئيسية
//           Row(
//             children: [
//               // زر البدء/الإيقاف المؤقت
//               Expanded(
//                 flex: 2,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   child: ElevatedButton.icon(
//                     onPressed: isSessionActive ? onPause : onStart,
//                     icon: AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 300),
//                       child: Icon(
//                         isSessionActive
//                             ? Icons.pause_rounded
//                             : Icons.play_arrow_rounded,
//                         key: ValueKey(isSessionActive),
//                         size: 24.sp,
//                       ),
//                     ),
//                     label: AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 300),
//                       child: Text(
//                         isSessionActive ? 'إيقاف مؤقت' : 'بدء الجلسة',
//                         key: ValueKey(isSessionActive),
//                         style: AppTextStyle.textStyle16Bold,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isSessionActive
//                           ? AppColors.primaryWarning
//                           : AppColors.primarySuccess,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(vertical: 16.h),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       elevation: isSessionActive ? 8 : 4,
//                       shadowColor: isSessionActive
//                           ? AppColors.primaryWarning.withOpacity(0.3)
//                           : AppColors.primarySuccess.withOpacity(0.3),
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(width: 12.w),

//               // زر إنهاء الجلسة
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: onEnd,
//                   icon: Icon(Icons.stop_rounded, size: 20.sp),
//                   label: Text('إنهاء', style: AppTextStyle.textStyle14Bold),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryError,
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(vertical: 16.h),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           SizedBox(height: 16.h),

//           // أزرار إضافية
//           Row(
//             children: [
//               // زر إضافة استراحة
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () {
//                     _showBreakDialog(context);
//                   },
//                   icon: Icon(
//                     Icons.coffee_rounded,
//                     size: 18.sp,
//                     color: AppColors.primaryBlueViolet,
//                   ),
//                   label: Text(
//                     'استراحة',
//                     style: AppTextStyle.textStyle14Medium.copyWith(
//                       color: AppColors.primaryBlueViolet,
//                     ),
//                   ),
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: AppColors.primaryBlueViolet),
//                     padding: EdgeInsets.symmetric(vertical: 12.h),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(width: 8.w),

//               // زر إضافة ملاحظة سريعة
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () {
//                     _showQuickNoteDialog(context);
//                   },
//                   icon: Icon(
//                     Icons.note_add_rounded,
//                     size: 18.sp,
//                     color: AppColors.primaryBlueViolet,
//                   ),
//                   label: Text(
//                     'ملاحظة',
//                     style: AppTextStyle.textStyle14Medium.copyWith(
//                       color: AppColors.primaryBlueViolet,
//                     ),
//                   ),
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: AppColors.primaryBlueViolet),
//                     padding: EdgeInsets.symmetric(vertical: 12.h),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(width: 8.w),

//               // زر مشاركة الشاشة (مستقبلي)
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           'ميزة مشاركة الشاشة قريباً',
//                           style: AppTextStyle.textStyle14Medium.copyWith(
//                             color: Colors.white,
//                           ),
//                         ),
//                         backgroundColor: AppColors.primaryBlueViolet,
//                       ),
//                     );
//                   },
//                   icon: Icon(
//                     Icons.screen_share_rounded,
//                     size: 18.sp,
//                     color: AppColors.textSecondary,
//                   ),
//                   label: Text(
//                     'مشاركة',
//                     style: AppTextStyle.textStyle14Medium.copyWith(
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: AppColors.textSecondary),
//                     padding: EdgeInsets.symmetric(vertical: 12.h),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           // حالة الجلسة
//           if (isSessionActive) ...[
//             SizedBox(height: 16.h),
//             Container(
//               padding: EdgeInsets.all(12.w),
//               decoration: BoxDecoration(
//                 color: AppColors.primarySuccess.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8.r),
//                 border: Border.all(
//                   color: AppColors.primarySuccess.withOpacity(0.3),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 8.w,
//                     height: 8.h,
//                     decoration: BoxDecoration(
//                       color: AppColors.primarySuccess,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   Text(
//                     'الجلسة نشطة الآن',
//                     style: AppTextStyle.textStyle14Medium.copyWith(
//                       color: AppColors.primarySuccess,
//                     ),
//                   ),
//                   const Spacer(),
//                   Icon(
//                     Icons.radio_button_checked_rounded,
//                     size: 16.sp,
//                     color: AppColors.primarySuccess,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   void _showBreakDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('استراحة', style: AppTextStyle.textStyle18Bold),
//         content: Text(
//           'هل تريد أخذ استراحة؟ سيتم إيقاف المؤقت مؤقتاً.',
//           style: AppTextStyle.textStyle14Medium,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'إلغاء',
//               style: AppTextStyle.textStyle14Medium.copyWith(
//                 color: AppColors.textSecondary,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // إيقاف الجلسة مؤقتاً
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryWarning,
//             ),
//             child: Text(
//               'استراحة',
//               style: AppTextStyle.textStyle14Medium.copyWith(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showQuickNoteDialog(BuildContext context) {
//     final TextEditingController noteController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('ملاحظة سريعة', style: AppTextStyle.textStyle18Bold),
//         content: TextFormField(
//           controller: noteController,
//           maxLines: 3,
//           decoration: InputDecoration(
//             hintText: 'اكتب ملاحظة سريعة...',
//             hintStyle: AppTextStyle.textStyle14Medium.copyWith(
//               color: AppColors.textSecondary,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'إلغاء',
//               style: AppTextStyle.textStyle14Medium.copyWith(
//                 color: AppColors.textSecondary,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // حفظ الملاحظة السريعة
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     'تم حفظ الملاحظة',
//                     style: AppTextStyle.textStyle14Medium.copyWith(
//                       color: Colors.white,
//                     ),
//                   ),
//                   backgroundColor: AppColors.primarySuccess,
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryBlueViolet,
//             ),
//             child: Text(
//               'حفظ',
//               style: AppTextStyle.textStyle14Medium.copyWith(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
