import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/loading_page.dart';
import '../pages/login_page.dart';
import '../pages/main_layout.dart';
import '../pages/dashboard_page.dart';
import '../pages/user_management_page.dart';
import '../pages/system_management_page.dart';
import '../pages/customer_management_page.dart';
import '../pages/product_management_page.dart';
import '../pages/finance_management_page.dart';
import '../pages/inventory/inbound_page.dart';
import '../pages/inventory/outbound_page.dart';
import '../pages/inventory/loss_page.dart';
import '../pages/inventory/overflow_page.dart';
import '../pages/inventory/stocktaking_page.dart';
import '../pages/inventory/transfer_page.dart';
import '../pages/inventory/return_page.dart';
import '../pages/vip_page.dart';

class AppRouter {
  static bool _isLoggedIn = false;
  
  static void setLoginStatus(bool status) {
    _isLoggedIn = status;
  }
  
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // 启动加载页
      GoRoute(
        path: '/',
        name: 'loading',
        builder: (context, state) => const LoadingPage(),
      ),
      
      // 登录页
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      
      // 主布局页面
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          // 首页/仪表板
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          
          // 用户管理
          GoRoute(
            path: '/users',
            name: 'users',
            builder: (context, state) => const UserManagementPage(),
          ),
          
          // 系统管理
          GoRoute(
            path: '/system',
            name: 'system',
            builder: (context, state) => const SystemManagementPage(),
          ),
          
          // 客户管理
          GoRoute(
            path: '/customers',
            name: 'customers',
            builder: (context, state) => const CustomerManagementPage(),
          ),
          
          // 商品管理
          GoRoute(
            path: '/products',
            name: 'products',
            builder: (context, state) => const ProductManagementPage(),
          ),
          
          // 财务管理
          GoRoute(
            path: '/finance',
            name: 'finance',
            builder: (context, state) => const FinanceManagementPage(),
          ),
          
          // VIP权益
          GoRoute(
            path: '/vip',
            name: 'vip',
            builder: (context, state) => const VipPage(),
          ),
          
          // 库存管理 - 入库
          GoRoute(
            path: '/inventory/inbound',
            name: 'inbound',
            builder: (context, state) => const InboundPage(),
          ),
          
          // 库存管理 - 出库
          GoRoute(
            path: '/inventory/outbound',
            name: 'outbound',
            builder: (context, state) => const OutboundPage(),
          ),
          
          // 库存管理 - 报损
          GoRoute(
            path: '/inventory/loss',
            name: 'loss',
            builder: (context, state) => const LossPage(),
          ),
          
          // 库存管理 - 报溢
          GoRoute(
            path: '/inventory/overflow',
            name: 'overflow',
            builder: (context, state) => const OverflowPage(),
          ),
          
          // 库存管理 - 盘点
          GoRoute(
            path: '/inventory/stocktaking',
            name: 'stocktaking',
            builder: (context, state) => const StocktakingPage(),
          ),
          
          // 库存管理 - 调拨
          GoRoute(
            path: '/inventory/transfer',
            name: 'transfer',
            builder: (context, state) => const TransferPage(),
          ),
          
          // 库存管理 - 退货
          GoRoute(
            path: '/inventory/return',
            name: 'return',
            builder: (context, state) => const ReturnPage(),
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
      final isLoadingPage = state.matchedLocation == '/';
      
      // 如果是loading页面，不进行重定向
      if (isLoadingPage) {
        return null;
      }
      
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