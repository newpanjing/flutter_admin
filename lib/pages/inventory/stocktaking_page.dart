import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_dialog.dart';

class StocktakingPage extends StatefulWidget {
  const StocktakingPage({super.key});

  @override
  State<StocktakingPage> createState() => _StocktakingPageState();
}

class _StocktakingPageState extends State<StocktakingPage> {
  final List<Map<String, dynamic>> _stocktakingRecords = [
    {
      'id': 'ST001',
      'title': '2024年第一季度盘点',
      'warehouse': '主仓库',
      'startDate': '2024-01-15',
      'endDate': '2024-01-17',
      'status': '已完成',
      'operator': '张三',
      'totalItems': 1250,
      'checkedItems': 1250,
      'discrepancies': 15,
      'accuracy': 98.8,
      'description': '季度例行盘点',
    },
    {
      'id': 'ST002',
      'title': '电子产品专项盘点',
      'warehouse': '副仓库',
      'startDate': '2024-01-20',
      'endDate': '2024-01-21',
      'status': '进行中',
      'operator': '李四',
      'totalItems': 350,
      'checkedItems': 280,
      'discrepancies': 3,
      'accuracy': 99.1,
      'description': '电子产品类别专项盘点',
    },
    {
      'id': 'ST003',
      'title': '办公用品盘点',
      'warehouse': '主仓库',
      'startDate': '2024-01-10',
      'endDate': '2024-01-12',
      'status': '已完成',
      'operator': '王五',
      'totalItems': 800,
      'checkedItems': 800,
      'discrepancies': 8,
      'accuracy': 99.0,
      'description': '办公用品类别盘点',
    },
  ];

  List<Map<String, dynamic>> _filteredRecords = [];
  String _searchQuery = '';
  String _selectedStatus = '全部';
  String _selectedWarehouse = '全部';

  @override
  void initState() {
    super.initState();
    _filteredRecords = List.from(_stocktakingRecords);
  }

  void _filterRecords() {
    setState(() {
      _filteredRecords = _stocktakingRecords.where((record) {
        final matchesSearch = record['title']
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
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.inventory_outlined,
                        color: const Color(0xFF4CAF50),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '盘点管理',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '管理库存盘点任务和盘点结果',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ModernButton(
                      text: '新建盘点',
                      icon: Icons.add,
                      onPressed: () => _showAddStocktakingDialog(),
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
                            hintText: '搜索盘点标题或编号...',
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
                          items: ['全部', '进行中', '已完成', '已暂停'].map((status) {
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
                _buildStatCard('本月盘点', '3', '次', const Color(0xFF4CAF50)),
                const SizedBox(width: 16),
                _buildStatCard('平均准确率', '98.9', '%', AppTheme.primaryBlue),
                const SizedBox(width: 16),
                _buildStatCard('总差异数', '26', '项', Colors.orange),
                const SizedBox(width: 16),
                _buildStatCard('进行中', '1', '项', AppTheme.warningYellow),
              ],
            ),
          ),
          
          // 盘点记录列表
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
                        _buildTableHeader('盘点编号', flex: 2),
                        _buildTableHeader('盘点标题', flex: 3),
                        _buildTableHeader('仓库', flex: 2),
                        _buildTableHeader('盘点时间', flex: 2),
                        _buildTableHeader('进度', flex: 2),
                        _buildTableHeader('准确率', flex: 1),
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
                    Icons.inventory,
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
    final progress = (record['checkedItems'] / record['totalItems'] * 100).toInt();
    
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
          // 盘点编号
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
          
          // 盘点标题
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record['title'],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  record['description'],
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
            flex: 2,
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
          
          // 盘点时间
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record['startDate']}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '至 ${record['endDate']}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // 进度
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$progress%',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: AppColors.borderColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress == 100 ? const Color(0xFF4CAF50) : AppTheme.warningYellow,
                  ),
                ),
              ],
            ),
          ),
          
          // 准确率
          Expanded(
            flex: 1,
            child: Text(
              '${record['accuracy']}%',
              style: TextStyle(
                color: record['accuracy'] >= 99 
                    ? const Color(0xFF4CAF50) 
                    : record['accuracy'] >= 95 
                        ? AppTheme.warningYellow 
                        : Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
                  onPressed: () => _showStocktakingDetail(record),
                  icon: const Icon(
                    Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  tooltip: '查看详情',
                ),
                IconButton(
                  onPressed: record['status'] == '进行中' 
                      ? () => _editStocktaking(record) 
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
                      ? () => _deleteStocktaking(record) 
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
      case '已暂停':
        return Colors.orange;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showAddStocktakingDialog() {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '新建盘点',
        titleIcon: Icons.add,
        width: 600,
        content: _buildStocktakingForm(),
        actions: [
          ModernButton(
            text: '取消',
            type: ButtonType.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          ModernButton(
            text: '创建盘点',
            onPressed: () {
              // 处理创建盘点逻辑
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('盘点任务已创建'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStocktakingForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: ModernFormField(
                label: '盘点标题',
                hint: '请输入盘点标题',
                prefixIcon: Icons.title,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernDropdown<String>(
                label: '盘点仓库',
                hint: '请选择盘点仓库',
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
                label: '开始日期',
                hint: '请选择开始日期',
                prefixIcon: Icons.calendar_today,
                readOnly: true,
                onTap: () {
                  // 显示日期选择器
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernFormField(
                label: '结束日期',
                hint: '请选择结束日期',
                prefixIcon: Icons.calendar_today,
                readOnly: true,
                onTap: () {
                  // 显示日期选择器
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ModernDropdown<String>(
          label: '盘点类型',
          hint: '请选择盘点类型',
          items: ['全盘', '抽盘', '循环盘点', '专项盘点'],
          itemBuilder: (item) => item,
          prefixIcon: Icons.category,
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: '盘点描述',
          hint: '请输入盘点描述',
          maxLines: 3,
          prefixIcon: Icons.description_outlined,
        ),
      ],
    );
  }

  void _showStocktakingDetail(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: '盘点详情',
        titleIcon: Icons.info_outline,
        width: 600,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('盘点编号', record['id']),
            _buildDetailRow('盘点标题', record['title']),
            _buildDetailRow('盘点仓库', record['warehouse']),
            _buildDetailRow('开始日期', record['startDate']),
            _buildDetailRow('结束日期', record['endDate']),
            _buildDetailRow('操作员', record['operator']),
            _buildDetailRow('总商品数', record['totalItems'].toString()),
            _buildDetailRow('已盘点数', record['checkedItems'].toString()),
            _buildDetailRow('差异数量', record['discrepancies'].toString()),
            _buildDetailRow('盘点准确率', '${record['accuracy']}%'),
            _buildDetailRow('状态', record['status']),
            _buildDetailRow('描述', record['description']),
          ],
        ),
        actions: [
          ModernButton(
            text: '关闭',
            type: ButtonType.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          if (record['status'] == '进行中') ...[
            ModernButton(
              text: '继续盘点',
              onPressed: () {
                Navigator.of(context).pop();
                // 跳转到盘点执行页面
              },
            ),
          ],
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

  void _editStocktaking(Map<String, dynamic> record) {
    // 编辑盘点记录的逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('编辑功能开发中...'),
        backgroundColor: AppTheme.warningYellow,
      ),
    );
  }

  void _deleteStocktaking(Map<String, dynamic> record) {
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
                      '确定要删除盘点任务 ${record['id']} 吗？\n此操作不可撤销。',
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
                _stocktakingRecords.removeWhere((r) => r['id'] == record['id']);
                _filterRecords();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('盘点任务已删除'),
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