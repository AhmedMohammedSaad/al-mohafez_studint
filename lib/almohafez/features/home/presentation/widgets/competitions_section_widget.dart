import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/repositories/competitions_repo.dart';
import '../cubit/competitions_cubit.dart';
import '../cubit/competitions_state.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CompetitionsSectionWidget extends StatelessWidget {
  const CompetitionsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CompetitionsCubit(CompetitionsRepo(Supabase.instance.client))
            ..loadCurrentCompetition(),
      child: const _CompetitionsContent(),
    );
  }
}

class _CompetitionsContent extends StatelessWidget {
  const _CompetitionsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          [
                Text(
                  'current_competitions'.tr(),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0A1D64),
                  ),
                ),
                SizedBox(height: 12.h),
                BlocBuilder<CompetitionsCubit, CompetitionsState>(
                  builder: (context, state) {
                    if (state is CompetitionsLoading) {
                      return _buildLoadingCard();
                    }

                    if (state is CompetitionsError) {
                      return _buildErrorCard(context, state.message);
                    }

                    if (state is CompetitionsLoaded) {
                      if (state.competition == null) {
                        return _buildEmptyCard();
                      }
                      return _buildCompetitionCard(context, state.competition!);
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ]
              .animate()
              .slideX(begin: 1, duration: 600.ms, curve: Curves.easeInOut)
              .fadeIn(duration: 600.ms),
    );
  }

  Widget _buildLoadingCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 140.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      height: 160.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.grey[200],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              TextButton.icon(
                onPressed: () {
                  context.read<CompetitionsCubit>().loadCurrentCompetition();
                },
                icon: const Icon(Icons.refresh),
                label: Text('retry'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      width: double.infinity,
      height: 140.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 40.sp,
              color: Colors.white54,
            ),
            SizedBox(height: 8.h),
            Text(
              'no_competitions'.tr(),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16.sp,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompetitionCard(BuildContext context, dynamic competition) {
    return GestureDetector(
      onTap: () async {
        if (competition.hasLink) {
          final uri = Uri.parse(competition.link!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: 140.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C43C6).withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              // Gradient Background
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF667EEA),
                      Color(0xFF764BA2),
                      Color(0xFFF093FB),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // Decorative circles
              Positioned(
                top: -30.h,
                right: -30.w,
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -20.h,
                left: -20.w,
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  children: [
                    // Left side - Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Competition name
                          Text(
                            competition.name,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 12.h),
                          // Button
                          if (competition.hasLink)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'view_details'.tr(),
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF764BA2),
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12.sp,
                                    color: const Color(0xFF764BA2),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Right side - Trophy icon
                    Container(
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        size: 35.sp,
                        color: Colors.white,
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
  }
}
