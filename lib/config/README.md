# API 配置说明

## 概述

本目录包含了应用程序的API配置文件，用于管理不同环境（开发、测试、生产）的API地址和端点。

## 文件说明

- `api_config.dart` - API配置主文件，包含环境设置和基础URL配置
- `api_usage_example.dart` - API使用示例，展示如何在项目中使用API配置

## 环境配置

系统支持三种环境：

1. **开发环境 (Development)** - 本地开发使用，默认地址为 `http://localhost:8080/api`
2. **测试环境 (Testing)** - 测试服务器环境，地址为 `https://test-api.yourcompany.com/api`
3. **生产环境 (Production)** - 正式生产环境，地址为 `https://api.yourcompany.com/api`

## 如何切换环境

在 `api_config.dart` 文件中，修改 `currentEnvironment` 常量的值：

```dart
// 当前环境类型
static const Environment currentEnvironment = Environment.development; // 修改这里的值
```

可选值：
- `Environment.development` - 开发环境
- `Environment.testing` - 测试环境
- `Environment.production` - 生产环境

## API端点

所有API端点都定义在 `ApiEndpoints` 类中，按功能模块分类：

- 用户相关接口 (`login`, `logout`, `userInfo`, `users`)
- 客户管理接口 (`customers`)
- 商品管理接口 (`products`)
- 订单管理接口 (`orders`)
- 合同管理接口 (`contracts`)
- 项目管理接口 (`projects`)
- 财务管理接口 (`finance`)
- 库存管理接口 (`inventory`, `inbound`, `outbound`, `transfer`, `stocktaking`)
- 系统管理接口 (`systemConfig`, `systemMonitor`)

## 使用示例

```dart
import 'package:your_app/config/api_config.dart';

// 获取当前环境的基础URL
String baseUrl = ApiConfig.baseUrl;

// 获取完整的API地址
String loginUrl = ApiConfig.getFullUrl(ApiEndpoints.login);

// 检查当前环境
if (ApiConfig.currentEnvironment.isDevelopment) {
  print('当前是开发环境');
}

// 使用Dio或其他HTTP客户端发起请求
final response = await dio.post(
  ApiEndpoints.login,
  data: {'username': 'admin', 'password': '123456'},
);
```

更详细的使用示例请参考 `api_usage_example.dart` 文件。

## 添加新的API端点

如需添加新的API端点，请在 `ApiEndpoints` 类中添加新的常量：

```dart
// 在ApiEndpoints类中添加
static const String newEndpoint = '/path/to/new/endpoint';
```

## 修改环境URL

如需修改某个环境的基础URL，请在 `ApiConfig` 类中修改对应的常量：

```dart
// 修改测试环境URL
static const String testingUrl = 'https://new-test-api.yourcompany.com/api';
```