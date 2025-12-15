import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../../routing/app_route.dart';
import '../../../services/navigation_service/global_navigation_service.dart';
import '../../../utils/app_consts.dart';
import '../../../utils/urls.dart';
import '../../local_data/caching_helper.dart';
import 'api_service.dart';

class DioService {
  DioService._() {
    _dio = Dio();
    _initializeDio();
  }

  static DioService? _instance;
  late Dio _dio;

  void _initializeDio() {
    final BaseOptions baseOptions = BaseOptions(
      baseUrl: Urls.baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    );

    _dio.options = baseOptions;

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: false,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          if (e.response?.statusCode == 403) {
            AppConst.accessToken = '';
            AppConst.refreshToken = '';
            await AppCacheHelper.deleteSecureCache(
              key: AppCacheHelper.accessTokenKey,
            );
            await AppCacheHelper.deleteSecureCache(
              key: AppCacheHelper.refreshTokenKey,
            );
            AppCacheHelper.deleteCache(key: AppCacheHelper.accessTokenKey);
            AppCacheHelper.deleteCache(key: AppCacheHelper.refreshTokenKey);
            NavigationService.goTo(AppRouter.kInitial);
            return handler.reject(e);
          }
          return handler.next(e);
        },
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          if (e.response?.statusCode == 401) {
            final newToken = await refreshToken();
            if (newToken != null) {
              final options = e.requestOptions;
              options.headers['Authorization'] = 'Bearer $newToken';
              final cloneReq = await _dio.request(
                options.path,
                options: Options(
                  method: options.method,
                  headers: options.headers,
                ),
                data: options.data,
                queryParameters: options.queryParameters,
              );
              return handler.resolve(cloneReq);
            } else {
              NavigationService.goTo(AppRouter.kInitial);
              return handler.reject(e);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  static DioService get instance {
    _instance ??= DioService._();
    return _instance!;
  }

  static Dio get dio => instance._dio;

  Future<Map<String, String>> getHeaders({bool withToken = true}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (withToken) {
      final token = await AppCacheHelper.getSecureString(
        key: AppCacheHelper.accessTokenKey,
      );

      if (token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<Response> sendRequest({
    required String method,
    required String path,
    dynamic data,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParams,
        options: Options(
          method: method,
          headers: headers ?? await getHeaders(),
        ),
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<dynamic> refreshToken() async {
    final refreshToken = await AppCacheHelper.getSecureString(
      key: AppCacheHelper.refreshTokenKey,
    );

    // final response = await AppDio().get(path: Urls.accessToken, headers: {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Bearer ${AppConst.refreshToken}',
    // });
    final response = await AppDio().post(
      path: Urls.accessToken,
      data: {"refresh": refreshToken},
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshToken',
      },
    );
    AppConst.accessToken = response.data['access'] ?? '';
    await AppCacheHelper.cacheSecureString(
      key: AppCacheHelper.accessTokenKey,
      value: AppConst.accessToken,
    );
    return AppConst.accessToken;
  }
}
