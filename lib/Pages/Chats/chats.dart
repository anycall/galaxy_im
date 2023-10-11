import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Helper/RouteManager.dart';
import 'package:galaxy_im/Models/JsonGenerator.dart';
import 'package:galaxy_im/Pages/Widget/WidgetFactory.dart';
import 'package:get/get.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:random_avatar/random_avatar.dart';

class Conversations extends StatefulWidget {
  const Conversations({super.key});

  @override
  State<Conversations> createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  // 会话列表数组
  List<Room> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    JsonArrayGenerator jsonArrayGenerator = JsonArrayGenerator();
    String randomJsonArray =
        await jsonArrayGenerator.generateRandomConversationJsonArray(100);
    final rooms = (jsonDecode(randomJsonArray) as List).map((e) {
      var room = Room.fromJson(e as Map<String, dynamic>);
      return room;
    }).toList();

    setState(() {
      _conversations = rooms;
    });
  }

  //导航栏标题方法
  Widget _buildTitle() {
    return GestureDetector(
      onTap: _onTapAppBar,
      child: Text(
        'chats'.tr,
        style: TextStyle(fontSize: Helper.titleFontSize),
      ),
    );
  }

  //点击导航栏方法
  void _onTapAppBar() {
    print('点击了导航栏');
  }

  //删除会话
  void _deleteConversation(int index) {
    _conversations.removeAt(index);
    setState(() {});
  }

  //跳转到聊天页面
  void _goToChatPage(int index) {
    Room model = _conversations[index];
    Get.toNamed(Routes.privateChat, arguments: model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        scrolledUnderElevation: 0,
        bottom: WidgetFactory().buildAppBarLine(),
        title: _buildTitle(),
      ),
      body: Padding(
        padding: EdgeInsets.zero,
        child: CustomScrollView(
          slivers: [
            ///列表
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return _buildConversationItem(index);
                },
                childCount: _conversations.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //会话item
  Widget _buildConversationItem(int index) {
    Room model = _conversations[index];
    double avatarSize =
        (Helper.subtitleFontSize + Helper.contentFontSize + 5) * 1.4;
    return SwipeActionCell(
      index: index,
      key: ValueKey(model.id),
      selectedForegroundColor: Colors.black.withAlpha(30),
      trailingActions: [
        SwipeAction(
            title: "delete".tr,
            style: TextStyle(
                fontSize: Helper.subtitleFontSize, color: Colors.white),
            widthSpace: 100,
            nestedAction:
                SwipeNestedAction(title: "deleteChat".tr, nestedWidth: 200),
            onTap: (handler) async {
              await handler(true);

              _deleteConversation(index);
            }),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _goToChatPage(index);
        },
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
          child: RepaintBoundary(
              child: Row(
            children: [
              ///头像
              RandomAvatar(
                model.users[0].id,
                height: avatarSize,
                width: avatarSize,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///名称和日期
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '${model.users[0].firstName} ${model.users[0].lastName}',
                            style: TextStyle(
                              fontSize: Helper.subtitleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          Helper.getConversationFormatDate(model.createdAt ?? 0),
                          style: TextStyle(
                              fontSize: Helper.contentFontSize,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),

                    ///最后一条消息
                    Text(
                      _getLastMessageContent(model),
                      style: TextStyle(
                          fontSize: Helper.contentFontSize, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  String _getLastMessageContent (Room room){
    if (room.lastMessages == null || room.lastMessages!.isEmpty) {
      return '';
    }
    final lastMessage = room.lastMessages!.last;
    switch (lastMessage.type) {
      case MessageType.audio:
        return '[${'audio'.tr}]';
      case MessageType.file:
        return '[${'file'.tr}]';
      case MessageType.image:
        return '[${'image'.tr}]';
      case MessageType.text:
        TextMessage textMessage = lastMessage as TextMessage;
        return textMessage.text;
      case MessageType.video:
        return '[${'video'.tr}]';
      default:
        return '';
    }
  }
}
