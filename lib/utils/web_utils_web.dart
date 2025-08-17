import 'dart:html' as html;

/// Web平台具体实现
class WebUtilsPlatform {
  /// 触发flutter-initialized事件（Web平台实现）
  static void triggerFlutterInitializedEvent() {
    try {
      final window = html.window;
      final event = html.CustomEvent('flutter-initialized');
      window.dispatchEvent(event);
    } catch (e) {
      print('Failed to dispatch flutter-initialized event: $e');
    }
  }
}