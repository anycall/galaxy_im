import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/RouteManager.dart';
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
        title: Text('me'.tr),
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
          ],
        ),
      ),
    );
  }
}
