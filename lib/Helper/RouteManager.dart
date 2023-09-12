/// RouteManager.dart
///
/// 1.push:
///   Get.toNamed(Routes.login); //跳转到登陆页
///   Get.offNamed(Routes.login); //跳转到登陆页,并销毁当前页面
///   Get.offAllNamed(Routes.login); //跳转到登陆页,并销毁之前所有页面
///
/// 2.pop:
///   Get.back(); //返回上一页
///   Get.until((route) => route.settings.name == Routes.login); //返回到指定路由页面
///
/// 3.传参:
///   Get.toNamed(Routes.login, arguments: {'id': 123}); //跳转并传递参数。登录页取值：Get.arguments['id']
///   Get.back(result: {'id': 123}); //返回并传递参数。上一页取值：final result = await Get.toNamed(Routes.login); 对应result['id']

import 'package:galaxy_im/Pages/Home/home.dart';
import 'package:galaxy_im/Pages/Login/login.dart';
import 'package:galaxy_im/Pages/Me/font.dart';
import 'package:galaxy_im/Pages/Me/skin.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

abstract class Routes {
  static const initial = '/';
  static const home = '/home';
  static const login = '/login';
  static const skin = '/skin';
  static const font = '/font';
}

abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.initial, page: () => const LoginPage()),
    GetPage(name: Routes.home, page: () => const HomePage()),
    GetPage(name: Routes.login, page: () => const LoginPage()),
    GetPage(name: Routes.skin, page: () => const SkinPage()),
    GetPage(name: Routes.font, page: () => const FontPage()),
  ];
}
