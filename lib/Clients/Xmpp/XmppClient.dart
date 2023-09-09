//基于IClientInterface 实现Xmpp协议的客户端

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:galaxy_im/Clients/IClientInterface.dart';

class XmppClient extends IClientInterface {
  XmppClient(XmppServerInfo serverInfo) : super(serverInfo) {
    var xmppServerInfo = serverInfo;
    _domain = serverInfo.server;
    // _username = _xmppLoginInfo.userName;
    // _password = _xmppLoginInfo.password;
  }

  String _domain = "";

  late Socket _socket;
  late String _account;
  late String _chatId;
  late String _token;
  late String _uid;
  late String _timer;
  late WebSocket _ws;
  Completer<bool> _completer = Completer();

  late XmppLoginInfo _xmppLoginInfo;

  void _defaultDataHandler(List<int> data) {
    //声明一个字节缓冲区
    var buffer = ByteData(8);
    //将data转换为Uint8List
    var list = Uint8List.fromList(data);
    //将data的前8个字节赋值给buffer
    buffer.buffer.asUint8List().setAll(0, list.sublist(0, 8));
    //获取消息长度
    var length = buffer.getInt32(0);
    //获取消息id
    var msgId = buffer.getInt32(4);
    // IMLogUtil.debug('receive:msgId---- $msgId');
    //获取消息体
    var body = list.sublist(8, length);
    var hasHandler = false;
  }

  @override
  Future<bool> login(BaseLoginInfo info) async {
    _xmppLoginInfo = info as XmppLoginInfo;
    var r = Random();
    String key = base64.encode(List<int>.generate(8, (_) => r.nextInt(255)));
    HttpClient client = HttpClient(context: SecurityContext());
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      print('SimpleWebSocket: Allow self-signed certificate => $host:$port. ');
      return true;
    };
    var server = "";
    _ws = await WebSocket.connect("ws://$server:5290/xmpp-websocket",
        headers: {
          'Connection': 'Upgrade',
          'Upgrade': 'websocket',
          'Sec-WebSocket-Version': '13',
          'Sec-WebSocket-Protocol': 'xmpp',
          'Sec-WebSocket-Key': key.toLowerCase()
        },
        customClient: client);

    _ws.listen((event) {
      print("receive qqq:" + event);
      // wsHandleInComingMessage(event);
    }, onError: (err) => {print(err)}, onDone: () => {print("onDone")});

    print("ws.readystate:" + _ws.readyState.toString());
    var userName = _xmppLoginInfo.userName;
    var password = _xmppLoginInfo.password;
    var crential = "\u0000$userName@$_domain\u0000$password";

    var base64Str = base64.encode(utf8.encode(crential));
    print(crential);

    _ws.add(
        '<?xml version="1.0"?><stream:stream xmlns:stream="http://etherx.jabber.org/streams" xmlns="jabber:client" xml:lang="zh-CN" xmlns:xml="http://www.w3.org/XML/1998/namespace" to="$_domain" version="1.0">');
    _ws.add(
        "<auth xmlns='urn:ietf:params:xml:ns:xmpp-sasl' mechanism='PLAIN'>$base64Str</auth>");

    return _completer.future;
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
