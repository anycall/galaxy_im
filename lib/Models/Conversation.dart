// Purpose: Model for Conversation object

class Conversation {
  String id;
  String name;
  String avatar;
  String lastMessage;
  int unreadCount;
  int timestamp;

  Conversation({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.unreadCount,
    required this.timestamp,
  });

  //TODO: implement fromJson
  //TODO: implement toJson
  //TODO: get user from id
}
