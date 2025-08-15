import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_dialog.dart';

class LossPage extends StatefulWidget {
  const LossPage({super.key});

  @override
  State<LossPage> createState() => _LossPageState();
}

class _LossPageState extends State<LossPage> {
  final List<Map<String, dynamic>> _lossRecords = [
    {
      'id': 'LS001',
      'productName': 'iPhone 15 Pro',
      'productCode': 'IP15P001',
      'category': '电子产品',
      'warehouse': '主仓库',
      'lossQuantity': 2,
      'unitPrice': 8999.00,
      'totalLoss': 17998.00,
      'lossType': '破损',
      'lossDate': '2024-01-15',
      'operator': '张三',
      'reason': '运输过程中包装破损导致屏幕碎裂',
      'status': '已确认',
      'approver': '李经理',
      'approveDate': '2024-01-16',
    },
    {
      'id': 'LS002',
      'productName': '办公椅',
      'productCode': 'OFC001',
      'category': '办公用品',
      'warehouse': '副仓库',
      'lossQuantity': 1,
      'unitPrice': 599.00,
      'totalLoss': 599.00,
      'lossType': '过期',
      'lossDate': '2024-01-18',
      'operator': '王五',
      'reason': '超过保质期，无法继续销售',
      'status': '待审核',
      'approver': '',
      'approveDate': '',
    },
    {
      'id': 'LS003',
      'productName': '笔记本电脑',
      'productCode': 'NB001',
      'category': '电子产品',
      'warehouse': '主仓库',
      'lossQuantity': 1,
      'unitPrice': 4999.00,
      'totalLoss': 4999.00,
      'lossType': '丢失',
      'lossDate': '2024-01-20',
      'operator': '李四',
      'reason': '盘点时发现缺失，疑似被盗',
      'status': '已确认',
      'approver': '张经理',
      'approveDate': '2024-01-21',
    },
  ];

  List<Map<String, dynamic>> _filteredRecords = [];
  String _searchQuery = '';
  String _selectedStatus = '全部';
  String _selectedLossType = '全部';
  String _selectedWarehouse = '全部';

  @override
  void initState() {
    super.initState();
    _filteredRecords = List.from(_lossRecords);
  }

