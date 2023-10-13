import 'dart:convert';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class JsonArrayGenerator {
  final Faker _faker = Faker();
  final Uuid _uuid = const Uuid();

  String generateRandomUserJsonArray(int numberOfObjects, {String? subscription = 'both'}) {
    List<Map<String, dynamic>> jsonArray = [];

    for (int i = 0; i < numberOfObjects; i++) {
      String id = _uuid.v4();
      String firstName = _faker.person.firstName();
      String lastName = _faker.person.lastName();

      Map<String, dynamic> jsonObject = {
        "createdAt": _faker.date.dateTime().millisecondsSinceEpoch,
        "firstName": firstName,
        "id": id,
        "imageUrl": id,
        "lastName": lastName,
        "lastSeen": DateTime.now().millisecondsSinceEpoch,
        "metadata": {
          "subscription": subscription, //订阅类型
        },
        "role": "user", //Role { admin, agent, moderator, user }
        "updatedAt": DateTime.now().millisecondsSinceEpoch,
      };

      jsonArray.add(jsonObject);
    }

    String jsonStr = json.encode(jsonArray);
    return jsonStr;
  }

  Future<String> generateRandomConversationJsonArray(
      int numberOfObjects) async {
    List<Map<String, dynamic>> jsonArray = [];
    final response = await rootBundle.loadString('assets/messages.json');
    final List<dynamic> messages = jsonDecode(response);
    //随机获取messages的一个元素
    final random = Random();
    

    for (int i = 0; i < numberOfObjects; i++) {
      String id = _uuid.v4();
      //聊天对象id
      String userId = _uuid.v4();

      final randomMessage = messages[random.nextInt(messages.length)];
      List<Map<String, dynamic>> lastMessagesList = [randomMessage];

      //聊天对象
      Map<String, dynamic> userObject = {
        "createdAt": _faker.date.dateTime().millisecondsSinceEpoch,
        "firstName": _faker.person.firstName(),
        "id": userId,
        "imageUrl": userId,
        "lastName": _faker.person.lastName(),
        "lastSeen": DateTime.now().millisecondsSinceEpoch,
        "metadata": {
          "subscription": 'both',
        },
        "role": "user",
        "updatedAt": DateTime.now().millisecondsSinceEpoch,
      };

      Map<String, dynamic> jsonObject = {
        "createdAt": DateTime.now().millisecondsSinceEpoch - 1000 * 60 * 60 * 24 * i,
        "id": id,
        "imageUrl": id,
        "lastMessages": lastMessagesList,
        "type": "direct", //RoomType { channel, direct, group }
        "name": userObject['firstName'] + userObject['lastName'],
        "updatedAt": DateTime.now().millisecondsSinceEpoch,
        "users": [userObject],
      };

      jsonArray.add(jsonObject);
    }

    String jsonStr = json.encode(jsonArray);
    return jsonStr;
  }
}
