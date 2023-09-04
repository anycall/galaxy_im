import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Helper/RouteManager.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${'galaxy'.tr} IM Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'titleIs'.tr,
            ),
            Text(
              'galaxy'.tr,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
            onPressed: () {
              Get.until((route) => route.settings.name == Routes.initial);
            },
            child: Text("返回登陆页"),
          ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              Helper.localizationService.setLocale('zh');
              Get.updateLocale(const Locale('zh'));
            },
            child: Text("中文"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Helper.localizationService.setLocale('en');
              Get.updateLocale(const Locale('en'));
            },
            child: Text("English"),
          ),
        ],
      ),
    );
  }
}
