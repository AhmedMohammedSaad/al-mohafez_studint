import 'package:almohafez/almohafez/features/sessions/presentation/views/session_details_screen.dart';
import 'package:almohafez/almohafez/features/sessions/presentation/views/session_rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/session_card.dart';
import '../widgets/empty_sessions_widget.dart';
import '../../logic/sessions_cubit.dart';
import '../../logic/sessions_state.dart';
import '../../data/models/session_model.dart';
import '../../../../core/services/navigation_service/global_navigation_service.dart';
import '../../../../core/routing/app_route.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/presentation/view/widgets/error_widget.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<SessionsCubit>().loadSessions();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToBooking() {
    // Navigate to teachers list or home to start booking
    NavigationService.push(AppRouter.kTeachersScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('nav_sessions'.tr())),
      body: BlocBuilder<SessionsCubit, SessionsState>(
        builder: (context, state) {
          if (state is SessionsLoading) {
            return _buildShimmerLoading();
          }

          if (state is SessionsError) {
            return AppErrorWidget(
              message: state.message,
              onRefresh: () => context.read<SessionsCubit>().loadSessions(),
            );
          }

          if (state is SessionsLoaded) {
            return _buildContent(state);
          }

          return _buildShimmerLoading();
        },
      ),
    );
  }

  Widget _buildContent(SessionsLoaded state) {
    return _buildUpcomingSessionsTab(state.upcomingSessions);
    // Column(
    // children: [
    // Statistics widget
    // 60.height,
    // // Tab bar
    // Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    //   child: Container(
    //     height: 52,
    //     decoration: BoxDecoration(
    //       color: Colors.grey.shade200,
    //       borderRadius: BorderRadius.circular(26),
    //     ),
    //     child:
    //  TabBar(
    //   dividerColor: Colors.transparent,
    //   controller: _tabController,
    //   indicator: BoxDecoration(
    //     color: const Color(0xFF2E7D32),
    //     borderRadius: BorderRadius.circular(24),
    //     boxShadow: [
    //       BoxShadow(
    //         color: const Color(0xFF2E7D32).withValues(alpha: .25),
    //         blurRadius: 8,
    //         offset: const Offset(0, 4),
    //       ),
    //     ],
    //   ),
    //   labelColor: Colors.white,
    //   unselectedLabelColor: Colors.grey.shade600,
    //   labelStyle: const TextStyle(
    //     fontWeight: FontWeight.w600,
    //     fontSize: 14,
    //   ),
    //   unselectedLabelStyle: const TextStyle(
    //     fontWeight: FontWeight.w500,
    //     fontSize: 14,
    //   ),
    //   indicatorPadding: const EdgeInsets.all(4),
    //   tabs: [
    //     Tab(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const SizedBox(width: 4),
    //           Flexible(
    //             child: Text(
    //               '${'sessions_upcoming'.tr()} (${state.upcomingSessions.length})',
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     Tab(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const SizedBox(width: 4),
    //           Flexible(
    //             child: Text(
    //               '${'sessions_completed'.tr()} (${state.completedSessions.length})',
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // ),
    // ),
    // ),
    // // Tab content
    // Expanded(
    //   child: TabBarView(
    //     controller: _tabController,
    //     children: [
    //       _buildUpcomingSessionsTab(state.upcomingSessions),
    //       _buildCompletedSessionsTab(state.completedSessions),
    //
    //   ],

    // ),
    // ),

    // ],
    // );;
  }

  Widget _buildUpcomingSessionsTab(List<SessionModel> sessions) {
    if (sessions.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<SessionsCubit>().loadSessions(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: EmptySessionsWidget.noUpcomingSessions(
              onBookNew: _navigateToBooking,
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<SessionsCubit>().loadSessions(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 70, left: 8, right: 8),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SessionCard(
              session: session,
              onTap: () => _navigateToSessionDetails(session.id),
              onJoinSession: () => _joinSession(context, session.id),
              onRateSession: () => _rateSession(session.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompletedSessionsTab(List<SessionModel> sessions) {
    if (sessions.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<SessionsCubit>().loadSessions(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: EmptySessionsWidget.noCompletedSessions(),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<SessionsCubit>().loadSessions(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SessionCard(
              session: session,
              onTap: () => _navigateToSessionDetails(session.id),
              onJoinSession: () => _joinSession(context, session.id),
              onRateSession: () => _rateSession(session.id),
            ),
          );
        },
      ),
    );
  }

  void _navigateToSessionDetails(String sessionId) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => SessionDetailsScreen(sessionId: sessionId),
    //   ),
    // );
  }

  void _joinSession(BuildContext context, String sessionId) async {
    // Find the session from the current state
    final state = context.read<SessionsCubit>().state;
    SessionModel? session;

    if (state is SessionsLoaded) {
      try {
        // Try to find in upcoming sessions first
        session = state.upcomingSessions.firstWhere(
          (s) => s.id == sessionId,
          orElse: () =>
              state.completedSessions.firstWhere((s) => s.id == sessionId),
        );
      } catch (e) {
        // Session not found
      }
    }

    if (session == null ||
        session.meetingUrl == null ||
        session.meetingUrl!.isEmpty) {
      Fluttertoast.showToast(
        msg: 'session_refresh_hint'.tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return;
    }

    try {
      final uri = Uri.parse(session.meetingUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch ${session.meetingUrl}';
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: '${'session_join_error'.tr()}: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _rateSession(String sessionId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SessionRatingScreen(sessionId: sessionId),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 70, left: 16, right: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    );
  }
}
