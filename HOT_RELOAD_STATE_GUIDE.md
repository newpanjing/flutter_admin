# Hot Reload 状态保持功能指南

## 功能概述

本功能解决了Flutter Web应用在开发过程中使用Hot Reload时会默认跳转到首页的问题，实现了页面状态的保持。

## 实现原理

### 1. 路由状态管理
- 使用 `RouteStateManager` 类管理路由状态
- 将当前路由位置保存到 `SharedPreferences` 中
- 在应用启动时恢复之前保存的路由状态

### 2. GoRouter 配置优化
- 启用 `restorationScopeId` 支持状态恢复
- 修改 `redirect` 逻辑，在Hot Reload时保持当前页面
- 添加路由监听器，实时保存路由变化

### 3. 登录状态处理
- 在登录成功后恢复到之前访问的页面
- 支持Token验证后的页面状态恢复

## 核心文件修改

### 1. `/lib/routes/app_router.dart`
- 添加路由状态保存和恢复逻辑
- 修改初始路由获取方式
- 优化redirect逻辑

### 2. `/lib/main.dart`
- 在应用启动时恢复路由状态
- 启用MaterialApp的状态恢复

### 3. `/lib/pages/main_layout.dart`
- 添加路由变化监听
- 实时保存当前路由状态

### 4. `/lib/pages/login_page.dart`
- 修改登录成功后的跳转逻辑
- 支持恢复到之前访问的页面

### 5. `/lib/utils/route_state_manager.dart`
- 新增路由状态管理工具类
- 提供路由状态的保存、获取和清除功能

## 使用方法

### 1. 正常使用
功能已自动集成，无需额外配置。在开发过程中使用Hot Reload时，应用会自动保持当前页面状态。

### 2. 测试功能
访问 `/test-hot-reload` 页面进行功能测试：

```dart
// 在浏览器中访问
http://localhost:port/#/test-hot-reload
```

### 3. 测试步骤
1. 登录系统
2. 导航到任意页面（如商品管理页面）
3. 使用 `r` 键进行Hot Reload
4. 确认页面保持在当前位置，没有跳转到首页

## 技术特性

### 1. 状态持久化
- 路由状态保存到本地存储
- 支持应用重启后的状态恢复
- 状态有效期为1小时

### 2. 安全性
- 只有在用户已登录的情况下才恢复路由状态
- 不会恢复到登录页面
- 自动清理过期的状态数据

### 3. 性能优化
- 异步保存状态，不阻塞UI
- 错误处理机制，避免状态保存失败影响应用
- 最小化存储空间占用

## 配置选项

### 1. 状态有效期
在 `RouteStateManager` 中可以修改状态有效期：

```dart
// 默认1小时，可以修改为其他值
final hourInMs = 60 * 60 * 1000; // 1小时
```

### 2. 排除特定路由
可以在 `AppRouter` 中添加不需要保存状态的路由：

```dart
static void saveCurrentLocation(String location) {
  // 排除登录页面和其他特殊页面
  if (location == '/login' || location == '/error') {
    return;
  }
  _lastKnownLocation = location;
  _saveLocationToStorage(location);
}
```

## 故障排除

### 1. 状态未保持
- 检查用户是否已登录
- 确认 `SharedPreferences` 权限正常
- 查看控制台是否有错误信息

### 2. 跳转异常
- 检查路由配置是否正确
- 确认目标路由是否存在
- 验证用户权限是否足够

### 3. 性能问题
- 状态保存是异步的，不会影响UI性能
- 如有问题，可以在控制台查看相关日志

## 开发注意事项

1. **Hot Reload vs Hot Restart**：此功能主要针对Hot Reload，Hot Restart会重新初始化应用状态

2. **状态范围**：只保持路由状态，不保持页面内的组件状态（如表单输入、滚动位置等）

3. **兼容性**：功能与现有的路由和状态管理系统兼容，不会影响正常的应用逻辑

4. **调试**：可以通过测试页面 `/test-hot-reload` 验证功能是否正常工作

## 更新日志

- **v1.0.0**: 初始实现Hot Reload状态保持功能
- 支持路由状态的保存和恢复
- 集成登录状态处理
- 添加测试页面和文档