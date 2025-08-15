import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/modern_dialog.dart';

class SystemManagementPage extends StatefulWidget {
  const SystemManagementPage({super.key});

  @override
  State<SystemManagementPage> createState() => _SystemManagementPageState();
}

class _SystemManagementPageState extends State<SystemManagementPage> {
  // 系统配置数据
  final Map<String, dynamic> _systemConfig = {
    'systemName': 'ERP管理系统',
    'systemVersion': 'v1.0.0',
    'companyName': '示例公司',
    'companyAddress': '北京市朝阳区示例大厦',
    'companyPhone': '010-12345678',
    'companyEmail': 'contact@example.com',
    'sessionTimeout': 30,
    'maxLoginAttempts': 5,
    'enableEmailNotification': true,
    'enableSMSNotification': false,
    'autoBackup': true,
    'backupInterval': 24,
    'logLevel': 'INFO',
    'maxLogSize': 100,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 现代化页面标题
            _buildModernHeader(context),
            const SizedBox(height: 40),
            
            // 主要内容区域
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧配置面板
                Expanded(
                  flex: 2,
                  child: _buildConfigurationPanel(),
                ),
                const SizedBox(width: 32),
                // 右侧系统信息面板
                Expanded(
                  flex: 1,
                  child: _buildSystemInfoPanel(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // 现代化页面标题
  Widget _buildModernHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue.withOpacity(0.1),
            AppTheme.successGreen.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.settings_applications,
              size: 40,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '系统管理中心',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '统一管理系统配置、安全设置、监控状态等核心功能',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // 快速操作按钮
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.successGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.refresh,
              color: AppTheme.successGreen,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // 配置面板
  Widget _buildConfigurationPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 面板标题
          Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                Icon(
                  Icons.tune,
                  color: AppTheme.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  '配置管理',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // 配置项列表
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
            child: Column(
              children: [
                _buildModernConfigItem(
                  title: '基本信息设置',
                  subtitle: '系统名称、公司信息等基础配置',
                  icon: Icons.info_outline,
                  color: AppTheme.primaryBlue,
                  onTap: () => _showBasicInfoDialog(),
                ),
                const SizedBox(height: 16),
                _buildModernConfigItem(
                  title: '安全策略配置',
                  subtitle: '会话超时、登录限制等安全设置',
                  icon: Icons.security,
                  color: AppTheme.successGreen,
                  onTap: () => _showSecurityDialog(),
                ),
                const SizedBox(height: 16),
                _buildModernConfigItem(
                  title: '通知服务管理',
                  subtitle: '邮件、短信等通知渠道配置',
                  icon: Icons.notifications_outlined,
                  color: AppTheme.warningYellow,
                  onTap: () => _showNotificationDialog(),
                ),
                const SizedBox(height: 16),
                _buildModernConfigItem(
                  title: '数据备份策略',
                  subtitle: '自动备份、备份间隔等设置',
                  icon: Icons.backup,
                  color: const Color(0xFF4CAF50),
                  onTap: () => _showBackupDialog(),
                ),
                const SizedBox(height: 16),
                _buildModernConfigItem(
                  title: '日志管理配置',
                  subtitle: '日志级别、存储大小等设置',
                  icon: Icons.description_outlined,
                  color: Colors.orange,
                  onTap: () => _showLogDialog(),
                ),
                const SizedBox(height: 16),
                _buildModernConfigItem(
                  title: '系统监控面板',
                  subtitle: '实时查看系统运行状态',
                  icon: Icons.monitor_heart,
                  color: Colors.teal,
                  onTap: () => _showMonitorDialog(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 现代化配置项
  Widget _buildModernConfigItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
              Icon(
                Icons.arrow_forward_ios,
                color: color.withOpacity(0.6),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 系统信息面板
  Widget _buildSystemInfoPanel(BuildContext context) {
    return Column(
      children: [
        // 系统状态卡片
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.computer,
                      color: AppTheme.successGreen,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '系统状态',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.successGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '运行正常',
                          style: TextStyle(
                            color: AppTheme.successGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildModernInfoRow('系统名称', _systemConfig['systemName'], Icons.computer),
              _buildModernInfoRow('系统版本', _systemConfig['systemVersion'], Icons.info),
              _buildModernInfoRow('公司名称', _systemConfig['companyName'], Icons.business),
              _buildModernInfoRow('联系电话', _systemConfig['companyPhone'], Icons.phone),
              _buildModernInfoRow('联系邮箱', _systemConfig['companyEmail'], Icons.email),
              _buildModernInfoRow('服务器时间', DateTime.now().toString().substring(0, 19), Icons.access_time),
              _buildModernInfoRow('运行时长', '15天 8小时 32分钟', Icons.timer),
              _buildModernInfoRow('在线用户', '12', Icons.people),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // 快速监控卡片
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.analytics,
                      color: AppTheme.primaryBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '快速监控',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildQuickMonitorItem('CPU使用率', '45%', AppTheme.successGreen, 0.45),
              const SizedBox(height: 12),
              _buildQuickMonitorItem('内存使用率', '68%', AppTheme.warningYellow, 0.68),
              const SizedBox(height: 12),
              _buildQuickMonitorItem('磁盘使用率', '32%', AppTheme.successGreen, 0.32),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showMonitorDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '查看详细监控',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // 现代化信息行
  Widget _buildModernInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // 快速监控项
  Widget _buildQuickMonitorItem(String label, String value, Color color, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ],
    );
  }
  
  void _showBasicInfoDialog() {
    final nameController = TextEditingController(text: _systemConfig['systemName']);
    final companyController = TextEditingController(text: _systemConfig['companyName']);
    final addressController = TextEditingController(text: _systemConfig['companyAddress']);
    final phoneController = TextEditingController(text: _systemConfig['companyPhone']);
    final emailController = TextEditingController(text: _systemConfig['companyEmail']);
    
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '基本信息设置',
        titleIcon: Icons.info_outline,
        width: 500,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModernFormField(
              controller: nameController,
              label: '系统名称',
              prefixIcon: Icons.computer,
            ),
            const SizedBox(height: 20),
            ModernFormField(
              controller: companyController,
              label: '公司名称',
              prefixIcon: Icons.business,
            ),
            const SizedBox(height: 20),
            ModernFormField(
              controller: addressController,
              label: '公司地址',
              prefixIcon: Icons.location_on,
            ),
            const SizedBox(height: 20),
            ModernFormField(
              controller: phoneController,
              label: '联系电话',
              prefixIcon: Icons.phone,
            ),
            const SizedBox(height: 20),
            ModernFormField(
              controller: emailController,
              label: '联系邮箱',
              prefixIcon: Icons.email,
            ),
          ],
        ),
        actions: [
          ModernButton(
             text: '取消',
             type: ButtonType.secondary,
             onPressed: () => Navigator.of(context).pop(),
           ),
           ModernButton(
             text: '保存',
             type: ButtonType.primary,
            onPressed: () {
              setState(() {
                _systemConfig['systemName'] = nameController.text;
                _systemConfig['companyName'] = companyController.text;
                _systemConfig['companyAddress'] = addressController.text;
                _systemConfig['companyPhone'] = phoneController.text;
                _systemConfig['companyEmail'] = emailController.text;
              });
              Navigator.of(context).pop();
              _showSuccessMessage('基本信息已更新');
            },
          ),
        ],
      ),
    );
  }
  
  void _showSecurityDialog() {
    int sessionTimeout = _systemConfig['sessionTimeout'];
    int maxLoginAttempts = _systemConfig['maxLoginAttempts'];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => ModernDialog(
          title: '安全设置',
          titleIcon: Icons.security,
          width: 500,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timer, color: AppTheme.primaryBlue, size: 20),
                        const SizedBox(width: 8),
                        const Text('会话超时时间', style: TextStyle(fontWeight: FontWeight.w500)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.successGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '$sessionTimeout 分钟',
                            style: TextStyle(color: AppTheme.successGreen, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppTheme.successGreen,
                        thumbColor: AppTheme.successGreen,
                        overlayColor: AppTheme.successGreen.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: sessionTimeout.toDouble(),
                        min: 5,
                        max: 120,
                        divisions: 23,
                        onChanged: (value) {
                          setState(() {
                            sessionTimeout = value.round();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lock_outline, color: AppTheme.primaryBlue, size: 20),
                        const SizedBox(width: 8),
                        const Text('最大登录尝试次数', style: TextStyle(fontWeight: FontWeight.w500)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.warningYellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '$maxLoginAttempts 次',
                            style: TextStyle(color: AppTheme.warningYellow, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppTheme.warningYellow,
                        thumbColor: AppTheme.warningYellow,
                        overlayColor: AppTheme.warningYellow.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: maxLoginAttempts.toDouble(),
                        min: 3,
                        max: 10,
                        divisions: 7,
                        onChanged: (value) {
                          setState(() {
                            maxLoginAttempts = value.round();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ModernButton(
              text: '取消',
              type: ButtonType.secondary,
              onPressed: () => Navigator.of(context).pop(),
            ),
            ModernButton(
              text: '保存',
              type: ButtonType.primary,
              onPressed: () {
                this.setState(() {
                  _systemConfig['sessionTimeout'] = sessionTimeout;
                  _systemConfig['maxLoginAttempts'] = maxLoginAttempts;
                });
                Navigator.of(context).pop();
                _showSuccessMessage('安全设置已更新');
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showNotificationDialog() {
    bool emailNotification = _systemConfig['enableEmailNotification'];
    bool smsNotification = _systemConfig['enableSMSNotification'];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => ModernDialog(
          title: '通知设置',
          titleIcon: Icons.notifications_outlined,
          width: 500,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: emailNotification ? AppTheme.successGreen.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.email_outlined,
                            color: emailNotification ? AppTheme.successGreen : Colors.grey,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '邮件通知',
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '启用系统邮件通知功能',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: emailNotification,
                          onChanged: (value) {
                            setState(() {
                              emailNotification = value;
                            });
                          },
                          activeColor: AppTheme.successGreen,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: smsNotification ? AppTheme.successGreen.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.sms_outlined,
                            color: smsNotification ? AppTheme.successGreen : Colors.grey,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '短信通知',
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '启用系统短信通知功能',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: smsNotification,
                          onChanged: (value) {
                            setState(() {
                              smsNotification = value;
                            });
                          },
                          activeColor: AppTheme.successGreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ModernButton(
              text: '取消',
              type: ButtonType.secondary,
              onPressed: () => Navigator.of(context).pop(),
            ),
            ModernButton(
              text: '保存',
              type: ButtonType.primary,
              onPressed: () {
                this.setState(() {
                  _systemConfig['enableEmailNotification'] = emailNotification;
                  _systemConfig['enableSMSNotification'] = smsNotification;
                });
                Navigator.of(context).pop();
                _showSuccessMessage('通知设置已更新');
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showBackupDialog() {
    bool autoBackup = _systemConfig['autoBackup'];
    int backupInterval = _systemConfig['backupInterval'];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => ModernDialog(
          title: '备份设置',
          titleIcon: Icons.backup_outlined,
          width: 500,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: autoBackup ? AppTheme.successGreen.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.backup,
                            color: autoBackup ? AppTheme.successGreen : Colors.grey,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '自动备份',
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '启用系统自动备份功能',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: autoBackup,
                          onChanged: (value) {
                            setState(() {
                              autoBackup = value;
                            });
                          },
                          activeColor: AppTheme.successGreen,
                        ),
                      ],
                    ),
                    if (autoBackup) ...[
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.schedule, color: AppTheme.primaryBlue, size: 20),
                          const SizedBox(width: 8),
                          const Text('备份间隔', style: TextStyle(fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '$backupInterval 小时',
                              style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppTheme.primaryBlue,
                          thumbColor: AppTheme.primaryBlue,
                          overlayColor: AppTheme.primaryBlue.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: backupInterval.toDouble(),
                          min: 1,
                          max: 168,
                          divisions: 167,
                          onChanged: (value) {
                            setState(() {
                              backupInterval = value.round();
                            });
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ModernButton(
              text: '取消',
              type: ButtonType.secondary,
              onPressed: () => Navigator.of(context).pop(),
            ),
            ModernButton(
              text: '保存',
              type: ButtonType.primary,
              onPressed: () {
                this.setState(() {
                  _systemConfig['autoBackup'] = autoBackup;
                  _systemConfig['backupInterval'] = backupInterval;
                });
                Navigator.of(context).pop();
                _showSuccessMessage('备份设置已更新');
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showLogDialog() {
    String logLevel = _systemConfig['logLevel'];
    int maxLogSize = _systemConfig['maxLogSize'];
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => ModernDialog(
          title: '日志设置',
          titleIcon: Icons.description_outlined,
          width: 500,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  children: [
                    ModernDropdown<String>(
                      label: '日志级别',
                      value: logLevel,
                      items: ['DEBUG', 'INFO', 'WARN', 'ERROR'],
                      itemBuilder: (level) => level,
                      prefixIcon: Icons.bug_report,
                      onChanged: (value) {
                        setState(() {
                          logLevel = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(Icons.storage, color: AppTheme.primaryBlue, size: 20),
                        const SizedBox(width: 8),
                        const Text('最大日志大小', style: TextStyle(fontWeight: FontWeight.w500)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.warningYellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '$maxLogSize MB',
                            style: TextStyle(color: AppTheme.warningYellow, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppTheme.warningYellow,
                        thumbColor: AppTheme.warningYellow,
                        overlayColor: AppTheme.warningYellow.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: maxLogSize.toDouble(),
                        min: 10,
                        max: 1000,
                        divisions: 99,
                        onChanged: (value) {
                          setState(() {
                            maxLogSize = value.round();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ModernButton(
              text: '取消',
              type: ButtonType.secondary,
              onPressed: () => Navigator.of(context).pop(),
            ),
            ModernButton(
              text: '保存',
              type: ButtonType.primary,
              onPressed: () {
                this.setState(() {
                  _systemConfig['logLevel'] = logLevel;
                  _systemConfig['maxLogSize'] = maxLogSize;
                });
                Navigator.of(context).pop();
                _showSuccessMessage('日志设置已更新');
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showMonitorDialog() {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '系统监控',
        titleIcon: Icons.monitor_heart_outlined,
        width: 600,
        maxHeight: 500,
        content: Container(
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildModernMonitorItem('CPU使用率', '45%', AppTheme.successGreen, Icons.memory, 0.45),
                    const SizedBox(height: 12),
                    _buildModernMonitorItem('内存使用率', '68%', AppTheme.warningYellow, Icons.storage, 0.68),
                    const SizedBox(height: 12),
                    _buildModernMonitorItem('磁盘使用率', '32%', AppTheme.successGreen, Icons.storage_outlined, 0.32),
                    const SizedBox(height: 12),
                    _buildModernMonitorItem('网络流量', '1.2MB/s', AppTheme.primaryBlue, Icons.network_check, 0.3),
                    const SizedBox(height: 12),
                    _buildModernMonitorItem('数据库连接', '15/100', AppTheme.successGreen, Icons.data_usage, 0.15),
                    const SizedBox(height: 12),
                    _buildModernMonitorItem('活跃会话', '12', AppTheme.primaryBlue, Icons.people, 0.2),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          ModernButton(
            text: '关闭',
            type: ButtonType.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMonitorItem(String label, String value, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            Icons.analytics,
            color: color,
            size: 20,
          ),
        ),
        title: Text(label),
        trailing: Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildModernMonitorItem(String label, String value, Color color, IconData icon, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
  
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}