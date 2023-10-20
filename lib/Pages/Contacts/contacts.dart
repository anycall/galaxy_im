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
import 'package:lpinyin/lpinyin.dart';

//搜索框高度 
const double kSearchBarHeight = 50;

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final FloatingSearchBarController _searchBarController =
      FloatingSearchBarController();
  bool showAppBarLine = false;
  final List<ContactModel> _topList = [];
  final List<ContactModel> _contactList = [];
  List<ContactModel> _allList = [];
  final GlobalKey<SearchResultsState> searchResultsKey = GlobalKey<SearchResultsState>();


  @override
  void initState() {
    super.initState();
    _loadTops();
    _loadUsers();
    itemPositionsListener.itemPositions.addListener(_onScroll);
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_onScroll);
    super.dispose();
  }

  //点击空搜索结果背景
  void _onEmptySearchResultTap() {
    _searchBarController.close();
  }

  void _onScroll() {
    bool newfrienCellIsVisible = false;
    for (var element in itemPositionsListener.itemPositions.value) {
      if (element.index == 0) {
        newfrienCellIsVisible = true;
        break; 
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

  void _loadTops() {
    _topList.clear();
    ContactModel newFriendItem = ContactModel(
      name: 'newFriend'.tr,
      tagIndex: '↑',
    );
    _topList.add(newFriendItem);
    ContactModel groupItem = ContactModel(
      name: 'group'.tr,
      tagIndex: '↑',
    );
    _topList.add(groupItem);
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

    setState(() {
      _allList = _topList + _contactList;
    });
  }

  void _sortContactList(List<User> list) {
    if (list.isEmpty) return;
    _contactList.clear();
    for (int i = 0, length = list.length; i < length; i++) {
      User user = list[i];
      String? firstName = user.firstName; 
      String? lastName = user.lastName; 
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

  //搜索数据
  void _filterData(String filterStr) {
    List<ContactModel> searchList = [];
    for (int i = 0, length = _contactList.length; i < length; i++) {
      ContactModel contactModel = _contactList[i];
      //不区分大小写比较
      if (contactModel.namePinyin!.toLowerCase().contains(filterStr.toLowerCase()) ||
          contactModel.name.toLowerCase().contains(filterStr.toLowerCase())) {
        searchList.add(contactModel);
      }
    }
    searchResultsKey.currentState?.updateSearchResults(searchList, filterStr);
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
      borderRadius: const BorderRadius.all(Radius.circular(3)),
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
            icon: const Icon(Icons.person_search),
            onPressed: () {},
          ),
        ),
      ],
      transitionDuration: const Duration(milliseconds: 700),
      transitionCurve: Curves.easeInOutCubic,
      axisAlignment: isPortrait ? 0.0 : -1.0,
      actions: actions,
      scrollPadding: EdgeInsets.zero,
      isScrollControlled: true,
      transition: SlideFadeFloatingSearchBarTransition(),
      onQueryChanged:(query) {
        _filterData(query);
      },
      builder: (BuildContext context, _) => _buildSearchBody(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return AzListView(
      padding: const EdgeInsets.only(top: kSearchBarHeight),
      itemPositionsListener: itemPositionsListener,
      data: _allList,
      itemCount: _allList.length,
      itemBuilder: (BuildContext context, int index) {
        ContactModel model = _allList[index];
        if (index == 0){
          return TopCell(height: Helper.contentFontSize * 2 + 30, iconData: Icons.notification_add , title: model.name, isLast: false);
        }
        else if (index == 1){
          return TopCell(height: Helper.contentFontSize * 2 + 30, iconData: Icons.groups , title: model.name, isLast: index == _allList.length - 1 ? true : false);
        }
        return UserCell(height: Helper.contentFontSize * 2 + 30, model: model, isLast: index == _allList.length - 1 ? true : false);
      },
      physics: const ClampingScrollPhysics(),
      susItemBuilder: (BuildContext context, int index) {
        ContactModel model = _allList[index];
        if ('↑' == model.getSuspensionTag()) {
          return Container();
        }
        return IndexHeader(indexLetter: model.getSuspensionTag()); 
      },
      indexBarData: const ['↑', ...kIndexBarData],
      indexBarOptions: const IndexBarOptions(
        needRebuild: true,
        selectTextStyle: TextStyle(
            fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
        selectItemDecoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.grey ),
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
    return SearchResults(
      key: searchResultsKey,
      onEmpty: _onEmptySearchResultTap,
    );
  }

}
