import 'dart:convert';
import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:galaxy_im/Pages/Widget/WidgetFactory.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SingleChatPage extends StatefulWidget {
  const SingleChatPage({super.key});

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  final User _user = Get.arguments;
  final GlobalKey<ChatState> _singleChatKey = GlobalKey(); //用于跳转到未读
  List<types.Message> _messages = [];
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  //发消息
  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  //分页
  Future<void> _handleEndReached() async {
    //测试数据
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List).map((e) {
      var message = types.Message.fromJson(e as Map<String, dynamic>);
      message = message.copyWith(id: const Uuid().v4());
      return message;
    }).toList();

    setState(() {
      _messages.addAll(messages);
      //假设100条消息为最后一页
      if (_messages.length >= 100) {
        _isLastPage = true;
      }
    });
  }

  //滚动到未读消息
  Future<void> _scrollToLastReadMessage() async {
    if (_messages.where((e) => e.id == 'lastReadMessageId').isEmpty) {
      await _handleEndReached();//没有未读消息，加载更多，这个待定
    } else {
      Future.delayed(const Duration(milliseconds: 20), () {
        _singleChatKey.currentState?.scrollToUnreadHeader();
      });
    }
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  void _handleMessageStatusTap(BuildContext _, types.Message message) async {
    print('Message status tapped: ${message.status}');
  }

  Widget _bubbleBuilder(
    Widget child, {
    required message,
    required nextMessageInGroup,
  }) {
    double padding = 0;
    if (nextMessageInGroup) {
      if (_user.id == message.author.id) {
        padding = 6;
      }
    }
    return Bubble(
      color: _user.id != message.author.id ||
              message.type == types.MessageType.image
          ? (Helper.isDarkMode
              ? Helper.imSurface.withOpacity(0.2)
              : Helper.imPrimary)
          : Helper.imSecondary,
      margin: BubbleEdges.symmetric(horizontal: padding),
      nip: nextMessageInGroup
          ? BubbleNip.no
          : _user.id != message.author.id
              ? BubbleNip.leftBottom
              : BubbleNip.rightBottom,
      padding: message.type == types.MessageType.text
          ? const BubbleEdges.all(0)
          : const BubbleEdges.all(5),
      elevation: 0,
      child: child,
    );
  }

  //头像
  Widget _avatarBuilder(
    String? url,
  ) =>
      RandomAvatar(
        url ?? '',
        width: 30.r,
        height: 30.r,
      );
  //日期
  String _dateHeaderText(DateTime dateTime) {
    int timeStamp = dateTime.millisecondsSinceEpoch;
    return Helper.getConversationFormatDate(timeStamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        scrolledUnderElevation: 0,
        bottom: WidgetFactory().buildAppBarLine(),
        title: Text('单聊'),
        leading: WidgetFactory().buildAppBarBackButton(context),
      ),
      body: Chat(
        key: _singleChatKey,
        messages: _messages,
        // onAttachmentPressed: _handleAttachmentPressed,
        onMessageTap: _handleMessageTap, //点击消息
        onEndReached: _handleEndReached, //分页
        onEndReachedThreshold: 0.1, // 分页加载阈值，0.1表示滑动到距离列表总数10%时触发
        isLastPage: _isLastPage, //true表示最后一页,不再调用onEndReached
        onMessageStatusTap: _handleMessageStatusTap, //点击消息状态
        onPreviewDataFetched: _handlePreviewDataFetched, //显示连接消息的预览数据
        onSendPressed: _handleSendPressed, //发送消息
        avatarBuilder: _avatarBuilder, //头像
        bubbleBuilder: _bubbleBuilder, //气泡
        customDateHeaderText: _dateHeaderText, //日期
        showUserAvatars: true,
        showUserNames: true,
        user: _user,
        theme: Helper.chatTheme,
      ),
    );
  }
}
