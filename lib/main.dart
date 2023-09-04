import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Helper/RouteManager.dart';
import 'package:galaxy_im/Pages/Home/home.dart';
import 'package:galaxy_im/Pages/Login/login.dart';
import 'package:get/get.dart';
import 'Helper/LocalizationService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Helper.localizationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(Helper.localizationService);

    return GetMaterialApp(
      title: 'Galaxy IM',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        useMaterial3: false,
      ),
      initialRoute: Routes.initial,
      getPages: AppPages.pages,
      locale: Helper.localizationService.currentLocale,
      translations: LocationService(),
      translationsKeys: LocationService().keys,
      home: const LoginPage(),
    );
  }
}
