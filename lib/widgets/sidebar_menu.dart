import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';
import '../models/menu_model.dart';

class SidebarMenu extends StatefulWidget {
  final bool isCollapsed;
  
  const SidebarMenu({super.key, required this.isCollapsed});

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  String? _expandedGroup;
  List<MenuGroup> _menuGroups = [];
  bool _isLoading = true;
  String? _lastClickedRoute;
  DateTime? _lastClickTime;
  
  @override
  void initState() {
    super.initState();
    _loadMenus();
  }
  
  void _handleMenuItemTap(String route) {
    final now = DateTime.now();
    
    // 防抖：如果是同一个路由且点击间隔小于300ms，则忽略
    if (_lastClickedRoute == route && 
        _lastClickTime != null && 
        now.difference(_lastClickTime!).inMilliseconds < 300) {
      return;
    }
    
    _lastClickedRoute = route;
    _lastClickTime = now;
    
    // 使用Future.microtask来避免在build过程中调用setState
    Future.microtask(() {
      if (mounted) {
        context.go(route);
      }
    });
  }
  
  Future<void> _loadMenus() async {
    try {
      // 获取API菜单配置
      final menuConfig = await ApiService.getMenuConfig();
      
      // 调试信息：打印获取到的菜单配置
      print('菜单配置获取成功: ${menuConfig.data.menus.length} 个菜单组');
      for (final menu in menuConfig.data.menus) {
        print('菜单: ${menu.name}, URL: ${menu.url}, 子菜单数量: ${menu.children.length}');
      }
      
      // 创建固定菜单组（仪表盘）
      final fixedMenus = [
        MenuGroup(
          title: '首页',
          icon: FontAwesomeIcons.house,
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          items: [
            MenuItem(
              title: '仪表板',
              icon: FontAwesomeIcons.chartLine,
              route: '/dashboard',
            ),
          ],
        ),
      ];
      
      // 创建动态菜单组
      final dynamicMenus = _createDynamicMenuGroups(menuConfig.data.menus);
      print('动态菜单组创建完成: ${dynamicMenus.length} 个菜单组');
      
      setState(() {
        _menuGroups = [...fixedMenus, ...dynamicMenus];
        _isLoading = false;
      });
    } catch (e) {
      // 如果API调用失败，使用默认菜单
      print('菜单配置获取失败: $e');
      print('使用默认菜单配置');
      setState(() {
        _menuGroups = _getDefaultMenus();
        _isLoading = false;
      });
    }
  }
  
  List<MenuGroup> _createDynamicMenuGroups(List<MenuItemConfig> apiMenus) {
    final List<MenuGroup> dynamicGroups = [];
    
    for (final apiMenu in apiMenus) {
      // 扁平化嵌套菜单
      final flatMenus = _flattenMenuItems(apiMenu);
      
      if (flatMenus.isNotEmpty) {
        dynamicGroups.add(MenuGroup(
          title: apiMenu.name,
          icon: Icons.face,
          items: flatMenus,
        ));
      }
    }
    
    return dynamicGroups;
  }
  
  List<MenuItem> _flattenMenuItems(MenuItemConfig menuConfig) {
    List<MenuItem> items = [];
    
    // 如果有子菜单，只处理子菜单，不添加父级菜单项
    if (menuConfig.children.isNotEmpty) {
      for (final child in menuConfig.children) {
        items.addAll(_flattenMenuItems(child));
      }
    } else {
      // 只有叶子节点（没有子菜单的菜单项）才添加到菜单列表中
      items.add(MenuItem(
        title: menuConfig.name,
        icon: Icons.face,
        route: menuConfig.url,
      ));
    }
    
    return items;
  }
  
  
  List<MenuGroup> _getDefaultMenus() {
    // 只保留仪表盘菜单，其他菜单项从API接口获取
    return [
      MenuGroup(
        title: '首页',
        icon: FontAwesomeIcons.house,
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        items: [
          MenuItem(
            title: '仪表板',
            icon: FontAwesomeIcons.chartLine,
            route: '/dashboard',
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    
    if (_isLoading) {
      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          border: Border(
            right: BorderSide(
              color: Color(0xFF333333),
              width: 1,
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
          ),
        ),
      );
    }
    
    return RepaintBoundary(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          border: Border(
            right: BorderSide(
              color: Color(0xFF333333),
              width: 1,
            ),
          ),
        ),
        child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: _menuGroups.length,
        itemBuilder: (context, index) {
          final group = _menuGroups[index];
          final isExpanded = _expandedGroup == group.title;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 分组标题
              if (!widget.isCollapsed)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: group.items.length > 1 ? () {
                      // 只有在状态真正需要改变时才调用setState
                      final newExpandedGroup = isExpanded ? null : group.title;
                      if (_expandedGroup != newExpandedGroup) {
                        setState(() {
                          _expandedGroup = newExpandedGroup;
                        });
                      }
                    } : null,
                    borderRadius: BorderRadius.circular(6),
                    hoverColor: group.items.length > 1 ? Colors.white.withOpacity(0.03) : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 3,
                            height: 16,
                            decoration: BoxDecoration(
                              gradient: group.gradient,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FaIcon(
                            group.icon,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              group.title,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          if (group.items.length > 1)
                            AnimatedRotation(
                              turns: isExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: Colors.white54,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              
              // 菜单项
              if (widget.isCollapsed || group.items.length == 1 || isExpanded)
                ...group.items.map((item) {
                  final isActive = currentLocation == item.route;
                  
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: widget.isCollapsed ? 8 : 12,
                      vertical: 1,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      child: InkWell(
                        onTap: () => _handleMenuItemTap(item.route),
                        borderRadius: BorderRadius.circular(6),
                        hoverColor: Colors.white.withOpacity(0.05),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: widget.isCollapsed ? 12 : 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isActive 
                                ? const Color(0xFF4CAF50).withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: isActive
                                ? const Border(
                                    left: BorderSide(
                                      color: Color(0xFF4CAF50),
                                      width: 3,
                                    ),
                                  )
                                : null,
                          ),
                          child: widget.isCollapsed
                              ? Center(
                                  child: Tooltip(
                                    message: item.title,
                                    preferBelow: false,
                                    child: FaIcon(
                                      item.icon,
                                      size: 18,
                                      color: isActive 
                                          ? const Color(0xFF4CAF50)
                                          : Colors.white70,
                                    ),
                                  ),
                                )
                              : Row(
                                  children: [
                                    const SizedBox(width: 15),
                                    FaIcon(
                                      item.icon,
                                      size: 16,
                                      color: isActive 
                                          ? const Color(0xFF4CAF50)
                                          : Colors.white70,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: isActive 
                                              ? Colors.white
                                              : Colors.white70,
                                          fontWeight: isActive 
                                              ? FontWeight.w500 
                                              : FontWeight.normal,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              
              // 分组间距
              if (index < _menuGroups.length - 1)
                const SizedBox(height: 16),
            ],
          );
        },
        ),
      ),
    );
  }
}

class MenuGroup {
  final String title;
  final IconData icon;
  final List<MenuItem> items;
  final LinearGradient? gradient;
  
  MenuGroup({
    required this.title,
    required this.icon,
    required this.items,
    this.gradient,
  });
}

class MenuItem {
  final String title;
  final IconData icon;
  final String route;
  
  MenuItem({
    required this.title,
    required this.icon,
    required this.route,
  });
}