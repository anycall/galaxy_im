import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Helper/RouteManager.dart';
import 'package:galaxy_im/Pages/Home/home.dart';
import 'package:galaxy_im/Pages/Login/login.dart';
import 'package:get/get.dart';
import 'Helper/LocalizationService.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Helper.localizationService.init();
  await Helper.themeManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(Helper.localizationService);
    initialization();
    return ScreenUtilInit(
      ensureScreenSize: true,
      child: GetMaterialApp(
        title: 'Galaxy IM',
        theme: ThemeData(
          colorScheme: Helper.themeManager.currentColorScheme,
          textTheme: TextTheme(labelMedium: TextStyle(fontSize: Helper.themeManager.currentFontSizeStyle.subtitleFontSize)),
          useMaterial3: true,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.initial,
        getPages: AppPages.pages,
        locale: Helper.localizationService.currentLocale,
        translations: LocationService(),
        translationsKeys: LocationService().keys,
        home: const LoginPage(),
      ),
    );
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }
}
