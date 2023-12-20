import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:galaxy_im/Clients/IClientInterface.dart';
import 'package:galaxy_im/Clients/Xmpp/Basic_XEP.dart';
import 'package:galaxy_im/Clients/Xmpp/Handlers/XepMessageHandler.dart';
import 'package:galaxy_im/Utils/Extensions.dart';
import 'package:galaxy_im/Utils/LogUtil.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart';

class XmppClient extends IClientInterface with BasicXEP {
  late XmppLoginInfo _xmppLoginInfo;
  String get domain => _xmppLoginInfo.domain;
  late Socket _socket;
  String get userName => _xmppLoginInfo.userName;
  String get password => _xmppLoginInfo.password;
  late String _chatId;
  late String _token;
  late String _uid;
  late String _timer;
  late WebSocket _ws;

  late Completer<bool> _loginCompleter;
  List<XepMessageHandler> handlers = [];
  final List<XEP> _xeps = [];
  late XEP_Login _xepLogin;

  XmppClient(XmppServerInfo serverInfo) : super(serverInfo) {
    var xmppServerInfo = serverInfo;
    _xepLogin = XEP_Login(this);
    _xeps.addAll([_xepLogin]);
    handlers.addAll(_xeps.mapMany((item) => item.receiveHandlers));

    //打印所有的过滤器的name属性
    var filterNames = handlers.map((e) => e.name).toList();
    LogUtil.debug("所有的过滤器的name属性", params: [filterNames]);
  }

  @override
  Future<bool> login(BaseLoginInfo info) async {
    _xmppLoginInfo = info as XmppLoginInfo;
    // _loginCompleter = Completer();
    var r = Random();
    String key = base64.encode(List<int>.generate(8, (_) => r.nextInt(255)));
    HttpClient client = HttpClient(context: SecurityContext());
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      LogUtil.debug(
          'SimpleWebSocket: Allow self-signed certificate => $host:$port. ');
      return true;
    };
    var server = super.serverInfo.server;
    var port = super.serverInfo.port;
    _ws = await WebSocket.connect("$server:$port/xmpp-websocket",
        headers: {
          'Connection': 'Upgrade',
          'Upgrade': 'websocket',
          'Sec-WebSocket-Version': '13',
          'Sec-WebSocket-Protocol': 'xmpp, xmpp-framing',
          'Sec-WebSocket-Key': key.toLowerCase()
        },
        customClient: client);

    _ws.listen((event) {
      LogUtil.debug("receive:", params: [event]);
      wsHandleInComingMessage(event);
    },
        onError: (err) => {LogUtil.error(err)},
        onDone: () => {LogUtil.debug("onDone")});

    LogUtil.debug("ws.readystate:${_ws.readyState}");

    return await _xepLogin.login();
    // return _loginCompleter.future;
  }

  //直接使用websocket发送消息
  void _sendXmppMessage(String msg) {
    LogUtil.debug("send:", params: [msg]);
    _ws.add(msg);
  }

  void wsHandleInComingMessage(String message) {
    var (parseResult, parseDoc) = XmlDocumentExtension.tryParse(message);

    if (parseResult) {
      //如果转成了xmlDocument类型的对象，就可以使用过滤器进行过滤
      XmlDocument? document = parseDoc;

      var name = document?.rootElement.localName;
      var type = document?.rootElement.getAttribute("type");
      var id = document?.rootElement.getAttribute("id");
      var from = document?.rootElement.getAttribute("from");
      var to = document?.rootElement.getAttribute("to");
      //这个地方，可能需要单独处理一下，获取所有的子节点的xmlns，然后再进行过滤
      var xmlnsList = document?.rootElement
              .findAllElements("*")
              .map((e) => e.getAttribute("xmlns"))
              .where((ns) => ns != null && ns.isNotEmpty) ??
          [];
      var hitHandlerCount = 0;
      for (var handler in handlers) {
        if ((handler.ns.isEmpty || (xmlnsList.contains(handler.ns))) &&
            (handler.name.isEmpty || name == handler.name) &&
            (handler.id.isEmpty || id == handler.id) &&
            (handler.from.isEmpty || from == handler.from) &&
            (handler.to.isEmpty || to == handler.to) &&
            (handler.type.isEmpty || type == handler.type)) {
          hitHandlerCount++;
          LogUtil.debug("匹配上过滤器", params: [
            "匹配顺序$hitHandlerCount",
            name,
            type,
            id,
            from,
            to,
            message
          ]);
          handler.msgHandler(document!);
        } else {}
      }
      if (hitHandlerCount == 0) {
        LogUtil.debug("没有匹配上过滤器", params: [name, type, id, from, to, message]);
      }
      hitHandlerCount = 0;
    } else {
      //如果没有转换成功，则不行过滤
    }
  }

  Future<XmlDocument> sendElement(XmlDocument xml) async {
    var id = xml.rootElement.getAttribute("id") ?? "";
    Completer<XmlDocument> completer = Completer();
    var tHandler =
        XepMessageHandler("", "", "", id, "", "", false, false, (xml) {
      //send a sigal to invoke ;
      completer.complete(xml);
    });
    handlers.add(tHandler);
    send(xml.toXmlString());
    // wait a signal from handleTlsMessage
    XmlDocument xmlElement = await completer.future;
    handlers.remove(tHandler);
    return xmlElement;
  }

  /// 需要在这个方法中，进行一个等待
  Future<XmlDocument> sendIQAsnyc(XmlDocument xml) async {
    //用 dart创建一个带参数的信号量，然后在这个方法中，等待信号量的返回
    var id = xml.rootElement.getAttribute("id") ?? "";
    Completer<XmlDocument> completer = Completer();
    var tHandler =
        XepMessageHandler("", "", "", id, "", "", false, false, (xml) {
      //send a sigal to invoke ;
      completer.complete(xml);
    });
    handlers.add(tHandler);
    send(xml.toString());

    // wait a signal from handleTlsMessage
    XmlDocument xmlIq = await completer.future;
    handlers.remove(tHandler);
    return xmlIq;
  }

  void send(String message) {
    // rawOutput(message, prefix: "xmpp");
    _ws.add(message);
  }

  @override
  Future<void> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> receiveMessage() {
    // TODO: implement receiveMessage
    throw UnimplementedError();
  }

  @override
  Future<void> reconnect() {
    // TODO: implement reconnect
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(String message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
