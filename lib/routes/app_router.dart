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
import '../pages/business/order_management_page.dart';
import '../pages/business/contract_management_page.dart';
import '../pages/business/project_management_page.dart';

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
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const LoadingPage(),
        ),
      ),
      
      // 登录页
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
      
      // 主布局页面
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          // 首页/仪表板
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const DashboardPage(),
            ),
          ),
          
          // 用户管理
          GoRoute(
            path: '/users',
            name: 'users',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const UserManagementPage(),
            ),
          ),
          
          // 系统管理
          GoRoute(
            path: '/system',
            name: 'system',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SystemManagementPage(),
            ),
          ),
          
          // 客户管理
          GoRoute(
            path: '/customers',
            name: 'customers',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const CustomerManagementPage(),
            ),
          ),
          
          // 商品管理
          GoRoute(
            path: '/products',
            name: 'products',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProductManagementPage(),
            ),
          ),
          
          // 财务管理
          GoRoute(
            path: '/finance',
            name: 'finance',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const FinanceManagementPage(),
            ),
          ),
          
          // VIP权益
          GoRoute(
            path: '/vip',
            name: 'vip',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const VipPage(),
            ),
          ),
          
          // 库存管理 - 入库
          GoRoute(
            path: '/inventory/inbound',
            name: 'inbound',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const InboundPage(),
            ),
          ),
          
          // 库存管理 - 出库
          GoRoute(
            path: '/inventory/outbound',
            name: 'outbound',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const OutboundPage(),
            ),
          ),
          
          // 库存管理 - 报损
          GoRoute(
            path: '/inventory/loss',
            name: 'loss',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const LossPage(),
            ),
          ),
          
          // 库存管理 - 报溢
          GoRoute(
            path: '/inventory/overflow',
            name: 'overflow',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const OverflowPage(),
            ),
          ),
          
          // 库存管理 - 盘点
          GoRoute(
            path: '/inventory/stocktaking',
            name: 'stocktaking',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const StocktakingPage(),
            ),
          ),
          
          // 库存管理 - 调拨
          GoRoute(
            path: '/inventory/transfer',
            name: 'transfer',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const TransferPage(),
            ),
          ),
          
          // 库存管理 - 退货
          GoRoute(
            path: '/inventory/return',
            name: 'return',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ReturnPage(),
            ),
          ),
          
          // 业务管理 - 订单管理
          GoRoute(
            path: '/business/orders',
            name: 'orders',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const OrderManagementPage(),
            ),
          ),
          
          // 业务管理 - 合同管理
          GoRoute(
            path: '/business/contracts',
            name: 'contracts',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ContractManagementPage(),
            ),
          ),
          
          // 业务管理 - 项目管理
          GoRoute(
            path: '/business/projects',
            name: 'projects',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProjectManagementPage(),
            ),
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