import 'package:get/get.dart';

import '../features/splash_screen/presentation/screens/splash_screen.dart';

class AppRoute {
  static String init = "/";
  static String loginScreen = "/loginScreen";
  static String signUpScreen = "/signUpScreen";



  static List<GetPage> routes = [
    GetPage(name: init, page: () => const SplashScreen()),
  ];
}