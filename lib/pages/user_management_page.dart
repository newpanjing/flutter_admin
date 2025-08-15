import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../theme/app_theme.dart';
import '../models/user_model.dart';
import '../widgets/modern_dialog.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final List<UserModel> _users = [
    UserModel(
      id: '1',
      username: 'admin',
      name: '系统管理员',
      email: 'admin@company.com',
      role: '管理员',
      status: '启用',
      createTime: DateTime.now().subtract(const Duration(days: 30)),
      lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    UserModel(
      id: '2',
      username: 'manager',
      name: '部门经理',
      email: 'manager@company.com',
      role: '经理',
      status: '启用',
      createTime: DateTime.now().subtract(const Duration(days: 15)),
      lastLogin: DateTime.now().subtract(const Duration(days: 1)),
    ),
    UserModel(
      id: '3',
      username: 'employee',
      name: '普通员工',
      email: 'employee@company.com',
      role: '员工',
      status: '禁用',
      createTime: DateTime.now().subtract(const Duration(days: 7)),
      lastLogin: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
  
  String _searchText = '';
  String _selectedRole = '全部';
  String _selectedStatus = '全部';
  
  List<UserModel> get _filteredUsers {
    return _users.where((user) {
      final matchesSearch = user.name.toLowerCase().contains(_searchText.toLowerCase()) ||
                           user.username.toLowerCase().contains(_searchText.toLowerCase()) ||
                           user.email.toLowerCase().contains(_searchText.toLowerCase());
      final matchesRole = _selectedRole == '全部' || user.role == _selectedRole;
      final matchesStatus = _selectedStatus == '全部' || user.status == _selectedStatus;
      
      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 页面标题
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '用户管理',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '管理系统用户账户和权限',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: _showAddUserDialog,
              icon: const Icon(Icons.add),
              label: const Text('添加用户'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // 搜索和筛选区域
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 搜索框
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: '搜索用户名、姓名或邮箱',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                
                // 角色筛选
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: const InputDecoration(
                      labelText: '角色',
                      border: OutlineInputBorder(),
                    ),
                    items: ['全部', '管理员', '经理', '员工']
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                
                // 状态筛选
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: '状态',
                      border: OutlineInputBorder(),
                    ),
                    items: ['全部', '启用', '禁用']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // 用户列表
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '用户列表 (${_filteredUsers.length})',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 800,
                      columns: const [
                        DataColumn2(
                          label: Text('用户名'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('姓名'),
                          size: ColumnSize.M,
                        ),
                        DataColumn2(
                          label: Text('邮箱'),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text('角色'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('状态'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('最后登录'),
                          size: ColumnSize.M,
                        ),
                        DataColumn2(
                          label: Text('操作'),
                          size: ColumnSize.M,
                        ),
                      ],
                      rows: _filteredUsers.map((user) {
                        return DataRow2(
                          cells: [
                            DataCell(Text(user.username)),
                            DataCell(Text(user.name)),
                            DataCell(Text(user.email)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getRoleColor(user.role).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user.role,
                                  style: TextStyle(
                                    color: _getRoleColor(user.role),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: user.status == '启用'
                                      ? AppTheme.successGreen.withOpacity(0.1)
                                      : AppTheme.errorRed.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user.status,
                                  style: TextStyle(
                                    color: user.status == '启用'
                                        ? AppTheme.successGreen
                                        : AppTheme.errorRed,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                _formatDateTime(user.lastLogin),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => _showEditUserDialog(user),
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                    ),
                                    tooltip: '编辑',
                                  ),
                                  IconButton(
                                    onPressed: () => _toggleUserStatus(user),
                                    icon: Icon(
                                      user.status == '启用'
                                          ? Icons.block
                                          : Icons.check_circle_outline,
                                      size: 18,
                                      color: user.status == '启用'
                                          ? AppTheme.errorRed
                                          : AppTheme.successGreen,
                                    ),
                                    tooltip: user.status == '启用' ? '禁用' : '启用',
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteUser(user),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                      color: AppTheme.errorRed,
                                    ),
                                    tooltip: '删除',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Color _getRoleColor(String role) {
    switch (role) {
      case '管理员':
        return AppTheme.errorRed;
      case '经理':
        return AppTheme.warningYellow;
      case '员工':
        return AppTheme.primaryBlue;
      default:
        return AppColors.textSecondary;
    }
  }
  
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
  
  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => _UserDialog(
        title: '添加用户',
        onSave: (user) {
          setState(() {
            _users.add(user.copyWith(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              createTime: DateTime.now(),
              lastLogin: DateTime.now(),
            ));
          });
        },
      ),
    );
  }
  
  void _showEditUserDialog(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => _UserDialog(
        title: '编辑用户',
        user: user,
        onSave: (updatedUser) {
          setState(() {
            final index = _users.indexWhere((u) => u.id == user.id);
            if (index != -1) {
              _users[index] = updatedUser;
            }
          });
        },
      ),
    );
  }
  
  void _toggleUserStatus(UserModel user) {
    setState(() {
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user.copyWith(
          status: user.status == '启用' ? '禁用' : '启用',
        );
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('用户 ${user.name} 已${user.status == '启用' ? '禁用' : '启用'}'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }
  
  void _deleteUser(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除用户 "${user.name}" 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _users.removeWhere((u) => u.id == user.id);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('用户 ${user.name} 已删除'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}

class _UserDialog extends StatefulWidget {
  final String title;
  final UserModel? user;
  final Function(UserModel) onSave;
  
  const _UserDialog({
    required this.title,
    this.user,
    required this.onSave,
  });

  @override
  State<_UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<_UserDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late String _selectedRole;
  late String _selectedStatus;
  
  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user?.username ?? '');
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _passwordController = TextEditingController();
    _selectedRole = widget.user?.role ?? '员工';
    _selectedStatus = widget.user?.status ?? '启用';
  }
  
  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModernDialog(
      title: widget.title,
      titleIcon: widget.user == null ? Icons.person_add : Icons.edit,
      width: 500,
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            ModernFormField(
              controller: _usernameController,
              label: '用户名',
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入用户名';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ModernFormField(
              controller: _nameController,
              label: '姓名',
              prefixIcon: Icons.badge,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入姓名';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ModernFormField(
              controller: _emailController,
              label: '邮箱',
              prefixIcon: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入邮箱';
                }
                if (!value.contains('@')) {
                  return '请输入有效的邮箱地址';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            if (widget.user == null) ...[
              ModernFormField(
                controller: _passwordController,
                label: '密码',
                prefixIcon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入密码';
                  }
                  if (value.length < 6) {
                    return '密码长度至少6位';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
            ],
            Row(
              children: [
                Expanded(
                  child: ModernDropdown<String>(
                    value: _selectedRole,
                    label: '角色',
                    prefixIcon: Icons.admin_panel_settings,
                    items: ['管理员', '经理', '员工'],
                    itemBuilder: (role) => role,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ModernDropdown<String>(
                    value: _selectedStatus,
                    label: '状态',
                    prefixIcon: Icons.toggle_on,
                    items: ['启用', '禁用'],
                    itemBuilder: (status) => status,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
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
          icon: Icons.save,
          onPressed: _saveUser,
        ),
      ],
    );
  }
  
  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        id: widget.user?.id ?? '',
        username: _usernameController.text,
        name: _nameController.text,
        email: _emailController.text,
        role: _selectedRole,
        status: _selectedStatus,
        createTime: widget.user?.createTime ?? DateTime.now(),
        lastLogin: widget.user?.lastLogin ?? DateTime.now(),
      );
      
      widget.onSave(user);
      Navigator.of(context).pop();
    }
  }
}