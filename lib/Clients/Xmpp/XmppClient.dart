//基于IClientInterface 实现Xmpp协议的客户端

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:galaxy_im/Clients/IClientInterface.dart';

class XmppClient extends IClientInterface {
  XmppClient(super.server, super.port);

  late Socket _socket;
  late String _account;
  late String _chatId;
  late String _token;
  late String _uid;
  late String _timer;
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
  Future<void> connect(XmppLoginInfo) async {
    _xmppLoginInfo = XmppLoginInfo;

    try {
      _socket = await Socket.connect(super.server, super.port);
    } catch (e) {
      print("连接失败");
    }

    return Future.value(Void);
  }

  @override
  Future<void> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<void> login() {
    // TODO: implement login
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
