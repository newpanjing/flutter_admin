import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/sidebar_menu.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/notification_dialog.dart';
import '../routes/app_router.dart';
import '../models/menu_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
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
  MenuConfig? _menuConfig;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadMenuConfig();
  }

  Future<void> _loadMenuConfig() async {
    try {
      final config = await ApiService.getMenuConfig();
      if (mounted) {
        setState(() {
          _menuConfig = config;
        });
      }
    } catch (e) {
      // 静默处理错误，不影响页面正常显示
      print('加载菜单配置失败: $e');
    }
  }

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

  void _toggleSidebar() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _SearchDialog(moduleList: _moduleList),
    );
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
                  
                  // 底部留空，管理员信息已移至右上角
                  const SizedBox(height: 16),
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
                          // 管理员信息
                          PopupMenuButton<String>(
                            offset: const Offset(-120, 40),
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
                                  '管理员',
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
                                            '管理员',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                    ],
                                  ),
                                ),
                              ),
                              const PopupMenuDivider(),
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
                              if (value == 'logout') {
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
      case '/business/orders':
        return '业务管理 / 订单管理';
      case '/business/contracts':
        return '业务管理 / 合同管理';
      case '/business/projects':
        return '业务管理 / 项目管理';
      case '/vip':
        return '会员管理 / VIP权益';
      case '/menu-debug':
        return '系统管理 / 菜单调试';
      default:
        // 尝试从动态菜单中查找面包屑
        String? dynamicBreadcrumb = _getDynamicBreadcrumb(location);
        if (dynamicBreadcrumb != null) {
          return dynamicBreadcrumb;
        }
        
        // 对于404页面或其他未知路径
        if (location.startsWith('/')) {
          return '首页 / 页面未找到';
        }
        return '首页';
    }
  }
  
  String? _getDynamicBreadcrumb(String location) {
    // 从菜单配置中查找匹配的路径
    if (_menuConfig != null) {
      for (var group in _menuConfig!.data.menus) {
        String? breadcrumb = _findBreadcrumbInGroup(group, location, group.name);
        if (breadcrumb != null) {
          return breadcrumb;
        }
      }
    }
    return null;
  }
  
  String? _findBreadcrumbInGroup(MenuItemConfig menu, String targetPath, String groupName) {
    // 将菜单URL转换为路由路径进行比较
    String menuPath = menu.url.startsWith('http') ? menu.url : menu.url;
    if (menuPath.startsWith('/')) {
      menuPath = menuPath.substring(1);
    }
    String routePath = '/$menuPath';
    
    if (routePath == targetPath) {
      return '$groupName / ${menu.name}';
    }
    
    // 递归查找子菜单
    if (menu.children != null) {
      for (var child in menu.children!) {
        String? childBreadcrumb = _findBreadcrumbInGroup(child, targetPath, groupName);
        if (childBreadcrumb != null) {
          return childBreadcrumb;
        }
      }
    }
    
    return null;
  }
}

class _SearchDialog extends StatefulWidget {
  final List<Map<String, String>> moduleList;
  
  const _SearchDialog({required this.moduleList});

  @override
  State<_SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<_SearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredModules = [];

  @override
  void initState() {
    super.initState();
    _filteredModules = widget.moduleList;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredModules = widget.moduleList;
      } else {
        _filteredModules = widget.moduleList.where((module) {
          return module['name']!.toLowerCase().contains(query) ||
                 module['category']!.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _navigateToModule(String route) {
    Navigator.of(context).pop();
    context.go(route);
  }

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
              color: Colors.black.withOpacity(0.1),
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
                      controller: _searchController,
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
              child: _filteredModules.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(
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
                      itemCount: _filteredModules.length,
                      itemBuilder: (context, index) {
                        final module = _filteredModules[index];
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withOpacity(0.1),
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
                              fontSize: 12,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.textMuted,
                          ),
                          onTap: () => _navigateToModule(module['route']!),
                          hoverColor: AppColors.sidebarHover,
                        );
                      },
                    ),
            ),
            
            // 底部提示
            if (_filteredModules.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.borderColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '点击项目快速导航到对应功能',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
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
        return Icons.diamond;
      default:
        return Icons.apps;
    }
  }
}