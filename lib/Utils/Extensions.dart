import 'package:xml/xml.dart';

//定义一个扩展方法，用于封装try catch，当从String转为XmlDocument时，如果出现异常，返回false，否则返回true
extension XmlDocumentExtension on XmlDocument {
  static (bool, XmlDocument?) tryParse(String xml) {
    try {
      var doc = XmlDocument.parse(xml);
      return (true, doc);
    } catch (err) {
      return (false, null);
    }
  }
}
