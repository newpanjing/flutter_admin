import 'package:flutter/foundation.dart';
import 'web_utils_stub.dart'
    if (dart.library.html) 'web_utils_web.dart'
    if (dart.library.io) 'web_utils_io.dart';

/// Web平台工具类
class WebUtils {
  /// 触发flutter-initialized事件（仅Web平台）
  static void triggerFlutterInitializedEvent() {
    if (kIsWeb) {
      WebUtilsPlatform.triggerFlutterInitializedEvent();
    }
  }
}