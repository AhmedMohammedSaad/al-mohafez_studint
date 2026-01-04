import 'package:almohafez/almohafez/core/presentation/view/main_screen.dart';
import 'package:almohafez/almohafez/features/authentication/presentation/views/login_screen.dart';
import 'package:almohafez/almohafez/features/authentication/presentation/views/sign_up_screen.dart';
import 'package:almohafez/almohafez/features/authentication/presentation/views/forgot_password_screen.dart';
import 'package:almohafez/almohafez/features/onboarding/presentation/views/welcome_onboarding_screen.dart';
import 'package:almohafez/almohafez/features/sessions/presentation/views/sessions_screen.dart';
import 'package:almohafez/almohafez/features/sessions/presentation/views/session_details_screen.dart';
import 'package:almohafez/almohafez/features/sessions/presentation/views/session_rating_screen.dart';

import 'package:almohafez/almohafez/features/profile/presentation/views/edit_profile_screen.dart';
import 'package:almohafez/almohafez/features/profile/presentation/views/change_password_screen.dart';
import 'package:almohafez/almohafez/features/profile/presentation/views/contact_us_screen.dart';
import 'package:almohafez/almohafez/features/teachers/presentation/views/payment_screen.dart';
import '../../features/teachers/presentation/views/teachers_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/navigation_service/global_navigation_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

enum PageRouteAnimation { fade, scale, rotate, slide, slideBottomTop }

class AppRouter {
  AppRouter();

  // Route names
  static const String kInitial = '/onboarding-screen';
  static const String kOnboardingScreen = '/onboarding-screen';
  static const String kMainScreen = '/main-screen';
  static const String kCompleteProfileScreen = '/register-screen';
  static const String kStudentOnboardingScreen = '/student-onboarding-screen';
  static const String kParentOnboardingScreen = '/parent-onboarding-screen';
  static const String kSheikhOnboardingScreen = '/sheikh-onboarding-screen';
  static const String kRoleSelectionScreen = '/role-selection-screen';

  // Authentication Routes
  static const String kLoginScreen = '/login';
  static const String kSignUpScreen = '/sign-up';
  static const String kForgotPasswordScreen = '/forgot-password';

  // Sessions Routes
  static const String kSessionsScreen = '/sessions';
  static const String kSessionDetailsScreen = '/session-details';
  static const String kSessionRatingScreen = '/session-rating';

  // Profile Routes
  static const String kEditProfileScreen = '/edit-profile';
  static const String kChangePasswordScreen = '/change-password';
  static const String kContactUsScreen = '/contact-us';

  // Teachers Routes
  static const String kTeachersScreen = '/teachers';

