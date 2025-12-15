// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//  import 'package:go_router/go_router.dart';
// import 'package:nb_utils/nb_utils.dart';
// import '../../../../gen/fonts.gen.dart';
// import '../../../routing/app_route.dart';
// import '../../../utils/app_consts.dart';
// import 'app_state.dart';

// class AppCubit extends Cubit<AppState> {
//   AppCubit() : super(const InitState());

//   static AppCubit get(context, {bool listen = false}) => BlocProvider.of<AppCubit>(context, listen: listen);
//   int _currentIndex = 0;

//   int get currentIndex => _currentIndex;

//   set currentIndex(int value) {
//     _currentIndex = value;
//     emit(const ChangeCurrentIndexState());
//   }

//   String _currentFontFamily = FontFamily.roboto;

//   String get currentFontFamily => _currentFontFamily;

//   void changeFontFamily({required String fontFamily}) {
//     _currentFontFamily = fontFamily;
//     emit(const ChangeFontState());
//   }

//   void navToMain({required BuildContext context, required int pageIndex}) {
//     _currentIndex = pageIndex;
//     context.go(AppRouter.kInitial);
//   }

//   void changeCurrentIndex({required int index}) {
//     _currentIndex = index;

//     emit(const ChangeCurrentIndexState());
//   }

//   void changeTheme({required bool value}) {
//     AppConst.isDark = value;
//     setValue('isDark', value);

//     emit(const ChangeThemeState());
//   }

//   void changeLang({
//     required BuildContext context,
//     required Locale locale,
//   }) {
//     context.setLocale(locale);
//     emit(const ChangeLanguageState());
//   }

//   void refresh() {
//     emit(const RefreshState());
//   }
// }
