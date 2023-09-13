import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Helper/ThemeManager.dart';
import 'package:get/get.dart';

class FontPage extends StatefulWidget {
  const FontPage({super.key});

  @override
  State<FontPage> createState() => _FontPageState();
}

class _FontPageState extends State<FontPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.25),
          child: Container(
            color: Colors.grey,
            height: 0.25,
          ),
        ),
        title: Text('font'.tr, style: TextStyle(fontSize: Helper.titleFontSize),),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Helper.themeManager.updateFontSize(FontSize.small);
              },
              child: Text("小"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Helper.themeManager.updateFontSize(FontSize.standard);
              },
              child: Text("标准"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Helper.themeManager.updateFontSize(FontSize.large);
              },
              child: Text("大"),
            ),
          ],
        ),
      ),
    );
  }
}