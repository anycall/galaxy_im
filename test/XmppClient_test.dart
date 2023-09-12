import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_im/Clients/IClientInterface.dart';
import 'package:galaxy_im/Clients/Xmpp/XmppClient.dart';

void main() {
  late XmppClient _xmppClient;

  setUp(() async {
    var xmppServerInfo = XmppServerInfo("wss://xmpp.cloud", 5291, null);
    _xmppClient = XmppClient(xmppServerInfo);
  });
  test('test login', () async {
    var email = "krtbzq38764@chacuo.net";
    var username = "krtbzq38764";
    var password = "krtbzq38764";
    var domain = "xmpp.cloud";
    var xmppLoginInfo = XmppLoginInfo(username, password, domain);
    var loginResult = await _xmppClient.login(xmppLoginInfo);
    expect(loginResult, true);
  });
}
