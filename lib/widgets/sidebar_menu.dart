import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SidebarMenu extends StatefulWidget {
  final bool isCollapsed;
  
  const SidebarMenu({super.key, required this.isCollapsed});

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  String? _expandedGroup;
  
  final List<MenuGroup> _menuGroups = [
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
    MenuGroup(
      title: '系统管理',
      icon: FontAwesomeIcons.gear,
      gradient: const LinearGradient(
        colors: [Color(0xFF2196F3), Color(0xFF42A5F5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      items: [
        MenuItem(
          title: '用户管理',
          icon: FontAwesomeIcons.users,
          route: '/users',
        ),
        MenuItem(
          title: '系统设置',
          icon: FontAwesomeIcons.sliders,
          route: '/system',
        ),
      ],
    ),
    MenuGroup(
      title: '业务管理',
      icon: FontAwesomeIcons.briefcase,
      gradient: const LinearGradient(
        colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      items: [
        MenuItem(
          title: '客户管理',
          icon: FontAwesomeIcons.userTie,
          route: '/customers',
        ),
        MenuItem(
          title: '商品管理',
          icon: FontAwesomeIcons.boxOpen,
          route: '/products',
        ),
        MenuItem(
          title: '订单管理',
          icon: FontAwesomeIcons.fileInvoice,
          route: '/business/orders',
        ),
        MenuItem(
          title: '合同管理',
          icon: FontAwesomeIcons.fileContract,
          route: '/business/contracts',
        ),
        MenuItem(
          title: '项目管理',
          icon: FontAwesomeIcons.projectDiagram,
          route: '/business/projects',
        ),
      ],
    ),
    MenuGroup(
      title: '财务管理',
      icon: FontAwesomeIcons.chartPie,
      gradient: const LinearGradient(
        colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      items: [
        MenuItem(
          title: '财务概览',
          icon: FontAwesomeIcons.coins,
          route: '/finance',
        ),
      ],
    ),
    MenuGroup(
      title: '库存管理',
      icon: FontAwesomeIcons.warehouse,
      gradient: const LinearGradient(
        colors: [Color(0xFF607D8B), Color(0xFF90A4AE)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      items: [
        MenuItem(
          title: '入库管理',
          icon: FontAwesomeIcons.arrowDown,
          route: '/inventory/inbound',
        ),
        MenuItem(
          title: '出库管理',
          icon: FontAwesomeIcons.arrowUp,
          route: '/inventory/outbound',
        ),
        MenuItem(
          title: '报损管理',
          icon: FontAwesomeIcons.triangleExclamation,
          route: '/inventory/loss',
        ),
        MenuItem(
          title: '报溢管理',
          icon: FontAwesomeIcons.plus,
          route: '/inventory/overflow',
        ),
        MenuItem(
          title: '盘点管理',
          icon: FontAwesomeIcons.clipboardCheck,
          route: '/inventory/stocktaking',
        ),
        MenuItem(
          title: '调拨管理',
          icon: FontAwesomeIcons.rightLeft,
          route: '/inventory/transfer',
        ),
        MenuItem(
          title: '退货管理',
          icon: FontAwesomeIcons.rotateLeft,
          route: '/inventory/return',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    
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
                      setState(() {
                        _expandedGroup = isExpanded ? null : group.title;
                      });
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
                        onTap: () => context.go(item.route),
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