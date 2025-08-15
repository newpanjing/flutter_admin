import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化动态路由
  await AppRouter.initializeDynamicRoutes();
  
  runApp(const MyApp());
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
    );
  }
}
