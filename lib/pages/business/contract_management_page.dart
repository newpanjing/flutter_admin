import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_dialog.dart';

class ContractManagementPage extends StatefulWidget {
  const ContractManagementPage({super.key});

  @override
  State<ContractManagementPage> createState() => _ContractManagementPageState();
}

class _ContractManagementPageState extends State<ContractManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = '全部';
  String _selectedType = '全部';
  
  // 合同数据
  final List<ContractModel> _contracts = [
    ContractModel(
      id: 'CON001',
      title: '产品销售合同',
      customerName: '北京科技有限公司',
      contractAmount: 150000.0,
      status: '执行中',
      type: '销售合同',
      signDate: DateTime.now().subtract(const Duration(days: 30)),
      startDate: DateTime.now().subtract(const Duration(days: 25)),
      endDate: DateTime.now().add(const Duration(days: 335)),
      description: '年度产品销售合作协议',
      attachments: ['合同正本.pdf', '附件清单.xlsx'],
    ),
    ContractModel(
      id: 'CON002',
      title: '设备采购合同',
      customerName: '上海设备供应商',
      contractAmount: 280000.0,
      status: '待签署',
      type: '采购合同',
      signDate: null,
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 97)),
      description: '生产设备采购协议',
      attachments: ['合同草案.pdf'],
    ),
    ContractModel(
      id: 'CON003',
      title: '技术服务合同',
      customerName: '广州技术公司',
      contractAmount: 120000.0,
      status: '已完成',
      type: '服务合同',
      signDate: DateTime.now().subtract(const Duration(days: 180)),
      startDate: DateTime.now().subtract(const Duration(days: 175)),
      endDate: DateTime.now().subtract(const Duration(days: 5)),
      description: '系统开发与维护服务',
      attachments: ['服务合同.pdf', '验收报告.pdf'],
    ),
    ContractModel(
      id: 'CON004',
      title: '租赁合同',
      customerName: '深圳物业管理公司',
      contractAmount: 240000.0,
      status: '即将到期',
      type: '租赁合同',
      signDate: DateTime.now().subtract(const Duration(days: 350)),
      startDate: DateTime.now().subtract(const Duration(days: 345)),
      endDate: DateTime.now().add(const Duration(days: 15)),
      description: '办公场地租赁协议',
      attachments: ['租赁合同.pdf', '物业清单.xlsx'],
    ),
  ];

  List<ContractModel> get _filteredContracts {
    return _contracts.where((contract) {
      final matchesSearch = contract.id.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          contract.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          contract.customerName.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesStatus = _selectedStatus == '全部' || contract.status == _selectedStatus;
      final matchesType = _selectedType == '全部' || contract.type == _selectedType;
      return matchesSearch && matchesStatus && matchesType;
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
                    '合同管理',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '管理各类业务合同和协议',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildStatCard('总合同', '${_contracts.length}', AppTheme.successGreen),
                  const SizedBox(width: 16),
                  _buildStatCard('执行中', '${_contracts.where((c) => c.status == '执行中').length}', AppTheme.primaryBlue),
                  const SizedBox(width: 16),
                  _buildStatCard('即将到期', '${_contracts.where((c) => c.status == '即将到期').length}', AppTheme.warningYellow),
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
                            hintText: '搜索合同编号、标题或客户名称...',
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
                          labelText: '合同状态',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: ['全部', '待签署', '执行中', '已完成', '已终止', '即将到期']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedStatus = value!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // 类型筛选
                    SizedBox(
                      width: 120,
                      child: DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          labelText: '合同类型',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: ['全部', '销售合同', '采购合同', '服务合同', '租赁合同']
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedType = value!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // 新增按钮
                    ModernButton(
                      text: '新增合同',
                      icon: Icons.add,
                      onPressed: () => _showAddContractDialog(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // 合同列表
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '合同列表 (${_filteredContracts.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 1200,
                      columns: const [
                        DataColumn2(
                          label: Text('合同编号'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('合同标题'),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text('客户名称'),
                          size: ColumnSize.M,
                        ),
                        DataColumn2(
                          label: Text('合同金额'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('合同状态'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('签署日期'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('到期日期'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('操作'),
                          size: ColumnSize.M,
                        ),
                      ],
                      rows: _filteredContracts.map((contract) {
                        return DataRow2(
                          cells: [
                            DataCell(
                              Text(
                                contract.id,
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
                                    contract.title,
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    contract.type,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(contract.customerName),
                            ),
                            DataCell(
                              Text(
                                '¥${contract.contractAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.successGreen,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(contract.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  contract.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _getStatusColor(contract.status),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                contract.signDate != null
                                    ? '${contract.signDate!.month}/${contract.signDate!.day}'
                                    : '未签署',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: contract.signDate != null 
                                      ? AppColors.textSecondary
                                      : Colors.red,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${contract.endDate.month}/${contract.endDate.day}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: contract.endDate.isBefore(DateTime.now().add(const Duration(days: 30)))
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
                                    onPressed: () => _showContractDetails(contract),
                                    tooltip: '查看详情',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () => _showEditContractDialog(contract),
                                    tooltip: '编辑',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                    onPressed: () => _showDeleteConfirmDialog(contract),
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
      case '待签署':
        return AppTheme.warningYellow;
      case '执行中':
        return AppTheme.primaryBlue;
      case '已完成':
        return AppTheme.successGreen;
      case '已终止':
        return Colors.red;
      case '即将到期':
        return Colors.orange;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showAddContractDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddContractDialog(),
    );
  }

  void _showEditContractDialog(ContractModel contract) {
    showDialog(
      context: context,
      builder: (context) => EditContractDialog(contract: contract),
    );
  }

  void _showContractDetails(ContractModel contract) {
    showDialog(
      context: context,
      builder: (context) => ContractDetailsDialog(contract: contract),
    );
  }

  void _showDeleteConfirmDialog(ContractModel contract) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除合同 ${contract.id} 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _contracts.remove(contract);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('合同删除成功')),
              );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// 合同数据模型
class ContractModel {
  final String id;
  final String title;
  final String customerName;
  final double contractAmount;
  final String status;
  final String type;
  final DateTime? signDate;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final List<String> attachments;

  ContractModel({
    required this.id,
    required this.title,
    required this.customerName,
    required this.contractAmount,
    required this.status,
    required this.type,
    required this.signDate,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.attachments,
  });
}

// 新增合同对话框
class AddContractDialog extends StatefulWidget {
  const AddContractDialog({super.key});

  @override
  State<AddContractDialog> createState() => _AddContractDialogState();
}

class _AddContractDialogState extends State<AddContractDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _contractAmountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = '销售合同';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));

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
                  Icon(Icons.description, color: AppTheme.successGreen),
                  const SizedBox(width: 12),
                  const Text(
                    '新增合同',
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
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: '合同标题',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '请输入合同标题';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _customerNameController,
                              decoration: const InputDecoration(
                                labelText: '客户名称',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return '请输入客户名称';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedType,
                              decoration: const InputDecoration(
                                labelText: '合同类型',
                                border: OutlineInputBorder(),
                              ),
                              items: ['销售合同', '采购合同', '服务合同', '租赁合同']
                                  .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedType = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _contractAmountController,
                        decoration: const InputDecoration(
                          labelText: '合同金额',
                          border: OutlineInputBorder(),
                          prefixText: '¥ ',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '请输入合同金额';
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
                                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
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
                                  lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
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
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: '合同描述',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
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
        const SnackBar(content: Text('合同创建成功')),
      );
    }
  }
}

// 编辑合同对话框
class EditContractDialog extends StatefulWidget {
  final ContractModel contract;
  
  const EditContractDialog({super.key, required this.contract});

  @override
  State<EditContractDialog> createState() => _EditContractDialogState();
}

class _EditContractDialogState extends State<EditContractDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _customerNameController;
  late TextEditingController _contractAmountController;
  late TextEditingController _descriptionController;
  late String _selectedStatus;
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.contract.title);
    _customerNameController = TextEditingController(text: widget.contract.customerName);
    _contractAmountController = TextEditingController(text: widget.contract.contractAmount.toString());
    _descriptionController = TextEditingController(text: widget.contract.description);
    _selectedStatus = widget.contract.status;
    _selectedType = widget.contract.type;
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
                    '编辑合同 - ${widget.contract.id}',
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
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: '合同标题',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _customerNameController,
                              decoration: const InputDecoration(
                                labelText: '客户名称',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedType,
                              decoration: const InputDecoration(
                                labelText: '合同类型',
                                border: OutlineInputBorder(),
                              ),
                              items: ['销售合同', '采购合同', '服务合同', '租赁合同']
                                  .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedType = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _contractAmountController,
                              decoration: const InputDecoration(
                                labelText: '合同金额',
                                border: OutlineInputBorder(),
                                prefixText: '¥ ',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: '合同状态',
                                border: OutlineInputBorder(),
                              ),
                              items: ['待签署', '执行中', '已完成', '已终止', '即将到期']
                                  .map((status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(status),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedStatus = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: '合同描述',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
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
                        const SnackBar(content: Text('合同更新成功')),
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

// 合同详情对话框
class ContractDetailsDialog extends StatelessWidget {
  final ContractModel contract;
  
  const ContractDetailsDialog({super.key, required this.contract});

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
                  Icon(Icons.description, color: AppTheme.successGreen),
                  const SizedBox(width: 12),
                  Text(
                    '合同详情 - ${contract.id}',
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
                      _buildInfoRow('合同编号', contract.id),
                      _buildInfoRow('合同标题', contract.title),
                      _buildInfoRow('合同类型', contract.type),
                      _buildInfoRow('合同状态', contract.status),
                      _buildInfoRow('合同金额', '¥${contract.contractAmount.toStringAsFixed(2)}'),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    // 客户信息
                    _buildInfoSection('客户信息', [
                      _buildInfoRow('客户名称', contract.customerName),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    // 时间信息
                    _buildInfoSection('时间信息', [
                      _buildInfoRow('签署日期', contract.signDate != null 
                          ? '${contract.signDate!.year}-${contract.signDate!.month.toString().padLeft(2, '0')}-${contract.signDate!.day.toString().padLeft(2, '0')}'
                          : '未签署'),
                      _buildInfoRow('开始日期', '${contract.startDate.year}-${contract.startDate.month.toString().padLeft(2, '0')}-${contract.startDate.day.toString().padLeft(2, '0')}'),
                      _buildInfoRow('结束日期', '${contract.endDate.year}-${contract.endDate.month.toString().padLeft(2, '0')}-${contract.endDate.day.toString().padLeft(2, '0')}'),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    // 合同描述
                    _buildInfoSection('合同描述', [
                      _buildInfoRow('描述', contract.description),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    // 附件信息
                    const Text(
                      '附件信息',
                      style: TextStyle(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: contract.attachments.map((attachment) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.attach_file, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 8),
                              Text(attachment),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('下载 $attachment')),
                                  );
                                },
                                child: const Text('下载'),
                              ),
                            ],
                          ),
                        )).toList(),
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