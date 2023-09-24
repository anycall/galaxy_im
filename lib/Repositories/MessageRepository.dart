// 目标：消息仓库，用于处理Client返回的消息，包括消息的本地缓存；
// 在这个仓库中，使用本地数据库进行存储，并且使用事件流的方式进行消息的分发；
// 将MessageRepository作为一个数据接收器，绑定到Client上，方便在Client中消息接收到之后进行回调通知

import 'package:galaxy_im/Clients/IChatMessage.dart';
import 'package:galaxy_im/Clients/IClientInterface.dart';
import 'package:get/get.dart';

class MessageRepository extends GetxController {
  /// 消息仓库初始化的时候，将Client进行传递，并绑定client的消息接收方法
  MessageRepository(IClientInterface client) {
    client.BindChatMessageStream(_onChatMessageReceived);
  }

  /// 用于存储会话消息的Map，key为会话的ID，value为会话的消息列表
  final Map<String, List<IChatMessage>> _sessionMessageMap = {};

  /// 用于从client中接收消息的方法
  Future<void> _onChatMessageReceived(IChatMessage message) async {}
}
