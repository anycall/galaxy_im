import 'package:flutter/material.dart';

class WidgetFactory{

  static PreferredSize buildAppBarLine(){
    return PreferredSize(
      preferredSize: const Size.fromHeight(0.25),
      child: WidgetFactory.buildLine(),
    );
  }

  /// 构建AppBar返回按钮
  static IconButton buildAppBarBackButton(BuildContext context){
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back_ios_new),
    );
  }

  /// 构建App的线
  static Widget buildLine(){
    return Container(
      color: Colors.grey,
      height: 0.25,
    );
  }


}