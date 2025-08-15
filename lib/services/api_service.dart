import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';
import '../models/menu_model.dart';

/// API服务类
/// 处理所有HTTP请求和响应
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;

  // 初始化Dio客户端
  void _initDio() {
    _dio = Dio();
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = ApiConfig.connectTimeout;
    _dio.options.receiveTimeout = ApiConfig.receiveTimeout;
    _dio.options.sendTimeout = ApiConfig.sendTimeout;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // 添加请求拦截器
    if (ApiConfig.isDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
        ),
      );
    }
  }

  // 获取Dio实例
  Dio get dio {
    if (!_isDioInitialized) {
      _initDio();
      _isDioInitialized = true;
    }
    return _dio;
  }

  bool _isDioInitialized = false;

  /// 登录请求
  /// 参数：用户名和密码
  /// 返回：登录响应数据
  Future<LoginResponse> login(String username, String password) async {
    try {
      final requestData = {
        'username': username,
        'password': password,
      };

      final response = await dio.post(
        ApiEndpoints.login,
        data: requestData,
      );

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException('网络请求失败: $e', 0, '');
    }
  }

  /// 验证Token
  /// 参数：JWT token
  /// 返回：验证响应数据（与登录接口返回格式一致）
  Future<LoginResponse> verifyToken(String token) async {
    try {
      final response = await dio.post(
        ApiEndpoints.verifyToken,
        data: {
          'token': token,
        },
      );

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException('网络请求失败: $e', 0, '');
    }
  }

  /// 获取用户信息
  Future<UserModel> getUserInfo(String token) async {
    try {
      final response = await dio.get(
        ApiEndpoints.userInfo,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException('网络请求失败: $e', 0, '');
    }
  }

  /// 获取系统配置和菜单
  /// 
  /// 返回:
  /// - [MenuConfig] 菜单配置对象
  /// 
  /// 异常:
  /// - [ApiException] API请求异常
  static Future<MenuConfig> getMenuConfig() async {
    try {
      print('开始获取系统配置和菜单...');
      print('请求URL: ${ApiConfig.getFullUrl('/config')}');
      
      final response = await ApiService().dio.get('/config');

      if (response.statusCode == 200) {
        final data = response.data;
        print('API响应状态码: ${response.statusCode}');
        print('API响应数据: $data');
        
        if (data['success'] == true) {
          final menuConfig = MenuConfig.fromJson(data);
          print('菜单配置解析成功: ${menuConfig.data.menus.length} 个菜单组');
          return menuConfig;
        } else {
          print('API请求失败: ${data['message']}');
          throw ApiException(data['message'] ?? '获取系统配置失败', 0, '');
        }
      } else {
        print('API请求失败，状态码: ${response.statusCode}');
        throw ApiException('获取系统配置失败', response.statusCode ?? 0, '');
      }
    } catch (e) {
      print('获取菜单配置时发生错误: $e');
      throw ApiException('获取系统配置时发生错误: $e', 0, '');
    }
  }

  /// 注册用户
  Future<RegisterResponse> register({
    required String username,
    required String password,
    required String email,
    required String phone,
  }) async {
    try {
      final requestData = {
        'username': username,
        'password': password,
        'email': email,
        'phone': phone,
      };

      final response = await dio.post(
        '/auth/register',
        data: requestData,
      );

      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException('网络请求失败: $e', 0, '');
    }
  }
}

/// 登录响应数据模型
class LoginResponse {
  final bool success;
  final String message;
  final String? token;
  final UserModel? user;
  final Map<String, dynamic>? data;

  LoginResponse({
    required this.success,
    required this.message,
    this.token,
    this.user,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    UserModel? user;
    
    // 处理登录接口返回的user字段
    if (json['user'] != null) {
      user = UserModel.fromJson(json['user']);
    }
    // 处理验证接口返回的data字段
     else if (json['data'] != null) {
       final data = json['data'] as Map<String, dynamic>;
       user = UserModel(
         id: data['user_id'] ?? 0,
         username: data['username'] ?? '',
         email: data['email'] ?? '',
         role: 'user', // 默认角色
         status: 'active', // 默认状态
         isStaff: false, // 默认非员工
         isSuperuser: false, // 默认非超级用户
       );
     }
    
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
      user: user,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'token': token,
      'user': user?.toJson(),
      'data': data,
    };
  }
}

/// 注册响应数据模型
class RegisterResponse {
  final bool success;
  final String message;
  final UserModel? user;

  RegisterResponse({
    required this.success,
    required this.message,
    this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user?.toJson(),
    };
  }
}

/// API异常类
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String responseBody;

  ApiException(this.message, this.statusCode, this.responseBody);

  /// 从DioException创建ApiException
  factory ApiException.fromDioException(DioException dioException) {
    String message = '网络请求失败';
    int statusCode = 0;
    String responseBody = '';

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        message = '连接超时';
        break;
      case DioExceptionType.sendTimeout:
        message = '发送超时';
        break;
      case DioExceptionType.receiveTimeout:
        message = '接收超时';
        break;
      case DioExceptionType.badResponse:
        statusCode = dioException.response?.statusCode ?? 0;
        responseBody = dioException.response?.data?.toString() ?? '';
        message = _getErrorMessageFromStatusCode(statusCode);
        break;
      case DioExceptionType.cancel:
        message = '请求已取消';
        break;
      case DioExceptionType.connectionError:
        message = '网络连接失败';
        break;
      default:
        message = dioException.message ?? '未知错误';
        break;
    }

    return ApiException(message, statusCode, responseBody);
  }

  static String _getErrorMessageFromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '用户名或密码错误';
      case 403:
        return '访问被拒绝';
      case 404:
        return '服务不存在';
      case 500:
        return '服务器内部错误';
      default:
        return '请求失败';
    }
  }

  @override
  String toString() {
    return 'ApiException: $message (状态码: $statusCode)';
  }

  /// 获取用户友好的错误信息
  String get userFriendlyMessage {
    return message;
  }
}