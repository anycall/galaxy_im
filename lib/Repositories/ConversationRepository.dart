// Purpose: 处理与会话相关的所有数据库和网络请求，UI层直接使用该类的方法即可，
// 无需处理数据持久化和网络请求
// 本类型使用GetX的依赖注入功能，返回的类型可以直接用于UI层

import 'package:get/get.dart';

class ConversationRepository extends GetxController {}
