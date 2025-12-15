// import 'package:flutter/material.dart';
// import 'package:almohafez/features/home/presentation/views/home_screen.dart';
// import 'package:almohafez/features/teachers/presentation/views/teachers_screen.dart';
// import 'package:almohafez/features/sessions/presentation/views/sessions_screen.dart';
// import 'package:almohafez/features/progress/presentation/views/progress_screen.dart';
// import 'package:almohafez/features/profile/presentation/views/profile_screen.dart';
// import 'package:almohafez/core/presentation/view/widgets/custom_bottom_navigation_bar.dart';

// class MainNavigationScreen extends StatefulWidget {
//   const MainNavigationScreen({super.key});

//   @override
//   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// }

// class _MainNavigationScreenState extends State<MainNavigationScreen>
//     with TickerProviderStateMixin {
//   int _currentIndex = 0;
//   late AnimationController _slideAnimationController;
//   late Animation<Offset> _slideAnimation;

//   final List<Widget> _screens = [
//     const HomeScreen(),
//     const TeachersScreen(),
//     const SessionsScreen(),
//     const ProgressScreen(),
//     const ProfileScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _slideAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
//           CurvedAnimation(
//             parent: _slideAnimationController,
//             curve: Curves.easeInOut,
//           ),
//         );
//   }

//   @override
//   void dispose() {
//     _slideAnimationController.dispose();
//     super.dispose();
//   }

//   void _onTabTapped(int index) {
//     if (index != _currentIndex) {
//       int previousIndex = _currentIndex;

//       setState(() {
//         _currentIndex = index;
//       });

//       // Determine slide direction based on navigation
//       bool slideFromRight = index > previousIndex;

//       _slideAnimation =
//           Tween<Offset>(
//             begin: slideFromRight
//                 ? const Offset(1.0, 0.0)
//                 : const Offset(-1.0, 0.0),
//             end: Offset.zero,
//           ).animate(
//             CurvedAnimation(
//               parent: _slideAnimationController,
//               curve: Curves.easeInOut,
//             ),
//           );

//       _slideAnimationController.reset();
//       _slideAnimationController.forward();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnimatedBuilder(
//         animation: _slideAnimationController,
//         builder: (context, child) {
//           return SlideTransition(
//             position: _slideAnimation,
//             child: IndexedStack(index: _currentIndex, children: _screens),
//           );
//         },
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onTabTapped,
//       ),
//     );
//   }
// }
