import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Pages/Widget/WidgetFactory.dart';
import 'package:get/get.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: WidgetFactory().buildAppBarLine(),
        title: Text('contacts'.tr, style: TextStyle(fontSize: Helper.titleFontSize),),
      ),
      body: Center(),
    );
  }
}
