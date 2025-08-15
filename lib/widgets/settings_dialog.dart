import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  // 主题色选项
  final List<Color> _themeColors = [
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.orange,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
  ];
  
  Color _selectedThemeColor = Colors.green;
  
  // 风格选项
  final List<String> _themeStyles = ['现代风格', '经典风格', '简约风格', '商务风格'];
  String _selectedThemeStyle = '现代风格';
  
  // 字体大小选项
  final List<String> _fontSizes = ['小', '中', '大', '特大'];
  String _selectedFontSize = '中';
  
  // 字体类型选项
  final List<String> _fontTypes = ['系统默认', '微软雅黑', 'PingFang SC', 'Helvetica', 'Arial'];
  String _selectedFontType = '系统默认';
  
  // 语言选项
  final List<String> _languages = ['简体中文', 'English', '繁體中文', '日本語'];
  String _selectedLanguage = '简体中文';
  
  // 其他设置
  bool _enableAnimations = true;
  bool _enableNotifications = true;
  bool _enableSounds = false;
  bool _autoSave = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
        height: 700,
        decoration: BoxDecoration(
          color: AppTheme.primaryWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // 对话框标题
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _selectedThemeColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: _selectedThemeColor,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '系统设置',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _selectedThemeColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // 设置内容
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 主题色设置
                    _buildSectionTitle('主题色彩'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _themeColors.map((color) {
                        final isSelected = color == _selectedThemeColor;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedThemeColor = color;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: isSelected ? Colors.white : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 界面风格
                    _buildSectionTitle('界面风格'),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      value: _selectedThemeStyle,
                      items: _themeStyles,
                      onChanged: (value) {
                        setState(() {
                          _selectedThemeStyle = value!;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 字体设置
                    _buildSectionTitle('字体设置'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '字体大小',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildDropdown(
                                value: _selectedFontSize,
                                items: _fontSizes,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedFontSize = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '字体类型',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildDropdown(
                                value: _selectedFontType,
                                items: _fontTypes,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedFontType = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 语言设置
                    _buildSectionTitle('语言设置'),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      value: _selectedLanguage,
                      items: _languages,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 其他设置
                    _buildSectionTitle('其他设置'),
                    const SizedBox(height: 16),
                    _buildSwitchTile(
                      title: '启用动画效果',
                      subtitle: '界面切换和交互动画',
                      value: _enableAnimations,
                      onChanged: (value) {
                        setState(() {
                          _enableAnimations = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      title: '启用通知提醒',
                      subtitle: '系统消息和提醒通知',
                      value: _enableNotifications,
                      onChanged: (value) {
                        setState(() {
                          _enableNotifications = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      title: '启用提示音',
                      subtitle: '操作反馈和提示音效',
                      value: _enableSounds,
                      onChanged: (value) {
                        setState(() {
                          _enableSounds = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      title: '自动保存',
                      subtitle: '自动保存用户操作和数据',
                      value: _autoSave,
                      onChanged: (value) {
                        setState(() {
                          _autoSave = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // 底部按钮
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.contentBackground,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // 保存设置
                      _saveSettings();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('设置已保存'),
                          backgroundColor: _selectedThemeColor,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedThemeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '保存设置',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
  
  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
        color: AppTheme.primaryWhite,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
  
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _selectedThemeColor,
            activeTrackColor: _selectedThemeColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
  
  void _saveSettings() {
    // 这里可以实现实际的设置保存逻辑
    // 比如保存到SharedPreferences或其他持久化存储
    print('保存设置:');
    print('主题色: $_selectedThemeColor');
    print('界面风格: $_selectedThemeStyle');
    print('字体大小: $_selectedFontSize');
    print('字体类型: $_selectedFontType');
    print('语言: $_selectedLanguage');
    print('启用动画: $_enableAnimations');
    print('启用通知: $_enableNotifications');
    print('启用提示音: $_enableSounds');
    print('自动保存: $_autoSave');
  }
}