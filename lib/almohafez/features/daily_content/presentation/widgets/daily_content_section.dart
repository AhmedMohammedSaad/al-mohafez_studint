import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/daily_content_remote_datasource.dart';
import '../../data/repositories/daily_content_repo_impl.dart';
import '../../domain/usecases/get_daily_content_usecase.dart';
import '../cubit/daily_content_cubit.dart';
import '../cubit/daily_content_state.dart';
import '../screens/daily_content_list_screen.dart';
import 'video_card.dart';

class DailyContentSection extends StatelessWidget {
  const DailyContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DailyContentCubit(
        GetDailyContentUseCase(
          DailyContentRepositoryImpl(
            remoteDataSource: DailyContentRemoteDataSourceImpl(
              supabaseClient: Supabase.instance.client,
            ),
          ),
        ),
      )..fetchDailyContent(),
      child: BlocBuilder<DailyContentCubit, DailyContentState>(
        builder: (context, state) {
          // Always show the header if it's not loading initially, or handle loading state gracefully
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'غذاء الروح',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    if (state.videos.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          // Create a NEW Cubit for the full list screen to handle independent pagination
                          // without affecting the horizontal widget state.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => DailyContentCubit(
                                  GetDailyContentUseCase(
                                    DailyContentRepositoryImpl(
                                      remoteDataSource:
                                          DailyContentRemoteDataSourceImpl(
                                            supabaseClient:
                                                Supabase.instance.client,
                                          ),
                                    ),
                                  ),
                                )..fetchAllContent(), // Fetch FULL list with pagination
                                child: const DailyContentListScreen(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'عرض الكل',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              if (state.status == DailyContentStatus.loading &&
                  state.videos.isEmpty)
                _buildShimmerLoadingBody()
              else if (state.videos.isEmpty)
                Container(
                  height: 200.h,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.ondemand_video_outlined,
                        size: 48.sp,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 12.h),
                      TextButton.icon(
                        onPressed: () {
                          context.read<DailyContentCubit>().fetchDailyContent(
                            refresh: true,
                          );
                        },
                        icon: Icon(Icons.refresh, color: AppColors.primary),
                        label: Text(
                          'تحديث لعرض الفيديوهات',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  height: 240.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: state.videos.length > 5
                        ? 5
                        : state.videos.length,
                    itemBuilder: (context, index) {
                      return VideoCard(video: state.videos[index]);
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 100.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
        _buildShimmerLoadingBody(),
      ],
    );
  }

  Widget _buildShimmerLoadingBody() {
    return SizedBox(
      height: 240.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 200.w,
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          );
        },
      ),
    );
  }
}
