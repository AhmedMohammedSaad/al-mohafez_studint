import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/daily_content_cubit.dart';
import '../cubit/daily_content_state.dart';
import '../widgets/video_card.dart';
import '../../../../core/utils/admin_video_seeder.dart';

class DailyContentListScreen extends StatefulWidget {
  const DailyContentListScreen({super.key});

  @override
  State<DailyContentListScreen> createState() => _DailyContentListScreenState();
}

class _DailyContentListScreenState extends State<DailyContentListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<DailyContentCubit>().loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Slightly off-white for premium feel
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'غذاء الروح',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        actions: [
          SizedBox(width: 8.w),
          // Admin Seeder removed from UI as requested/implied clean up
        ],
      ),
      body: BlocBuilder<DailyContentCubit, DailyContentState>(
        builder: (context, state) {
          if (state.status == DailyContentStatus.loading &&
              state.videos.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state.status == DailyContentStatus.failure &&
              state.videos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'حدث خطأ ما'),
                  SizedBox(height: 16.h),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      context.read<DailyContentCubit>().fetchDailyContent(
                        refresh: true,
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          } else if (state.videos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.ondemand_video_outlined,
                    size: 64.sp,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'لا توجد مقاطع حالياً',
                    style: TextStyle(color: Colors.grey[500], fontSize: 16.sp),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                    ),
                    onPressed: () {
                      context.read<DailyContentCubit>().fetchDailyContent(
                        refresh: true,
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('تحديث المحتوى'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              await context.read<DailyContentCubit>().fetchDailyContent(
                refresh: true,
              );
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: state.hasReachedMax
                  ? state.videos.length
                  : state.videos.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.videos.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                }
                // Add animation
                return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: VideoCard(video: state.videos[index]),
                    )
                    .animate()
                    .fade(duration: 400.ms)
                    .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad);
              },
            ),
          );
        },
      ),
    );
  }
}
