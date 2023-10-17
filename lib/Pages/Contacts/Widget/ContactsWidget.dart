import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Pages/Widget/WidgetFactory.dart';
import 'package:galaxy_im/Pages/Widget/random_avatar.dart';

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
    return Column(
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
                    fontSize: Helper.contentFontSize, color: Helper.imSurface),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: isLast ? 0 : height + 15),
          child: WidgetFactory.buildLine(),
        )
      ],
    );
  }
}

class UserCell extends StatelessWidget {
  final double height;
  final String avatarUrl;
  final String name;
  final bool isLast;
  const UserCell(
      {super.key,
      required this.height,
      required this.avatarUrl,
      required this.name,
      required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 15, right: 30),
          height: height,
          child: Row(
            children: [
              RandomAvatar(
                avatarUrl,
                height: height - 15,
                width: height - 15,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: Helper.contentFontSize,
                      color: Helper.imSurface),
                ),
              ),
              //q:上边的Text由于字符串太长越界了，怎么办？
            ],
          ),
        ),
        isLast
            ? Container()
            : Padding(
                padding:
                    EdgeInsets.only(left: isLast ? 0 : height + 15, right: 25),
                child: WidgetFactory.buildLine(),
              ),
      ],
    );
  }
}
