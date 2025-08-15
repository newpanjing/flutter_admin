class ApiConfig {
  // 当前环境类型
  static const Environment currentEnvironment = Environment.development;
  
  // 根据环境获取API基础地址
  static String get baseUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return developmentUrl;
      case Environment.testing:
        return testingUrl;
      case Environment.production:
        return productionUrl;
    }
  }
  
  // 开发环境API地址
  static const String developmentUrl = 'http://localhost:8000/api';
  
  // 测试环境API地址
  static const String testingUrl = 'http://localhost:8000/api';
  
  // 生产环境API地址
  static const String productionUrl = '/api';
  
  // 获取完整的API地址
  static String getFullUrl(String endpoint) {
    return baseUrl + endpoint;
  }
  
  // 请求超时配置
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // 调试模式配置
  static bool get isDebugMode {
    return currentEnvironment == Environment.development;
  }
}

// 环境枚举
enum Environment {
  development,  // 开发环境
  testing,      // 测试环境
  production,   // 生产环境
}

// 环境扩展方法
extension EnvironmentExtension on Environment {
  String get name {
    switch (this) {
      case Environment.development:
        return '开发环境';
      case Environment.testing:
        return '测试环境';
      case Environment.production:
        return '生产环境';
    }
  }
  
  bool get isProduction => this == Environment.production;
  bool get isDevelopment => this == Environment.development;
  bool get isTesting => this == Environment.testing;
}

// API端点配置类
class ApiEndpoints {
  // 用户相关接口
  static const String login = '/login';
  static const String logout = '/auth/logout';
  static const String verifyToken = '/verify-token';
  static const String userInfo = '/user/info';
  static const String users = '/users';
  
  // 客户管理接口
  static const String customers = '/customers';
  
  // 商品管理接口
  static const String products = '/products';
  
  // 订单管理接口
  static const String orders = '/orders';
  
  // 合同管理接口
  static const String contracts = '/contracts';
  
  // 项目管理接口
  static const String projects = '/projects';
  
  // 财务管理接口
  static const String finance = '/finance';
  
  // 库存管理接口
  static const String inventory = '/inventory';
  static const String inbound = '/inventory/inbound';
  static const String outbound = '/inventory/outbound';
  static const String transfer = '/inventory/transfer';
  static const String stocktaking = '/inventory/stocktaking';
  
  // 系统管理接口
  static const String systemConfig = '/system/config';
  static const String systemMonitor = '/system/monitor';
}