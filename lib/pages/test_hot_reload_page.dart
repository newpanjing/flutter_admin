import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../routes/app_router.dart';
import '../utils/route_state_manager.dart';

class TestHotReloadPage extends StatefulWidget {
  const TestHotReloadPage({super.key});

  @override
  State<TestHotReloadPage> createState() => _TestHotReloadPageState();
}

class _TestHotReloadPageState extends State<TestHotReloadPage> {
  String _currentTime = '';
  String _currentLocation = '';
  String? _savedLocation;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _getCurrentLocation();
    _getSavedLocation();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateTime.now().toString();
    });
  }

  void _getCurrentLocation() {
    setState(() {
      _currentLocation = GoRouterState.of(context).matchedLocation;
    });
  }

  Future<void> _getSavedLocation() async {
    final saved = await RouteStateManager.getSavedRouteState();
    setState(() {
      _savedLocation = saved;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hot Reload 状态测试'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '路由状态测试',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('当前时间: $_currentTime'),
                    const SizedBox(height: 8),
                    Text('当前路由: $_currentLocation'),
                    const SizedBox(height: 8),
                    Text('保存的路由: ${_savedLocation ?? "无"}'),
                    const SizedBox(height: 8),
                    Text('计数器: $_counter'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '测试说明',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. 点击计数器按钮增加数值\n'
                      '2. 使用 Hot Reload (r) 重新加载应用\n'
                      '3. 如果状态保持功能正常，应该：\n'
                      '   - 保持在当前页面\n'
                      '   - 计数器值会重置（这是正常的）\n'
                      '   - 不会跳转到首页或登录页',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _incrementCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('增加计数器'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _updateTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('更新时间'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _getSavedLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('刷新保存状态'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => context.go('/dashboard'),
                  child: const Text('跳转到首页'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => context.go('/products'),
                  child: const Text('跳转到商品管理'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => context.go('/vip'),
                  child: const Text('跳转到VIP页面'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}