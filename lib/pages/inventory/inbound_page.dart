import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_dialog.dart';

class InboundPage extends StatefulWidget {
  const InboundPage({super.key});

  @override
  State<InboundPage> createState() => _InboundPageState();
}

class _InboundPageState extends State<InboundPage> {
  final List<Map<String, dynamic>> _inboundRecords = [
    {
      'id': 'IN001',
      'productName': 'iPhone 14 Pro',
      'category': '电子产品',
      'quantity': 50,
      'unitPrice': 8999.0,
      'totalAmount': 449950.0,
      'supplier': '苹果供应商',
      'warehouse': '主仓库',
      'operator': '张三',
      'date': '2024-01-15',
      'status': '已完成',
    },
    {
      'id': 'IN002',
      'productName': 'MacBook Pro',
      'category': '电子产品',
      'quantity': 20,
      'unitPrice': 15999.0,
      'totalAmount': 319980.0,
      'supplier': '苹果供应商',
      'warehouse': '主仓库',
      'operator': '李四',
      'date': '2024-01-14',
      'status': '进行中',
    },
    {
      'id': 'IN003',
      'productName': '办公椅',
      'category': '办公用品',
      'quantity': 100,
      'unitPrice': 299.0,
      'totalAmount': 29900.0,
      'supplier': '办公家具公司',
      'warehouse': '副仓库',
      'operator': '王五',
      'date': '2024-01-13',
      'status': '已完成',
    },
  ];

  List<Map<String, dynamic>> _filteredRecords = [];
  String _searchQuery = '';
  String _selectedStatus = '全部';
  String _selectedWarehouse = '全部';

  @override
  void initState() {
    super.initState();
    _filteredRecords = List.from(_inboundRecords);
  }

