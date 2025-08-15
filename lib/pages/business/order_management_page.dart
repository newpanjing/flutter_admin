import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_dialog.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  State<OrderManagementPage> createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = '全部';
  String _selectedType = '全部';
  
  // 订单数据
  final List<OrderModel> _orders = [
    OrderModel(
      id: 'ORD001',
      customerName: '张三',
      customerPhone: '13800138001',
      products: [
        OrderProduct(name: '产品A', quantity: 2, price: 100.0),
        OrderProduct(name: '产品B', quantity: 1, price: 200.0),
      ],
      totalAmount: 400.0,
      status: '待付款',
      type: '销售订单',
      createTime: DateTime.now().subtract(const Duration(hours: 2)),
      deliveryAddress: '北京市朝阳区示例街道123号',
      remark: '客户要求尽快发货',
    ),
    OrderModel(
      id: 'ORD002',
      customerName: '李四',
      customerPhone: '13800138002',
      products: [
        OrderProduct(name: '产品C', quantity: 3, price: 150.0),
      ],
      totalAmount: 450.0,
      status: '已付款',
      type: '销售订单',
      createTime: DateTime.now().subtract(const Duration(hours: 5)),
      deliveryAddress: '上海市浦东新区示例路456号',
      remark: '',
    ),
    OrderModel(
      id: 'ORD003',
      customerName: '王五',
      customerPhone: '13800138003',
      products: [
        OrderProduct(name: '产品D', quantity: 1, price: 300.0),
        OrderProduct(name: '产品E', quantity: 2, price: 80.0),
      ],
      totalAmount: 460.0,
      status: '配送中',
      type: '销售订单',
      createTime: DateTime.now().subtract(const Duration(days: 1)),
      deliveryAddress: '广州市天河区示例大道789号',
      remark: '送货时间：工作日上午',
    ),
    OrderModel(
      id: 'PUR001',
      customerName: '供应商A',
      customerPhone: '13800138004',
      products: [
        OrderProduct(name: '原料A', quantity: 100, price: 50.0),
      ],
      totalAmount: 5000.0,
      status: '已完成',
      type: '采购订单',
      createTime: DateTime.now().subtract(const Duration(days: 3)),
      deliveryAddress: '仓库地址',
      remark: '质量检验合格',
    ),
  ];

  List<OrderModel> get _filteredOrders {
    return _orders.where((order) {
      final matchesSearch = order.id.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          order.customerName.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesStatus = _selectedStatus == '全部' || order.status == _selectedStatus;
      final matchesType = _selectedType == '全部' || order.type == _selectedType;
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
                    '订单管理',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '管理销售订单和采购订单',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildStatCard('总订单', '${_orders.length}', AppTheme.successGreen),
                  const SizedBox(width: 16),
                  _buildStatCard('待处理', '${_orders.where((o) => o.status == '待付款').length}', AppTheme.warningYellow),
                  const SizedBox(width: 16),
                  _buildStatCard('已完成', '${_orders.where((o) => o.status == '已完成').length}', AppTheme.primaryBlue),
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
                            hintText: '搜索订单号或客户名称...',
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
                          labelText: '订单状态',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: ['全部', '待付款', '已付款', '配送中', '已完成', '已取消']
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
                          labelText: '订单类型',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: ['全部', '销售订单', '采购订单']
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
                      text: '新增订单',
                      icon: Icons.add,
                      onPressed: () => _showAddOrderDialog(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // 订单列表
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '订单列表 (${_filteredOrders.length})',
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
                          label: Text('订单号'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('客户信息'),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                          label: Text('订单类型'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('订单金额'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('订单状态'),
                          size: ColumnSize.S,
                        ),
                        DataColumn2(
                          label: Text('创建时间'),
                          size: ColumnSize.M,
                        ),
                        DataColumn2(
                          label: Text('操作'),
                          size: ColumnSize.M,
                        ),
                      ],
                      rows: _filteredOrders.map((order) {
                        return DataRow2(
                          cells: [
                            DataCell(
                              Text(
                                order.id,
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
                                    order.customerName,
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    order.customerPhone,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: order.type == '销售订单' 
                                      ? AppTheme.successGreen.withOpacity(0.1)
                                      : AppTheme.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  order.type,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: order.type == '销售订单' 
                                        ? AppTheme.successGreen
                                        : AppTheme.primaryBlue,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '¥${order.totalAmount.toStringAsFixed(2)}',
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
                                  color: _getStatusColor(order.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  order.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _getStatusColor(order.status),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${order.createTime.month}/${order.createTime.day} ${order.createTime.hour.toString().padLeft(2, '0')}:${order.createTime.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility, size: 18),
                                    onPressed: () => _showOrderDetails(order),
                                    tooltip: '查看详情',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () => _showEditOrderDialog(order),
                                    tooltip: '编辑',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                    onPressed: () => _showDeleteConfirmDialog(order),
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
      case '待付款':
        return AppTheme.warningYellow;
      case '已付款':
        return AppTheme.primaryBlue;
      case '配送中':
        return const Color(0xFF9C27B0);
      case '已完成':
        return AppTheme.successGreen;
      case '已取消':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showAddOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddOrderDialog(),
    );
  }

  void _showEditOrderDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => EditOrderDialog(order: order),
    );
  }

  void _showOrderDetails(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => OrderDetailsDialog(order: order),
    );
  }

  void _showDeleteConfirmDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除订单 ${order.id} 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _orders.remove(order);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('订单删除成功')),
              );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// 订单数据模型
class OrderModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final List<OrderProduct> products;
  final double totalAmount;
  final String status;
  final String type;
  final DateTime createTime;
  final String deliveryAddress;
  final String remark;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.products,
    required this.totalAmount,
    required this.status,
    required this.type,
    required this.createTime,
    required this.deliveryAddress,
    required this.remark,
  });
}

class OrderProduct {
  final String name;
  final int quantity;
  final double price;

  OrderProduct({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

// 新增订单对话框
class AddOrderDialog extends StatefulWidget {
  const AddOrderDialog({super.key});

  @override
  State<AddOrderDialog> createState() => _AddOrderDialogState();
}

class _AddOrderDialogState extends State<AddOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _remarkController = TextEditingController();
  String _selectedType = '销售订单';
  final List<OrderProduct> _products = [];

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
                  Icon(Icons.add_shopping_cart, color: AppTheme.successGreen),
                  const SizedBox(width: 12),
                  const Text(
                    '新增订单',
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
                      // 基本信息
                      const Text(
                        '基本信息',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
                            child: TextFormField(
                              controller: _customerPhoneController,
                              decoration: const InputDecoration(
                                labelText: '联系电话',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return '请输入联系电话';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          labelText: '订单类型',
                          border: OutlineInputBorder(),
                        ),
                        items: ['销售订单', '采购订单']
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedType = value!),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _deliveryAddressController,
                        decoration: const InputDecoration(
                          labelText: '配送地址',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _remarkController,
                        decoration: const InputDecoration(
                          labelText: '备注信息',
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
        const SnackBar(content: Text('订单创建成功')),
      );
    }
  }
}

// 编辑订单对话框
class EditOrderDialog extends StatefulWidget {
  final OrderModel order;
  
  const EditOrderDialog({super.key, required this.order});

  @override
  State<EditOrderDialog> createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends State<EditOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _customerNameController;
  late TextEditingController _customerPhoneController;
  late TextEditingController _deliveryAddressController;
  late TextEditingController _remarkController;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _customerNameController = TextEditingController(text: widget.order.customerName);
    _customerPhoneController = TextEditingController(text: widget.order.customerPhone);
    _deliveryAddressController = TextEditingController(text: widget.order.deliveryAddress);
    _remarkController = TextEditingController(text: widget.order.remark);
    _selectedStatus = widget.order.status;
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
                    '编辑订单 - ${widget.order.id}',
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
                            child: TextFormField(
                              controller: _customerPhoneController,
                              decoration: const InputDecoration(
                                labelText: '联系电话',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: '订单状态',
                          border: OutlineInputBorder(),
                        ),
                        items: ['待付款', '已付款', '配送中', '已完成', '已取消']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedStatus = value!),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _deliveryAddressController,
                        decoration: const InputDecoration(
                          labelText: '配送地址',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _remarkController,
                        decoration: const InputDecoration(
                          labelText: '备注信息',
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
                        const SnackBar(content: Text('订单更新成功')),
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

// 订单详情对话框
class OrderDetailsDialog extends StatelessWidget {
  final OrderModel order;
  
  const OrderDetailsDialog({super.key, required this.order});

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
                  Text(
                    '订单详情 - ${order.id}',
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
                      _buildInfoRow('订单号', order.id),
                      _buildInfoRow('订单类型', order.type),
                      _buildInfoRow('订单状态', order.status),
                      _buildInfoRow('创建时间', '${order.createTime.year}-${order.createTime.month.toString().padLeft(2, '0')}-${order.createTime.day.toString().padLeft(2, '0')} ${order.createTime.hour.toString().padLeft(2, '0')}:${order.createTime.minute.toString().padLeft(2, '0')}'),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    // 客户信息
                    _buildInfoSection('客户信息', [
                      _buildInfoRow('客户名称', order.customerName),
                      _buildInfoRow('联系电话', order.customerPhone),
                      _buildInfoRow('配送地址', order.deliveryAddress),
                    ]),
                    
                    const SizedBox(height: 24),
                    
                    // 商品信息
                    const Text(
                      '商品信息',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Expanded(flex: 3, child: Text('商品名称', style: TextStyle(fontWeight: FontWeight.w600))),
                                Expanded(flex: 1, child: Text('数量', style: TextStyle(fontWeight: FontWeight.w600))),
                                Expanded(flex: 1, child: Text('单价', style: TextStyle(fontWeight: FontWeight.w600))),
                                Expanded(flex: 1, child: Text('小计', style: TextStyle(fontWeight: FontWeight.w600))),
                              ],
                            ),
                          ),
                          ...order.products.map((product) => Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: AppColors.borderColor)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Text(product.name)),
                                Expanded(flex: 1, child: Text('${product.quantity}')),
                                Expanded(flex: 1, child: Text('¥${product.price.toStringAsFixed(2)}')),
                                Expanded(flex: 1, child: Text('¥${(product.quantity * product.price).toStringAsFixed(2)}')),
                              ],
                            ),
                          )).toList(),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.successGreen.withOpacity(0.1),
                              border: const Border(top: BorderSide(color: AppColors.borderColor)),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Expanded(flex: 5, child: Text('总计', style: TextStyle(fontWeight: FontWeight.w600))),
                                Expanded(flex: 1, child: Text('¥${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.successGreen))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    if (order.remark.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildInfoSection('备注信息', [
                        _buildInfoRow('备注', order.remark),
                      ]),
                    ],
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