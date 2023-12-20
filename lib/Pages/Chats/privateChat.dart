import 'package:flutter/material.dart';
import 'package:galaxy_im/Pages/Widget/WidgetFactory.dart';

class PrivateChatPage extends StatefulWidget {
  const PrivateChatPage({super.key});

  @override
  State<PrivateChatPage> createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: WidgetFactory().buildAppBarLine(),
        title: const Text('单聊'),
        leading: WidgetFactory().buildAppBarBackButton(context),
      ),
      body: const Center(),
    );
  }
}