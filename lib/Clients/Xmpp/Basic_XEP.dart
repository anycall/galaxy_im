import 'dart:async';

import 'package:galaxy_im/Clients/Xmpp/Xmpp_Types.dart';
import 'package:xml/xml.dart';
import 'package:uuid/uuid.dart';
import 'package:galaxy_im/Utils/LogUtil.dart';

typedef MessageFilter = XmlDocument Function(XmlDocument xml);

abstract class XEP {
  ///生成一个GUID，返回GUID字符串
  String newGuid() {
    var uuid = Uuid();
    return uuid.v4();
  }

  ///子类可以访问的String类型的属性

  abstract String xep_name;
  List<XepMessageHandler> receiveHandlers = [];
  List<MessageFilter> beforeMessageFilter = [];
  List<MessageFilter> afterMessageFitler = [];

  List<Timer Function()> continuousTasks = [];
  List<void Function()> onceTasks = [];
  String bare_jid = '';
  List<XepMessageHandler> getReceiceHandlers() {
    if (receiveHandlers.isNotEmpty) {
      for (var handler in receiveHandlers) {
        handler.ns = xep_name;
      }
    }
    return receiveHandlers;
  }

  List<MessageFilter> getBeforeMessageFilters() {
    var filters = beforeMessageFilter;
    LogUtil.debug('${xep_name} 包含 ${filters.length} 消息前处理过滤器');
    return filters;
  }

  List<MessageFilter> getAfterMessageFitlers() {
    var filters = afterMessageFitler;
    LogUtil.debug('${xep_name} 包含 ${filters.length} 消息后处理过滤器');
    return filters;
  }
}

abstract class IXEP_Common {}

class XEP_Login extends XEP implements IXEP_Common {
  @override
  String xep_name = "XEP_Login";
}
