import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_im/Clients/IClientInterface.dart';
import 'package:galaxy_im/Clients/Xmpp/XmppClient.dart';

void main() {
  late XmppClient xmppClient;

  setUp(() async {
    var xmppServerInfo = XmppServerInfo("wss://xmpp.cloud", 5291, null);
    xmppClient = XmppClient(xmppServerInfo);
  });
  test('test login', () async {
    var email = "krtbzq38764@chacuo.net";
    var username = "krtbzq38764";
    var password = "krtbzq38764";
    var domain = "xmpp.cloud";
    var xmppLoginInfo = XmppLoginInfo(username, password, domain);
    var loginResult = await xmppClient.login(xmppLoginInfo);
    expect(loginResult, true);
  });
}
