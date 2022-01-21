// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:getfitappmobile/pages/home_view.dart';
import 'package:getfitappmobile/view/adminerrorpage.dart';
import '../core.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.WELCOME;
  static const INITIALIFSAVEDCREDENTIALS = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.WELCOME,
      page: () => const WelcomeView(),
    ),
    GetPage(
      name: Routes.ABOUT,
      page: () => const AboutView(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
    ),
    GetPage(
      name: Routes.FORGET_PASSWORD,
      page: () => ForgetPassword(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
    ),
    GetPage(
      name: Routes.ADMINERRORPAGE,
      page: () => Error404Screen(),
    )
  ];
}
