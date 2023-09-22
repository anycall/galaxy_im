/// 主题管理类ColorScheme
/// light() 里的onPrimary是白色，onSurface是黑色
/// dark() 里的onPrimary是黑色，onSurface是白色
/// auto为系统皮肤
///
/// 字体TextTheme
/// displayLarge: 这是一种用于显示非常大的文本的样式。通常用于大屏幕上的重要文本或数字。
/// displayMedium: 这是一种介于大号和小号之间的大型文本样式，也用于显示重要文本或数字。
/// displaySmall: 这是一种用于显示相对较小但仍然重要的文本的样式。通常在大屏幕上使用。
/// headlineLarge: 这是用于标题的大型文本样式。标题通常是页面上的重要标题。
/// headlineMedium: 这是用于标题的中型文本样式，较小于大号标题。
/// headlineSmall: 这是用于标题的较小的文本样式，通常用于较小的屏幕或辅助标题。
/// titleLarge: 这是一种用于标题文本的大型样式，相对较小于标题。
/// titleMedium: 这是一种用于标题文本的中型样式，较小于大号标题。
/// titleSmall: 这是一种用于标题文本的较小样式，通常用于较小的屏幕或次要标题。
/// bodyLarge: 这是用于正文文本的大型文本样式，通常用于显示长文本段落。
/// bodyMedium: 这是用于正文文本的中型文本样式，是默认的文本样式。
/// bodySmall: 这是用于正文文本的较小文本样式，通常用于显示较小的正文文本。
/// labelLarge: 这是一种用于标签文本的大型样式，通常用于标签、按钮文本等。
/// labelMedium: 这是一种用于标签文本的中型样式。
/// labelSmall: 这是一种用于标签文本的较小样式，通常用于显示较小的标签文本。

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends GetxController {
  static final ThemeManager _instance = ThemeManager._internal();

  factory ThemeManager() {
    return _instance;
  }

  ThemeManager._internal();

  late ColorScheme currentColorScheme;
  FontSizeStyle currentFontSizeStyle = FontSizeStyle(
    titleFontSize: 20,
    subtitleFontSize: 16,
    contentFontSize: 12,
  );

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedSkin = prefs.getString('skin');

    Brightness platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (platformBrightness == Brightness.dark) {
      currentColorScheme = const ColorScheme.dark(onSecondary: Colors.blue);
    } else {
      currentColorScheme = const ColorScheme.light(onSecondary: Colors.blue);
    }

    if (savedSkin != null) {
      currentColorScheme = jsonToColorScheme(savedSkin);
    }

    int? fontSizeIndex = prefs.getInt('fontSize');
    if (fontSizeIndex != null) {
      currentFontSizeStyle = getFontSizeStyle(fontSizeIndex);
    } else {
      //存储默认字体大小
      saveFontSize(FontSize.standard);
    }
  }

  // 根据枚举获取字体大小
  FontSizeStyle getFontSizeStyle(int fontSizeIndex) {
    switch (fontSizeIndex) {
      case 0:
        return FontSizeStyle(
          titleFontSize: 16,
          subtitleFontSize: 13,
          contentFontSize: 10,
        );
      case 1:
        return FontSizeStyle(
          titleFontSize: 20,
          subtitleFontSize: 16,
          contentFontSize: 12,
        );
      case 2:
        return FontSizeStyle(
          titleFontSize: 24,
          subtitleFontSize: 19,
          contentFontSize: 14,
        );

      default:
        return FontSizeStyle(
          titleFontSize: 20,
          subtitleFontSize: 16,
          contentFontSize: 12,
        );
    }
  }

  // 将ColorScheme对象转换为JSON字符串
  String colorSchemeToJson(ColorScheme colorScheme) {
    Map<String, dynamic> colorValues = {
      'brightness': colorScheme.brightness.toString(), // 将Brightness枚举转换为字符串
      'primary': colorScheme.primary.value,
      'onPrimary': colorScheme.onPrimary.value,
      'secondary': colorScheme.secondary.value,
      'onSecondary': colorScheme.onSecondary.value,
      'error': colorScheme.error.value,
      'onError': colorScheme.onError.value,
      'background': colorScheme.background.value,
      'onBackground': colorScheme.onBackground.value,
      'surface': colorScheme.surface.value,
      'onSurface': colorScheme.onSurface.value,
    };
    return jsonEncode(colorValues);
  }

  // 将JSON字符串转换为ColorScheme对象
  ColorScheme jsonToColorScheme(String json) {
    Map<String, dynamic> colorValues = jsonDecode(json);
    return ColorScheme(
      brightness: colorValues['brightness'] == 'Brightness.light'
          ? Brightness.light
          : Brightness.dark,
      primary: Color(colorValues['primary']),
      onPrimary: Color(colorValues['onPrimary']),
      secondary: Color(colorValues['secondary']),
      onSecondary: Color(colorValues['onSecondary']),
      error: Color(colorValues['error']),
      onError: Color(colorValues['onError']),
      background: Color(colorValues['background']),
      onBackground: Color(colorValues['onBackground']),
      surface: Color(colorValues['surface']),
      onSurface: Color(colorValues['onSurface']),
    );
  }

  //切换主题的方法
  Future<void> updateColorScheme(bool auto, {ColorScheme? colorScheme}) async {
    if (auto == false) {
      colorScheme ??= const ColorScheme.light(onSecondary: Colors.blue);
      String color = colorSchemeToJson(colorScheme);
      await saveColorScheme(color);
      currentColorScheme = colorScheme;

      Get.changeTheme(ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ));
    } else {
      await deleteColorScheme();
      Brightness platformBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (platformBrightness == Brightness.dark) {
        currentColorScheme = const ColorScheme.dark(onSecondary: Colors.blue);
      } else {
        currentColorScheme = const ColorScheme.light(onSecondary: Colors.blue);
      }
      Get.changeTheme(ThemeData(
        colorScheme: currentColorScheme,
        textTheme: TextTheme(
            labelMedium:
                TextStyle(fontSize: currentFontSizeStyle.subtitleFontSize)),
        useMaterial3: true,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ));
    }
  }

  DefaultChatTheme getChatTheme() {
    return DefaultChatTheme(
      backgroundColor: currentColorScheme.brightness == Brightness.dark ? currentColorScheme.onPrimary : currentColorScheme.onSurface.withOpacity(0.1),
      inputBackgroundColor: currentColorScheme.onPrimary,
      //光标
      inputTextCursorColor: currentColorScheme.onSurface,
      inputTextColor: currentColorScheme.onSurface,
      primaryColor: currentColorScheme.onSecondary,
      
      userNameTextStyle: TextStyle(
        fontSize: currentFontSizeStyle.contentFontSize,
        fontWeight: FontWeight.bold,
      ),
      inputBorderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      inputContainerDecoration: BoxDecoration(
        color: currentColorScheme.onPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, -1.5),
            blurRadius: 4,
          ),
        ],
      ),
      receivedMessageBodyTextStyle: TextStyle(
        color: currentColorScheme.onSurface,
        fontSize: currentFontSizeStyle.contentFontSize,
      ),
      sentMessageBodyTextStyle: TextStyle(
        color: currentColorScheme.onPrimary,
        fontSize: currentFontSizeStyle.contentFontSize,
      ),
      // sentMessageBodyLinkTextStyle: TextStyle(
      //   color: currentColorScheme.onSurface,
      //   fontSize: currentFontSizeStyle.contentFontSize,
      // ),
      // receivedMessageBodyCodeTextStyle: TextStyle(
      //   color: currentColorScheme.onPrimary,
      //   fontSize: currentFontSizeStyle.contentFontSize,
      // ),
    );
  }

  //切换字体大小的方法
  Future<void> updateFontSize(FontSize fontSize) async {
    currentFontSizeStyle = getFontSizeStyle(fontSize.index);
    await saveFontSize(fontSize);
    Get.changeTheme(ThemeData(
      colorScheme: currentColorScheme,
      textTheme: TextTheme(
          labelMedium:
              TextStyle(fontSize: currentFontSizeStyle.subtitleFontSize)),
      useMaterial3: true,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    ));
  }

  //SharedPreferencess保存主题
  Future<void> saveColorScheme(String color) async {
    if (color.isEmpty) {
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('skin', color);
  }

  //SharedPreferencess删除主题
  Future<void> deleteColorScheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('skin');
  }

  //SharedPreferencess保存字体大小(枚举)
  Future<void> saveFontSize(FontSize fontSize) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fontSize', fontSize.index);
  }
}

//字体大小的枚举类，有小、标准、大三种
enum FontSize { small, standard, large }

// 字体类
class FontSizeStyle {
  final double titleFontSize;
  final double subtitleFontSize;
  final double contentFontSize;

  FontSizeStyle({
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.contentFontSize,
  });
}
