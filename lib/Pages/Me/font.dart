import 'package:flutter/material.dart';
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
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.25),
          child: Container(
            color: Colors.grey,
            height: 0.25,
          ),
        ),
        title: Text('font'.tr),
      ),
      body: Center(),
    );
  }
}