import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/RouteManager.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('galaxy'.tr),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
            onPressed: () async {
              Get.toNamed(Routes.login);
            },
            child: Text("下一页"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.home);
            },
            child: Text("登陆"),
          ),
          ],
        ),
      ),
    );
  }
}