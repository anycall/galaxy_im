import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galaxy_im/Helper/LocalizationService.dart';
import 'package:galaxy_im/Helper/ThemeManager.dart';

class Helper {
  /// 国际化
  static final LocalizationService _localizationService = LocalizationService();
  static LocalizationService get localizationService => _localizationService;

  /// 主题
  static final ThemeManager _themeManager = ThemeManager();
  static ThemeManager get themeManager => _themeManager;

  ///主题色（背景）
  static Color get imPrimary => _themeManager.currentColorScheme.inversePrimary;
  ///主题色反色（字）
  static Color get imSurface => _themeManager.currentColorScheme.onSurface;

  ///字体大小
  ///标题
  static double get titleFontSize => _themeManager.currentFontSizeStyle.titleFontSize.sp;
  ///副标题
  static double get subtitleFontSize => _themeManager.currentFontSizeStyle.subtitleFontSize.sp;
  ///内容
  static double get contentFontSize => _themeManager.currentFontSizeStyle.contentFontSize.sp;

  /// 获取屏幕参数
  /// 获取屏幕高度
  static double get screenHeight => 1.sh;
  /// 获取屏幕宽度
  static double get screenWidth => 1.sw;
  static double? get scale => ScreenUtil().pixelRatio;
  static double get textScaleFactor => ScreenUtil().textScaleFactor;
  ///顶部导航栏高度= 状态栏高度 + 导航栏高度
  static double get topBarHeight => kToolbarHeight + ScreenUtil().statusBarHeight;
  ///顶部状态栏高度（包含安全区）
  static double get topSafeHeight => ScreenUtil().statusBarHeight;
  ///底部状态栏高度（包含安全区）
  static double get bottomSafeHeight => ScreenUtil().bottomBarHeight;
}