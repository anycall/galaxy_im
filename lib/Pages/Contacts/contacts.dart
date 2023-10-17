import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Models/ContactModel.dart';
import 'package:galaxy_im/Models/JsonGenerator.dart';
import 'package:galaxy_im/Pages/Contacts/Widget/ContactsWidget.dart';
import 'package:galaxy_im/Pages/Widget/WidgetFactory.dart';
import 'package:galaxy_im/Pages/Widget/azlistview/azlistview.dart';
import 'package:galaxy_im/Pages/Widget/material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:galaxy_im/Pages/Widget/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:get/get.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:lpinyin/lpinyin.dart';

//搜索框高度 55
const double kSearchBarHeight = 50;

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final FloatingSearchBarController _searchBarController =
      FloatingSearchBarController();
  bool showAppBarLine = false;
  List<ContactModel> _topList = [];
  List<ContactModel> _contactList = [];
  List<User> _searchList = [];
  List<ContactModel> _AllList = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
    itemPositionsListener.itemPositions.addListener(_onScroll);
  }

  void _onScroll() {
    bool newfrienCellIsVisible = false;
    for (var element in itemPositionsListener.itemPositions.value) {
      if (element.index == 0) {
        newfrienCellIsVisible = true;
        break; // 当满足条件时跳出循环
      }
    }
    if (!newfrienCellIsVisible && !showAppBarLine) {
      setState(() {
        _searchBarController.hide();
        showAppBarLine = true;
      });
    } else if (newfrienCellIsVisible && showAppBarLine) {
      setState(() {
        showAppBarLine = false;
        _searchBarController.show();
      });
    }
  }

  void _loadUsers() {
    JsonArrayGenerator jsonArrayGenerator = JsonArrayGenerator();
    String randomJsonArray =
        jsonArrayGenerator.generateRandomUserJsonArray(100);
    final contacts = (jsonDecode(randomJsonArray) as List).map((e) {
      var user = User.fromJson(e as Map<String, dynamic>);
      return user;
    }).toList();
    _sortContactList(contacts);

    ContactModel newFriendItem = ContactModel(
      name: 'newFriend'.tr,
      tagIndex: '↑',
    );
    ContactModel groupItem = ContactModel(
      name: 'group'.tr,
      tagIndex: '↑',
    );
    List<ContactModel> topList = [newFriendItem, groupItem];

    setState(() {
      _topList = topList;
      _AllList = _topList + _contactList;
    });
  }

  void _sortContactList(List<User> list) {
    if (list.isEmpty) return;
    _contactList.clear();
    for (int i = 0, length = list.length; i < length; i++) {
      User user = list[i];
      String? firstName = user.firstName; // 可能为null的firstName
      String? lastName = user.lastName; // 可能为null的lastName
      ContactModel contactModel = ContactModel(
          name: '${firstName ?? ''} ${lastName ?? ''}', user: user);
      String pinyin = PinyinHelper.getPinyinE(contactModel.name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      contactModel.namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        contactModel.tagIndex = tag;
      } else {
        contactModel.tagIndex = "#";
      }
      _contactList.add(contactModel);
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(_contactList);
    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(_contactList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        scrolledUnderElevation: 0,
        bottom: showAppBarLine ? WidgetFactory.buildAppBarLine() : null,
        title: Text(
          'contacts'.tr,
          style: TextStyle(fontSize: Helper.titleFontSize),
        ),
      ),
      body: buildSearchBar(),
    );
  }

  Widget buildSearchBar() {
    final List<FloatingSearchBarAction> actions = <FloatingSearchBarAction>[
      FloatingSearchBarAction.back(
        showIfClosed: false,
      ),
    ];

    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      backdropColor: Helper.imPrimary,
      backgroundColor: Helper.imPrimary,
      height: 40,
      elevation: 0,
      margins: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      padding: EdgeInsets.zero,
      insets: EdgeInsets.zero,
      automaticallyImplyBackButton: false,
      automaticallyImplyDrawerHamburger: false,
      closeOnBackdropTap: false,
      controller: _searchBarController,
      iconColor: Colors.grey,
      border: const BorderSide(
        color: Colors.grey,
        width: 0.25,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      hint: 'search'.tr,
      accentColor: Helper.imSurface,
      hintStyle: TextStyle(
        height: 40 / Helper.contentFontSize,
        fontSize: Helper.contentFontSize,
        color: Colors.grey,
        fontWeight: FontWeight.w400,
      ),
      title: Text(
        'search'.tr,
        style: TextStyle(
          fontSize: Helper.contentFontSize,
          color: Colors.grey,
        ),
      ),
      queryStyle: TextStyle(
        fontSize: Helper.contentFontSize,
        color: Helper.imSurface,
      ),
      textInputAction: TextInputAction.search,
      leadingActions: <Widget>[
        FloatingSearchBarAction(
          showIfOpened: true,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ),
      ],
      transitionDuration: const Duration(milliseconds: 700),
      transitionCurve: Curves.easeInOutCubic,
      axisAlignment: isPortrait ? 0.0 : -1.0,
      actions: actions,
      scrollPadding: EdgeInsets.zero,
      transition: SlideFadeFloatingSearchBarTransition(),
      onFocusChanged: (isFocused) {
        setState(() {});
      },
      builder: (BuildContext context, _) => _buildSearchBody(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return AzListView(
      padding: const EdgeInsets.only(top: kSearchBarHeight),
      itemPositionsListener: itemPositionsListener,
      data: _AllList,
      itemCount: _AllList.length,
      itemBuilder: (BuildContext context, int index) {
        ContactModel model = _AllList[index];
        if (index == 0){
          return TopCell(height: Helper.contentFontSize * 2 + 30, iconData: Icons.notification_add , title: model.name, isLast: false);
        }
        else if (index == 1){
          return TopCell(height: Helper.contentFontSize * 2 + 30, iconData: Icons.groups , title: model.name, isLast: index == _AllList.length - 1 ? true : false);
        }
        return UserCell(height: Helper.contentFontSize * 2 + 30, avatarUrl: model.user!.id, name: model.name, isLast: index == _AllList.length - 1 ? true : false);
      },
      physics: const ClampingScrollPhysics(),
      susItemBuilder: (BuildContext context, int index) {
        ContactModel model = _AllList[index];
        if ('↑' == model.getSuspensionTag()) {
          return Container();
        }
        return IndexHeader(indexLetter: model.getSuspensionTag()); 
      },
      indexBarData: const ['↑', ...kIndexBarData],
      indexBarOptions: const IndexBarOptions(
        needRebuild: true,
        // ignoreDragCancel: true,
        selectTextStyle: TextStyle(
            fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
        selectItemDecoration:
            BoxDecoration(shape: BoxShape.circle, color: Color(0xFF333333)),
        indexHintWidth: 120 / 2,
        indexHintHeight: 100 / 2,
        indexHintDecoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/index_bar_bubble_gray.png'),
            fit: BoxFit.contain,
          ),
        ),
        indexHintAlignment: Alignment.centerRight,
        indexHintChildAlignment: Alignment(-0.25, 0.0),
        indexHintOffset: Offset(-20, 0),
      ),
    );
  }

  Widget _buildSearchBody() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: ImplicitlyAnimatedList<ContactModel>(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          items: _contactList,
          insertDuration: const Duration(milliseconds: 700),
          itemBuilder: (BuildContext context, Animation<double> animation,
              ContactModel item, _) {
            return SizeFadeTransition(
              animation: animation,
              child: buildItem(context, item),
            );
          },
          updateItemBuilder: (BuildContext context, Animation<double> animation,
              ContactModel item) {
            return FadeTransition(
              opacity: animation,
              child: buildItem(context, item),
            );
          },
          areItemsTheSame: (ContactModel a, ContactModel b) => a == b,
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, ContactModel item) {
    return Container(
      color: Colors.white,
      height: 44,
      child: Text(item.name),
    );
  }
}
