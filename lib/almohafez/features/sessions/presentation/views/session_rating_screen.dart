import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../data/models/session_model.dart';
import '../../data/models/session_rating_model.dart';
import '../../data/services/sessions_service.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class SessionRatingScreen extends StatefulWidget {
  final String sessionId;

  const SessionRatingScreen({Key? key, required this.sessionId})
    : super(key: key);

  @override
  State<SessionRatingScreen> createState() => _SessionRatingScreenState();
}

class _SessionRatingScreenState extends State<SessionRatingScreen> {
  SessionModel? _session;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  final List<String> _selectedTags = [];

  final List<String> _availableTags = [
    'session_rating_tag_excellent',
    'session_rating_tag_helpful',
    'session_rating_tag_clear',
    'session_rating_tag_patient',
    'session_rating_tag_skilled',
    'session_rating_tag_inspiring',
    'session_rating_tag_organized',
    'session_rating_tag_interactive',
  ];

  @override
  void initState() {
    super.initState();
    _loadSessionDetails();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _loadSessionDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final session = await SessionsService.getSessionById(widget.sessionId);
      setState(() {
        _session = session;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'session_details_error'.tr();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'session_rating_title'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadSessionDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
            ),
            child: Text('sessions_retry'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_session == null) return const SizedBox();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with tutor info
          _buildHeader(),

          // Rating section
          _buildRatingSection(),

          // Tags section
          // _buildTagsSection(),

          // Feedback section
          _buildFeedbackSection(),

          // Submit button
          _buildSubmitButton(),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Tutor image
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withOpacity(0.2),
              backgroundImage: _session!.tutorImageUrl.isNotEmpty
                  ? NetworkImage(_session!.tutorImageUrl)
                  : null,
              child: _session!.tutorImageUrl.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white.withOpacity(0.7),
                    )
                  : null,
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              'session_rating_question'.tr(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Tutor name and session type
            Text(
              '${'session_rating_with'.tr()} ${_session!.tutorName}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

            Text(
              _session!.typeDisplayName,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'session_rating_rate_session'.tr(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),

          const SizedBox(height: 24),

          // Star rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 40,
                    color: Colors.amber,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          // Rating description
          if (_rating > 0)
            Text(
              _getRatingDescription(_rating),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  // Widget _buildTagsSection() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 8,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'session_rating_what_liked'.tr(),
  //           style: const TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //             color: Color(0xFF2E7D32),
  //           ),
  //         ),

  //         const SizedBox(height: 16),

  //         Wrap(
  //           spacing: 8,
  //           runSpacing: 8,
  //           children: _availableTags.map((tag) {
  //             final isSelected = _selectedTags.contains(tag);
  //             return GestureDetector(
  //               onTap: () {
  //                 setState(() {
  //                   if (isSelected) {
  //                     _selectedTags.remove(tag);
  //                   } else {
  //                     _selectedTags.add(tag);
  //                   }
  //                 });
  //               },
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 16,
  //                   vertical: 8,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: isSelected
  //                       ? const Color(0xFF2E7D32)
  //                       : Colors.grey[100],
  //                   borderRadius: BorderRadius.circular(20),
  //                   border: Border.all(
  //                     color: isSelected
  //                         ? const Color(0xFF2E7D32)
  //                         : Colors.grey[300]!,
  //                   ),
  //                 ),
  //                 child: Text(
  //                   tag,
  //                   style: TextStyle(
  //                     color: isSelected ? Colors.white : Colors.grey[700],
  //                     fontWeight: isSelected
  //                         ? FontWeight.bold
  //                         : FontWeight.normal,
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFeedbackSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'session_rating_feedback_title'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'session_rating_feedback_subtitle'.tr(),
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: _feedbackController,
            maxLines: 4,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: 'session_rating_feedback_placeholder'.tr(),
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final canSubmit = _rating > 0 && !_isSubmitting;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canSubmit ? _submitRating : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[600],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'session_rating_submit'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  String _getRatingDescription(int rating) {
    switch (rating) {
      case 1:
        return 'session_rating_level_very_poor'.tr();
      case 2:
        return 'session_rating_level_poor'.tr();
      case 3:
        return 'session_rating_level_acceptable'.tr();
      case 4:
        return 'session_rating_level_good'.tr();
      case 5:
        return 'session_rating_level_excellent'.tr();
      default:
        return '';
    }
  }

  Future<void> _submitRating() async {
    if (_rating == 0) {
      Fluttertoast.showToast(
        msg: 'session_rating_select_rating'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final ratingModel = SessionRatingModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sessionId: widget.sessionId,
        studentId:
            Supabase.instance.client.auth.currentUser?.id ?? 'unknown_student',
        tutorId: _session!.tutorId,
        rating: _rating.toDouble(),
        feedback: _feedbackController.text.trim().isNotEmpty
            ? _feedbackController.text.trim()
            : null,
        tags: _selectedTags.isNotEmpty ? _selectedTags : null,
        createdAt: DateTime.now(),
      );

      await SessionsService.submitSessionRating(ratingModel);

      // Show success message
      Fluttertoast.showToast(
        msg: 'session_rating_success'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigate back
      Navigator.pop(context, true);
    } catch (e) {
      Fluttertoast.showToast(
        msg: '${'session_rating_error'.tr()}: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
