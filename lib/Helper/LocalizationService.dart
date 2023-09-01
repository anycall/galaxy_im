import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends GetxController {
  static final LocalizationService _instance = LocalizationService._internal();

  factory LocalizationService() {
    return _instance;
  }

  LocalizationService._internal();

  final String defaultString = 'en';
  late String _currentString;
  var localizedStrings = <String, dynamic>{}.obs;

  String get currentLocale => _currentString;

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLocale = prefs.getString('locale');
    String systemLocale = PlatformDispatcher.instance.locale.languageCode;

    if (savedLocale != null) {
      _currentString = savedLocale;
    }
    else if (systemLocale == 'zh' || systemLocale == 'en') {
      _currentString = systemLocale;
    }
    else {
      _currentString = defaultString;
    }
    await loadJsonLocale(_currentString); 
    // Intl.defaultLocale = _currentString;
  }


  Future<void> loadJsonLocale(String locale) async {
    final String fileName = 'assets/l10n/$locale.json';
    //TODO: 从本地文件加载本地化文本

    try {
      final jsonString = await rootBundle.loadString(fileName);
      final jsonMap = json.decode(jsonString);
      localizedStrings.value = jsonMap;
    } catch (e) {
      // 如果加载或解析失败，可以添加适当的错误处理，在这里可以设置默认的本地化文本或采取其他措施
    }
  }

  String translate(String key) {
    if (localizedStrings[key] == null) {
      // 在未找到翻译时，返回一个默认的占位文本或采取其他措施
      return 'Translation not found for $key';
    }
    return localizedStrings[key];
  }

  Future<void> setLocale(String locale) async {
    _currentString = locale;
    await loadJsonLocale(_currentString); 
    // Intl.defaultLocale = _currentString;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', _currentString);
  }
}
