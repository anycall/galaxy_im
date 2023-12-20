import 'dart:async';
import 'dart:convert';

import 'package:galaxy_im/Clients/Xmpp/XmppClient.dart';
import 'package:galaxy_im/Clients/Xmpp/Xmpp_Types.dart';
import 'package:xml/xml.dart';
import 'package:uuid/uuid.dart';
import 'package:galaxy_im/Utils/LogUtil.dart';

typedef MessageFilter = XmlDocument Function(XmlDocument xml);

abstract class XEP {
  XmppClient xmppClient;
  XEP(this.xmppClient);

  ///生成一个GUID，返回GUID字符串
  String newGuid() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  ///子类可以访问的String类型的属性

  abstract String xep_name;
  List<XepMessageHandler> receiveHandlers = [];
  List<MessageFilter> beforeMessageFilter = [];
  List<MessageFilter> afterMessageFitler = [];

  List<Timer Function()> continuousTasks = [];
  List<void Function()> onceTasks = [];
  String bare_jid = '';
  List<XepMessageHandler> getReceiceHandlers() {
    if (receiveHandlers.isNotEmpty) {
      for (var handler in receiveHandlers) {
        handler.ns = xep_name;
      }
    }
    return receiveHandlers;
  }

  List<MessageFilter> getBeforeMessageFilters() {
    var filters = beforeMessageFilter;
    LogUtil.debug('$xep_name 包含 ${filters.length} 消息前处理过滤器');
    return filters;
  }

  List<MessageFilter> getAfterMessageFitlers() {
    var filters = afterMessageFitler;
    LogUtil.debug('$xep_name 包含 ${filters.length} 消息后处理过滤器');
    return filters;
  }
}

abstract class IXEP_Common {}

class XEP_Login extends XEP implements IXEP_Common {
  @override
  String xep_name = "XEP_Login";

  bool _hasLogin = false;
  late Completer<bool> _successCompleter;

  XEP_Login(XmppClient xmppClient) : super(xmppClient) {
    receiveHandlers.add(
        XepMessageHandler("", "open", "", "", "", "", true, true, openHandler));
    receiveHandlers.add(XepMessageHandler(
        "", "success", "", "", "", "", true, true, successHandler));
    _successCompleter = Completer<bool>();
  }

  /// 响应<open/>节点
  Future<void> openHandler(XmlDocument xml) async {
    if (_hasLogin) {
      //说明已经登录成功了，不需要再次登录，处理后续逻辑
      // 发送一个resource节点，将当前设备标识为一个资源，这样就可以在多个设备上同时登录了
      var resource =
          "<iq type='set' id='${newGuid()}'><bind xmlns='urn:ietf:params:xml:ns:xmpp-bind'><resource>galaxy_im</resource></bind></iq>";
      var resourceElement = XmlDocument.parse(resource);
      var resultXml = await xmppClient.sendIQAsnyc(resourceElement);
      // 登录过程结束
      // 登录成功之后，发送一个ping，保持心跳

      var ping =
          "<iq type='get' id='${newGuid()}'><ping xmlns='urn:xmpp:ping'/></iq>";
      var pingElement = XmlDocument.parse(ping);
      var pingRsult = await xmppClient.sendIQAsnyc(pingElement);
      // 登录成功之后，发送一个presence，表示上线
      var presence = "<presence xmlns='jabber:client'/>";
      xmppClient.send(presence);
    }
    // 收到第一个open之后，发送Auth节点进行登录
    var userName = xmppClient.userName;
    var password = xmppClient.password;
    var domain = xmppClient.domain;
    var crential = "\u0000$userName@$domain\u0000$password";

    var base64Str = base64.encode(utf8.encode(crential));
    var auth =
        "<auth xmlns='urn:ietf:params:xml:ns:xmpp-sasl' mechanism='PLAIN'>$base64Str</auth>";
    xmppClient.send(auth);
    _hasLogin = await _successCompleter.future;
    if (_hasLogin) {
      // 发送一个open节点
      var open =
          "<open xmlns='urn:ietf:params:xml:ns:xmpp-framing' from='${xmppClient.domain}' id='${newGuid()}'    version='1.0' xml:lang='en' />";
      xmppClient.send(open);
    }
  }

  /// 响应<success/>节点,此节点表示登录成功
  /// <success xmlns="urn:ietf:params:xml:ns:xmpp-sasl"/>
  Future<void> successHandler(XmlDocument xml) async {
    // 收到success节点之后，说明登录成功，发送一个complete告诉上一个回调
    _successCompleter.complete(true);
  }

  Future<void> msgReceivedHandler(XmlDocument xml) async {
    XmlElement? message = xml.rootElement;
    XmlElement? received = message.lastElementChild;
    String? name = received?.name.toString();
    if (name == 'received') {
      print("receivedHandler 处理程序$xml");
      // XmlDocument document = sendDisplayed(
      //     message.getAttribute("from").toString(),
      //     message.getAttribute("id").toString());
      // await connection.sendElement(document);
    }
  }
}
