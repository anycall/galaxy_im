import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Pages/Widget/WidgetFactory.dart';
import 'package:get/get.dart';

class SkinPage extends StatefulWidget {
  const SkinPage({super.key});

  @override
  State<SkinPage> createState() => _SkinPageState();
}

class _SkinPageState extends State<SkinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: WidgetFactory().buildAppBarLine(),
        title: Text('skin'.tr, style: TextStyle(fontSize: Helper.titleFontSize),),
        leading: WidgetFactory().buildAppBarBackButton(context),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Helper.themeManager.updateColorScheme(true);
              },
              child: const Text("自动"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Helper.themeManager.updateColorScheme(false,
                    colorScheme: const ColorScheme.light(onSecondary: Colors.blue));
              },
              child: const Text("白天"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Helper.themeManager.updateColorScheme(false,
                    colorScheme: const ColorScheme.dark(onSecondary: Colors.blue));
              },
              child: const Text("黑天"),
            ),
          ],
        ),
      ),
    );
  }
}
