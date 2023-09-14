import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Helper/RouteManager.dart';
import 'package:galaxy_im/Pages/Chats/chats.dart';
import 'package:galaxy_im/Pages/Contacts/contacts.dart';
import 'package:galaxy_im/Pages/Me/me.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as BDG;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RestorationMixin {
  final RestorableInt _currentIndex = RestorableInt(0);

  int _unreadCount = 0; //未读消息数
  int _friendRequestCount = 0; //好友请求数

  var pages = <Widget>[
    const Conversations(),
    const Contacts(),
    const Me(),
  ];

  @override
  String get restorationId => Routes.home;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_currentIndex, 'bottom_navigation_tab_index');
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    var bottomNavigationBarItems = <BottomNavigationBarItem>[
      _buildBottomNavigationBarItem(
          Icons.chat_outlined, Icons.chat, 'chats', _unreadCount),
      _buildBottomNavigationBarItem(Icons.contacts_outlined, Icons.contacts,
          'contacts', _friendRequestCount),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outlined),
        activeIcon: const Icon(Icons.person),
        label: 'me'.tr,
      ),
    ];

    return Scaffold(
      body: Center(
        child: pages[_currentIndex.value],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.25,
            ),
          ),
        ),
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          items: bottomNavigationBarItems,
          currentIndex: _currentIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: textTheme.bodySmall!.fontSize!,
          unselectedFontSize: textTheme.bodySmall!.fontSize!,
          onTap: (index) {
            setState(() {
              _currentIndex.value = index;
            });
          },
          selectedIconTheme: IconThemeData(
            color: colorScheme.onBackground,
          ),
          selectedItemColor: colorScheme.onBackground,
          unselectedItemColor: Colors.grey,
          backgroundColor: colorScheme.inversePrimary,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData iconData, IconData activeIconData, String label, int count) {
    return BottomNavigationBarItem(
      icon: RepaintBoundary(
        child: BDG.Badge(
          showBadge: count > 0,
          badgeAnimation: const BDG.BadgeAnimation.rotation(),
          badgeContent: Text(
            count.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          child: Icon(iconData),
        ),
      ),
      activeIcon: RepaintBoundary(
        child: BDG.Badge(
          showBadge: count > 0,
          badgeAnimation: const BDG.BadgeAnimation.rotation(),
          badgeContent: Text(
            count.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          child: Icon(activeIconData),
        ),
      ),
      label: label.tr,
    );
  }
}



