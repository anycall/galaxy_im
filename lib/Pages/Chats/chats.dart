import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Pages/Widget/WidgetFactory.dart';
import 'package:get/get.dart';

class Conversations extends StatefulWidget {
  const Conversations({super.key});

  @override
  State<Conversations> createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: WidgetFactory().buildAppBarLine(),
        title: Text(
          'chats'.tr,
          style: TextStyle(fontSize: Helper.titleFontSize),
        ),
      ),
      body: Center(),
    );
  }
}
