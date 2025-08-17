import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import 'controllers/settings_controller.dart';
import 'package:flutter/foundation.dart';
import 'utils/web_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化GetX
  Get.put(SettingsController());
  
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
    // 在第一帧渲染完成后触发flutter-initialized事件（仅Web平台）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WebUtils.triggerFlutterInitializedEvent();
    });
    
    return GetBuilder<SettingsController>(
      builder: (controller) => MaterialApp.router(
        title: 'ERP管理系统',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: controller.themeMode,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        // 启用状态恢复，支持hot reload后保持页面状态
        restorationScopeId: 'main_app',
      ),
    );
  }
}
