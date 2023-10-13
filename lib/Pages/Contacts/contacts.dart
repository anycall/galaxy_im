import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Models/JsonGenerator.dart';
import 'package:galaxy_im/Pages/Widget/WidgetFactory.dart';
import 'package:galaxy_im/Utils/LogUtil.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

//搜索框高度 55
const double kSearchBarHeight = 55;

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final ScrollController _scrollController = ScrollController();
  final FloatingSearchBarController _searchBarController =
      FloatingSearchBarController();
  bool showAppBarLine = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > kSearchBarHeight && !showAppBarLine) {
      setState(() {
        showAppBarLine = true;
      });
    } else if (_scrollController.offset <= kSearchBarHeight && showAppBarLine) {
      setState(() {
        showAppBarLine = false;
      });
    }
  }

  void _loadUsers() {
    JsonArrayGenerator jsonArrayGenerator = JsonArrayGenerator();
    String randomJsonArray = jsonArrayGenerator.generateRandomUserJsonArray(10);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        scrolledUnderElevation: 0,
        bottom: showAppBarLine ? WidgetFactory().buildAppBarLine() : null,
        title: Text(
          'contacts'.tr,
          style: TextStyle(fontSize: Helper.titleFontSize),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      controller: _scrollController,
      physics: _searchBarController.isOpen
          ? const NeverScrollableScrollPhysics()
          : const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              width: Helper.screenWidth,
              height: _searchBarController.isOpen
                  ? Helper.screenHeight -
                      Helper.topBarHeight -
                      Helper.bottomBarHeight
                  : kSearchBarHeight,
              //搜索框
              child: buildSearchBar(),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 0.25, // 设置线的高度
            color: Colors.grey, // 设置线的颜色
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Container(
            color: Helper.imPrimary,
            height: 44,
          );
        }, childCount: 50)),
      ],
    );
  }

  Widget buildSearchBar() {
    LogUtil.debug(
        '${_searchBarController.isOpen}----${_searchBarController.isVisible}');
    final List<FloatingSearchBarAction> actions = <FloatingSearchBarAction>[
      FloatingSearchBarAction.back(
        showIfClosed: false,
      ),
    ];

    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      backdropColor: Helper.imPrimary,
      height: 40,
      elevation: 0,
      margins: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      insets: EdgeInsets.zero,
      automaticallyImplyBackButton: false,
      controller: _searchBarController,
      iconColor: Colors.grey,
      border: const BorderSide(
        color: Colors.grey,
        width: 0.25,
      ),
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
      physics: const NeverScrollableScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      actions: actions,
      scrollPadding: EdgeInsets.zero,
      transition: SlideFadeFloatingSearchBarTransition(),
      onFocusChanged: (isFocused) {
        setState(() {});
      },
      builder: (BuildContext context, _) => _buildSearchBody(),
    );
  }

  Widget _buildSearchBody() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      color: Colors.white,
      height: Helper.screenHeight -
          Helper.topBarHeight -
          Helper.bottomBarHeight -
          kSearchBarHeight,
      child: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              color: Colors.white,
              height: 44,
              child: Text('test $index'),
            );
          },
          itemCount: 100),
    );
  }
}
