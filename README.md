# 目标 / Objective

使用Flutter开发一个跨平台，兼容多种后台的IM客户端程序；


客户端兼容平台目标：iOS, Android, Web, Windows, MacOS, Linux

客户端功能目标：

* 实现即时通讯单聊基本功能
* 实现即时通讯群聊基本功能
* 实现音视频语音通话功能
* 支持多语言国际化
* 支持多种主题


服务器端兼容目标：Tigease Server, Netty Server, SingalR, MQTT

## 路线图 / Roadmap

- [ ] 2023-08-31：完成项目初始化，完成项目目录结构设计，完成项目文档编写
- [ ] 2023-09-30：客户端基础UI功能开发完成，服务端适配Tigease Server
- [ ] 2023-10-31：客户端音视频通话功能开发完成，建立Media Server


# 功能特性 / Features

# 技术栈 / Tech Stack


技术框架：Flutter, Dart, Tigease Server, Netty, SingalR, MQTT

数据库技术：MongoDB, MySql, Drift

开发语言：Dart, Java, C#, Go, C++ 

# 安装 / Installation

客户端开发环境配置:

客户端需要安装Flutter 开发环境，请自行获取Flutter开发环境的安装方法；

切换到 Flutter Master Chanel 进行开发

```bash
flutter channel master
```



Tigease Server 运行环境配置：

由于不需要定制开发Tigease Server，所以直接使用Tigease Server的Docker镜像进行部署即可；

```bash
docker pull tigase/tigase-xmpp-server
docker run --name tigase-server -p 8080:8080 -p 5222:5222 tigase/tigase-xmpp-server:tag
```

[参考地址](https://hub.docker.com/r/tigase/tigase-xmpp-server)


# 测试 / Testing

使用Flutter自带的测试框架进行测试；

单元测试

UI测试


# 部署 / Deployment

# 使用说明 / Usage

# 贡献指南 / Contributing



# 版权信息 / License

本项目使用 Apache 许可证 2.0 开源协议，详情请见 LICENSE 文件。


# 联系方式 / Contact

# 常见问题 / FAQ

# 更新日志 / Changelog


# 致谢 / Acknowledgements

[Gallery](https://gallery.flutter.cn/#/)
