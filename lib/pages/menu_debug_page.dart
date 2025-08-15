import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/menu_model.dart';
import '../theme/app_theme.dart';

class MenuDebugPage extends StatefulWidget {
  const MenuDebugPage({Key? key}) : super(key: key);

  @override
  State<MenuDebugPage> createState() => _MenuDebugPageState();
}

class _MenuDebugPageState extends State<MenuDebugPage> {
  MenuConfig? _menuConfig;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMenuConfig();
  }

  Future<void> _loadMenuConfig() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      final config = await ApiService.getMenuConfig();
      setState(() {
        _menuConfig = config;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('菜单调试页面'),
        backgroundColor: AppTheme.successGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMenuConfig,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('正在加载菜单配置...'),
                  ],
                ),
              )
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '加载菜单配置失败',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadMenuConfig,
                          child: const Text('重试'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '菜单配置概览',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text('站点名称: ${_menuConfig?.data.siteName ?? "未设置"}'),
                                const SizedBox(height: 8),
                                Text('菜单组数量: ${_menuConfig?.data.menus.length ?? 0}'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_menuConfig != null) ..._buildMenuItems(),
                      ],
                    ),
                  ),
      ),
    );
  }

  List<Widget> _buildMenuItems() {
    if (_menuConfig?.data.menus == null) return [];
    
    return _menuConfig!.data.menus.asMap().entries.map((entry) {
      final index = entry.key;
      final menu = entry.value;
      
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: ExpansionTile(
          title: Text(
            '菜单组 ${index + 1}: ${menu.name}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('URL: ${menu.url}'),
              Text('图标: ${menu.icon ?? "无"}'),
              Text('子菜单数量: ${menu.children?.length ?? 0}'),
            ],
          ),
          children: [
            if (menu.children != null && menu.children!.isNotEmpty)
              ...menu.children!.asMap().entries.map((childEntry) {
                final childIndex = childEntry.key;
                final child = childEntry.value;
                return Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '子菜单 ${childIndex + 1}: ${child.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('URL: ${child.url}'),
                      Text('图标: ${child.icon ?? "无"}'),
                      if (child.children != null && child.children!.isNotEmpty)
                        Text('嵌套子菜单数量: ${child.children!.length}'),
                      if (child.children != null && child.children!.isNotEmpty)
                        ...child.children!.asMap().entries.map((nestedEntry) {
                          final nestedIndex = nestedEntry.key;
                          final nested = nestedEntry.value;
                          return Container(
                            margin: const EdgeInsets.only(left: 16, top: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.blue[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '嵌套菜单 ${nestedIndex + 1}: ${nested.name}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                                Text('URL: ${nested.url}', style: const TextStyle(fontSize: 12)),
                                Text('图标: ${nested.icon ?? "无"}', style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                );
              }).toList()
            else
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '此菜单组没有子菜单',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      );
    }).toList();
  }
}