import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/sidebar_menu.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/notification_dialog.dart';
import '../routes/app_router.dart';
import 'vip_page.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  
  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool _isCollapsed = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _toggleSidebar() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('您确定要退出系统吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              AppRouter.setLoginStatus(false);
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.contentBackground,
      body: Row(
        children: [
          // 左侧菜单栏
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isCollapsed ? 70 : 250,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.sidebar,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 10,
                    offset: Offset(2, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 顶部Logo区域
                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryBlue,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isCollapsed
                        ? Center(
                            child: IconButton(
                              onPressed: _toggleSidebar,
                              icon: const Icon(
                                Icons.menu_open,
                                color: AppTheme.primaryWhite,
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              const Icon(
                                Icons.business,
                                color: AppTheme.primaryWhite,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'ERP系统',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppTheme.primaryWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _toggleSidebar,
                                icon: const Icon(
                                  Icons.menu,
                                  color: AppTheme.primaryWhite,
                                ),
                              ),
                            ],
                          ),
                  ),
                  
                  // 菜单列表
                  Expanded(
                    child: SidebarMenu(isCollapsed: _isCollapsed),
                  ),
                  
                  // 底部用户信息
                  Container(
                    padding: EdgeInsets.all(_isCollapsed ? 8 : 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppColors.sidebarHover,
                          width: 1,
                        ),
                      ),
                    ),
                    child: _isCollapsed
                        ? Center(
                            child: Tooltip(
                              message: '管理员 (admin)',
                              child: GestureDetector(
                                onTap: _logout,
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppTheme.primaryBlue,
                                  child: const Icon(
                                    Icons.person,
                                    color: AppTheme.primaryWhite,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppTheme.primaryBlue,
                                child: const Icon(
                                  Icons.person,
                                  color: AppTheme.primaryWhite,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '管理员',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.primaryWhite,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'admin',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: _logout,
                                icon: const Icon(
                                  Icons.logout,
                                  color: AppColors.textMuted,
                                  size: 20,
                                ),
                                tooltip: '退出登录',
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
          
          // 右侧内容区域
          Expanded(
            child: Column(
              children: [
                // 顶部导航栏
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryWhite,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // 面包屑导航
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _getBreadcrumb(context),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // 右侧工具栏
                      Row(
                        children: [
                          PopupMenuButton<String>(
                            offset: const Offset(0, 40),
                            color: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            child: Stack(
                              children: [
                                IconButton(
                                  onPressed: null,
                                  icon: const Icon(
                                    Icons.notifications_outlined,
                                    color: AppColors.textSecondary,
                                  ),
                                  tooltip: '通知',
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem<String>(
                                enabled: false,
                                padding: EdgeInsets.zero,
                                child: const NotificationDropdown(),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00C853), Color(0xFF4CAF50)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00C853).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const VipPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.diamond,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'VIP',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const SettingsDialog(),
                              );
                            },
                            icon: const Icon(
                              Icons.settings_outlined,
                              color: AppColors.textSecondary,
                            ),
                            tooltip: '设置',
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateTime.now().toString().substring(0, 16),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 主要内容区域
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getBreadcrumb(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    
    switch (location) {
      case '/dashboard':
        return '首页 / 仪表板';
      case '/users':
        return '系统管理 / 用户管理';
      case '/system':
        return '系统管理 / 系统设置';
      case '/customers':
        return '业务管理 / 客户管理';
      case '/products':
        return '业务管理 / 商品管理';
      case '/finance':
        return '财务管理 / 财务概览';
      case '/inventory/inbound':
        return '库存管理 / 入库管理';
      case '/inventory/outbound':
        return '库存管理 / 出库管理';
      case '/inventory/loss':
        return '库存管理 / 报损管理';
      case '/inventory/overflow':
        return '库存管理 / 报溢管理';
      case '/inventory/stocktaking':
        return '库存管理 / 盘点管理';
      case '/inventory/transfer':
        return '库存管理 / 调拨管理';
      case '/inventory/return':
        return '库存管理 / 退货管理';
      default:
        return '首页';
    }
  }
}