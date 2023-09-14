// Purpose: Model for Conversation object

class Conversation {
  String? id;
  String? name;
  String? avatar;
  String? lastMessage;
  int? unreadCount;
  int? timestamp;

  Conversation({
    this.id,
    this.name,
    this.avatar,
    this.lastMessage,
    this.unreadCount,
    this.timestamp,
  });
}