  // Router configuration
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: NavigationService.navigatorKey,
    // initialLocation: kOnboardingScreen,
    routes: <RouteBase>[
      // Initial/Onboarding Route
      GoRoute(
        path: kOnboardingScreen,
        name: 'Onboarding',
        pageBuilder: (context, state) => _animateRouteBuilder(
          const WelcomeOnboardingScreen(),
          pageRouteAnimation: PageRouteAnimation.fade,
          duration: const Duration(milliseconds: 500),
        ),
      ),

      // Authentication Routes
      GoRoute(
        path: kLoginScreen,
        name: 'Login',
        pageBuilder: (context, state) {
          final Map<String, dynamic> args =
              state.extra as Map<String, dynamic>? ?? {};
          return _animateRouteBuilder(
            const LoginScreen(),
            pageRouteAnimation:
                args['pageAnimation'] ?? PageRouteAnimation.fade,
            duration: const Duration(milliseconds: 500),
          );
        },
      ),
      GoRoute(
        path: kSignUpScreen,
        name: 'SignUp',
        pageBuilder: (context, state) {
          final Map<String, dynamic> args =
              state.extra as Map<String, dynamic>? ?? {};
          return _animateRouteBuilder(
            const SignUpScreen(),
            pageRouteAnimation:
                args['pageAnimation'] ?? PageRouteAnimation.slide,
          );
        },
      ),

      GoRoute(
        path: kForgotPasswordScreen,
        name: 'ForgotPassword',
        pageBuilder: (context, state) {
          final Map<String, dynamic> args =
              state.extra as Map<String, dynamic>? ?? {};
          return _animateRouteBuilder(
            const ForgotPasswordScreen(),
            pageRouteAnimation:
                args['pageAnimation'] ?? PageRouteAnimation.slideBottomTop,
          );
        },
      ),

      // Main Screen
      GoRoute(
        path: kMainScreen,
        name: 'MainScreen',
        pageBuilder: (context, state) {
          final Map<String, dynamic> args =
              state.extra as Map<String, dynamic>? ?? {};
          return _animateRouteBuilder(
            const MainScreen(),
            pageRouteAnimation:
                args['pageAnimation'] ?? PageRouteAnimation.slide,
          );
        },
      ),

      // Sessions Routes
      GoRoute(
        path: kSessionsScreen,
        name: 'Sessions',
        pageBuilder: (context, state) {
          final Map<String, dynamic> args =
              state.extra as Map<String, dynamic>? ?? {};
          return _animateRouteBuilder(
            const SessionsScreen(),
            pageRouteAnimation:
                args['pageAnimation'] ?? PageRouteAnimation.slide,
          );
        },
      ),

      // GoRoute(
      //   path: kSessionDetailsScreen,
      //   name: 'SessionDetails',
      //   pageBuilder: (context, state) {
      //     final Map<String, dynamic> args =
      //         state.extra as Map<String, dynamic>? ?? {};
      //     final sessionId = state.uri.queryParameters['sessionId'] ?? '';
      //     return _animateRouteBuilder(
      //       PaymentScreen(  bookingResponse:  , tutorName: '', tutorId: '',),
      //       pageRouteAnimation:
      //           args['pageAnimation'] ?? PageRouteAnimation.slide,
      //     );
      //   },
      // ),
      GoRoute(
        path: kSessionRatingScreen,
        name: 'SessionRating',
        pageBuilder: (context, state) {
          final Map<String, dynamic> args =
              state.extra as Map<String, dynamic>? ?? {};
          final sessionId = state.uri.queryParameters['sessionId'] ?? '';
          return _animateRouteBuilder(
            SessionRatingScreen(sessionId: sessionId),
            pageRouteAnimation:
                args['pageAnimation'] ?? PageRouteAnimation.slideBottomTop,
          );
        },
      ),

      // Profile Routes
      GoRoute(
        path: kEditProfileScreen,
        name: 'EditProfile',
        pageBuilder: (context, state) {
          final Map<String, dynamic> args =
              state.extra as Map<String, dynamic>? ?? {};
          return _animateRouteBuilder(
            EditProfileScreen(
              currentFirstName: args['firstName'] ?? '',
              currentLastName: args['lastName'] ?? '',
              currentPhoneNumber: args['phoneNumber'],
            ),
            pageRouteAnimation:
                args['pageAnimation'] ?? PageRouteAnimation.slide,
          );
        },
      ),

      GoRoute(
        path: kChangePasswordScreen,
        name: 'ChangePassword',
        pageBuilder: (context, state) {
          final Map<String, dynamic> args =
              state.extra as Map<String, dynamic>? ?? {};
          return _animateRouteBuilder(
            const ChangePasswordScreen(),
            pageRouteAnimation:
                args['pageAnimation'] ?? PageRouteAnimation.slide,
          );
        },
      ),

      GoRoute(
        path: kContactUsScreen,
        name: 'ContactUs',
        pageBuilder: (context, state) {
          final Map<String, dynamic> args =
              state.extra as Map<String, dynamic>? ?? {};
          return _animateRouteBuilder(
            const ContactUsScreen(),
            pageRouteAnimation:
                args['pageAnimation'] ?? PageRouteAnimation.slide,
          );
        },
      ),

      // Teachers Route
      GoRoute(
        path: kTeachersScreen,
        name: 'Teachers',
        pageBuilder: (context, state) {
          final Map<String, dynamic> args =
              state.extra as Map<String, dynamic>? ?? {};
          return _animateRouteBuilder(
            const TeachersScreen(),
            pageRouteAnimation:
                args['pageAnimation'] ?? PageRouteAnimation.slide,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Error: Page not found!', style: TextStyle(fontSize: 18)),
      ),
    ),
    // inside AppRouter.router configuration -> redirect: (context, state) async { ... }
    redirect: (context, state) async {
      try {
        final currentLocation = state.matchedLocation;

        // Check if user has seen onboarding
        final hasSeenOnboarding = getBoolAsync(
          'onBoardingShow',
          defaultValue: false,
        );

        // Check if user has active Supabase session
        final session = Supabase.instance.client.auth.currentSession;
        final isAuthenticated = session != null;

        // Debug logs
        print('🔍 [Routing] Current: $currentLocation');
        print('🔍 [Routing] Seen onboarding: $hasSeenOnboarding');
        print('🔍 [Routing] Authenticated: $isAuthenticated');

        final authScreens = [kLoginScreen, kForgotPasswordScreen];

        // Priority 1: Show onboarding if not seen yet
        if (!hasSeenOnboarding && currentLocation != kOnboardingScreen) {
          print('✅ [Routing] → Onboarding');
          return kOnboardingScreen;
        }

        // Priority 2: If authenticated, avoid auth screens
        if (isAuthenticated && authScreens.contains(currentLocation)) {
          print('✅ [Routing] → Main (authenticated)');
          return kMainScreen;
        }

        // Priority 3: If not authenticated, block access to non-auth screens
        if (!isAuthenticated &&
            !authScreens.contains(currentLocation) &&
            currentLocation != kOnboardingScreen) {
          print('✅ [Routing] → Login (not authenticated)');
          return kLoginScreen;
        }

        print('✅ [Routing] → No redirect');
        return null;
      } catch (e) {
        print('❌ [Routing] Error: $e');
        return kOnboardingScreen;
      }
    },
  );

  // Custom transition builder with enhanced animations
  static CustomTransitionPage _animateRouteBuilder(
    Widget widget, {
    PageRouteAnimation? pageRouteAnimation,
    Duration? duration,
  }) {
    return CustomTransitionPage(
      child: widget,
      reverseTransitionDuration: duration ?? const Duration(milliseconds: 300),
      fullscreenDialog: false,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (pageRouteAnimation) {
          case PageRouteAnimation.fade:
            return FadeTransition(opacity: animation, child: child);

          case PageRouteAnimation.scale:
            return ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
              ),
              child: child,
            );

          case PageRouteAnimation.rotate:
            return RotationTransition(
              turns: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
              child: FadeTransition(opacity: animation, child: child),
            );

          case PageRouteAnimation.slide:
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            );

          case PageRouteAnimation.slideBottomTop:
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            );

          default:
            return FadeTransition(opacity: animation, child: child);
        }
      },
      transitionDuration: duration ?? const Duration(milliseconds: 500),
    );
  }
}
