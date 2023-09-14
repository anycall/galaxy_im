import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_im/Utils/Extensions.dart';
import 'package:galaxy_im/Utils/LogUtil.dart';

void main() {
  test("test xml parse", () {
    var openResultXml =
        "<open xmlns='urn:ietf:params:xml:ns:xmpp-framing' from='xmpp.cloud' id='2c0d22d2-f305-483b-98da-1f8950af4789'    version='1.0' xml:lang='en' />";
    var (result, doc) = XmlDocumentExtension.tryParse(openResultXml);
    if (result) {
      var name = doc!.rootElement.localName.toString();
      var from = doc.rootElement.getAttribute("from");

      assert(name == "open" && from == "xmpp.cloud");
    } else {
      assert(false);
    }
  });

  test("stream", () {
    var streamXml =
        '<stream:features xmlns:stream="http://etherx.jabber.org/streams"><auth xmlns="http://jabber.org/features/iq-auth"/><mechanisms xmlns="urn:ietf:params:xml:ns:xmpp-sasl"><mechanism>PLAIN</mechanism></mechanisms><register xmlns="http://jabber.org/features/iq-register"/><compression xmlns="http://jabber.org/features/compress"><method>zlib</method></compression></stream:features>';
    var (result, doc) = XmlDocumentExtension.tryParse(streamXml);
    if (result) {
      LogUtil.debug(doc!.rootElement.localName);
    }
    assert(result);
  });

  test("success", () {
    var successXml = '<success xmlns="urn:ietf:params:xml:ns:xmpp-sasl"/>';
    var (result, doc) = XmlDocumentExtension.tryParse(successXml);
    if (result) {
      LogUtil.debug(doc!.rootElement.localName);
    }
    assert(doc?.rootElement.localName == "success");
  });
}
