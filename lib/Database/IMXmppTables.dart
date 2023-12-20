import 'package:drift/drift.dart';
/**
 * 创建数据库表
 * 1.联系人表
 * 2.XMPP消息表
 * 3.聊天消息表
 * 4.会话表
 */

/// 消息表，用于存储XMPP原始消息，包括每条消息的ack消息
@DataClassName('XmppMessage')
class XmppMessages extends Table {
  // 消息ID，作为主键
  TextColumn get id => text()();
  // 发送方
  TextColumn get from => text()();
  // 接收方
  TextColumn get to => text()();
  // 消息内容
  TextColumn get content => text()();
  // 消息类型
  TextColumn get type => text()();
  // 消息发送时间
  TextColumn get time => text()();
}

/// 联系人表
/// 用于存储联系人信息
@DataClassName('Contact')
class Contacts extends Table {
  //联系人的jid，作为主键
  TextColumn get jid => text()();
  //联系人类型（user,group）
  IntColumn get type => integer()();
  //联系人详请（VCard信息--Json格式）
  TextColumn get detail => text()();
}

/// 会话表
@DataClassName('Conversation')
class Conversations extends Table {
  //对方的jid,String类型,作为主键
  TextColumn get jid => text()();
  //我的jid,String类型,作为主键
  TextColumn get selfJid => text()();
  //消息类型
  IntColumn get type => integer()();
  //用于显示的消息内容
  TextColumn get content => text()();
  //消息发送时间
  TextColumn get time => text()();
  //消息发送状态
  IntColumn get status => integer()();
  //消息发送者
  TextColumn get from => text()();
  //消息接收者
  TextColumn get to => text()();
  //会话是否静音
  IntColumn get isMute => integer()();
  //会话是否置顶 0 不置顶 1 置顶
  IntColumn get isTop => integer()();
  //会话的未读数量
  IntColumn get unreadCount => integer()();
  //加密类型
  IntColumn get encryptType => integer()();
  @override
  Set<Column> get primaryKey => {jid, selfJid};
}

/// 聊天消息表，用来存储聊天消息
@DataClassName("ChatMessage")
class ChatMessages extends Table {
  //消息本地生成的Id，全局唯一
  TextColumn get id => text()();
  //用来区分会话的key（对方的id+自己的id）组合在一起的字符串
  TextColumn get sessionKey => text()();
  //消息序号
  Int64Column get serverIndex => int64()();
  //消息发送状态
  IntColumn get status => integer()();
  //客户端发送时间
  TextColumn get clientSendTime => text()();
  // 发送方
  TextColumn get from => text()();
  // 接收方
  TextColumn get to => text()();
  // 消息类型:chat,groupchat
  TextColumn get messageType => text()();
  // 聊天消息的实际内容，使用Json格式保存到这个地方
  TextColumn get content => text()();
  @override
  Set<Column> get primaryKey => {id};
}

// Tables can mix-in common definitions if needed
mixin AutoIncrementingPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}
