// Client接口文件，用于定义客户端接口方法，不同类型的服务器端，拥有自己的Client类型的实现，实现的类型需要继承本接口
// 例如：XmppClient，是实现了Xmpp协议链接的客户端
// 接口定义了连接，断开，重连，接受消息，发送消息，登录，登出等方法


abstract class IClientInterface {
  BaseServerInfo serverInfo;
  RawMessageOutput get rawOutput => serverInfo.rawOutput!;

  IClientInterface(this.serverInfo);

  Future<void> disconnect();
  Future<void> reconnect();
  Future<void> receiveMessage();
  Future<void> sendMessage(String message);
  Future<bool> login(BaseLoginInfo info);
  Future<void> logout();
}

typedef RawMessageOutput = void Function(String message,
    {String prefix, String suffix});

class BaseServerInfo {
  String server;
  int port;
  RawMessageOutput? rawOutput;
  BaseServerInfo(this.server, this.port, this.rawOutput);
}

class XmppServerInfo extends BaseServerInfo {
  XmppServerInfo(String server, int port, RawMessageOutput? outputHandler)
      : super(server, port, outputHandler);
}

//基础的登录信息，用于占位的基类，不同的协议，需要继承本类，实现自己的登录信息传入
class BaseLoginInfo {
  String userName;
  String password;
  BaseLoginInfo(this.userName, this.password);
}

class XmppLoginInfo extends BaseLoginInfo {
  String domain;
  XmppLoginInfo(String userName, String password, this.domain)
      : super(userName, password);
}
