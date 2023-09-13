import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/Helper.dart';
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.25),
          child: Container(
            color: Colors.grey,
            height: 0.25,
          ),
        ),
        title: Text('skin'.tr, style: TextStyle(fontSize: Helper.titleFontSize),),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Helper.themeManager.updateColorScheme(true);
              },
              child: Text("自动"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Helper.themeManager.updateColorScheme(false,
                    colorScheme: const ColorScheme.light());
              },
              child: Text("白天"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Helper.themeManager.updateColorScheme(false,
                    colorScheme: const ColorScheme.dark());
              },
              child: Text("黑天"),
            ),
          ],
        ),
      ),
    );
  }
}
