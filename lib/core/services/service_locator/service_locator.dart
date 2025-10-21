// import 'package:almohafez/features/location/data/remote/location_data_source.dart';
// import 'package:almohafez/features/notifications/data/remote/notifications_data_source.dart'
//     show NotificationsDataSource;
// import 'package:almohafez/features/onboarding/data/remote/onboarding_data_source.dart';

// import "package:almohafez/features/onboarding/data/repository/onboarding_repository.dart";
// import 'package:almohafez/features/order/data/remote/order_data_source.dart';
// import 'package:almohafez/features/profile/data/remote/profile_data_source.dart';
// import 'package:almohafez/features/search/data/remote/search_data_source.dart';
// import 'package:almohafez/features/auth/data/remote/auth_data_source.dart';
// import 'package:almohafez/features/auth/data/repository/auth_repository.dart';
// import 'package:almohafez/features/auth/presentation/view_model/auth_cubit.dart';
// import 'package:almohafez/features/bookings/data/remote/booking_data_source.dart';
// import 'package:almohafez/features/bookings/data/repository/booking_repository.dart';
// import 'package:almohafez/features/bookings/presentation/view_model/booking_cubit.dart';
// import 'package:almohafez/features/favourite/data/remote/favourite_data_source.dart';
// import 'package:almohafez/features/favourite/data/repository/favourite_repository.dart';
// import 'package:almohafez/features/favourite/presentation/view_model/favourite_cubit.dart';
// import 'package:almohafez/features/home/data/remote/home_data_source.dart';
// import 'package:almohafez/features/home/data/repository/home_repositoey.dart';
// import 'package:almohafez/features/home/presentation/view_model/home_cubit.dart';

// import 'package:almohafez/features/location/data/repository/location_repository.dart'
//     show LocationRepository;
// import 'package:almohafez/features/location/presentation/view_model/location_cubit.dart';
// import 'package:almohafez/features/notifications/data/repository/notifications_repository.dart';
// import 'package:almohafez/features/notifications/presentation/view_model/notifications_cubit.dart';
// import 'package:almohafez/features/onboarding/presentation/view_model/onboarding_cubit.dart';
// import 'package:almohafez/features/order/data/repository/order_repository.dart';
// import 'package:almohafez/features/order/presentation/view_model/order_cubit.dart';
// import 'package:almohafez/features/profile/data/repository/profile_repository.dart';
// import 'package:almohafez/features/profile/presentation/view_model/profile_cubit.dart';
// import 'package:almohafez/features/search/data/repository/search_repository.dart';
// import 'package:almohafez/features/search/presentation/view_model/bloc/search_bloc.dart';
// import 'package:almohafez/features/settings/data/remote/settings_data_source.dart';
// import 'package:almohafez/features/settings/data/repository/settings_repository.dart';
// import 'package:almohafez/features/settings/presentation/view_model/setting_cubit.dart';

// import 'package:get_it/get_it.dart';

// import '../../data/network/web_service/api_service.dart';
// import '../../presentation/view_model/cubit/app_cubit.dart';

// final sl = GetIt.instance;

// class ServiceLocator {
//   static void init() {
//     /// Core / External Dependencies
//     sl.registerLazySingleton<AppDio>(() => AppDio());

//     /// cubit / bloc --> sl.registerFactory(() => );
//     sl.registerFactory(() => AppCubit());
//     sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));
//     sl.registerFactory<BookingCubit>(
//       () => BookingCubit(sl<BookingRepository>()),
//     );
//     sl.registerFactory<FavouriteCubit>(
//       () => FavouriteCubit(sl<FavouriteRepository>()),
//     );
//     sl.registerFactory<HomeCubit>(() => HomeCubit(sl<HomeRepository>()));
//     sl.registerFactory<LocationCubit>(
//       () => LocationCubit(sl<LocationRepository>()),
//     );
//     sl.registerFactory<NotificationsCubit>(
//       () => NotificationsCubit(sl<NotificationsRepository>()),
//     );
//     sl.registerFactory<OnboardingCubit>(
//       () => OnboardingCubit(sl<OnboardingRepository>()),
//     );
//     sl.registerFactory<OrderCubit>(() => OrderCubit(sl<OrderRepository>()));
//     sl.registerFactory<ProfileCubit>(
//       () => ProfileCubit(sl<ProfileRepository>()),
//     );
//     sl.registerFactory<SearchBloc>(() => SearchBloc(sl<SearchRepository>()));
//     sl.registerFactory<SettingsCubit>(
//       () => SettingsCubit(sl<SettingsRepository>()),
//     );

