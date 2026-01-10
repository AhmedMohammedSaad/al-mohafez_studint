import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:dio/dio.dart';
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
            remoteDataSource: DailyContentRemoteDataSourceImpl(dio: Dio()),
          ),
        ),
      )..fetchDailyContent(),
      child: BlocBuilder<DailyContentCubit, DailyContentState>(
        builder: (context, state) {
          if (state.status == DailyContentStatus.success) {
            if (state.videos.isEmpty) return const SizedBox.shrink();

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
                      TextButton(
                        onPressed: () {
                          // Pass the EXISTING Cubit to the new screen
                          final cubit = context.read<DailyContentCubit>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: cubit,
                                child: const DailyContentListScreen(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'عرض الكل', // Show All
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
          } else if (state.status == DailyContentStatus.loading) {
            return _buildShimmerLoading();
          }
          return const SizedBox.shrink();
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
        SizedBox(
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
        ),
      ],
    );
  }
}
