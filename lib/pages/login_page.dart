import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../routes/app_router.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isRegisterMode = false;

  @override
  void initState() {
    super.initState();
    _checkExistingToken();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// 检查本地是否存在有效的token
  Future<void> _checkExistingToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token != null && token.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });
        
        // 验证token是否有效
        final apiService = ApiService();
        final verifyResponse = await apiService.verifyToken(token);
        
        if (verifyResponse.success) {
          // Token有效，更新用户信息并跳转到仪表板
          if (verifyResponse.user != null) {
            await prefs.setString('user_id', verifyResponse.user!.id.toString());
            await prefs.setString('username', verifyResponse.user!.username);
            await prefs.setString('email', verifyResponse.user!.email);
          }
          
          AppRouter.setLoginStatus(true);
          if (mounted) {
            context.go('/dashboard');
          }
        } else {
          // Token无效，清除本地存储
          await _clearLocalStorage();
        }
      }
    } catch (e) {
      // Token验证失败，清除本地存储
      await _clearLocalStorage();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// 清除本地存储
  Future<void> _clearLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('username');
    await prefs.remove('email');
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      // 调用API服务进行登录
      final apiService = ApiService();
      final loginResponse = await apiService.login(username, password);

      if (loginResponse.success && loginResponse.token != null) {
        // 登录成功，保存token和用户信息
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', loginResponse.token!);
        
        if (loginResponse.user != null) {
          await prefs.setString('user_id', loginResponse.user!.id.toString());
          await prefs.setString('username', loginResponse.user!.username);
          await prefs.setString('email', loginResponse.user!.email);
        }
        
        // 设置登录状态并跳转到仪表板
        AppRouter.setLoginStatus(true);
        if (mounted) {
          // 显示成功消息
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loginResponse.message),
              backgroundColor: AppTheme.successGreen,
            ),
          );
          context.go('/dashboard');
        }
      } else {
        // 登录失败，显示错误信息
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loginResponse.message),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      }
    } catch (e) {
      // 处理异常
      if (mounted) {
        String errorMessage = '登录失败';
        if (e is ApiException) {
          errorMessage = e.userFriendlyMessage;
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 调用API服务进行注册
      final apiService = ApiService();
      final registerResponse = await apiService.register(
        username: _usernameController.text,
        password: _passwordController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      if (registerResponse.success) {
        // 注册成功
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(registerResponse.message),
              backgroundColor: AppTheme.successGreen,
            ),
          );
          // 切换到登录模式
          setState(() {
            _isRegisterMode = false;
            _usernameController.clear();
            _passwordController.clear();
            _confirmPasswordController.clear();
            _emailController.clear();
            _phoneController.clear();
          });
        }
      } else {
        // 注册失败
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(registerResponse.message),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      }
    } catch (e) {
      // 处理异常
      if (mounted) {
        String errorMessage = '注册失败';
        if (e is ApiException) {
          errorMessage = e.userFriendlyMessage;
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleMode() {
    setState(() {
      _isRegisterMode = !_isRegisterMode;
      _usernameController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _emailController.clear();
      _phoneController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo和标题
                    const Icon(
                       Icons.business,
                       size: 64,
                       color: AppTheme.primaryBlue,
                     ),
                    const SizedBox(height: 16),
                    Text(
                      _isRegisterMode ? '注册账号' : 'ERP管理系统',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlack,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // 用户名输入框
                    TextFormField(
                      controller: _usernameController,
                      onFieldSubmitted: (_) {
                        // 回车登录功能
                        if (!_isRegisterMode && !_isLoading) {
                          _login();
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: '用户名',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入用户名';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // 密码输入框
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onFieldSubmitted: (_) {
                        // 回车登录功能
                        if (!_isRegisterMode && !_isLoading) {
                          _login();
                        }
                      },
                      decoration: InputDecoration(
                        labelText: '密码',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入密码';
                        }
                        if (_isRegisterMode && value.length < 6) {
                          return '密码长度至少6位';
                        }
                        return null;
                      },
                    ),
                    
                    // 注册模式下的额外字段
                    if (_isRegisterMode) ...
                      [
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscurePassword,
                          decoration: const InputDecoration(
                            labelText: '确认密码',
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请确认密码';
                            }
                            if (value != _passwordController.text) {
                              return '两次输入的密码不一致';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: '邮箱',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入邮箱';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return '请输入有效的邮箱地址';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: '手机号',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入手机号';
                            }
                            if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
                              return '请输入有效的手机号';
                            }
                            return null;
                          },
                        ),
                      ],
                    
                    const SizedBox(height: 24),
                    
                    // 登录/注册按钮
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : (_isRegisterMode ? _register : _login),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                _isRegisterMode ? '注册' : '登录',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 模式切换链接
                    TextButton(
                      onPressed: _toggleMode,
                      child: Text(
                        _isRegisterMode ? '已有账号？立即登录' : '没有账号？立即注册',
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    // 登录模式下显示默认账号提示
                    if (!_isRegisterMode)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                '默认账号：admin / 123456',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}