//     ///repositories --> sl.registerLazySingleton<>(() => );
//     sl.registerLazySingleton<AuthRepository>(
//       () => AuthRepository(sl<AuthDataSource>()),
//     );
//     sl.registerLazySingleton<BookingRepository>(
//       () => BookingRepository(sl<BookingDataSource>()),
//     );
//     sl.registerLazySingleton<FavouriteRepository>(
//       () => FavouriteRepository(sl<FavouriteDataSource>()),
//     );
//     sl.registerLazySingleton<HomeRepository>(
//       () => HomeRepository(sl<HomeDataSource>()),
//     );
//     sl.registerLazySingleton<LocationRepository>(
//       () => LocationRepository(sl<LocationsDataSource>()),
//     );
//     sl.registerLazySingleton<NotificationsRepository>(
//       () => NotificationsRepository(sl<NotificationsDataSource>()),
//     );
//     sl.registerLazySingleton<OnboardingRepository>(
//       () => OnboardingRepository(sl<OnboardingDataSource>()),
//     );
//     sl.registerLazySingleton<OrderRepository>(
//       () => OrderRepository(sl<OrderDataSource>()),
//     );
//     sl.registerLazySingleton<ProfileRepository>(
//       () => ProfileRepository(sl<ProfileDataSource>()),
//     );
//     sl.registerLazySingleton<SearchRepository>(
//       () => SearchRepository(sl<SearchDataSource>()),
//     );
//     sl.registerLazySingleton<SettingsRepository>(
//       () => SettingsRepository(sl<SettingsDataSource>()),
//     );

//     ///data source --> sl.registerLazySingleton<>(() => );
//     sl.registerLazySingleton<AuthDataSource>(
//       () => AuthDataSource(apiClient: sl<AppDio>()),
//     );
//     sl.registerLazySingleton<BookingDataSource>(
//       () => BookingDataSource(apiClient: sl<AppDio>()),
//     );
//     sl.registerLazySingleton<FavouriteDataSource>(
//       () => FavouriteDataSource(apiClient: sl<AppDio>()),
//     );
//     sl.registerLazySingleton<HomeDataSource>(
//       () => HomeDataSource(apiClient: sl<AppDio>()),
//     );
//     sl.registerLazySingleton<LocationsDataSource>(
//       () => LocationsDataSource(apiClient: sl<AppDio>()),
//     );
//     sl.registerLazySingleton<NotificationsDataSource>(
//       () => NotificationsDataSource(apiClient: sl<AppDio>()),
//     );
//     sl.registerLazySingleton<OnboardingDataSource>(
//       () => OnboardingDataSource(apiClient: sl<AppDio>()),
//     );
//     sl.registerLazySingleton<OrderDataSource>(
//       () => OrderDataSource(apiClient: sl<AppDio>()),
//     );
//     sl.registerLazySingleton<ProfileDataSource>(
//       () => ProfileDataSource(apiClient: sl<AppDio>()),
//     );
//     sl.registerLazySingleton<SearchDataSource>(
//       () => SearchDataSource(apiClient: sl<AppDio>()),
//     );
//     sl.registerLazySingleton<SettingsDataSource>(
//       () => SettingsDataSource(apiClient: sl<AppDio>()),
//     );
//   }
//  }
