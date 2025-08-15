import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_dialog.dart';

class ReturnPage extends StatefulWidget {
  const ReturnPage({super.key});

  @override
  State<ReturnPage> createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  final List<Map<String, dynamic>> _returnRecords = [
    {
      'id': 'RT001',
      'productName': 'iPhone 15 Pro',
      'productCode': 'IP15P001',
      'category': '电子产品',
      'warehouse': '主仓库',
      'returnQuantity': 2,
      'unitPrice': 8999.00,
      'totalValue': 17998.00,
      'returnDate': '2024-01-15',
      'operator': '张三',
      'customerName': '李先生',
      'customerPhone': '13800138001',
      'returnReason': '商品质量问题，客户要求退货',
      'status': '已完成',
      'approver': '李经理',
      'approveDate': '2024-01-16',
      'refundAmount': 17998.00,
      'refundStatus': '已退款',
    },
    {
      'id': 'RT002',
      'productName': '蓝牙耳机',
      'productCode': 'BT001',
      'category': '电子配件',
      'warehouse': '副仓库',
      'returnQuantity': 1,
      'unitPrice': 299.00,
      'totalValue': 299.00,
      'returnDate': '2024-01-18',
      'operator': '王五',
      'customerName': '张女士',
      'customerPhone': '13900139002',
      'returnReason': '不符合预期，7天无理由退货',
      'status': '待审核',
      'approver': '',
      'approveDate': '',
      'refundAmount': 0.00,
      'refundStatus': '待退款',
    },
    {
      'id': 'RT003',
      'productName': '办公椅',
      'productCode': 'CHR001',
      'category': '办公家具',
      'warehouse': '主仓库',
      'returnQuantity': 1,
      'unitPrice': 1299.00,
      'totalValue': 1299.00,
      'returnDate': '2024-01-20',
      'operator': '李四',
      'customerName': '王总',
      'customerPhone': '13700137003',
      'returnReason': '尺寸不合适，需要更换其他型号',
      'status': '处理中',
      'approver': '张经理',
      'approveDate': '2024-01-21',
      'refundAmount': 1299.00,
      'refundStatus': '处理中',
    },
  ];

  List<Map<String, dynamic>> _filteredRecords = [];
  String _searchQuery = '';
  String _selectedStatus = '全部';
  String _selectedWarehouse = '全部';

  @override
  void initState() {
    super.initState();
    _filteredRecords = List.from(_returnRecords);
  }

