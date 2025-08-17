import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/notification_dialog.dart';

import '../widgets/sidebar_menu.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color darkGray = Color(0xFF757575);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textMuted = Color(0xFF9E9E9E);
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color cardShadow = Color(0x1A000000);
}

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool _isCollapsed = false;
  UserModel? _currentUser;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredModules = [];

  // 功能模块搜索数据
  final List<Map<String, String>> _moduleList = [
    {'name': '仪表板', 'route': '/dashboard', 'category': '首页'},
    {'name': '用户管理', 'route': '/users', 'category': '系统管理'},
    {'name': '系统设置', 'route': '/system', 'category': '系统管理'},
    {'name': '菜单调试', 'route': '/menu-debug', 'category': '系统管理'},
    {'name': '客户管理', 'route': '/customers', 'category': '业务管理'},
    {'name': '商品管理', 'route': '/products', 'category': '业务管理'},
    {'name': '订单管理', 'route': '/business/orders', 'category': '业务管理'},
    {'name': '合同管理', 'route': '/business/contracts', 'category': '业务管理'},
    {'name': '项目管理', 'route': '/business/projects', 'category': '业务管理'},
    {'name': '财务概览', 'route': '/finance', 'category': '财务管理'},
    {'name': '收支管理', 'route': '/finance/income-expense', 'category': '财务管理'},
    {'name': '发票管理', 'route': '/finance/invoice', 'category': '财务管理'},
    {'name': '报表分析', 'route': '/finance/report', 'category': '财务管理'},
    {'name': '入库管理', 'route': '/inventory/inbound', 'category': '库存管理'},
    {'name': '出库管理', 'route': '/inventory/outbound', 'category': '库存管理'},
    {'name': '报损管理', 'route': '/inventory/loss', 'category': '库存管理'},
    {'name': '报溢管理', 'route': '/inventory/overflow', 'category': '库存管理'},
    {'name': '盘点管理', 'route': '/inventory/stocktaking', 'category': '库存管理'},
    {'name': '调拨管理', 'route': '/inventory/transfer', 'category': '库存管理'},
    {'name': '退货管理', 'route': '/inventory/return', 'category': '库存管理'},
    {'name': 'VIP权益', 'route': '/vip', 'category': '会员管理'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _filteredModules = List.from(_moduleList);
    _searchController.addListener(_filterModules);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCurrentUser() async {
    try {
      final user = await ApiService().getCurrentUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      print('加载用户信息失败: $e');
    }
  }

  void _toggleSidebar() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  void _logout() {
    context.go('/login');
  }

  void _navigateToProfile() {
    context.go('/profile');
  }

  void _filterModules() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredModules = _moduleList.where((module) {
        return module['name']!.toLowerCase().contains(query) ||
            module['category']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _SearchDialog(
        searchController: _searchController,
        filteredModules: _filteredModules,
        onNavigate: _navigateToModule,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Row(
        children: [
          // 左侧边栏
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isCollapsed ? 80 : 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryBlue,
                  AppTheme.primaryBlue.withValues(alpha: 0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // 顶部Logo区域
                ClipRect(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryBlue.withValues(alpha: 0.9),
                          AppTheme.primaryBlue,
                        ],
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: AppTheme.primaryWhite.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: _isCollapsed ? 8 : 16, 
                        vertical: 12
                      ),
                      child: _isCollapsed 
                        ? Center(
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryWhite.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppTheme.primaryWhite.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                onPressed: _toggleSidebar,
                                icon: Icon(
                                  Icons.menu_open,
                                  color: AppTheme.primaryWhite,
                                  size: 16,
                                ),
                                tooltip: '展开菜单',
                                padding: EdgeInsets.zero,
                                splashColor: AppTheme.primaryWhite.withValues(alpha: 0.1),
                                highlightColor: AppTheme.primaryWhite.withValues(alpha: 0.05),
                              ),
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final availableWidth = constraints.maxWidth;
                              final showFullLayout = availableWidth > 200;
                              final isVeryNarrow = availableWidth < 100;
                              
                              if (isVeryNarrow) {
                                 // 极窄模式：垂直布局
                                 return Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Container(
                                       padding: const EdgeInsets.all(4),
                                       decoration: BoxDecoration(
                                         color: AppTheme.primaryWhite.withValues(alpha: 0.15),
                                         borderRadius: BorderRadius.circular(6),
                                       ),
                                       child: Icon(
                                         Icons.business_center,
                                         color: AppTheme.primaryWhite,
                                         size: 16,
                                       ),
                                     ),
                                     const SizedBox(height: 4),
                                     Container(
                                       width: 32,
                                       height: 32,
                                       decoration: BoxDecoration(
                                         color: AppTheme.primaryWhite.withValues(alpha: 0.15),
                                         borderRadius: BorderRadius.circular(6),
                                         border: Border.all(
                                           color: AppTheme.primaryWhite.withValues(alpha: 0.2),
                                           width: 1,
                                         ),
                                       ),
                                       child: IconButton(
                                         onPressed: _toggleSidebar,
                                         icon: Icon(
                                           Icons.menu_open,
                                           color: AppTheme.primaryWhite,
                                           size: 16,
                                         ),
                                         tooltip: '展开菜单',
                                         padding: EdgeInsets.zero,
                                         splashColor: AppTheme.primaryWhite.withValues(alpha: 0.1),
                                         highlightColor: AppTheme.primaryWhite.withValues(alpha: 0.05),
                                       ),
                                     ),
                                   ],
                                 );
                               }
                              
                              return Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(showFullLayout ? 8 : 6),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryWhite.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(showFullLayout ? 10 : 8),
                                    ),
                                    child: Icon(
                                      Icons.business_center,
                                      color: AppTheme.primaryWhite,
                                      size: showFullLayout ? 28 : 20,
                                    ),
                                  ),
                                  if (showFullLayout) const SizedBox(width: 12),
                                  if (showFullLayout) Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ERP系统',
                                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                            color: AppTheme.primaryWhite,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          '企业资源管理',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppTheme.primaryWhite.withValues(alpha: 0.7),
                                            fontSize: 11,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (showFullLayout) const SizedBox(width: 8) else const Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryWhite.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppTheme.primaryWhite.withValues(alpha: 0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: _toggleSidebar,
                                      icon: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 200),
                                        child: Icon(
                                          _isCollapsed ? Icons.menu_open : Icons.menu,
                                          key: ValueKey(_isCollapsed),
                                          color: AppTheme.primaryWhite,
                                          size: 20,
                                        ),
                                      ),
                                      tooltip: _isCollapsed ? '展开菜单' : '收起菜单',
                                      splashColor: AppTheme.primaryWhite.withValues(alpha: 0.1),
                                      highlightColor: AppTheme.primaryWhite.withValues(alpha: 0.05),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                    ),
                  ),
                ),
                
                // 菜单列表
                Expanded(
                  child: SidebarMenu(isCollapsed: _isCollapsed),
                ),
                
                // 底部留空
                const SizedBox(height: 16),
              ],
            ),
          ),
          
          // 右侧内容区域
          Expanded(
            child: Column(
              children: [
                // 顶部导航栏
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryWhite,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // 面包屑导航
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
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
                          // 搜索按钮
                          IconButton(
                            onPressed: () {
                              _showSearchDialog(context);
                            },
                            icon: const Icon(
                              Icons.search_outlined,
                              color: AppColors.textSecondary,
                            ),
                            tooltip: '搜索功能',
                          ),
                          // 通知按钮
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
                                child: Container(
                                    width: 300,
                                    child: const NotificationDialog(
                                      title: '通知',
                                      content: '暂无新通知',
                                    ),
                                  ),
                              ),
                            ],
                          ),
                          // 设置按钮
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
                          // 用户信息
                          PopupMenuButton<String>(
                            offset: const Offset(-140, 50),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppTheme.primaryBlue,
                                  child: const Icon(
                                    Icons.person,
                                    color: AppTheme.primaryWhite,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _currentUser?.name ?? _currentUser?.username ?? '用户',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.textSecondary,
                                  size: 16,
                                ),
                              ],
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem<String>(
                                enabled: false,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AppTheme.primaryBlue,
                                        child: const Icon(
                                          Icons.person,
                                          color: AppTheme.primaryWhite,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _currentUser?.name ?? _currentUser?.username ?? '用户',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            _currentUser?.role ?? _currentUser?.username ?? '',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem<String>(
                                value: 'profile',
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.person_outline,
                                      color: AppColors.textSecondary,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '个人中心',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'logout',
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.logout,
                                      color: AppColors.textSecondary,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '退出登录',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'profile') {
                                _navigateToProfile();
                              } else if (value == 'logout') {
                                _logout();
                              }
                            },
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
        return '首页 / 系统管理 / 用户管理';
      case '/system':
        return '首页 / 系统管理 / 系统设置';
      case '/menu-debug':
        return '首页 / 系统管理 / 菜单调试';
      case '/customers':
        return '首页 / 业务管理 / 客户管理';
      case '/products':
        return '首页 / 业务管理 / 商品管理';
      case '/business/orders':
        return '首页 / 业务管理 / 订单管理';
      case '/business/contracts':
        return '首页 / 业务管理 / 合同管理';
      case '/business/projects':
        return '首页 / 业务管理 / 项目管理';
      case '/finance':
        return '首页 / 财务管理 / 财务概览';
      case '/finance/income-expense':
        return '首页 / 财务管理 / 收支管理';
      case '/finance/invoice':
        return '首页 / 财务管理 / 发票管理';
      case '/finance/report':
        return '首页 / 财务管理 / 报表分析';
      case '/inventory/inbound':
        return '首页 / 库存管理 / 入库管理';
      case '/inventory/outbound':
        return '首页 / 库存管理 / 出库管理';
      case '/inventory/loss':
        return '首页 / 库存管理 / 报损管理';
      case '/inventory/overflow':
        return '首页 / 库存管理 / 报溢管理';
      case '/inventory/stocktaking':
        return '首页 / 库存管理 / 盘点管理';
      case '/inventory/transfer':
        return '首页 / 库存管理 / 调拨管理';
      case '/inventory/return':
        return '首页 / 库存管理 / 退货管理';
      case '/vip':
        return '首页 / 会员管理 / VIP权益';
      default:
        return '首页';
    }
  }

  String? _getDynamicBreadcrumb(String location) {
    // 这里可以根据动态菜单数据生成面包屑
    return null;
  }

  void _navigateToModule(String route) {
    Navigator.of(context).pop();
    context.go(route);
  }

  IconData _getModuleIcon(String category) {
    switch (category) {
      case '首页':
        return Icons.dashboard;
      case '系统管理':
        return Icons.settings;
      case '业务管理':
        return Icons.business;
      case '财务管理':
        return Icons.account_balance;
      case '库存管理':
        return Icons.inventory;
      case '会员管理':
        return Icons.people;
      default:
        return Icons.folder;
    }
  }
}

class _SearchDialog extends StatelessWidget {
  final TextEditingController searchController;
  final List<Map<String, String>> filteredModules;
  final Function(String) onNavigate;

  const _SearchDialog({
    required this.searchController,
    required this.filteredModules,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: AppTheme.primaryWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 搜索头部
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.borderColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: AppTheme.primaryBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: '搜索功能模块...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            
            // 搜索结果
            Flexible(
              child: filteredModules.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 48,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '未找到相关功能模块',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filteredModules.length,
                      itemBuilder: (context, index) {
                        final module = filteredModules[index];
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getModuleIcon(module['category']!),
                              color: AppTheme.primaryBlue,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            module['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            module['category']!,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                            ),
                          ),
                          onTap: () => onNavigate(module['route']!),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getModuleIcon(String category) {
    switch (category) {
      case '首页':
        return Icons.dashboard;
      case '系统管理':
        return Icons.settings;
      case '业务管理':
        return Icons.business;
      case '财务管理':
        return Icons.account_balance;
      case '库存管理':
        return Icons.inventory;
      case '会员管理':
        return Icons.people;
      default:
        return Icons.folder;
    }
  }
}