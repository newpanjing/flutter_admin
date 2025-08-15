import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_dialog.dart';

class OutboundPage extends StatefulWidget {
  const OutboundPage({super.key});

  @override
  State<OutboundPage> createState() => _OutboundPageState();
}

class _OutboundPageState extends State<OutboundPage> {
  final List<Map<String, dynamic>> _outboundRecords = [
    {
      'id': 'OUT001',
      'productName': 'iPhone 14 Pro',
      'category': '电子产品',
      'quantity': 30,
      'unitPrice': 8999.0,
      'totalAmount': 269970.0,
      'customer': '零售客户A',
      'warehouse': '主仓库',
      'operator': '张三',
      'date': '2024-01-15',
      'status': '已完成',
      'type': '销售出库',
    },
    {
      'id': 'OUT002',
      'productName': 'MacBook Pro',
      'category': '电子产品',
      'quantity': 10,
      'unitPrice': 15999.0,
      'totalAmount': 159990.0,
      'customer': '企业客户B',
      'warehouse': '主仓库',
      'operator': '李四',
      'date': '2024-01-14',
      'status': '进行中',
      'type': '销售出库',
    },
    {
      'id': 'OUT003',
      'productName': '办公椅',
      'category': '办公用品',
      'quantity': 50,
      'unitPrice': 299.0,
      'totalAmount': 14950.0,
      'customer': '内部使用',
      'warehouse': '副仓库',
      'operator': '王五',
      'date': '2024-01-13',
      'status': '已完成',
      'type': '内部领用',
    },
  ];

  List<Map<String, dynamic>> _filteredRecords = [];
  String _searchQuery = '';
  String _selectedStatus = '全部';
  String _selectedType = '全部';
  String _selectedWarehouse = '全部';

  @override
  void initState() {
    super.initState();
    _filteredRecords = List.from(_outboundRecords);
  }

  void _filterRecords() {
    setState(() {
      _filteredRecords = _outboundRecords.where((record) {
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
        
        final matchesType = _selectedType == '全部' || 
            record['type'] == _selectedType;
        
        final matchesWarehouse = _selectedWarehouse == '全部' || 
            record['warehouse'] == _selectedWarehouse;
        
        return matchesSearch && matchesStatus && matchesType && matchesWarehouse;
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
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.output_outlined,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '出库管理',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '管理商品出库记录和库存减少',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ModernButton(
                      text: '新增出库',
                      icon: Icons.add,
                      onPressed: () => _showAddOutboundDialog(),
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
                            hintText: '搜索商品名称或出库单号...',
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
                    // 类型筛选
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
                          value: _selectedType,
                          items: ['全部', '销售出库', '内部领用', '调拨出库'].map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
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
                _buildStatCard('今日出库', '8', '单', Colors.orange),
                const SizedBox(width: 16),
                _buildStatCard('本月出库', '98', '单', AppTheme.primaryBlue),
                const SizedBox(width: 16),
                _buildStatCard('出库金额', '¥1,856,700', '', Colors.red),
                const SizedBox(width: 16),
                _buildStatCard('待处理', '2', '单', AppTheme.warningYellow),
              ],
            ),
          ),
          
          // 出库记录列表
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
                        _buildTableHeader('出库单号', flex: 2),
                        _buildTableHeader('商品信息', flex: 3),
                        _buildTableHeader('数量', flex: 1),
                        _buildTableHeader('单价', flex: 2),
                        _buildTableHeader('总金额', flex: 2),
                        _buildTableHeader('客户/用途', flex: 2),
                        _buildTableHeader('类型', flex: 2),
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
                    Icons.trending_down,
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
          // 出库单号
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
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // 客户/用途
          Expanded(
            flex: 2,
            child: Text(
              record['customer'],
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          
          // 类型
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getTypeColor(record['type']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                record['type'],
                style: TextStyle(
                  color: _getTypeColor(record['type']),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
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
                  onPressed: () => _showOutboundDetail(record),
                  icon: const Icon(
                    Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  tooltip: '查看详情',
                ),
                IconButton(
                  onPressed: record['status'] == '进行中' 
                      ? () => _editOutbound(record) 
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
                      ? () => _deleteOutbound(record) 
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

  Color _getTypeColor(String type) {
    switch (type) {
      case '销售出库':
        return AppTheme.primaryBlue;
      case '内部领用':
        return Colors.orange;
      case '调拨出库':
        return AppTheme.successGreen;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showAddOutboundDialog() {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '新增出库',
        titleIcon: Icons.add,
        width: 600,
        content: _buildOutboundForm(),
        actions: [
          ModernButton(
            text: '取消',
            type: ButtonType.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          ModernButton(
            text: '确认出库',
            onPressed: () {
              // 处理出库逻辑
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('出库单已创建'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOutboundForm() {
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
              child: ModernDropdown<String>(
                label: '出库类型',
                hint: '请选择出库类型',
                items: ['销售出库', '内部领用', '调拨出库'],
                itemBuilder: (item) => item,
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
                label: '出库数量',
                hint: '请输入出库数量',
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
              child: ModernFormField(
                label: '客户/用途',
                hint: '请输入客户名称或用途',
                prefixIcon: Icons.person_outline,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernDropdown<String>(
                label: '出库仓库',
                hint: '请选择出库仓库',
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

  void _showOutboundDetail(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '出库详情',
        titleIcon: Icons.info_outline,
        width: 500,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('出库单号', record['id']),
            _buildDetailRow('商品名称', record['productName']),
            _buildDetailRow('商品类别', record['category']),
            _buildDetailRow('出库数量', record['quantity'].toString()),
            _buildDetailRow('单价', '¥${record['unitPrice'].toStringAsFixed(2)}'),
            _buildDetailRow('总金额', '¥${record['totalAmount'].toStringAsFixed(2)}'),
            _buildDetailRow('客户/用途', record['customer']),
            _buildDetailRow('出库类型', record['type']),
            _buildDetailRow('出库仓库', record['warehouse']),
            _buildDetailRow('操作员', record['operator']),
            _buildDetailRow('出库日期', record['date']),
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

  void _editOutbound(Map<String, dynamic> record) {
    // 编辑出库记录的逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('编辑功能开发中...'),
        backgroundColor: AppTheme.warningYellow,
      ),
    );
  }

  void _deleteOutbound(Map<String, dynamic> record) {
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
                      '确定要删除出库单 ${record['id']} 吗？\n此操作不可撤销。',
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
                _outboundRecords.removeWhere((r) => r['id'] == record['id']);
                _filterRecords();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('出库单已删除'),
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