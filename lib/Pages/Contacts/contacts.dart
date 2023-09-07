import 'package:flutter/material.dart';
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
        title: Text('contacts'.tr),
      ),
      body: Center(),
    );
  }
}
