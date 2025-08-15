import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 页面标题
          Row(
            children: [
              Icon(
                Icons.settings,
                size: 32,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '系统管理',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '配置系统参数和基础设置',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // 配置卡片网格
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.2,
            children: [
              _buildConfigCard(
                title: '基本信息',
                icon: Icons.info_outline,
                color: AppTheme.primaryBlue,
                onTap: () => _showBasicInfoDialog(),
              ),
              _buildConfigCard(
                title: '安全设置',
                icon: Icons.security,
                color: AppTheme.successGreen,
                onTap: () => _showSecurityDialog(),
              ),
              _buildConfigCard(
                title: '通知设置',
                icon: Icons.notifications_outlined,
                color: AppTheme.warningYellow,
                onTap: () => _showNotificationDialog(),
              ),
              _buildConfigCard(
                title: '备份设置',
                icon: Icons.backup,
                color: Colors.purple,
                onTap: () => _showBackupDialog(),
              ),
              _buildConfigCard(
                title: '日志设置',
                icon: Icons.description_outlined,
                color: Colors.orange,
                onTap: () => _showLogDialog(),
              ),
              _buildConfigCard(
                title: '系统监控',
                icon: Icons.monitor,
                color: Colors.teal,
                onTap: () => _showMonitorDialog(),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // 系统信息卡片
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.computer,
                        color: AppTheme.primaryBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '系统信息',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('系统名称', _systemConfig['systemName']),
                  _buildInfoRow('系统版本', _systemConfig['systemVersion']),
                  _buildInfoRow('公司名称', _systemConfig['companyName']),
                  _buildInfoRow('联系电话', _systemConfig['companyPhone']),
                  _buildInfoRow('联系邮箱', _systemConfig['companyEmail']),
                  _buildInfoRow('服务器时间', DateTime.now().toString().substring(0, 19)),
                  _buildInfoRow('运行时长', '15天 8小时 32分钟'),
                  _buildInfoRow('在线用户', '12'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildConfigCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
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
      builder: (context) => AlertDialog(
        title: const Text('基本信息设置'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: '系统名称',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: companyController,
                decoration: const InputDecoration(
                  labelText: '公司名称',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: '公司地址',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: '联系电话',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: '联系邮箱',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
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
            child: const Text('保存'),
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
        builder: (context, setState) => AlertDialog(
          title: const Text('安全设置'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text('会话超时时间'),
                    const Spacer(),
                    Text('$sessionTimeout 分钟'),
                  ],
                ),
                Slider(
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('最大登录尝试次数'),
                    const Spacer(),
                    Text('$maxLoginAttempts 次'),
                  ],
                ),
                Slider(
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                this.setState(() {
                  _systemConfig['sessionTimeout'] = sessionTimeout;
                  _systemConfig['maxLoginAttempts'] = maxLoginAttempts;
                });
                Navigator.of(context).pop();
                _showSuccessMessage('安全设置已更新');
              },
              child: const Text('保存'),
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
        builder: (context, setState) => AlertDialog(
          title: const Text('通知设置'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('邮件通知'),
                subtitle: const Text('启用系统邮件通知功能'),
                value: emailNotification,
                onChanged: (value) {
                  setState(() {
                    emailNotification = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('短信通知'),
                subtitle: const Text('启用系统短信通知功能'),
                value: smsNotification,
                onChanged: (value) {
                  setState(() {
                    smsNotification = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                this.setState(() {
                  _systemConfig['enableEmailNotification'] = emailNotification;
                  _systemConfig['enableSMSNotification'] = smsNotification;
                });
                Navigator.of(context).pop();
                _showSuccessMessage('通知设置已更新');
              },
              child: const Text('保存'),
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
        builder: (context, setState) => AlertDialog(
          title: const Text('备份设置'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('自动备份'),
                subtitle: const Text('启用系统自动备份功能'),
                value: autoBackup,
                onChanged: (value) {
                  setState(() {
                    autoBackup = value;
                  });
                },
              ),
              if (autoBackup) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('备份间隔'),
                    const Spacer(),
                    Text('$backupInterval 小时'),
                  ],
                ),
                Slider(
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
               ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                this.setState(() {
                  _systemConfig['autoBackup'] = autoBackup;
                  _systemConfig['backupInterval'] = backupInterval;
                });
                Navigator.of(context).pop();
                _showSuccessMessage('备份设置已更新');
              },
              child: const Text('保存'),
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
        builder: (context, setState) => AlertDialog(
          title: const Text('日志设置'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: logLevel,
                decoration: const InputDecoration(
                  labelText: '日志级别',
                  border: OutlineInputBorder(),
                ),
                items: ['DEBUG', 'INFO', 'WARN', 'ERROR']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    logLevel = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('最大日志大小'),
                  const Spacer(),
                  Text('$maxLogSize MB'),
                ],
              ),
              Slider(
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                this.setState(() {
                  _systemConfig['logLevel'] = logLevel;
                  _systemConfig['maxLogSize'] = maxLogSize;
                });
                Navigator.of(context).pop();
                _showSuccessMessage('日志设置已更新');
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showMonitorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('系统监控'),
        content: SizedBox(
          width: 500,
          height: 400,
          child: Column(
            children: [
              _buildMonitorItem('CPU使用率', '45%', AppTheme.successGreen),
              _buildMonitorItem('内存使用率', '68%', AppTheme.warningYellow),
              _buildMonitorItem('磁盘使用率', '32%', AppTheme.successGreen),
              _buildMonitorItem('网络流量', '1.2MB/s', AppTheme.primaryBlue),
              _buildMonitorItem('数据库连接', '15/100', AppTheme.successGreen),
              _buildMonitorItem('活跃会话', '12', AppTheme.primaryBlue),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
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