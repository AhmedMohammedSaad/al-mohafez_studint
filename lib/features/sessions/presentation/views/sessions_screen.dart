import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/session_card.dart';
import '../widgets/empty_sessions_widget.dart';
import '../../logic/sessions_cubit.dart';
import '../../logic/sessions_state.dart';
import '../../data/repos/sessions_repo.dart';
import '../../data/models/session_model.dart';
import '../../../../core/services/navigation_service/global_navigation_service.dart';
import '../../../../core/routing/app_route.dart';

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
    return BlocProvider(
      create: (context) => SessionsCubit(SessionsRepo())..loadSessions(),
      child: Scaffold(
        body: BlocBuilder<SessionsCubit, SessionsState>(
          builder: (context, state) {
            if (state is SessionsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SessionsError) {
              return _buildErrorWidget(context, state.message);
            }

            if (state is SessionsLoaded) {
              return _buildContent(state);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message, // Or localize generic error
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<SessionsCubit>().loadSessions(),
            child: Text('sessions_retry'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(SessionsLoaded state) {
    return Column(
      children: [
        // Statistics widget
        60.height,
        // Tab bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(26),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              indicatorPadding: const EdgeInsets.all(4),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 4),
                      Text(
                        '${'sessions_upcoming'.tr()} (${state.upcomingSessions.length})',
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 4),
                      Text(
                        '${'sessions_completed'.tr()} (${state.completedSessions.length})',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildUpcomingSessionsTab(state.upcomingSessions),
              _buildCompletedSessionsTab(state.completedSessions),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingSessionsTab(List<SessionModel> sessions) {
    if (sessions.isEmpty) {
      return EmptySessionsWidget.noUpcomingSessions(
        onBookNew: _navigateToBooking,
      );
    }

    return ListView.builder(
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
    );
  }

  Widget _buildCompletedSessionsTab(List<SessionModel> sessions) {
    if (sessions.isEmpty) {
      return EmptySessionsWidget.noCompletedSessions();
    }

    return ListView.builder(
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
    );
  }

  void _navigateToSessionDetails(String sessionId) {
    NavigationService.push(
      '${AppRouter.kSessionDetailsScreen}?sessionId=$sessionId',
    );
  }

  void _joinSession(BuildContext context, String sessionId) async {
    // Find the session from the current state
    final state = context.read<SessionsCubit>().state;
    SessionModel? session;

    if (state is SessionsLoaded) {
      // Try to find in upcoming sessions first
      session = state.upcomingSessions.firstWhere(
        (s) => s.id == sessionId,
        orElse: () => state.completedSessions.firstWhere(
          (s) => s.id == sessionId,
          orElse: () => throw Exception('Session not found'),
        ),
      );
    }

    if (session == null ||
        session.meetingUrl == null ||
        session.meetingUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('meeting_url_missing'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to WebView with meeting URL
    NavigationService.push(
      '${AppRouter.kMeetingWebViewScreen}?meetingUrl=${Uri.encodeComponent(session.meetingUrl!)}',
    );
  }

  void _rateSession(String sessionId) {
    NavigationService.push(
      '${AppRouter.kSessionRatingScreen}?sessionId=$sessionId',
    );
  }
}
