import 'package:flutter/material.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

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

  ///搜索无结果
  static Widget buildSearchNoResult(){
    return SizedBox(
        width: Helper.screenWidth,
        height: Helper.screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.manage_search, color: Colors.grey, size: 50,),
            Text('noSearchResults'.tr, style: TextStyle(color: Colors.grey, fontSize: Helper.contentFontSize),)
          ],
        )
      );
  }

}