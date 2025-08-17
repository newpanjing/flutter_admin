import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 系统设置控制器
/// 管理主题色、语言、文字大小等系统设置
class SettingsController extends GetxController {
  // 主题色配置
  static const Map<String, Color> _themeColors = {
    'blue': Color(0xFF2196F3),
    'green': Color(0xFF4CAF50),
    'purple': Color(0xFF9C27B0),
    'orange': Color(0xFFFF9800),
    'red': Color(0xFFF44336),
    'teal': Color(0xFF009688),
  };

  // 语言配置
  static const Map<String, Locale> _languages = {
    'zh_CN': Locale('zh', 'CN'),
    'en_US': Locale('en', 'US'),
  };

  // 文字大小配置
  static const Map<String, double> _fontSizes = {
    'small': 0.8,
    'medium': 1.0,
    'large': 1.2,
    'extra_large': 1.4,
  };

  // 响应式变量
  final _primaryColor = 'blue'.obs;
  final _language = 'zh_CN'.obs;
  final _fontSize = 'medium'.obs;
  final _isDarkMode = false.obs;
  final _isLoading = false.obs;

  // Getters
  String get primaryColorKey => _primaryColor.value;
  Color get primaryColor => _themeColors[_primaryColor.value] ?? _themeColors['blue']!;
  String get languageKey => _language.value;
  Locale get language => _languages[_language.value] ?? _languages['zh_CN']!;
  String get fontSizeKey => _fontSize.value;
  double get fontSizeScale => _fontSizes[_fontSize.value] ?? _fontSizes['medium']!;
  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  bool get isLoading => _isLoading.value;

  /// 获取可用颜色列表
  List<String> get availableColorKeys => _themeColors.keys.toList();

  /// 获取可用字体大小列表
  List<String> get availableFontSizeKeys => _fontSizes.keys.toList();

  /// 获取可用语言列表
  List<String> get availableLanguageKeys => _languages.keys.toList();

  // 获取所有可用的主题色
  Map<String, Color> get availableColors => _themeColors;
  
  // 获取所有可用的语言
  Map<String, Locale> get availableLanguages => _languages;
  
