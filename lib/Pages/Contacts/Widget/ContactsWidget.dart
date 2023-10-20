import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Helper/RouteManager.dart';
import 'package:galaxy_im/Models/ContactModel.dart';
import 'package:galaxy_im/Pages/Widget/WidgetFactory.dart';
import 'package:galaxy_im/Pages/Widget/random_avatar.dart';
import 'package:get/get.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:easy_rich_text/easy_rich_text.dart';

//contacts widget
class ContactsWidget {}

//contacts group header
class IndexHeader extends StatelessWidget {
  final String indexLetter;
  const IndexHeader({super.key, required this.indexLetter});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Helper.imPrimary,
      padding: const EdgeInsets.only(left: 15),
      alignment: Alignment.bottomLeft,
      child: Text(
        indexLetter,
        style: TextStyle(
            fontSize: Helper.contentFontSize,
            color: Colors.grey,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Cell
class TopCell extends StatelessWidget {
  final double height;
  final IconData iconData;
  final String title;
  final bool isLast;
  const TopCell(
      {super.key,
      required this.height,
      required this.iconData,
      required this.title,
      required this.isLast});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15),
            height: height,
            child: Row(
              children: [
                Container(
                  width: height - 15,
                  height: height - 15,
                  decoration: BoxDecoration(
                    color: Helper.imSecondary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Icon(
                    iconData,
                    color: Colors.white,
                    size: height - 30,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: Helper.contentFontSize,
                      color: Helper.imSurface),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: isLast ? 0 : height + 15),
            child: WidgetFactory.buildLine(),
          )
        ],
      ),
    );
  }
}

//跳转到个人中心
void _pushUserProfilePage(ContactModel model) {
  Get.toNamed(Routes.userProfile, arguments: model.user);
}

class UserCell extends StatelessWidget {
  final double height;
  final ContactModel model;
  final bool isLast;
  const UserCell(
      {super.key,
      required this.height,
      required this.model,
      required this.isLast});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _pushUserProfilePage(model);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, right: 30),
            height: height,
            child: Row(
              children: [
                RandomAvatar(
                  model.user!.id,
                  height: height - 15,
                  width: height - 15,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    model.name,
                    style: TextStyle(
                        fontSize: Helper.contentFontSize,
                        color: Helper.imSurface),
                  ),
                ),
              ],
            ),
          ),
          isLast
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(left: isLast ? 0 : height + 15),
                  child: WidgetFactory.buildLine(),
                ),
        ],
      ),
    );
  }
}

class UserRichTextCell extends StatelessWidget {
  final double height;
  final ContactModel model;
  final String keywords;
  const UserRichTextCell(
      {super.key,
      required this.height,
      required this.model,
      required this.keywords});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _pushUserProfilePage(model);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, right: 30),
            height: height,
            child: Row(
              children: [
                RandomAvatar(
                  model.user!.id,
                  height: height - 15,
                  width: height - 15,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: EasyRichText(
                    model.name,
                    caseSensitive: false,
                    defaultStyle: TextStyle(
                      fontSize: Helper.contentFontSize,
                      color: Helper.imSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                    patternList: [
                      EasyRichTextPattern(
                        targetString: keywords,
                        matchWordBoundaries: false,
                        matchOption: [0],
                        style: TextStyle(
                          fontSize: Helper.contentFontSize,
                          color: Helper.imSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: height + 15),
            child: WidgetFactory.buildLine(),
          ),
        ],
      ),
    );
  }
}

typedef EmptyResultsCallback = void Function();

class SearchResults extends StatefulWidget {
  final EmptyResultsCallback? onEmpty;
  const SearchResults({super.key, this.onEmpty});

  @override
  State<SearchResults> createState() => SearchResultsState();
}

class SearchResultsState extends State<SearchResults> {
  List<ContactModel> _filteredList = [];
  String _query = '';

  void updateSearchResults(List<ContactModel> searchList, String query) {
    _query = query;
    if (query.isEmpty) {
      setState(() {
        _filteredList.clear();
      });
      return;
    }
    setState(() {
      _filteredList = searchList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_filteredList.isEmpty) {
      return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (widget.onEmpty != null) {
              widget.onEmpty!();
            }
          },
          child: WidgetFactory.buildSearchNoResult());
    }
    return ImplicitlyAnimatedList<ContactModel>(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      items: _filteredList,
      insertDuration: const Duration(milliseconds: 300),
      removeDuration: const Duration(milliseconds: 300),
      updateDuration: const Duration(milliseconds: 300),
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
    );
  }

  Widget buildItem(BuildContext context, ContactModel item) {
    return UserRichTextCell(
        height: Helper.contentFontSize * 2 + 30,
        model: item,
        keywords: _query);
  }
}
