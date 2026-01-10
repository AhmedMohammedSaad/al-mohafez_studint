import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/daily_content_cubit.dart';
import '../cubit/daily_content_state.dart';
import '../widgets/video_card.dart';

class DailyContentListScreen extends StatefulWidget {
  const DailyContentListScreen({super.key});

  @override
  State<DailyContentListScreen> createState() => _DailyContentListScreenState();
}

class _DailyContentListScreenState extends State<DailyContentListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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

  bool _isSearching = false;

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
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'ابحث عن...',
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[400],
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    context.read<DailyContentCubit>().searchContent(query);
                  }
                },
              )
            : Text(
                'غذاء الروح',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: AppColors.primary,
              size: 26.sp,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  // Optional: Reset search to default feed when closing?
                  // For now, let's keep the results or maybe reload feed?
                  // context.read<DailyContentCubit>().fetchDailyContent();
                }
              });
            },
          ),
          SizedBox(width: 8.w),
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
            return Center(child: Text(state.errorMessage ?? 'حدث خطأ ما'));
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
