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