  // 获取所有可用的文字大小
  Map<String, double> get availableFontSizes => _fontSizes;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  /// 加载设置
  Future<void> _loadSettings() async {
    try {
      _isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      
      // 加载主题色
      final savedColor = prefs.getString('primary_color');
      if (savedColor != null && _themeColors.containsKey(savedColor)) {
        _primaryColor.value = savedColor;
      }
      
      // 加载语言
      final savedLanguage = prefs.getString('language');
      if (savedLanguage != null && _languages.containsKey(savedLanguage)) {
        _language.value = savedLanguage;
      }
      
      // 加载文字大小
      final savedFontSize = prefs.getString('font_size');
      if (savedFontSize != null && _fontSizes.containsKey(savedFontSize)) {
        _fontSize.value = savedFontSize;
      }
      
      // 加载暗黑模式
      _isDarkMode.value = prefs.getBool('dark_mode') ?? false;
      
    } catch (e) {
      print('加载设置失败: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// 保存设置
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('primary_color', _primaryColor.value);
      await prefs.setString('language', _language.value);
      await prefs.setString('font_size', _fontSize.value);
      await prefs.setBool('dark_mode', _isDarkMode.value);
    } catch (e) {
      print('保存设置失败: $e');
    }
  }

  /// 设置主题色
  Future<void> setPrimaryColor(String colorKey) async {
    if (_themeColors.containsKey(colorKey)) {
      _primaryColor.value = colorKey;
      await _saveSettings();
      Get.snackbar(
        '设置成功',
        '主题色已更新',
        snackPosition: SnackPosition.TOP,
        backgroundColor: primaryColor.withOpacity(0.1),
        colorText: primaryColor,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// 设置语言
  Future<void> setLanguage(String languageKey) async {
    if (_languages.containsKey(languageKey)) {
      _language.value = languageKey;
      await _saveSettings();
      
      // 更新GetX的语言设置
      Get.updateLocale(_languages[languageKey]!);
      
      Get.snackbar(
        '设置成功',
        '语言已更新',
        snackPosition: SnackPosition.TOP,
        backgroundColor: primaryColor.withOpacity(0.1),
        colorText: primaryColor,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// 设置文字大小
  Future<void> setFontSize(String fontSizeKey) async {
    if (_fontSizes.containsKey(fontSizeKey)) {
      _fontSize.value = fontSizeKey;
      await _saveSettings();
      Get.snackbar(
        '设置成功',
        '文字大小已更新',
        snackPosition: SnackPosition.TOP,
        backgroundColor: primaryColor.withOpacity(0.1),
        colorText: primaryColor,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// 切换暗黑模式
  Future<void> toggleDarkMode() async {
    _isDarkMode.value = !_isDarkMode.value;
    await _saveSettings();
    
    // 更新GetX的主题模式
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    
    Get.snackbar(
      '设置成功',
      _isDarkMode.value ? '已切换到暗黑模式' : '已切换到明亮模式',
      snackPosition: SnackPosition.TOP,
      backgroundColor: primaryColor.withOpacity(0.1),
      colorText: primaryColor,
      duration: const Duration(seconds: 2),
    );
  }

  /// 更新暗黑模式
  Future<void> updateDarkMode(bool isDark) async {
    _isDarkMode.value = isDark;
    await _saveSettings();
    
    // 更新GetX的主题模式
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    update();
  }

  /// 更新主题色
  Future<void> updatePrimaryColor(String colorKey) async {
    if (_themeColors.containsKey(colorKey)) {
      _primaryColor.value = colorKey;
      await _saveSettings();
      update();
    }
  }

  /// 更新字体大小
  Future<void> updateFontSize(String size) async {
    if (_fontSizes.containsKey(size)) {
      _fontSize.value = size;
      await _saveSettings();
      update();
    }
  }

  /// 更新语言
  Future<void> updateLanguage(String lang) async {
    if (_languages.containsKey(lang)) {
      _language.value = lang;
      await _saveSettings();
      
      // 更新GetX的语言设置
      Get.updateLocale(_languages[lang]!);
      update();
    }
  }

  /// 根据名称获取颜色
  Color getColorByName(String name) {
    return _themeColors[name] ?? _themeColors['blue']!;
  }

  /// 获取颜色显示名称
  String getColorDisplayName(String name) {
    const displayNames = {
      'blue': '蓝色',
      'green': '绿色',
      'purple': '紫色',
      'orange': '橙色',
      'red': '红色',
    };
    return displayNames[name] ?? name;
  }

  /// 获取字体大小显示名称
  String getFontSizeDisplayName(String size) {
    const displayNames = {
      'small': '小',
      'medium': '中',
      'large': '大',
    };
    return displayNames[size] ?? size;
  }

  /// 获取语言显示名称
  String getLanguageDisplayName(String lang) {
    const displayNames = {
      'zh_CN': '简体中文',
      'en_US': 'English',
    };
    return displayNames[lang] ?? lang;
  }

  /// 重置所有设置
  Future<void> resetSettings() async {
    try {
      _isLoading.value = true;
      
      _primaryColor.value = 'blue';
      _language.value = 'zh_CN';
      _fontSize.value = 'medium';
      _isDarkMode.value = false;
      
      await _saveSettings();
      
      // 更新GetX设置
      Get.updateLocale(_languages['zh_CN']!);
      Get.changeThemeMode(ThemeMode.light);
      update();
      
      Get.snackbar(
        '重置成功',
        '所有设置已恢复默认值',
        snackPosition: SnackPosition.TOP,
        backgroundColor: primaryColor.withOpacity(0.1),
        colorText: primaryColor,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('重置设置失败: $e');
      Get.snackbar(
        '重置失败',
        '请稍后重试',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 2),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// 获取主题色名称
  String getColorName(String colorKey) {
    const colorNames = {
      'blue': '蓝色',
      'green': '绿色',
      'purple': '紫色',
      'orange': '橙色',
      'red': '红色',
      'teal': '青色',
    };
    return colorNames[colorKey] ?? '未知';
  }

  /// 获取语言名称
  String getLanguageName(String languageKey) {
    const languageNames = {
      'zh_CN': '简体中文',
      'en_US': 'English',
    };
    return languageNames[languageKey] ?? '未知';
  }

  /// 获取文字大小名称
  String getFontSizeName(String fontSizeKey) {
    const fontSizeNames = {
      'small': '小',
      'medium': '中',
      'large': '大',
      'extra_large': '特大',
    };
    return fontSizeNames[fontSizeKey] ?? '未知';
  }

  /// 获取主题色名称
  String get primaryColorName => _primaryColor.value;

  /// 获取当前主题色
  String get currentPrimaryColor => _primaryColor.value;

  /// 获取当前字体大小
  String get currentFontSize => _fontSize.value;

  /// 获取当前语言
  String get currentLanguage => _language.value;
}