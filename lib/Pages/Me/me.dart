import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Helper/RouteManager.dart';
import 'package:galaxy_im/Pages/Widget/WidgetFactory.dart';
import 'package:get/get.dart';

class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => _MeState();
}

class _MeState extends State<Me> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: WidgetFactory().buildAppBarLine(),
        title: Text(
          'me'.tr,
          style: TextStyle(fontSize: Helper.titleFontSize),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.skin);
              },
              child: Text("皮肤"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.font);
              },
              child: Text("字号"),
            ),
          ],
        ),
      ),
    );
  }
}
