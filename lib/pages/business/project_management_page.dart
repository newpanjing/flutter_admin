import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_dialog.dart';

class ProjectManagementPage extends StatefulWidget {
  const ProjectManagementPage({super.key});

  @override
  State<ProjectManagementPage> createState() => _ProjectManagementPageState();
}

class _ProjectManagementPageState extends State<ProjectManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = '全部';
  String _selectedPriority = '全部';
  
  // 项目数据
  final List<ProjectModel> _projects = [
    ProjectModel(
      id: 'PRJ001',
      name: '电商平台开发',
      description: '构建现代化电商平台系统',
      status: '进行中',
      priority: '高',
      progress: 0.65,
      budget: 500000.0,
      spent: 325000.0,
      manager: '张经理',
      team: ['李开发', '王设计', '赵测试'],
      startDate: DateTime.now().subtract(const Duration(days: 45)),
      endDate: DateTime.now().add(const Duration(days: 25)),
      milestones: [
        Milestone('需求分析', true, DateTime.now().subtract(const Duration(days: 40))),
        Milestone('系统设计', true, DateTime.now().subtract(const Duration(days: 30))),
        Milestone('开发实现', false, DateTime.now().add(const Duration(days: 10))),
        Milestone('测试部署', false, DateTime.now().add(const Duration(days: 20))),
      ],
    ),
    ProjectModel(
      id: 'PRJ002',
      name: '移动应用开发',
      description: '企业级移动应用开发项目',
      status: '计划中',
      priority: '中',
      progress: 0.15,
      budget: 300000.0,
      spent: 45000.0,
      manager: '刘经理',
      team: ['陈开发', '周UI'],
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 97)),
      milestones: [
        Milestone('需求调研', true, DateTime.now().subtract(const Duration(days: 5))),
        Milestone('原型设计', false, DateTime.now().add(const Duration(days: 14))),
        Milestone('开发实现', false, DateTime.now().add(const Duration(days: 45))),
        Milestone('测试发布', false, DateTime.now().add(const Duration(days: 85))),
      ],
    ),
    ProjectModel(
      id: 'PRJ003',
      name: '数据分析系统',
      description: '企业数据分析与可视化系统',
      status: '已完成',
      priority: '高',
      progress: 1.0,
      budget: 400000.0,
      spent: 380000.0,
      manager: '王经理',
      team: ['孙开发', '钱分析师', '吴测试'],
      startDate: DateTime.now().subtract(const Duration(days: 120)),
      endDate: DateTime.now().subtract(const Duration(days: 10)),
      milestones: [
        Milestone('需求分析', true, DateTime.now().subtract(const Duration(days: 115))),
        Milestone('架构设计', true, DateTime.now().subtract(const Duration(days: 100))),
        Milestone('开发实现', true, DateTime.now().subtract(const Duration(days: 50))),
        Milestone('测试部署', true, DateTime.now().subtract(const Duration(days: 10))),
      ],
    ),
    ProjectModel(
      id: 'PRJ004',
      name: '系统升级改造',
      description: '现有系统架构升级与性能优化',
      status: '暂停',
      priority: '低',
      progress: 0.30,
      budget: 200000.0,
      spent: 60000.0,
      manager: '赵经理',
      team: ['郑开发', '冯运维'],
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      endDate: DateTime.now().add(const Duration(days: 40)),
      milestones: [
        Milestone('现状评估', true, DateTime.now().subtract(const Duration(days: 55))),
        Milestone('方案设计', true, DateTime.now().subtract(const Duration(days: 40))),
        Milestone('系统改造', false, DateTime.now().add(const Duration(days: 20))),
        Milestone('性能测试', false, DateTime.now().add(const Duration(days: 35))),
      ],
    ),
  ];

  List<ProjectModel> get _filteredProjects {
    return _projects.where((project) {
      final matchesSearch = project.id.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          project.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          project.manager.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesStatus = _selectedStatus == '全部' || project.status == _selectedStatus;
      final matchesPriority = _selectedPriority == '全部' || project.priority == _selectedPriority;
      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 页面标题和统计
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '项目管理',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '管理项目进度、资源和里程碑',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildStatCard('总项目', '${_projects.length}', AppTheme.successGreen),
                  const SizedBox(width: 16),
                  _buildStatCard('进行中', '${_projects.where((p) => p.status == '进行中').length}', AppTheme.primaryBlue),
                  const SizedBox(width: 16),
                  _buildStatCard('已完成', '${_projects.where((p) => p.status == '已完成').length}', AppTheme.successGreen),
                  const SizedBox(width: 16),
                  _buildStatCard('延期风险', '${_projects.where((p) => p.endDate.isBefore(DateTime.now()) && p.status != '已完成').length}', Colors.red),
                ],
              ),
            ],
          ),
        ),
        
        // 操作栏
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // 搜索框
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: '搜索项目编号、名称或项目经理...',
                            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // 状态筛选
                    SizedBox(
                      width: 120,
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: '项目状态',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: ['全部', '计划中', '进行中', '已完成', '暂停', '已取消']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedStatus = value!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // 优先级筛选
                    SizedBox(
                      width: 120,
                      child: DropdownButtonFormField<String>(
                        value: _selectedPriority,
                        decoration: const InputDecoration(
                          labelText: '优先级',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: ['全部', '高', '中', '低']
                            .map((priority) => DropdownMenuItem(
                                  value: priority,
                                  child: Text(priority),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedPriority = value!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // 新增按钮
                    ModernButton(
                      text: '新增项目',
                      icon: Icons.add,
                      onPressed: () => _showAddProjectDialog(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // 项目列表
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '项目列表 (${_filteredProjects.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 1400,
                      columns: const [
                        DataColumn2(
                          label: Text('项目编号'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('项目名称'),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text('项目经理'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('进度'),
                          size: ColumnSize.M,
                        ),
                        DataColumn2(
                          label: Text('预算/支出'),
                          size: ColumnSize.M,
                        ),
                        DataColumn2(
                          label: Text('状态'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('结束日期'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('操作'),
                          size: ColumnSize.M,
                        ),
                      ],
                      rows: _filteredProjects.map((project) {
                        return DataRow2(
                          cells: [
                            DataCell(
                              Text(
                                project.id,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.successGreen,
                                ),
                              ),
                            ),
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    project.name,
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '团队: ${project.team.length}人',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(project.manager),
                            ),
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${(project.progress * 100).toInt()}%',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 80,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: project.progress,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: _getProgressColor(project.progress),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '¥${project.budget.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    '¥${project.spent.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: project.spent > project.budget ? Colors.red : AppTheme.successGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(project.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  project.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _getStatusColor(project.status),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${project.endDate.month}/${project.endDate.day}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: project.endDate.isBefore(DateTime.now()) && project.status != '已完成'
                                      ? Colors.red
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility, size: 18),
                                    onPressed: () => _showProjectDetails(project),
                                    tooltip: '查看详情',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () => _showEditProjectDialog(project),
                                    tooltip: '编辑',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.timeline, size: 18, color: AppTheme.primaryBlue),
                                    onPressed: () => _showMilestonesDialog(project),
                                    tooltip: '里程碑',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                    onPressed: () => _showDeleteConfirmDialog(project),
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

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '计划中':
        return AppTheme.warningYellow;
      case '进行中':
        return AppTheme.primaryBlue;
      case '已完成':
        return AppTheme.successGreen;
      case '暂停':
        return Colors.orange;
      case '已取消':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.7) return AppTheme.warningYellow;
    return AppTheme.successGreen;
  }

  void _showAddProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddProjectDialog(),
    );
  }

  void _showEditProjectDialog(ProjectModel project) {
    showDialog(
      context: context,
      builder: (context) => EditProjectDialog(project: project),
    );
  }

  void _showProjectDetails(ProjectModel project) {
    showDialog(
      context: context,
      builder: (context) => ProjectDetailsDialog(project: project),
    );
  }

  void _showMilestonesDialog(ProjectModel project) {
    showDialog(
      context: context,
      builder: (context) => MilestonesDialog(project: project),
    );
  }

  void _showDeleteConfirmDialog(ProjectModel project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除项目 ${project.id} 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _projects.remove(project);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('项目删除成功')),
              );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// 项目数据模型
class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String status;
  final String priority;
  final double progress;
  final double budget;
  final double spent;
  final String manager;
  final List<String> team;
  final DateTime startDate;
  final DateTime endDate;
  final List<Milestone> milestones;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.priority,
    required this.progress,
    required this.budget,
    required this.spent,
    required this.manager,
    required this.team,
    required this.startDate,
    required this.endDate,
    required this.milestones,
  });
}

// 里程碑数据模型
class Milestone {
  final String name;
  final bool completed;
  final DateTime date;

  Milestone(this.name, this.completed, this.date);
}

// 新增项目对话框
class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({super.key});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _managerController = TextEditingController();
  String _selectedPriority = '中';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 90));

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.work, color: AppTheme.successGreen),
                  const SizedBox(width: 12),
                  const Text(
                    '新增项目',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // 表单内容
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: '项目名称',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '请输入项目名称';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: '项目描述',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _managerController,
                              decoration: const InputDecoration(
                                labelText: '项目经理',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return '请输入项目经理';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedPriority,
                              decoration: const InputDecoration(
                                labelText: '优先级',
                                border: OutlineInputBorder(),
                              ),
                              items: ['高', '中', '低']
                                  .map((priority) => DropdownMenuItem(
                                        value: priority,
                                        child: Text(priority),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedPriority = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _budgetController,
                        decoration: const InputDecoration(
                          labelText: '项目预算',
                          border: OutlineInputBorder(),
                          prefixText: '¥ ',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '请输入项目预算';
                          }
                          if (double.tryParse(value!) == null) {
                            return '请输入有效的金额';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _startDate,
                                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                                );
                                if (date != null) {
                                  setState(() => _startDate = date);
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: '开始日期',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  '${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')}',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _endDate,
                                  firstDate: _startDate,
                                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                                );
                                if (date != null) {
                                  setState(() => _endDate = date);
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: '结束日期',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  '${_endDate.year}-${_endDate.month.toString().padLeft(2, '0')}-${_endDate.day.toString().padLeft(2, '0')}',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // 按钮栏
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('保存'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('项目创建成功')),
      );
    }
  }
}

// 编辑项目对话框
class EditProjectDialog extends StatefulWidget {
  final ProjectModel project;
  
  const EditProjectDialog({super.key, required this.project});

  @override
  State<EditProjectDialog> createState() => _EditProjectDialogState();
}

class _EditProjectDialogState extends State<EditProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _budgetController;
  late TextEditingController _spentController;
  late TextEditingController _managerController;
  late String _selectedStatus;
  late String _selectedPriority;
  late double _progress;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.name);
    _descriptionController = TextEditingController(text: widget.project.description);
    _budgetController = TextEditingController(text: widget.project.budget.toString());
    _spentController = TextEditingController(text: widget.project.spent.toString());
    _managerController = TextEditingController(text: widget.project.manager);
    _selectedStatus = widget.project.status;
    _selectedPriority = widget.project.priority;
    _progress = widget.project.progress;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit, color: AppTheme.primaryBlue),
                  const SizedBox(width: 12),
                  Text(
                    '编辑项目 - ${widget.project.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // 表单内容
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: '项目名称',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: '项目描述',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _managerController,
                              decoration: const InputDecoration(
                                labelText: '项目经理',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedPriority,
                              decoration: const InputDecoration(
                                labelText: '优先级',
                                border: OutlineInputBorder(),
                              ),
                              items: ['高', '中', '低']
                                  .map((priority) => DropdownMenuItem(
                                        value: priority,
                                        child: Text(priority),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedPriority = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _budgetController,
                              decoration: const InputDecoration(
                                labelText: '项目预算',
                                border: OutlineInputBorder(),
                                prefixText: '¥ ',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _spentController,
                              decoration: const InputDecoration(
                                labelText: '已支出',
                                border: OutlineInputBorder(),
                                prefixText: '¥ ',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: '项目状态',
                                border: OutlineInputBorder(),
                              ),
                              items: ['计划中', '进行中', '已完成', '暂停', '已取消']
                                  .map((status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(status),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedStatus = value!),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '项目进度: ${(_progress * 100).toInt()}%',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Slider(
                                  value: _progress,
                                  onChanged: (value) => setState(() => _progress = value),
                                  divisions: 20,
                                  label: '${(_progress * 100).toInt()}%',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // 按钮栏
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('项目更新成功')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('保存'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 项目详情对话框
class ProjectDetailsDialog extends StatelessWidget {
  final ProjectModel project;
  
  const ProjectDetailsDialog({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 700,
        constraints: const BoxConstraints(maxHeight: 800),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.work, color: AppTheme.successGreen),
                  const SizedBox(width: 12),
                  Text(
                    '项目详情 - ${project.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // 详情内容
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 基本信息
                    _buildInfoSection('基本信息', [
                      _buildInfoRow('项目编号', project.id),
                      _buildInfoRow('项目名称', project.name),
                      _buildInfoRow('项目描述', project.description),
                      _buildInfoRow('项目状态', project.status),
                      _buildInfoRow('优先级', project.priority),
                      _buildInfoRow('项目进度', '${(project.progress * 100).toInt()}%'),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    // 团队信息
                    _buildInfoSection('团队信息', [
                      _buildInfoRow('项目经理', project.manager),
                      _buildInfoRow('团队成员', project.team.join(', ')),
                      _buildInfoRow('团队规模', '${project.team.length}人'),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    // 财务信息
                    _buildInfoSection('财务信息', [
                      _buildInfoRow('项目预算', '¥${project.budget.toStringAsFixed(2)}'),
                      _buildInfoRow('已支出', '¥${project.spent.toStringAsFixed(2)}'),
                      _buildInfoRow('剩余预算', '¥${(project.budget - project.spent).toStringAsFixed(2)}'),
                      _buildInfoRow('预算使用率', '${((project.spent / project.budget) * 100).toInt()}%'),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    // 时间信息
                    _buildInfoSection('时间信息', [
                      _buildInfoRow('开始日期', '${project.startDate.year}-${project.startDate.month.toString().padLeft(2, '0')}-${project.startDate.day.toString().padLeft(2, '0')}'),
                      _buildInfoRow('结束日期', '${project.endDate.year}-${project.endDate.month.toString().padLeft(2, '0')}-${project.endDate.day.toString().padLeft(2, '0')}'),
                      _buildInfoRow('项目周期', '${project.endDate.difference(project.startDate).inDays}天'),
                      _buildInfoRow('剩余天数', project.endDate.isAfter(DateTime.now()) 
                          ? '${project.endDate.difference(DateTime.now()).inDays}天'
                          : '已过期'),
                    ]),
                  ],
                ),
              ),
            ),
            
            // 按钮栏
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('关闭'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 里程碑对话框
class MilestonesDialog extends StatelessWidget {
  final ProjectModel project;
  
  const MilestonesDialog({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.timeline, color: AppTheme.primaryBlue),
                  const SizedBox(width: 12),
                  Text(
                    '项目里程碑 - ${project.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // 里程碑列表
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '项目里程碑',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: project.milestones.length,
                        itemBuilder: (context, index) {
                          final milestone = project.milestones[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: milestone.completed 
                                  ? AppTheme.successGreen.withOpacity(0.1)
                                  : const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: milestone.completed 
                                    ? AppTheme.successGreen.withOpacity(0.3)
                                    : AppColors.borderColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  milestone.completed 
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: milestone.completed 
                                      ? AppTheme.successGreen
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        milestone.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: milestone.completed 
                                              ? AppColors.textPrimary
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${milestone.date.month}/${milestone.date.day}/${milestone.date.year}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (milestone.completed)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.successGreen,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      '已完成',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 按钮栏
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('关闭'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}