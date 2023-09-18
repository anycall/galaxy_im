import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Helper/RouteManager.dart';
import 'package:galaxy_im/Models/Conversation.dart';
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
  List<Conversation> conversationList = List.generate(50, (index) {
    return Conversation(
      id: index.toString(),
      name: 'name$index',
      avatar: index.toString(),
      lastMessage: 'lastMessage$index， 哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈',
      unreadCount: 0,
      timestamp:
          DateTime.now().millisecondsSinceEpoch - index * 1000 * 60 * 60 * 24,
    );
  });

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
    conversationList.removeAt(index);
    setState(() {});
  }

  //跳转到聊天页面
  void _goToChatPage(int index) {
    Get.toNamed(Routes.privateChat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
                childCount: conversationList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //会话item
  Widget _buildConversationItem(int index) {
    Conversation model = conversationList[index];
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
        onTap: () {
          _goToChatPage(index);
        },
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
          child: RepaintBoundary(
              child: Row(
            children: [
              ///头像
              RandomAvatar(
                model.avatar!,
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
                            model.name!,
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
                          Helper.getConversationFormatDate(model.timestamp!),
                          style: TextStyle(
                              fontSize: Helper.contentFontSize,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    ///最后一条消息
                    Text(
                      model.lastMessage!,
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
}