  void _filterRecords() {
    setState(() {
      _filteredRecords = _inboundRecords.where((record) {
        final matchesSearch = record['productName']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()) ||
            record['id']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
        
        final matchesStatus = _selectedStatus == '全部' || 
            record['status'] == _selectedStatus;
        
        final matchesWarehouse = _selectedWarehouse == '全部' || 
            record['warehouse'] == _selectedWarehouse;
        
        return matchesSearch && matchesStatus && matchesWarehouse;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.contentBackground,
      body: Column(
        children: [
          // 页面标题和操作栏
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.borderColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.input_outlined,
                        color: AppTheme.successGreen,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '入库管理',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '管理商品入库记录和库存增加',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ModernButton(
                      text: '新增入库',
                      icon: Icons.add,
                      onPressed: () => _showAddInboundDialog(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // 搜索和筛选栏
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
                          onChanged: (value) {
                            _searchQuery = value;
                            _filterRecords();
                          },
                          decoration: const InputDecoration(
                            hintText: '搜索商品名称或入库单号...',
                            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 状态筛选
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedStatus,
                          items: ['全部', '进行中', '已完成', '已取消'].map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                            });
                            _filterRecords();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 仓库筛选
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedWarehouse,
                          items: ['全部', '主仓库', '副仓库'].map((warehouse) {
                            return DropdownMenuItem(
                              value: warehouse,
                              child: Text(warehouse),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedWarehouse = value!;
                            });
                            _filterRecords();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 统计卡片
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                _buildStatCard('今日入库', '12', '单', AppTheme.successGreen),
                const SizedBox(width: 16),
                _buildStatCard('本月入库', '156', '单', AppTheme.primaryBlue),
                const SizedBox(width: 16),
                _buildStatCard('入库金额', '¥2,458,900', '', AppTheme.warningYellow),
                const SizedBox(width: 16),
                _buildStatCard('待处理', '3', '单', Colors.orange),
              ],
            ),
          ),
          
          // 入库记录列表
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                children: [
                  // 表头
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildTableHeader('入库单号', flex: 2),
                        _buildTableHeader('商品信息', flex: 3),
                        _buildTableHeader('数量', flex: 1),
                        _buildTableHeader('单价', flex: 2),
                        _buildTableHeader('总金额', flex: 2),
                        _buildTableHeader('供应商', flex: 2),
                        _buildTableHeader('仓库', flex: 2),
                        _buildTableHeader('状态', flex: 1),
                        _buildTableHeader('操作', flex: 2),
                      ],
                    ),
                  ),
                  
                  // 表格内容
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredRecords.length,
                      itemBuilder: (context, index) {
                        final record = _filteredRecords[index];
                        return _buildTableRow(record, index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String unit, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
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
                  child: Icon(
                    Icons.trending_up,
                    color: color,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Text(
                    unit,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String title, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> record, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 入库单号
          Expanded(
            flex: 2,
            child: Text(
              record['id'],
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // 商品信息
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record['productName'],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  record['category'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // 数量
          Expanded(
            flex: 1,
            child: Text(
              record['quantity'].toString(),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          
          // 单价
          Expanded(
            flex: 2,
            child: Text(
              '¥${record['unitPrice'].toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          
          // 总金额
          Expanded(
            flex: 2,
            child: Text(
              '¥${record['totalAmount'].toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppTheme.successGreen,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // 供应商
          Expanded(
            flex: 2,
            child: Text(
              record['supplier'],
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          
          // 仓库
          Expanded(
            flex: 2,
            child: Text(
              record['warehouse'],
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          
          // 状态
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(record['status']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                record['status'],
                style: TextStyle(
                  color: _getStatusColor(record['status']),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // 操作
          Expanded(
            flex: 2,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _showInboundDetail(record),
                  icon: const Icon(
                    Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  tooltip: '查看详情',
                ),
                IconButton(
                  onPressed: record['status'] == '进行中' 
                      ? () => _editInbound(record) 
                      : null,
                  icon: Icon(
                    Icons.edit_outlined,
                    color: record['status'] == '进行中' 
                        ? AppColors.textSecondary 
                        : AppColors.textMuted,
                    size: 18,
                  ),
                  tooltip: '编辑',
                ),
                IconButton(
                  onPressed: record['status'] == '进行中' 
                      ? () => _deleteInbound(record) 
                      : null,
                  icon: Icon(
                    Icons.delete_outline,
                    color: record['status'] == '进行中' 
                        ? Colors.red 
                        : AppColors.textMuted,
                    size: 18,
                  ),
                  tooltip: '删除',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '已完成':
        return AppTheme.successGreen;
      case '进行中':
        return AppTheme.warningYellow;
      case '已取消':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showAddInboundDialog() {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '新增入库',
        titleIcon: Icons.add,
        width: 600,
        content: _buildInboundForm(),
        actions: [
          ModernButton(
            text: '取消',
            type: ButtonType.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          ModernButton(
            text: '确认入库',
            onPressed: () {
              // 处理入库逻辑
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('入库单已创建'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInboundForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: ModernFormField(
                label: '商品名称',
                hint: '请输入商品名称',
                prefixIcon: Icons.inventory_2_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernFormField(
                label: '商品类别',
                hint: '请选择商品类别',
                prefixIcon: Icons.category_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ModernFormField(
                label: '入库数量',
                hint: '请输入入库数量',
                prefixIcon: Icons.numbers,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernFormField(
                label: '单价',
                hint: '请输入单价',
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ModernDropdown<String>(
                label: '供应商',
                hint: '请选择供应商',
                items: ['苹果供应商', '办公家具公司', '电子产品供应商'],
                itemBuilder: (item) => item,
                prefixIcon: Icons.business,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernDropdown<String>(
                label: '目标仓库',
                hint: '请选择目标仓库',
                items: ['主仓库', '副仓库'],
                itemBuilder: (item) => item,
                prefixIcon: Icons.warehouse,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: '备注',
          hint: '请输入备注信息（可选）',
          maxLines: 3,
          prefixIcon: Icons.note_outlined,
        ),
      ],
    );
  }

  void _showInboundDetail(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '入库详情',
        titleIcon: Icons.info_outline,
        width: 500,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('入库单号', record['id']),
            _buildDetailRow('商品名称', record['productName']),
            _buildDetailRow('商品类别', record['category']),
            _buildDetailRow('入库数量', record['quantity'].toString()),
            _buildDetailRow('单价', '¥${record['unitPrice'].toStringAsFixed(2)}'),
            _buildDetailRow('总金额', '¥${record['totalAmount'].toStringAsFixed(2)}'),
            _buildDetailRow('供应商', record['supplier']),
            _buildDetailRow('目标仓库', record['warehouse']),
            _buildDetailRow('操作员', record['operator']),
            _buildDetailRow('入库日期', record['date']),
            _buildDetailRow('状态', record['status']),
          ],
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editInbound(Map<String, dynamic> record) {
    // 编辑入库记录的逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('编辑功能开发中...'),
        backgroundColor: AppTheme.warningYellow,
      ),
    );
  }

  void _deleteInbound(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '确认删除',
        titleIcon: Icons.warning_outlined,
        titleIconColor: Colors.red,
        width: 400,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF44336).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF44336).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_outlined,
                    color: Color(0xFFF44336),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '确定要删除入库单 ${record['id']} 吗？\n此操作不可撤销。',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
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
            text: '确认删除',
            type: ButtonType.danger,
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _inboundRecords.removeWhere((r) => r['id'] == record['id']);
                _filterRecords();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('入库单已删除'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}