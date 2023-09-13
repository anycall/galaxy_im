import 'package:flutter/material.dart';

class WidgetFactory{
    static final WidgetFactory _instance = WidgetFactory._internal();

  factory WidgetFactory() {
    return _instance;
  }

  WidgetFactory._internal();

  /// 构建AppBar下的线
  PreferredSize buildAppBarLine(){
    return PreferredSize(
      preferredSize: const Size.fromHeight(0.25),
      child: Container(
        color: Colors.grey,
        height: 0.25,
      ),
    );
  }

  /// 构建AppBar返回按钮
  IconButton buildAppBarBackButton(BuildContext context){
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back_ios_new),
    );
  }

}