  void _filterRecords() {
    setState(() {
      _filteredRecords = _returnRecords.where((record) {
        final matchesSearch = record['productName']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()) ||
            record['productCode']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            record['id']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            record['customerName']
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
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.keyboard_return_outlined,
                        color: const Color(0xFF4CAF50),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '退货管理',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '管理客户退货申请和退款处理流程',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ModernButton(
                      text: '新增退货',
                      icon: Icons.add,
                      onPressed: () => _showAddReturnDialog(),
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
                            hintText: '搜索商品名称、编码、退货编号或客户姓名...',
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
                          items: ['全部', '待审核', '处理中', '已完成', '已拒绝'].map((status) {
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
                _buildStatCard('本月退货', '3', '项', const Color(0xFF4CAF50)),
                const SizedBox(width: 16),
                _buildStatCard('退货金额', '19,596', '元', Colors.blue),
                const SizedBox(width: 16),
                _buildStatCard('待审核', '1', '项', AppTheme.warningYellow),
                const SizedBox(width: 16),
                _buildStatCard('已完成', '1', '项', const Color(0xFF4CAF50)),
              ],
            ),
          ),
          
          // 退货记录列表
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
                        _buildTableHeader('退货编号', flex: 2),
                        _buildTableHeader('商品信息', flex: 3),
                        _buildTableHeader('客户信息', flex: 2),
                        _buildTableHeader('退货数量', flex: 1),
                        _buildTableHeader('退货金额', flex: 2),
                        _buildTableHeader('退货日期', flex: 2),
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
                    Icons.keyboard_return,
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
          // 退货编号
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
                  '编码: ${record['productCode']}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '仓库: ${record['warehouse']}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // 客户信息
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record['customerName'],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  record['customerPhone'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // 退货数量
          Expanded(
            flex: 1,
            child: Text(
              record['returnQuantity'].toString(),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // 退货金额
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¥${record['totalValue'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '单价: ¥${record['unitPrice'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // 退货日期
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record['returnDate'],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '操作员: ${record['operator']}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
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
                  onPressed: () => _showReturnDetail(record),
                  icon: const Icon(
                    Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  tooltip: '查看详情',
                ),
                if (record['status'] == '待审核') ...[
                  IconButton(
                    onPressed: () => _approveReturn(record),
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF4CAF50),
                      size: 18,
                    ),
                    tooltip: '审核通过',
                  ),
                  IconButton(
                    onPressed: () => _rejectReturn(record),
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                      size: 18,
                    ),
                    tooltip: '审核拒绝',
                  ),
                ] else if (record['status'] == '处理中') ...[
                  IconButton(
                    onPressed: () => _completeReturn(record),
                    icon: const Icon(
                      Icons.done_all,
                      color: Color(0xFF4CAF50),
                      size: 18,
                    ),
                    tooltip: '完成退货',
                  ),
                ] else if (record['status'] == '已完成') ...[
                  IconButton(
                    onPressed: () => _deleteReturn(record),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 18,
                    ),
                    tooltip: '删除',
                  ),
                ],
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
      case '处理中':
        return Colors.blue;
      case '待审核':
        return AppTheme.warningYellow;
      case '已拒绝':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showAddReturnDialog() {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '新增退货',
        titleIcon: Icons.add,
        width: 600,
        content: _buildReturnForm(),
        actions: [
          ModernButton(
            text: '取消',
            type: ButtonType.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          ModernButton(
            text: '提交退货',
            onPressed: () {
              // 处理新增退货逻辑
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('退货申请已提交，等待审核'),
                  backgroundColor: AppTheme.warningYellow,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReturnForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: ModernFormField(
                label: '商品名称',
                hint: '请输入或选择商品',
                prefixIcon: Icons.inventory_2_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernFormField(
                label: '商品编码',
                hint: '请输入商品编码',
                prefixIcon: Icons.qr_code,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ModernDropdown<String>(
                label: '仓库',
                hint: '请选择仓库',
                items: ['主仓库', '副仓库'],
                itemBuilder: (item) => item,
                prefixIcon: Icons.warehouse,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernFormField(
                label: '退货数量',
                hint: '请输入退货数量',
                prefixIcon: Icons.remove_circle_outline,
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
                label: '客户姓名',
                hint: '请输入客户姓名',
                prefixIcon: Icons.person_outline,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernFormField(
                label: '客户电话',
                hint: '请输入客户电话',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: '退货原因',
          hint: '请详细描述退货原因',
          maxLines: 3,
          prefixIcon: Icons.description_outlined,
        ),
      ],
    );
  }

  void _showReturnDetail(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '退货详情',
        titleIcon: Icons.info_outline,
        width: 600,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('退货编号', record['id']),
            _buildDetailRow('商品名称', record['productName']),
            _buildDetailRow('商品编码', record['productCode']),
            _buildDetailRow('商品类别', record['category']),
            _buildDetailRow('仓库', record['warehouse']),
            _buildDetailRow('退货数量', record['returnQuantity'].toString()),
            _buildDetailRow('单价', '¥${record['unitPrice'].toStringAsFixed(2)}'),
            _buildDetailRow('退货金额', '¥${record['totalValue'].toStringAsFixed(2)}'),
            _buildDetailRow('退货日期', record['returnDate']),
            _buildDetailRow('操作员', record['operator']),
            _buildDetailRow('客户姓名', record['customerName']),
            _buildDetailRow('客户电话', record['customerPhone']),
            _buildDetailRow('退货原因', record['returnReason']),
            _buildDetailRow('状态', record['status']),
            if (record['approver'].isNotEmpty) ...[
              _buildDetailRow('审核人', record['approver']),
              _buildDetailRow('审核日期', record['approveDate']),
            ],
            _buildDetailRow('退款金额', '¥${record['refundAmount'].toStringAsFixed(2)}'),
            _buildDetailRow('退款状态', record['refundStatus']),
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
            width: 100,
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

  void _approveReturn(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '审核通过',
        titleIcon: Icons.check_circle_outline,
        titleIconColor: const Color(0xFF4CAF50),
        width: 400,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: const Color(0xFF4CAF50),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '确定要审核通过退货申请 ${record['id']} 吗？',
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
            text: '确认通过',
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                record['status'] = '处理中';
                record['approver'] = '当前用户';
                record['approveDate'] = DateTime.now().toString().substring(0, 10);
                _filterRecords();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('退货申请已审核通过，进入处理流程'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _rejectReturn(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '审核拒绝',
        titleIcon: Icons.cancel_outlined,
        titleIconColor: Colors.red,
        width: 400,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '确定要拒绝退货申请 ${record['id']} 吗？',
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
            text: '确认拒绝',
            type: ButtonType.danger,
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                record['status'] = '已拒绝';
                record['approver'] = '当前用户';
                record['approveDate'] = DateTime.now().toString().substring(0, 10);
                _filterRecords();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('退货申请已拒绝'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _completeReturn(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '完成退货',
        titleIcon: Icons.done_all,
        titleIconColor: const Color(0xFF4CAF50),
        width: 400,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.done_all,
                    color: const Color(0xFF4CAF50),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '确定要完成退货处理 ${record['id']} 吗？\n完成后将自动处理退款。',
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
            text: '确认完成',
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                record['status'] = '已完成';
                record['refundAmount'] = record['totalValue'];
                record['refundStatus'] = '已退款';
                _filterRecords();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('退货处理已完成，退款已处理'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _deleteReturn(Map<String, dynamic> record) {
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
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_outlined,
                    color: Colors.red,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '确定要删除退货记录 ${record['id']} 吗？\n此操作不可撤销。',
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
                _returnRecords.removeWhere((r) => r['id'] == record['id']);
                _filterRecords();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('退货记录已删除'),
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