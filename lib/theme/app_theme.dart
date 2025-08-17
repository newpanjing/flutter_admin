import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class AppTheme {
  // 获取设置控制器
  static SettingsController get _settingsController {
    try {
      return Get.find<SettingsController>();
    } catch (e) {
      // 如果控制器未初始化，返回默认设置
      return Get.put(SettingsController());
    }
  }

  // 动态主色调 - 从控制器获取
  static Color get primaryColor => _settingsController.primaryColor;
  static Color get lightPrimaryColor => _settingsController.primaryColor.withOpacity(0.8);
  static Color get darkPrimaryColor => _settingsController.primaryColor.withOpacity(1.2);
  
  // 默认主色调 - 企业蓝（备用）
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color lightBlue = Color(0xFF3B82F6);
  static const Color darkBlue = Color(0xFF1E40AF);

  // 辅助色 - 黑色系
  static const Color primaryBlack = Color(0xFF1F2937);
  static const Color lightBlack = Color(0xFF374151);
  static const Color darkBlack = Color(0xFF111827);

  // 背景色 - 白色系
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF9FAFB);
  static const Color mediumGray = Color(0xFFE5E7EB);
  static const Color darkGray = Color(0xFF6B7280);

  // 功能色
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningYellow = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoBlue = Color(0xFF3B82F6);

  static ThemeData get lightTheme {
    final fontScale = _settingsController.fontSizeScale;
    final themeColor = primaryColor;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: themeColor,
            brightness: Brightness.light,
          ).copyWith(
            primary: themeColor,
            secondary: themeColor.withOpacity(0.8),
            surface: primaryWhite,
            error: errorRed,
          ),

      // AppBar主题
      appBarTheme: AppBarTheme(
        backgroundColor: themeColor,
        foregroundColor: primaryWhite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: primaryWhite,
          fontSize: 20 * fontScale,
          fontWeight: FontWeight.w600,
        ),
      ),

      // 卡片主题
      cardTheme: CardThemeData(
        color: primaryWhite,
        elevation: 2,
        shadowColor: primaryBlack.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          foregroundColor: primaryWhite,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: TextStyle(fontSize: 14 * fontScale),
        ),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: mediumGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: mediumGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: themeColor, width: 2),
        ),
        filled: true,
        fillColor: primaryWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // 文本主题 - 支持动态字体大小
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: primaryBlack,
          fontSize: 32 * fontScale,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: primaryBlack,
          fontSize: 24 * fontScale,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: primaryBlack,
          fontSize: 20 * fontScale,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: primaryBlack,
          fontSize: 16 * fontScale,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: lightBlack,
          fontSize: 14 * fontScale,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: darkGray,
          fontSize: 12 * fontScale,
          fontWeight: FontWeight.normal,
        ),
      ),

      // 导航栏主题
      drawerTheme: const DrawerThemeData(
        backgroundColor: primaryWhite,
        elevation: 4,
      ),

      // 列表瓦片主题
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: darkGray,
        textColor: primaryBlack,
      ),
      //对话框主题
      dialogTheme: DialogThemeData(backgroundColor: Colors.white),
    );
  }

  /// 暗黑主题
  static ThemeData get darkTheme {
    final fontScale = _settingsController.fontSizeScale;
    final themeColor = primaryColor;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: themeColor,
            brightness: Brightness.dark,
          ).copyWith(
            primary: themeColor,
            secondary: themeColor.withOpacity(0.8),
            surface: const Color(0xFF1F1F1F),
            error: errorRed,
          ),

      // AppBar主题
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20 * fontScale,
          fontWeight: FontWeight.w600,
        ),
      ),

      // 卡片主题
      cardTheme: CardThemeData(
        color: const Color(0xFF2D2D2D),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: TextStyle(fontSize: 14 * fontScale),
        ),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: themeColor, width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFF2D2D2D),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // 文本主题 - 支持动态字体大小
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 32 * fontScale,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 24 * fontScale,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 20 * fontScale,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16 * fontScale,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: Colors.white70,
          fontSize: 14 * fontScale,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: Colors.white60,
          fontSize: 12 * fontScale,
          fontWeight: FontWeight.normal,
        ),
      ),

      // 导航栏主题
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFF1F1F1F),
        elevation: 4,
      ),

      // 列表瓦片主题
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: Colors.white70,
        textColor: Colors.white,
      ),
      
      //对话框主题
      dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF2D2D2D)),
    );
  }

  /// 获取当前主题
  static ThemeData get currentTheme {
    return _settingsController.isDarkMode ? darkTheme : lightTheme;
  }
}

// 自定义颜色扩展
class AppColors {
  static const Color sidebar = Color(0xFF1F2937);
  static const Color sidebarHover = Color(0xFF374151);
  static const Color sidebarActive = Color(0xFF1E3A8A);
  static const Color contentBackground = Color(0xFFF9FAFB);
  static const Color backgroundGray = Color(0xFFF9FAFB);
  static const Color cardShadow = Color(0x1A000000);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
}