import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/session_card.dart';
import '../widgets/empty_sessions_widget.dart';
import '../../data/models/sessions_response_model.dart';
import '../../data/services/sessions_service.dart';
import '../../../../core/services/navigation_service/global_navigation_service.dart';
import '../../../../core/routing/app_route.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SessionsResponseModel? _sessionsData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSessions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSessions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final sessions = await SessionsService.getAllSessions();
      setState(() {
        _sessionsData = sessions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'sessions_error_loading'.tr();
        _isLoading = false;
      });
    }
  }

  void _navigateToBooking() {
    // TODO: Navigate to booking screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('sessions_booking_redirect'.tr())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorWidget()
          : _buildContent(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadSessions,
            child: Text('sessions_retry'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_sessionsData == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
              dividerColor:
                  Colors.transparent, // Remove the divider line under tabs
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
                        '${'sessions_upcoming'.tr()} (${_sessionsData!.upcomingSessions.length})',
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
                        '${'sessions_completed'.tr()} (${_sessionsData!.completedSessions.length})',
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
              _buildUpcomingSessionsTab(),
              _buildCompletedSessionsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingSessionsTab() {
    final upcomingSessions = _sessionsData!.upcomingSessions;

    if (upcomingSessions.isEmpty) {
      return EmptySessionsWidget.noUpcomingSessions(
        onBookNew: _navigateToBooking,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: upcomingSessions.length,
      itemBuilder: (context, index) {
        final session = upcomingSessions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SessionCard(
            session: session,
            onTap: () => _navigateToSessionDetails(session.id),
            onJoinSession: () => _joinSession(session.id),
            onRateSession: () => _rateSession(session.id),
          ),
        );
      },
    );
  }

  Widget _buildCompletedSessionsTab() {
    final completedSessions = _sessionsData!.completedSessions;

    if (completedSessions.isEmpty) {
      return EmptySessionsWidget.noCompletedSessions();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedSessions.length,
      itemBuilder: (context, index) {
        final session = completedSessions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SessionCard(
            session: session,
            onTap: () => _navigateToSessionDetails(session.id),
            onJoinSession: () => _joinSession(session.id),
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

  void _joinSession(String sessionId) async {
    try {
      await SessionsService.joinSession(sessionId);

      // Navigate to meeting screen
      NavigationService.push(
        AppRouter.kMeetingScreen,
        extra: {'sessionId': sessionId},
      );

      _loadSessions(); // Refresh data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${'sessions_join_error'.tr()}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _rateSession(String sessionId) {
    NavigationService.push(
      '${AppRouter.kSessionRatingScreen}?sessionId=$sessionId',
    );
  }
}