  void _filterRecords() {
    setState(() {
      _filteredRecords = _lossRecords.where((record) {
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
                .contains(_searchQuery.toLowerCase());
        
        final matchesStatus = _selectedStatus == '全部' || 
            record['status'] == _selectedStatus;
        
        final matchesLossType = _selectedLossType == '全部' || 
            record['lossType'] == _selectedLossType;
        
        final matchesWarehouse = _selectedWarehouse == '全部' || 
            record['warehouse'] == _selectedWarehouse;
        
        return matchesSearch && matchesStatus && matchesLossType && matchesWarehouse;
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
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.trending_down_outlined,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '损耗管理',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '管理库存商品的损耗记录和损失统计',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ModernButton(
                      text: '新增损耗',
                      icon: Icons.add,
                      onPressed: () => _showAddLossDialog(),
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
                            hintText: '搜索商品名称、编码或损耗编号...',
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
                          items: ['全部', '待审核', '已确认', '已拒绝'].map((status) {
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
                    // 损耗类型筛选
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
                          value: _selectedLossType,
                          items: ['全部', '破损', '过期', '丢失', '其他'].map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedLossType = value!;
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
                _buildStatCard('本月损耗', '3', '项', Colors.red),
                const SizedBox(width: 16),
                _buildStatCard('损耗金额', '23,596', '元', Colors.orange),
                const SizedBox(width: 16),
                _buildStatCard('待审核', '1', '项', AppTheme.warningYellow),
                const SizedBox(width: 16),
                _buildStatCard('已确认', '2', '项', const Color(0xFF4CAF50)),
              ],
            ),
          ),
          
          // 损耗记录列表
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
                        _buildTableHeader('损耗编号', flex: 2),
                        _buildTableHeader('商品信息', flex: 3),
                        _buildTableHeader('仓库', flex: 1),
                        _buildTableHeader('损耗类型', flex: 1),
                        _buildTableHeader('损耗数量', flex: 1),
                        _buildTableHeader('损失金额', flex: 2),
                        _buildTableHeader('损耗日期', flex: 2),
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
          // 损耗编号
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
                  '类别: ${record['category']}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // 仓库
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                record['warehouse'],
                style: const TextStyle(
                  color: AppTheme.primaryBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // 损耗类型
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getLossTypeColor(record['lossType']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                record['lossType'],
                style: TextStyle(
                  color: _getLossTypeColor(record['lossType']),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // 损耗数量
          Expanded(
            flex: 1,
            child: Text(
              record['lossQuantity'].toString(),
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // 损失金额
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¥${record['totalLoss'].toStringAsFixed(2)}',
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
          
          // 损耗日期
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record['lossDate'],
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
                  onPressed: () => _showLossDetail(record),
                  icon: const Icon(
                    Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  tooltip: '查看详情',
                ),
                if (record['status'] == '待审核') ...[
                  IconButton(
                    onPressed: () => _approveLoss(record),
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF4CAF50),
                      size: 18,
                    ),
                    tooltip: '审核通过',
                  ),
                  IconButton(
                    onPressed: () => _rejectLoss(record),
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                      size: 18,
                    ),
                    tooltip: '审核拒绝',
                  ),
                ] else ...[
                  IconButton(
                    onPressed: () => _deleteLoss(record),
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
      case '已确认':
        return AppTheme.successGreen;
      case '待审核':
        return AppTheme.warningYellow;
      case '已拒绝':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getLossTypeColor(String lossType) {
    switch (lossType) {
      case '破损':
        return Colors.red;
      case '过期':
        return Colors.orange;
      case '丢失':
        return Colors.purple;
      case '其他':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showAddLossDialog() {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '新增损耗',
        titleIcon: Icons.add,
        width: 600,
        content: _buildLossForm(),
        actions: [
          ModernButton(
            text: '取消',
            type: ButtonType.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          ModernButton(
            text: '提交损耗',
            onPressed: () {
              // 处理新增损耗逻辑
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('损耗记录已提交，等待审核'),
                  backgroundColor: AppTheme.warningYellow,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLossForm() {
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
                label: '损耗类型',
                hint: '请选择损耗类型',
                items: ['破损', '过期', '丢失', '其他'],
                itemBuilder: (item) => item,
                prefixIcon: Icons.category,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernDropdown<String>(
                label: '仓库',
                hint: '请选择仓库',
                items: ['主仓库', '副仓库'],
                itemBuilder: (item) => item,
                prefixIcon: Icons.warehouse,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ModernFormField(
                label: '损耗数量',
                hint: '请输入损耗数量',
                prefixIcon: Icons.remove_circle_outline,
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
        ModernFormField(
          label: '损耗原因',
          hint: '请详细描述损耗原因',
          maxLines: 3,
          prefixIcon: Icons.description_outlined,
        ),
      ],
    );
  }

  void _showLossDetail(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '损耗详情',
        titleIcon: Icons.info_outline,
        width: 600,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('损耗编号', record['id']),
            _buildDetailRow('商品名称', record['productName']),
            _buildDetailRow('商品编码', record['productCode']),
            _buildDetailRow('商品类别', record['category']),
            _buildDetailRow('仓库', record['warehouse']),
            _buildDetailRow('损耗类型', record['lossType']),
            _buildDetailRow('损耗数量', record['lossQuantity'].toString()),
            _buildDetailRow('单价', '¥${record['unitPrice'].toStringAsFixed(2)}'),
            _buildDetailRow('总损失', '¥${record['totalLoss'].toStringAsFixed(2)}'),
            _buildDetailRow('损耗日期', record['lossDate']),
            _buildDetailRow('操作员', record['operator']),
            _buildDetailRow('损耗原因', record['reason']),
            _buildDetailRow('状态', record['status']),
            if (record['approver'].isNotEmpty) ...[
              _buildDetailRow('审核人', record['approver']),
              _buildDetailRow('审核日期', record['approveDate']),
            ],
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

  void _approveLoss(Map<String, dynamic> record) {
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
                      '确定要审核通过损耗记录 ${record['id']} 吗？',
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
                record['status'] = '已确认';
                record['approver'] = '当前用户';
                record['approveDate'] = DateTime.now().toString().substring(0, 10);
                _filterRecords();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('损耗记录已审核通过'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _rejectLoss(Map<String, dynamic> record) {
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
                      '确定要拒绝损耗记录 ${record['id']} 吗？',
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
                  content: Text('损耗记录已拒绝'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _deleteLoss(Map<String, dynamic> record) {
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
                      '确定要删除损耗记录 ${record['id']} 吗？\n此操作不可撤销。',
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
                _lossRecords.removeWhere((r) => r['id'] == record['id']);
                _filterRecords();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('损耗记录已删除'),
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