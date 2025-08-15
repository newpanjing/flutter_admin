import 'package:shared_preferences/shared_preferences.dart';

/// 路由状态管理器
/// 用于在hot reload时保持页面状态
class RouteStateManager {
  static const String _lastRouteKey = 'last_route_location';
  static const String _routeTimestampKey = 'route_timestamp';
  
  /// 保存路由状态
  static Future<void> saveRouteState(String location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastRouteKey, location);
      await prefs.setInt(_routeTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Failed to save route state: $e');
    }
  }
  
  /// 获取保存的路由状态
  static Future<String?> getSavedRouteState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final location = prefs.getString(_lastRouteKey);
      final timestamp = prefs.getInt(_routeTimestampKey);
      
      // 如果保存的状态超过1小时，则认为过期
      if (timestamp != null && location != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final hourInMs = 60 * 60 * 1000;
        
        if (now - timestamp < hourInMs) {
          return location;
        }
      }
      
      return null;
    } catch (e) {
      print('Failed to get saved route state: $e');
      return null;
    }
  }
  
  /// 清除路由状态
  static Future<void> clearRouteState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastRouteKey);
      await prefs.remove(_routeTimestampKey);
    } catch (e) {
      print('Failed to clear route state: $e');
    }
  }
  
  /// 检查是否应该恢复路由状态
  static Future<bool> shouldRestoreState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasToken = prefs.getString('auth_token') != null;
      final hasRouteState = await getSavedRouteState() != null;
      
      return hasToken && hasRouteState;
    } catch (e) {
      return false;
    }
  }
}