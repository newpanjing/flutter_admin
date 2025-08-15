import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_dialog.dart';

class IncomeExpensePage extends StatefulWidget {
  const IncomeExpensePage({super.key});

  @override
  State<IncomeExpensePage> createState() => _IncomeExpensePageState();
}

class _IncomeExpensePageState extends State<IncomeExpensePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = '全部';
  String _selectedCategory = '全部';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  
  // 收支记录数据
  final List<IncomeExpenseModel> _records = [
    IncomeExpenseModel(
      id: 'IE001',
      type: '收入',
      category: '销售收入',
      amount: 50000.0,
      description: '产品销售收入',
      date: DateTime.now().subtract(const Duration(days: 1)),
      relatedOrder: 'ORD001',
      paymentMethod: '银行转账',
      status: '已确认',
    ),
    IncomeExpenseModel(
      id: 'IE002',
      type: '支出',
      category: '办公费用',
      amount: 3500.0,
      description: '办公用品采购',
      date: DateTime.now().subtract(const Duration(days: 2)),
      relatedOrder: 'PUR001',
      paymentMethod: '公司卡',
      status: '已支付',
    ),
    IncomeExpenseModel(
      id: 'IE003',
      type: '收入',
      category: '服务收入',
      amount: 25000.0,
      description: '技术服务费',
      date: DateTime.now().subtract(const Duration(days: 3)),
      relatedOrder: 'SRV001',
      paymentMethod: '支付宝',
      status: '已确认',
    ),
    IncomeExpenseModel(
      id: 'IE004',
      type: '支出',
      category: '人员工资',
      amount: 120000.0,
      description: '员工月度工资',
      date: DateTime.now().subtract(const Duration(days: 5)),
      relatedOrder: '',
      paymentMethod: '银行转账',
      status: '已支付',
    ),
    IncomeExpenseModel(
      id: 'IE005',
      type: '支出',
      category: '营销费用',
      amount: 8000.0,
      description: '广告投放费用',
      date: DateTime.now().subtract(const Duration(days: 7)),
      relatedOrder: 'AD001',
      paymentMethod: '微信支付',
      status: '待审核',
    ),
  ];

  List<IncomeExpenseModel> get _filteredRecords {
    return _records.where((record) {
      final matchesSearch = record.id.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          record.description.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          record.category.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesType = _selectedType == '全部' || record.type == _selectedType;
      final matchesCategory = _selectedCategory == '全部' || record.category == _selectedCategory;
      final matchesDate = record.date.isAfter(_startDate.subtract(const Duration(days: 1))) &&
          record.date.isBefore(_endDate.add(const Duration(days: 1)));
      return matchesSearch && matchesType && matchesCategory && matchesDate;
    }).toList();
  }

  double get _totalIncome {
    return _filteredRecords
        .where((record) => record.type == '收入')
        .fold(0.0, (sum, record) => sum + record.amount);
  }

  double get _totalExpense {
    return _filteredRecords
        .where((record) => record.type == '支出')
        .fold(0.0, (sum, record) => sum + record.amount);
  }

  double get _netIncome => _totalIncome - _totalExpense;

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
                    '收支管理',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '管理企业收入支出记录',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildStatCard('总收入', '¥${_totalIncome.toStringAsFixed(2)}', AppTheme.successGreen),
                  const SizedBox(width: 16),
                  _buildStatCard('总支出', '¥${_totalExpense.toStringAsFixed(2)}', Colors.red),
                  const SizedBox(width: 16),
                  _buildStatCard('净收入', '¥${_netIncome.toStringAsFixed(2)}', 
                      _netIncome >= 0 ? AppTheme.successGreen : Colors.red),
                  const SizedBox(width: 16),
                  _buildStatCard('记录数', '${_filteredRecords.length}', AppTheme.primaryBlue),
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
                            hintText: '搜索记录编号、描述或分类...',
                            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // 类型筛选
                    SizedBox(
                      width: 120,
                      child: DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          labelText: '收支类型',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: ['全部', '收入', '支出']
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedType = value!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // 分类筛选
                    SizedBox(
                      width: 120,
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: '分类',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: ['全部', '销售收入', '服务收入', '办公费用', '人员工资', '营销费用', '其他']
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedCategory = value!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // 日期筛选
                    InkWell(
                      onTap: _showDateRangePicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.date_range, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              '${_startDate.month}/${_startDate.day} - ${_endDate.month}/${_endDate.day}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // 新增按钮
                    ModernButton(
                      text: '新增记录',
                      icon: Icons.add,
                      onPressed: () => _showAddRecordDialog(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // 记录列表
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '收支记录 (${_filteredRecords.length})',
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
                          label: Text('记录编号'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('类型'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('分类'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('金额'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('描述'),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text('日期'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('支付方式'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('状态'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('操作'),
                          size: ColumnSize.M,
                        ),
                      ],
                      rows: _filteredRecords.map((record) {
                        return DataRow2(
                          cells: [
                            DataCell(
                              Text(
                                record.id,
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
                                  color: record.type == '收入' 
                                      ? AppTheme.successGreen.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  record.type,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: record.type == '收入' ? AppTheme.successGreen : Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(record.category),
                            ),
                            DataCell(
                              Text(
                                '¥${record.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: record.type == '收入' ? AppTheme.successGreen : Colors.red,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                record.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DataCell(
                              Text(
                                '${record.date.month}/${record.date.day}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                record.paymentMethod,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(record.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  record.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _getStatusColor(record.status),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility, size: 18),
                                    onPressed: () => _showRecordDetails(record),
                                    tooltip: '查看详情',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () => _showEditRecordDialog(record),
                                    tooltip: '编辑',
                                  ),
                                  if (record.status == '待审核')
                                    IconButton(
                                      icon: const Icon(Icons.check, size: 18, color: AppTheme.successGreen),
                                      onPressed: () => _approveRecord(record),
                                      tooltip: '审核通过',
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                    onPressed: () => _showDeleteConfirmDialog(record),
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
              fontSize: 16,
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
      case '已确认':
      case '已支付':
        return AppTheme.successGreen;
      case '待审核':
        return AppTheme.warningYellow;
      case '已拒绝':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _showAddRecordDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddIncomeExpenseDialog(),
    );
  }

  void _showEditRecordDialog(IncomeExpenseModel record) {
    showDialog(
      context: context,
      builder: (context) => EditIncomeExpenseDialog(record: record),
    );
  }

  void _showRecordDetails(IncomeExpenseModel record) {
    showDialog(
      context: context,
      builder: (context) => IncomeExpenseDetailsDialog(record: record),
    );
  }

  void _approveRecord(IncomeExpenseModel record) {
    setState(() {
      record.status = record.type == '收入' ? '已确认' : '已支付';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('记录审核通过')),
    );
  }

  void _showDeleteConfirmDialog(IncomeExpenseModel record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除记录 ${record.id} 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _records.remove(record);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('记录删除成功')),
              );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// 收支记录数据模型
class IncomeExpenseModel {
  final String id;
  final String type;
  final String category;
  final double amount;
  final String description;
  final DateTime date;
  final String relatedOrder;
  final String paymentMethod;
  String status;

  IncomeExpenseModel({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
    required this.relatedOrder,
    required this.paymentMethod,
    required this.status,
  });
}

// 新增收支记录对话框
class AddIncomeExpenseDialog extends StatefulWidget {
  const AddIncomeExpenseDialog({super.key});

  @override
  State<AddIncomeExpenseDialog> createState() => _AddIncomeExpenseDialogState();
}

class _AddIncomeExpenseDialogState extends State<AddIncomeExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _relatedOrderController = TextEditingController();
  String _selectedType = '收入';
  String _selectedCategory = '销售收入';
  String _selectedPaymentMethod = '银行转账';
  DateTime _selectedDate = DateTime.now();

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
                  Icon(Icons.account_balance_wallet, color: AppTheme.successGreen),
                  const SizedBox(width: 12),
                  const Text(
                    '新增收支记录',
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
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedType,
                              decoration: const InputDecoration(
                                labelText: '收支类型',
                                border: OutlineInputBorder(),
                              ),
                              items: ['收入', '支出']
                                  .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                  _selectedCategory = value == '收入' ? '销售收入' : '办公费用';
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              decoration: const InputDecoration(
                                labelText: '分类',
                                border: OutlineInputBorder(),
                              ),
                              items: (_selectedType == '收入' 
                                  ? ['销售收入', '服务收入', '其他收入']
                                  : ['办公费用', '人员工资', '营销费用', '其他支出'])
                                  .map((category) => DropdownMenuItem(
                                        value: category,
                                        child: Text(category),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedCategory = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          labelText: '金额',
                          border: OutlineInputBorder(),
                          prefixText: '¥ ',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '请输入金额';
                          }
                          if (double.tryParse(value!) == null) {
                            return '请输入有效的金额';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: '描述',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '请输入描述';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _relatedOrderController,
                              decoration: const InputDecoration(
                                labelText: '关联订单（可选）',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedPaymentMethod,
                              decoration: const InputDecoration(
                                labelText: '支付方式',
                                border: OutlineInputBorder(),
                              ),
                              items: ['银行转账', '支付宝', '微信支付', '公司卡', '现金']
                                  .map((method) => DropdownMenuItem(
                                        value: method,
                                        child: Text(method),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                          );
                          if (date != null) {
                            setState(() => _selectedDate = date);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: '日期',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                          ),
                        ),
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
        const SnackBar(content: Text('收支记录创建成功')),
      );
    }
  }
}

// 编辑收支记录对话框
class EditIncomeExpenseDialog extends StatefulWidget {
  final IncomeExpenseModel record;
  
  const EditIncomeExpenseDialog({super.key, required this.record});

  @override
  State<EditIncomeExpenseDialog> createState() => _EditIncomeExpenseDialogState();
}

class _EditIncomeExpenseDialogState extends State<EditIncomeExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _relatedOrderController;
  late String _selectedType;
  late String _selectedCategory;
  late String _selectedPaymentMethod;
  late String _selectedStatus;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.record.amount.toString());
    _descriptionController = TextEditingController(text: widget.record.description);
    _relatedOrderController = TextEditingController(text: widget.record.relatedOrder);
    _selectedType = widget.record.type;
    _selectedCategory = widget.record.category;
    _selectedPaymentMethod = widget.record.paymentMethod;
    _selectedStatus = widget.record.status;
    _selectedDate = widget.record.date;
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
                    '编辑记录 - ${widget.record.id}',
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
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedType,
                              decoration: const InputDecoration(
                                labelText: '收支类型',
                                border: OutlineInputBorder(),
                              ),
                              items: ['收入', '支出']
                                  .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedType = value!),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              decoration: const InputDecoration(
                                labelText: '分类',
                                border: OutlineInputBorder(),
                              ),
                              items: (_selectedType == '收入' 
                                  ? ['销售收入', '服务收入', '其他收入']
                                  : ['办公费用', '人员工资', '营销费用', '其他支出'])
                                  .map((category) => DropdownMenuItem(
                                        value: category,
                                        child: Text(category),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedCategory = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          labelText: '金额',
                          border: OutlineInputBorder(),
                          prefixText: '¥ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: '描述',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _relatedOrderController,
                              decoration: const InputDecoration(
                                labelText: '关联订单',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedPaymentMethod,
                              decoration: const InputDecoration(
                                labelText: '支付方式',
                                border: OutlineInputBorder(),
                              ),
                              items: ['银行转账', '支付宝', '微信支付', '公司卡', '现金']
                                  .map((method) => DropdownMenuItem(
                                        value: method,
                                        child: Text(method),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
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
                                labelText: '状态',
                                border: OutlineInputBorder(),
                              ),
                              items: ['待审核', '已确认', '已支付', '已拒绝']
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
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate,
                                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                  lastDate: DateTime.now().add(const Duration(days: 30)),
                                );
                                if (date != null) {
                                  setState(() => _selectedDate = date);
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: '日期',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
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
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('记录更新成功')),
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

// 收支记录详情对话框
class IncomeExpenseDetailsDialog extends StatelessWidget {
  final IncomeExpenseModel record;
  
  const IncomeExpenseDetailsDialog({super.key, required this.record});

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
                color: AppTheme.successGreen.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: AppTheme.successGreen),
                  const SizedBox(width: 12),
                  Text(
                    '记录详情 - ${record.id}',
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
                    _buildInfoSection('基本信息', [
                      _buildInfoRow('记录编号', record.id),
                      _buildInfoRow('收支类型', record.type),
                      _buildInfoRow('分类', record.category),
                      _buildInfoRow('金额', '¥${record.amount.toStringAsFixed(2)}'),
                      _buildInfoRow('状态', record.status),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    _buildInfoSection('详细信息', [
                      _buildInfoRow('描述', record.description),
                      _buildInfoRow('关联订单', record.relatedOrder.isEmpty ? '无' : record.relatedOrder),
                      _buildInfoRow('支付方式', record.paymentMethod),
                      _buildInfoRow('日期', '${record.date.year}-${record.date.month.toString().padLeft(2, '0')}-${record.date.day.toString().padLeft(2, '0')}'),
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