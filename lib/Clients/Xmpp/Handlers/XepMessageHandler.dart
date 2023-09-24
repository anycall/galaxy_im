import 'package:xml/xml.dart';

typedef Handler = void Function(XmlDocument xml);

class XepMessageHandler {
  String ns;
  String name;
  String type;
  String id;
  String from;
  String to;
  bool matchBareFromJid;
  bool ignoreNamespaceFragment;
  Handler msgHandler;

  XepMessageHandler(this.ns, this.name, this.type, this.id, this.from, this.to,
      this.matchBareFromJid, this.ignoreNamespaceFragment, this.msgHandler);
}
