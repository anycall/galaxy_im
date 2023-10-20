import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Pages/Widget/WidgetFactory.dart';
import 'package:galaxy_im/Pages/Widget/random_avatar.dart';
import 'package:get/get.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final double avatarWidth = Helper.screenWidth * 0.6;
  late User user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    user = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: WidgetFactory.buildAppBarLine(),
        title: Text(
          'userProfile'.tr,
          style: TextStyle(fontSize: Helper.titleFontSize),
        ),
        leading: WidgetFactory.buildAppBarBackButton(context),
      ),
      body: Container(
        padding: EdgeInsets.only(top: (Helper.screenWidth - avatarWidth) / 4),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            _buildAvatar(),
            _buildName(),
            _buildID(),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return SizedBox(
      width: avatarWidth,
      height: avatarWidth,
      child: RandomAvatar(
        user.id,
        width: avatarWidth,
        height: avatarWidth,
      ),
    );
  }

  Widget _buildName() {
    String? firstName = user.firstName;
    String? lastName = user.lastName;

    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
      child: Text(
        '${firstName ?? ''} ${lastName ?? ''}',
        style: TextStyle(
          fontSize: Helper.subtitleFontSize,
          fontWeight: FontWeight.bold,
          color: Helper.imSurface,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildID() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 5),
      child: Text(
        'ID:${user.id}',
        style: TextStyle(
          fontSize: Helper.contentFontSize,
          fontWeight: FontWeight.w300,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildButton() {
    //关注参数：User的metaData中的subscription
    String subscription = user.metadata?['subscription'] ?? 'none';
    bool isSubscript = subscription == 'both' || subscription == 'to';
    return Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
        child: Column(
          children: [
            //订阅
            AnimatedButton(
              width: avatarWidth,
              color: isSubscript ? Colors.grey : Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isSubscript
                      ? const Icon(
                          Icons.person_remove_alt_1,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.person_add_alt_1,
                          color: Colors.white,
                        ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(isSubscript ? 'unsubscribe'.tr : 'subscribe'.tr,
                      style: TextStyle(
                          fontSize: Helper.subtitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
              onPressed: () {
                setState(() {
                  user.metadata?['subscription'] = isSubscript ? 'none' : 'to';
                });
              },
            ),
            const SizedBox(
              height: 30,
            ),
            //发消息
            AnimatedButton(
              width: avatarWidth,
              color: Helper.imSecondary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text('sendChat'.tr,
                      style: TextStyle(
                          fontSize: Helper.subtitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
              onPressed: () {
                //TODO: 发消息
                //建立会话列表返回会话model
              },
            ),
          ],
        ));
  }
}
