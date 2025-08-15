import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/menu_model.dart';
import '../pages/dashboard_page.dart';
import '../pages/login_page.dart';
import '../pages/main_layout.dart';
import '../pages/menu_debug_page.dart';
import '../pages/not_found_page.dart';
import '../pages/vip_page.dart';
import '../widgets/data_table.dart';
import '../services/api_service.dart';

class AppRouter {
  static bool _isLoggedIn = false;
  static List<GoRoute> _dynamicRoutes = [];

  static void setLoginStatus(bool status) {
    _isLoggedIn = status;
  }

  /// 初始化动态路由
  static Future<void> initializeDynamicRoutes() async {
    try {
      final menuConfig = await ApiService.getMenuConfig();
      if (menuConfig.success) {
        _dynamicRoutes = _createDynamicRoutes(menuConfig.data.menus);
      }
    } catch (e) {
      print('Failed to load dynamic routes: $e');
      // 如果加载失败，使用空的动态路由列表
      _dynamicRoutes = [];
    }
  }

  /// 根据菜单配置创建动态路由
  static List<GoRoute> _createDynamicRoutes(List<MenuItemConfig> menus) {
    List<GoRoute> routes = [];
    
    for (var menu in menus) {
      // 递归处理当前菜单项及其子菜单
      routes.addAll(_createRoutesFromMenu(menu));
    }
    
    return routes;
  }
  
  /// 递归创建单个菜单项及其子菜单的路由
  static List<GoRoute> _createRoutesFromMenu(MenuItemConfig menu) {
    List<GoRoute> routes = [];
    
    // 为当前菜单项创建路由
    String routePath = _convertUrlToRoute(menu.url);
    String routeName = _generateRouteName(menu.name);
    
    routes.add(GoRoute(
      path: routePath,
      name: routeName,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const ProductDataTable(),
      ),
    ));
    
    // 递归处理子菜单
    if (menu.children.isNotEmpty) {
      for (var child in menu.children) {
        routes.addAll(_createRoutesFromMenu(child));
      }
    }
    
    return routes;
  }

  /// 将API URL转换为Flutter路由路径
  static String _convertUrlToRoute(String url) {
    // 清理URL，移除多余的斜杠和API前缀
    String cleanUrl = url.trim();

    // 移除API前缀
    if (cleanUrl.startsWith('/api/')) {
      cleanUrl = cleanUrl.substring(5);
    }

    // 移除开头和结尾的斜杠
    cleanUrl = cleanUrl.replaceAll(RegExp(r'^/+|/+$'), '');

    // 如果为空，返回默认路径
    if (cleanUrl.isEmpty) {
      return '/dynamic-default';
    }

    // 将URL段转换为路由路径
    List<String> segments = cleanUrl
        .split('/')
        .where((s) => s.isNotEmpty)
        .toList();

    if (segments.isEmpty) {
      return '/dynamic-default';
    }

    // 构建路由路径
    String routePath = '/' + segments.join('/');

    // 确保路径唯一性，避免与现有路由冲突
    if (_isExistingRoute(routePath)) {
      routePath = '/dynamic-$cleanUrl'.replaceAll('/', '-');
    }

    return routePath;
  }

  /// 检查是否是现有的静态路由
  static bool _isExistingRoute(String path) {
    const existingRoutes = ['/dashboard', '/vip'];
    return existingRoutes.contains(path);
  }

  /// 生成路由名称
  static String _generateRouteName(String menuName) {
    return menuName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('管理', '')
        .replaceAll('页面', '');
  }

  /// 重新加载动态路由（用于运行时更新）
  static Future<void> reloadDynamicRoutes() async {
    await initializeDynamicRoutes();
    // 注意：GoRouter不支持运行时动态添加路由
    // 这个方法主要用于更新_dynamicRoutes列表
    // 实际的路由更新需要重启应用或使用其他路由管理方案
  }

  /// 获取所有动态路由信息（用于调试）
  static List<Map<String, String>> getDynamicRoutesInfo() {
    return _dynamicRoutes
        .map((route) => {'path': route.path, 'name': route.name ?? 'unnamed'})
        .toList();
  }

  static GoRouter get router => GoRouter(
    initialLocation: '/login',
    routes: [
      
      // 登录页
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const LoginPage()),
      ),

      // 主布局页面
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          ..._dynamicRoutes,
          // 首页/仪表板
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const DashboardPage(),
            ),
          ),

          // VIP权益
          GoRoute(
            path: '/vip',
            name: 'vip',
            pageBuilder: (context, state) =>
                NoTransitionPage(key: state.pageKey, child: const VipPage()),
          ),

          // 商品管理
          GoRoute(
            path: '/products',
            name: 'products',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProductDataTable(),
            ),
          ),

          // 菜单调试页面
          GoRoute(
            path: '/menu-debug',
            name: 'menuDebug',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const MenuDebugPage(),
            ),
          ),

          // 404错误页面 - 通配符路由，必须放在最后
          GoRoute(
            path: '/:path(.*)',
            name: 'notFound',
            pageBuilder: (context, state) {
              print("动态路由：${state.matchedLocation}");
              print("动态路由：${_dynamicRoutes}");
              return NoTransitionPage(
                key: state.pageKey,
                child: NotFoundPage(path: state.matchedLocation),
              );
            },
          ),
        ],
      ),
    ],

    // 路由重定向
    redirect: (context, state) {
      // 检查用户是否已登录
      // 这里可以添加实际的登录状态检查逻辑
      final isLoggedIn = _checkLoginStatus();
      final isLoginPage = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginPage) {
        return '/login';
      }

      if (isLoggedIn && isLoginPage) {
        return '/dashboard';
      }

      return null;
    },
  );

  // 检查登录状态的方法
  static bool _checkLoginStatus() {
    return _isLoggedIn;
  }
}
