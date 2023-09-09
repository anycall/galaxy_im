import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_im/Utils/Extensions.dart';

void main() {
  test("test xml parse", () {
    var openResultXml =
        "<open xmlns='urn:ietf:params:xml:ns:xmpp-framing' from='xmpp.cloud' id='2c0d22d2-f305-483b-98da-1f8950af4789'    version='1.0' xml:lang='en' />";
    var (result, doc) = XmlDocumentExtension.tryParse(openResultXml);
    if (result) {
      var name = doc!.rootElement.localName.toString();
      var from = doc!.rootElement.getAttribute("from");

      assert(name == "open" && from == "xmpp.cloud");
    } else {
      assert(false);
    }
  });
}
