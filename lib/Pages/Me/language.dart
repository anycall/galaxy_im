import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Pages/Widget/WidgetFactory.dart';
import 'package:get/get.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        bottom: WidgetFactory.buildAppBarLine(),
        title: Text(
          'language'.tr,
          style: TextStyle(fontSize: Helper.titleFontSize),
        ),
        leading: WidgetFactory.buildAppBarBackButton(context),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Helper.localizationService.setLocale('zh');
                Get.updateLocale(const Locale('zh'));
              },
              child: const Text("简体中文"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Helper.localizationService.setLocale('en');
                Get.updateLocale(const Locale('en'));
              },
              child: const Text("English"),
            ),
          ],
        ),
      ),
    );
  }
}
