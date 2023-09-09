import 'package:logger/logger.dart';

/// 日志工具类
/// 1. 使用方法, 在需要打印日志的地方调用 LogUtil.debug('日志内容');
class LogUtil {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  ///解释这个方法
  ///1. message: 日志内容
  ///2. params: 日志内容中的参数
  ///3. 返回值: 拼接后的日志内容
  ///4. 作用: 将日志内容和参数拼接成一个字符串
  ///5. 举例: mergeMessage('日志内容', ['参数1', '参数2']) => '日志内容\n参数1\n参数2'
  ///6. 说明: 为什么要这么做呢? 因为logger库的d方法只能接收一个参数, 但是我们的日志内容中可能会有多个参数, 所以需要将日志内容和参数拼接成一个字符串
  ///7. 举例: LogUtil.debug('日志内容', params: ['参数1', '参数2']) => '日志内容\n参数1\n参数2'
  static String mergeMessage(String message, List<dynamic>? params) {
    var itemsMessage = [message, params?.map((e) => e?.toString() ?? '')]
        .where((element) => element != null)
        .join("\n");
    return itemsMessage;
  }

  static void debug(String message, {List<dynamic>? params}) {
    _logger.d(mergeMessage(message, params));
  }

  static void info(String message) {
    _logger.i(message);
  }

  static void error(String message) {
    _logger.e(message);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void trace(String message) {
    _logger.t(message);
  }

  static void fatal(String message) {
    _logger.f(message);
  }
}
