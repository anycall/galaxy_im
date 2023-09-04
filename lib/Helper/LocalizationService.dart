import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:galaxy_im/Helper/Helper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends GetxController {
  static final LocalizationService _instance = LocalizationService._internal();

  factory LocalizationService() {
    return _instance;
  }

  LocalizationService._internal();

  late var currentString = 'en'.obs;
  var localizedStrings = <String, Map<String, String>>{}.obs;

  Locale get currentLocale => Locale(currentString.value);

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLocale = prefs.getString('locale');
    String systemLocale = PlatformDispatcher.instance.locale.languageCode;

    if (savedLocale != null) {
      currentString.value = savedLocale;
    } else if (systemLocale == 'zh' || systemLocale == 'en') {
      currentString.value = systemLocale;
    }
    await loadJsonLocale(currentString.value);
    // Intl.defaultLocale = currentString;
  }

  Future<void> loadJsonLocale(String locale) async {
    final String fileName = 'assets/l10n/$locale.json';
    //TODO: 从本地文件加载本地化文本

    try {
      final jsonString = await rootBundle.loadString(fileName);
      final jsonMap = json.decode(jsonString);
      Map<String, String> stringMap = Map<String, String>.from(jsonMap.map(
          (key, value) => MapEntry<String, String>(key, value.toString())));
      localizedStrings.clear();
      localizedStrings[locale] = stringMap;
      Get.clearTranslations();
      Get.addTranslations(localizedStrings);
    } catch (e) {
      // 如果加载或解析失败，可以添加适当的错误处理，在这里可以设置默认的本地化文本或采取其他措施
    }
  }

  Future<void> setLocale(String locale) async {
    if (currentString.value == locale) {
      return;
    }

    currentString.value = locale;
    await loadJsonLocale(currentString.value);
    // Intl.defaultLocale = currentString;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', currentString.value);
  }
}

class LocationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return Helper.localizationService.localizedStrings;
  }
}
