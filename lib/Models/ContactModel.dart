import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:galaxy_im/Pages/Widget/azlistview/azlistview.dart';

class ContactModel extends ISuspensionBean {
  String name;
  User? user;
  String? tagIndex;
  String? namePinyin;

  ContactModel({
    required this.name,
    this.user,
    this.tagIndex,
    this.namePinyin,
  });

  @override
  String getSuspensionTag() => tagIndex!;
}