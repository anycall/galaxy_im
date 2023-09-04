

import 'package:galaxy_im/Pages/Home/home.dart';
import 'package:galaxy_im/Pages/Login/login.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

abstract class Routes {
  static const initial = '/';
  static const home = '/home';
  static const login = '/login';
}

abstract class AppPages{
  static final pages = [
    GetPage(name: Routes.initial, page: () => const HomePage()),
    GetPage(name: Routes.home, page: () => const HomePage()),
    GetPage(name: Routes.login, page: () => const LoginPage()),
  ];
}