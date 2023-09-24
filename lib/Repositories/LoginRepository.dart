// 用于处理用户登录的逻辑，根据服务器的类型创建不同的Client
// 如果是xmpp类型的就创建XmppClient，目前仅实现了Xmpp的连接
// 设计一个登录方法，传递类型和参数

import 'package:galaxy_im/Clients/IClientInterface.dart';
import 'package:galaxy_im/Clients/Xmpp/XmppClient.dart';
import 'package:get/get.dart';

class LoginRepository extends GetxController {
  // 登录方法
  Future<bool> login(String type, Object serverInfo, Object loginInfo) async {
    // 根据类型创建不同的Client
    // 如果是xmpp类型的就创建XmppClient，目前仅实现了Xmpp的连接
    // 设计一个登录方法，传递类型和参数
    if (type == 'xmpp') {
      // 创建XmppClient
      // 调用XmppClient的login方法
      // 返回登录结果
      var xmppServerInfo = serverInfo as XmppServerInfo;
      var xmppLoginInfo = loginInfo as XmppLoginInfo;
      XmppClient xmppClient = XmppClient(xmppServerInfo);

      var loginResult = await xmppClient.login(xmppLoginInfo);
      if (loginResult) {
        // 此处用于保留一个切入点，方便以后多用户进行登录
        Get.put(xmppClient, tag: xmppLoginInfo.userName);
      }
      return loginResult;
    }
    return true;
  }

  // 这个方法，考虑用于程序启动后自动登录的办法
  Future<bool> autoLogin() {
    return Future.value(true);
  }
}
