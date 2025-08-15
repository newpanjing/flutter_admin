import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化动态路由
  await AppRouter.initializeDynamicRoutes();
  
  // 恢复路由状态
  await _restoreRouterState();
  
  runApp(const MyApp());
}

/// 从本地存储恢复路由状态
Future<void> _restoreRouterState() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final lastLocation = prefs.getString('last_route_location');
    final isLoggedIn = prefs.getString('auth_token') != null;
    
    if (lastLocation != null && isLoggedIn) {
      AppRouter.saveCurrentLocation(lastLocation);
      AppRouter.setLoginStatus(true);
    }
  } catch (e) {
    // 忽略恢复错误，使用默认状态
    print('Failed to restore router state: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 在第一帧渲染完成后触发flutter-initialized事件
    WidgetsBinding.instance.addPostFrameCallback((_) {
      html.window.dispatchEvent(html.CustomEvent('flutter-initialized'));
    });
    
    return MaterialApp.router(
      title: 'ERP管理系统',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      // 启用状态恢复，支持hot reload后保持页面状态
      restorationScopeId: 'main_app',
    );
  }
}
