import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_dialog.dart';

class InvoiceManagementPage extends StatefulWidget {
  const InvoiceManagementPage({super.key});

  @override
  State<InvoiceManagementPage> createState() => _InvoiceManagementPageState();
}

class _InvoiceManagementPageState extends State<InvoiceManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = '全部';
  String _selectedStatus = '全部';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  
  // 发票数据
  final List<InvoiceModel> _invoices = [
    InvoiceModel(
      id: 'INV001',
      type: '销售发票',
      customerName: '北京科技有限公司',
      amount: 50000.0,
      taxAmount: 6500.0,
      totalAmount: 56500.0,
      issueDate: DateTime.now().subtract(const Duration(days: 1)),
      dueDate: DateTime.now().add(const Duration(days: 29)),
      status: '已开具',
      description: '软件开发服务费',
      invoiceNumber: '20240101001',
      taxRate: 0.13,
    ),
    InvoiceModel(
      id: 'INV002',
      type: '采购发票',
      customerName: '上海设备供应商',
      amount: 25000.0,
      taxAmount: 3250.0,
      totalAmount: 28250.0,
      issueDate: DateTime.now().subtract(const Duration(days: 3)),
      dueDate: DateTime.now().add(const Duration(days: 27)),
      status: '已收票',
      description: '办公设备采购',
      invoiceNumber: '20240101002',
      taxRate: 0.13,
    ),
    InvoiceModel(
      id: 'INV003',
      type: '销售发票',
      customerName: '深圳创新企业',
      amount: 80000.0,
      taxAmount: 10400.0,
      totalAmount: 90400.0,
      issueDate: DateTime.now().subtract(const Duration(days: 5)),
      dueDate: DateTime.now().add(const Duration(days: 25)),
      status: '待开具',
      description: '系统集成项目',
      invoiceNumber: '',
      taxRate: 0.13,
    ),
    InvoiceModel(
      id: 'INV004',
      type: '费用发票',
      customerName: '广州物流公司',
      amount: 5000.0,
      taxAmount: 300.0,
      totalAmount: 5300.0,
      issueDate: DateTime.now().subtract(const Duration(days: 7)),
      dueDate: DateTime.now().add(const Duration(days: 23)),
      status: '已作废',
      description: '运输服务费',
      invoiceNumber: '20240101003',
      taxRate: 0.06,
    ),
    InvoiceModel(
      id: 'INV005',
      type: '销售发票',
      customerName: '杭州电商平台',
      amount: 120000.0,
      taxAmount: 15600.0,
      totalAmount: 135600.0,
      issueDate: DateTime.now().subtract(const Duration(days: 10)),
      dueDate: DateTime.now().add(const Duration(days: 20)),
      status: '已开具',
      description: '电商系统开发',
      invoiceNumber: '20240101004',
      taxRate: 0.13,
    ),
  ];

  List<InvoiceModel> get _filteredInvoices {
    return _invoices.where((invoice) {
      final matchesSearch = invoice.id.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          invoice.customerName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          invoice.description.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          invoice.invoiceNumber.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesType = _selectedType == '全部' || invoice.type == _selectedType;
      final matchesStatus = _selectedStatus == '全部' || invoice.status == _selectedStatus;
      final matchesDate = invoice.issueDate.isAfter(_startDate.subtract(const Duration(days: 1))) &&
          invoice.issueDate.isBefore(_endDate.add(const Duration(days: 1)));
      return matchesSearch && matchesType && matchesStatus && matchesDate;
    }).toList();
  }

  double get _totalAmount {
    return _filteredInvoices.fold(0.0, (sum, invoice) => sum + invoice.totalAmount);
  }

  double get _totalTax {
    return _filteredInvoices.fold(0.0, (sum, invoice) => sum + invoice.taxAmount);
  }

  int get _pendingCount {
    return _filteredInvoices.where((invoice) => invoice.status == '待开具').length;
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
                    '发票管理',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '管理销售发票、采购发票和费用发票',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildStatCard('总金额', '¥${_totalAmount.toStringAsFixed(2)}', AppTheme.successGreen),
                  const SizedBox(width: 16),
                  _buildStatCard('税额', '¥${_totalTax.toStringAsFixed(2)}', AppTheme.primaryBlue),
                  const SizedBox(width: 16),
                  _buildStatCard('待开具', '$_pendingCount', AppTheme.warningYellow),
                  const SizedBox(width: 16),
                  _buildStatCard('发票数', '${_filteredInvoices.length}', AppTheme.primaryBlue),
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
                            hintText: '搜索发票编号、客户名称或描述...',
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
                          labelText: '发票类型',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: ['全部', '销售发票', '采购发票', '费用发票']
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedType = value!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // 状态筛选
                    SizedBox(
                      width: 120,
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: '状态',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: ['全部', '待开具', '已开具', '已收票', '已作废']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedStatus = value!),
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
                      text: '新增发票',
                      icon: Icons.add,
                      onPressed: () => _showAddInvoiceDialog(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // 发票列表
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '发票列表 (${_filteredInvoices.length})',
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
                          label: Text('发票编号'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('类型'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('客户名称'),
                          size: ColumnSize.M,
                        ),
                        DataColumn2(
                          label: Text('金额'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('税额'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('总金额'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('开票日期'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('到期日期'),
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
                      rows: _filteredInvoices.map((invoice) {
                        return DataRow2(
                          cells: [
                            DataCell(
                              Text(
                                invoice.invoiceNumber.isEmpty ? invoice.id : invoice.invoiceNumber,
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
                                  color: _getTypeColor(invoice.type).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  invoice.type,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _getTypeColor(invoice.type),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                invoice.customerName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DataCell(
                              Text(
                                '¥${invoice.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '¥${invoice.taxAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '¥${invoice.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.successGreen,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${invoice.issueDate.month}/${invoice.issueDate.day}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${invoice.dueDate.month}/${invoice.dueDate.day}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(invoice.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  invoice.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _getStatusColor(invoice.status),
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
                                    onPressed: () => _showInvoiceDetails(invoice),
                                    tooltip: '查看详情',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () => _showEditInvoiceDialog(invoice),
                                    tooltip: '编辑',
                                  ),
                                  if (invoice.status == '待开具')
                                    IconButton(
                                      icon: const Icon(Icons.receipt, size: 18, color: AppTheme.successGreen),
                                      onPressed: () => _issueInvoice(invoice),
                                      tooltip: '开具发票',
                                    ),
                                  if (invoice.status == '已开具')
                                    IconButton(
                                      icon: const Icon(Icons.print, size: 18, color: AppTheme.primaryBlue),
                                      onPressed: () => _printInvoice(invoice),
                                      tooltip: '打印发票',
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                    onPressed: () => _showDeleteConfirmDialog(invoice),
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

  Color _getTypeColor(String type) {
    switch (type) {
      case '销售发票':
        return AppTheme.successGreen;
      case '采购发票':
        return AppTheme.primaryBlue;
      case '费用发票':
        return AppTheme.warningYellow;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '已开具':
      case '已收票':
        return AppTheme.successGreen;
      case '待开具':
        return AppTheme.warningYellow;
      case '已作废':
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

  void _showAddInvoiceDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddInvoiceDialog(),
    );
  }

  void _showEditInvoiceDialog(InvoiceModel invoice) {
    showDialog(
      context: context,
      builder: (context) => EditInvoiceDialog(invoice: invoice),
    );
  }

  void _showInvoiceDetails(InvoiceModel invoice) {
    showDialog(
      context: context,
      builder: (context) => InvoiceDetailsDialog(invoice: invoice),
    );
  }

  void _issueInvoice(InvoiceModel invoice) {
    setState(() {
      invoice.status = '已开具';
      invoice.invoiceNumber = 'INV${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('发票开具成功')),
    );
  }

  void _printInvoice(InvoiceModel invoice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('正在打印发票 ${invoice.invoiceNumber}')),
    );
  }

  void _showDeleteConfirmDialog(InvoiceModel invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除发票 ${invoice.id} 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _invoices.remove(invoice);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('发票删除成功')),
              );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// 发票数据模型
class InvoiceModel {
  final String id;
  final String type;
  final String customerName;
  final double amount;
  final double taxAmount;
  final double totalAmount;
  final DateTime issueDate;
  final DateTime dueDate;
  String status;
  final String description;
  String invoiceNumber;
  final double taxRate;

  InvoiceModel({
    required this.id,
    required this.type,
    required this.customerName,
    required this.amount,
    required this.taxAmount,
    required this.totalAmount,
    required this.issueDate,
    required this.dueDate,
    required this.status,
    required this.description,
    required this.invoiceNumber,
    required this.taxRate,
  });
}

// 新增发票对话框
class AddInvoiceDialog extends StatefulWidget {
  const AddInvoiceDialog({super.key});

  @override
  State<AddInvoiceDialog> createState() => _AddInvoiceDialogState();
}

class _AddInvoiceDialogState extends State<AddInvoiceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _customerController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = '销售发票';
  double _selectedTaxRate = 0.13;
  DateTime _issueDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));

  double get _taxAmount => (double.tryParse(_amountController.text) ?? 0) * _selectedTaxRate;
  double get _totalAmount => (double.tryParse(_amountController.text) ?? 0) + _taxAmount;

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
                  Icon(Icons.receipt_long, color: AppTheme.successGreen),
                  const SizedBox(width: 12),
                  const Text(
                    '新增发票',
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
                                labelText: '发票类型',
                                border: OutlineInputBorder(),
                              ),
                              items: ['销售发票', '采购发票', '费用发票']
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
                            child: DropdownButtonFormField<double>(
                              value: _selectedTaxRate,
                              decoration: const InputDecoration(
                                labelText: '税率',
                                border: OutlineInputBorder(),
                              ),
                              items: [0.03, 0.06, 0.09, 0.13]
                                  .map((rate) => DropdownMenuItem(
                                        value: rate,
                                        child: Text('${(rate * 100).toInt()}%'),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedTaxRate = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _customerController,
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
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          labelText: '金额（不含税）',
                          border: OutlineInputBorder(),
                          prefixText: '¥ ',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => setState(() {}),
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
                      
                      // 税额和总额显示
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('税额：'),
                                Text(
                                  '¥${_taxAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('总金额：'),
                                Text(
                                  '¥${_totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.successGreen,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: '发票内容',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '请输入发票内容';
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
                                  initialDate: _issueDate,
                                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setState(() => _issueDate = date);
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: '开票日期',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  '${_issueDate.year}-${_issueDate.month.toString().padLeft(2, '0')}-${_issueDate.day.toString().padLeft(2, '0')}',
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
                                  initialDate: _dueDate,
                                  firstDate: _issueDate,
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setState(() => _dueDate = date);
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: '到期日期',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  '${_dueDate.year}-${_dueDate.month.toString().padLeft(2, '0')}-${_dueDate.day.toString().padLeft(2, '0')}',
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
        const SnackBar(content: Text('发票创建成功')),
      );
    }
  }
}

// 编辑发票对话框
class EditInvoiceDialog extends StatefulWidget {
  final InvoiceModel invoice;
  
  const EditInvoiceDialog({super.key, required this.invoice});

  @override
  State<EditInvoiceDialog> createState() => _EditInvoiceDialogState();
}

class _EditInvoiceDialogState extends State<EditInvoiceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _customerController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late String _selectedType;
  late String _selectedStatus;
  late double _selectedTaxRate;
  late DateTime _issueDate;
  late DateTime _dueDate;

  double get _taxAmount => (double.tryParse(_amountController.text) ?? 0) * _selectedTaxRate;
  double get _totalAmount => (double.tryParse(_amountController.text) ?? 0) + _taxAmount;

  @override
  void initState() {
    super.initState();
    _customerController = TextEditingController(text: widget.invoice.customerName);
    _amountController = TextEditingController(text: widget.invoice.amount.toString());
    _descriptionController = TextEditingController(text: widget.invoice.description);
    _selectedType = widget.invoice.type;
    _selectedStatus = widget.invoice.status;
    _selectedTaxRate = widget.invoice.taxRate;
    _issueDate = widget.invoice.issueDate;
    _dueDate = widget.invoice.dueDate;
  }

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
                    '编辑发票 - ${widget.invoice.id}',
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
                                labelText: '发票类型',
                                border: OutlineInputBorder(),
                              ),
                              items: ['销售发票', '采购发票', '费用发票']
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
                              value: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: '状态',
                                border: OutlineInputBorder(),
                              ),
                              items: ['待开具', '已开具', '已收票', '已作废']
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
                        controller: _customerController,
                        decoration: const InputDecoration(
                          labelText: '客户名称',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _amountController,
                              decoration: const InputDecoration(
                                labelText: '金额（不含税）',
                                border: OutlineInputBorder(),
                                prefixText: '¥ ',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<double>(
                              value: _selectedTaxRate,
                              decoration: const InputDecoration(
                                labelText: '税率',
                                border: OutlineInputBorder(),
                              ),
                              items: [0.03, 0.06, 0.09, 0.13]
                                  .map((rate) => DropdownMenuItem(
                                        value: rate,
                                        child: Text('${(rate * 100).toInt()}%'),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedTaxRate = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // 税额和总额显示
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('税额：'),
                                Text(
                                  '¥${_taxAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('总金额：'),
                                Text(
                                  '¥${_totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.successGreen,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: '发票内容',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _issueDate,
                                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setState(() => _issueDate = date);
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: '开票日期',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  '${_issueDate.year}-${_issueDate.month.toString().padLeft(2, '0')}-${_issueDate.day.toString().padLeft(2, '0')}',
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
                                  initialDate: _dueDate,
                                  firstDate: _issueDate,
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setState(() => _dueDate = date);
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: '到期日期',
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  '${_dueDate.year}-${_dueDate.month.toString().padLeft(2, '0')}-${_dueDate.day.toString().padLeft(2, '0')}',
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
                        const SnackBar(content: Text('发票更新成功')),
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

// 发票详情对话框
class InvoiceDetailsDialog extends StatelessWidget {
  final InvoiceModel invoice;
  
  const InvoiceDetailsDialog({super.key, required this.invoice});

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
                  Icon(Icons.receipt_long, color: AppTheme.successGreen),
                  const SizedBox(width: 12),
                  Text(
                    '发票详情 - ${invoice.id}',
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
                      _buildInfoRow('发票编号', invoice.invoiceNumber.isEmpty ? invoice.id : invoice.invoiceNumber),
                      _buildInfoRow('发票类型', invoice.type),
                      _buildInfoRow('客户名称', invoice.customerName),
                      _buildInfoRow('状态', invoice.status),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    _buildInfoSection('金额信息', [
                      _buildInfoRow('金额（不含税）', '¥${invoice.amount.toStringAsFixed(2)}'),
                      _buildInfoRow('税率', '${(invoice.taxRate * 100).toInt()}%'),
                      _buildInfoRow('税额', '¥${invoice.taxAmount.toStringAsFixed(2)}'),
                      _buildInfoRow('总金额', '¥${invoice.totalAmount.toStringAsFixed(2)}'),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    _buildInfoSection('其他信息', [
                      _buildInfoRow('发票内容', invoice.description),
                      _buildInfoRow('开票日期', '${invoice.issueDate.year}-${invoice.issueDate.month.toString().padLeft(2, '0')}-${invoice.issueDate.day.toString().padLeft(2, '0')}'),
                      _buildInfoRow('到期日期', '${invoice.dueDate.year}-${invoice.dueDate.month.toString().padLeft(2, '0')}-${invoice.dueDate.day.toString().padLeft(2, '0')}'),
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
                  if (invoice.status == '已开具')
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('正在打印发票 ${invoice.invoiceNumber}')),
                        );
                      },
                      icon: const Icon(Icons.print),
                      label: const Text('打印'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  if (invoice.status == '已开具')
                    const SizedBox(width: 12),
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
            width: 100,
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