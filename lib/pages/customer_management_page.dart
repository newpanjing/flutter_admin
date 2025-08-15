import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../theme/app_theme.dart';
import '../models/customer_model.dart';
import '../widgets/custom_dropdown.dart';

class CustomerManagementPage extends StatefulWidget {
  const CustomerManagementPage({super.key});

  @override
  State<CustomerManagementPage> createState() => _CustomerManagementPageState();
}

class _CustomerManagementPageState extends State<CustomerManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // C端客户数据
  final List<CustomerModel> _cCustomers = [
    CustomerModel(
      id: '1',
      name: '王小明',
      contact: '王小明',
      phone: '138-0000-1234',
      email: 'wangxm@email.com',
      address: '广州市天河区珠江新城',
      type: '个人客户',
      status: '活跃',
      createTime: DateTime.now().subtract(const Duration(days: 15)),
      lastOrderTime: DateTime.now().subtract(const Duration(days: 2)),
      totalOrders: 5,
      totalAmount: 2500.0,
    ),
    CustomerModel(
      id: '2',
      name: '李小红',
      contact: '李小红',
      phone: '139-1111-2222',
      email: 'lixh@email.com',
      address: '深圳市南山区科技园',
      type: '个人客户',
      status: '潜在',
      createTime: DateTime.now().subtract(const Duration(days: 8)),
      lastOrderTime: null,
      totalOrders: 0,
      totalAmount: 0.0,
    ),
    CustomerModel(
      id: '3',
      name: '张三',
      contact: '张三',
      phone: '137-2222-3333',
      email: 'zhangsan@email.com',
      address: '上海市浦东新区',
      type: '个人客户',
      status: '休眠',
      createTime: DateTime.now().subtract(const Duration(days: 120)),
      lastOrderTime: DateTime.now().subtract(const Duration(days: 90)),
      totalOrders: 2,
      totalAmount: 800.0,
    ),
  ];
  
  // B端客户数据
  final List<CustomerModel> _bCustomers = [
    CustomerModel(
      id: '4',
      name: '北京科技有限公司',
      contact: '张经理',
      phone: '010-12345678',
      email: 'zhang@bjtech.com',
      address: '北京市海淀区中关村大街1号',
      type: '代理商',
      status: '活跃',
      createTime: DateTime.now().subtract(const Duration(days: 30)),
      lastOrderTime: DateTime.now().subtract(const Duration(days: 5)),
      totalOrders: 25,
      totalAmount: 125000.0,
    ),
    CustomerModel(
      id: '5',
      name: '上海贸易公司',
      contact: '李总',
      phone: '021-87654321',
      email: 'li@shtrade.com',
      address: '上海市浦东新区陆家嘴金融中心',
      type: '经销商',
      status: '活跃',
      createTime: DateTime.now().subtract(const Duration(days: 60)),
      lastOrderTime: DateTime.now().subtract(const Duration(days: 10)),
      totalOrders: 18,
      totalAmount: 89000.0,
    ),
    CustomerModel(
      id: '6',
      name: '广州供应链公司',
      contact: '陈总监',
      phone: '020-33334444',
      email: 'chen@gzsupply.com',
      address: '广州市天河区珠江新城CBD',
      type: '供货商',
      status: '活跃',
      createTime: DateTime.now().subtract(const Duration(days: 90)),
      lastOrderTime: DateTime.now().subtract(const Duration(days: 3)),
      totalOrders: 32,
      totalAmount: 156000.0,
    ),
    CustomerModel(
      id: '7',
      name: '深圳分销商',
      contact: '刘经理',
      phone: '0755-88889999',
      email: 'liu@szdist.com',
      address: '深圳市福田区CBD中心',
      type: '分销商',
      status: '潜在',
      createTime: DateTime.now().subtract(const Duration(days: 20)),
      lastOrderTime: null,
      totalOrders: 0,
      totalAmount: 0.0,
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 页面标题
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '客户管理',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '分类管理C端个人客户和B端企业客户',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              // 总体统计
              Row(
                children: [
                  _buildStatCard('C端客户', '${_cCustomers.length}', const Color(0xFF4CAF50)),
                  const SizedBox(width: 16),
                  _buildStatCard('B端客户', '${_bCustomers.length}', const Color(0xFF2196F3)),
                  const SizedBox(width: 16),
                  _buildStatCard('总客户', '${_cCustomers.length + _bCustomers.length}', const Color(0xFF9C27B0)),
                ],
              ),
            ],
          ),
        ),
        
        // 标签页
        Expanded(
          child: Card(
            child: Column(
              children: [
                // TabBar - Web风格设计
                Container(
                  height: 48,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFF2A2A2A),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft, // 左对齐
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true, // 允许滚动以支持左对齐
                      labelColor: const Color(0xFF4CAF50), // 前景色为主题色
                      unselectedLabelColor: const Color(0xFF888888),
                      indicatorColor: const Color(0xFF4CAF50), // 选中的底部下划线
                      indicatorWeight: 2,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      tabAlignment: TabAlignment.start, // 左对齐
                      tabs: [
                        Tab(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.person_outline, size: 16),
                                const SizedBox(width: 6),
                                Text('C端客户'),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4CAF50).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${_cCustomers.length}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.business_outlined, size: 16),
                                const SizedBox(width: 6),
                                Text('B端客户'),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2196F3).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${_bCustomers.length}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // TabBarView
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _CustomerListView(
                        customers: _cCustomers,
                        customerType: 'C端',
                        onAddCustomer: _addCCustomer,
                        onEditCustomer: _editCCustomer,
                        onDeleteCustomer: _deleteCCustomer,
                      ),
                      _CustomerListView(
                        customers: _bCustomers,
                        customerType: 'B端',
                        onAddCustomer: _addBCustomer,
                        onEditCustomer: _editBCustomer,
                        onDeleteCustomer: _deleteBCustomer,
                      ),
                    ],
                  ),
                ),
              ],
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
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  void _addCCustomer(CustomerModel customer) {
    setState(() {
      _cCustomers.add(customer.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createTime: DateTime.now(),
        totalOrders: 0,
        totalAmount: 0.0,
      ));
    });
  }
  
  void _addBCustomer(CustomerModel customer) {
    setState(() {
      _bCustomers.add(customer.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createTime: DateTime.now(),
        totalOrders: 0,
        totalAmount: 0.0,
      ));
    });
  }
  
  void _editCCustomer(CustomerModel customer) {
    setState(() {
      final index = _cCustomers.indexWhere((c) => c.id == customer.id);
      if (index != -1) {
        _cCustomers[index] = customer;
      }
    });
  }
  
  void _editBCustomer(CustomerModel customer) {
    setState(() {
      final index = _bCustomers.indexWhere((c) => c.id == customer.id);
      if (index != -1) {
        _bCustomers[index] = customer;
      }
    });
  }
  
  void _deleteCCustomer(String customerId) {
    setState(() {
      _cCustomers.removeWhere((c) => c.id == customerId);
    });
  }
  
  void _deleteBCustomer(String customerId) {
    setState(() {
      _bCustomers.removeWhere((c) => c.id == customerId);
    });
  }
}

class _CustomerListView extends StatefulWidget {
  final List<CustomerModel> customers;
  final String customerType;
  final Function(CustomerModel) onAddCustomer;
  final Function(CustomerModel) onEditCustomer;
  final Function(String) onDeleteCustomer;
  
  const _CustomerListView({
    required this.customers,
    required this.customerType,
    required this.onAddCustomer,
    required this.onEditCustomer,
    required this.onDeleteCustomer,
  });

  @override
  State<_CustomerListView> createState() => _CustomerListViewState();
}

class _CustomerListViewState extends State<_CustomerListView> {
  String _searchText = '';
  String _selectedType = '全部';
  String _selectedStatus = '全部';
  
  List<String> get _typeOptions {
    if (widget.customerType == 'C端') {
      return ['全部', '个人客户'];
    } else {
      return ['全部', '代理商', '经销商', '供货商', '分销商'];
    }
  }
  
  List<CustomerModel> get _filteredCustomers {
    return widget.customers.where((customer) {
      final matchesSearch = customer.name.toLowerCase().contains(_searchText.toLowerCase()) ||
                           customer.contact.toLowerCase().contains(_searchText.toLowerCase()) ||
                           customer.phone.contains(_searchText) ||
                           customer.email.toLowerCase().contains(_searchText.toLowerCase());
      final matchesType = _selectedType == '全部' || customer.type == _selectedType;
      final matchesStatus = _selectedStatus == '全部' || customer.status == _selectedStatus;
      
      return matchesSearch && matchesType && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搜索和筛选区域
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // 搜索框
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: '搜索客户名称、联系人、电话或邮箱',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // 客户类型筛选
                  Expanded(
                    child: CustomDropdown<String>(
                      value: _selectedType,
                      items: _typeOptions,
                      itemBuilder: (item) => item,
                      label: '客户类型',
                      prefixIcon: Icons.category_outlined,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // 状态筛选
                  Expanded(
                    child: CustomDropdown<String>(
                      value: _selectedStatus,
                      items: const ['全部', '活跃', '潜在', '休眠'],
                      itemBuilder: (item) => item,
                      label: '客户状态',
                      prefixIcon: Icons.info_outline,
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // 添加按钮
                  ElevatedButton.icon(
                    onPressed: () => _showAddCustomerDialog(),
                    icon: const Icon(Icons.add),
                    label: Text('添加${widget.customerType}客户'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // 客户列表
          Expanded(
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.customerType}客户列表 (${_filteredCustomers.length})',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            _buildStatChip('活跃', _filteredCustomers.where((c) => c.status == '活跃').length, const Color(0xFF4CAF50)),
                            const SizedBox(width: 8),
                            _buildStatChip('潜在', _filteredCustomers.where((c) => c.status == '潜在').length, const Color(0xFFFF9800)),
                            const SizedBox(width: 8),
                            _buildStatChip('休眠', _filteredCustomers.where((c) => c.status == '休眠').length, const Color(0xFFF44336)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 1000,
                        columns: const [
                          DataColumn2(
                            label: Text('客户名称'),
                            size: ColumnSize.L,
                          ),
                          DataColumn2(
                            label: Text('联系人'),
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                            label: Text('联系方式'),
                            size: ColumnSize.M,
                          ),
                          DataColumn2(
                            label: Text('类型'),
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                            label: Text('状态'),
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                            label: Text('订单数'),
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                            label: Text('总金额'),
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                            label: Text('操作'),
                            size: ColumnSize.M,
                          ),
                        ],
                        rows: _filteredCustomers.map((customer) {
                          return DataRow2(
                            cells: [
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      customer.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      customer.email,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(Text(customer.contact)),
                              DataCell(Text(customer.phone)),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getTypeColor(customer.type).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    customer.type,
                                    style: TextStyle(
                                      color: _getTypeColor(customer.type),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(customer.status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    customer.status,
                                    style: TextStyle(
                                      color: _getStatusColor(customer.status),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Text('${customer.totalOrders}')),
                              DataCell(
                                Text(
                                  '¥${customer.totalAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Color(0xFF4CAF50),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () => _showCustomerDetail(customer),
                                      icon: const Icon(
                                        Icons.visibility_outlined,
                                        size: 18,
                                      ),
                                      tooltip: '查看详情',
                                    ),
                                    IconButton(
                                      onPressed: () => _showEditCustomerDialog(customer),
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                      ),
                                      tooltip: '编辑',
                                    ),
                                    IconButton(
                                      onPressed: () => _deleteCustomer(customer),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                        color: Color(0xFFF44336),
                                      ),
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
      ),
    );
  }
  
  Widget _buildStatChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Color _getTypeColor(String type) {
    switch (type) {
      case '个人客户':
        return const Color(0xFF4CAF50);
      case '代理商':
        return const Color(0xFF2196F3);
      case '经销商':
        return const Color(0xFF9C27B0);
      case '供货商':
        return const Color(0xFFFF9800);
      case '分销商':
        return const Color(0xFF607D8B);
      default:
        return AppColors.textSecondary;
    }
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case '活跃':
        return const Color(0xFF4CAF50);
      case '潜在':
        return const Color(0xFFFF9800);
      case '休眠':
        return const Color(0xFFF44336);
      default:
        return AppColors.textSecondary;
    }
  }
  
  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) => _CustomerDialog(
        title: '添加${widget.customerType}客户',
        customerType: widget.customerType,
        onSave: widget.onAddCustomer,
      ),
    );
  }
  
  void _showEditCustomerDialog(CustomerModel customer) {
    showDialog(
      context: context,
      builder: (context) => _CustomerDialog(
        title: '编辑${widget.customerType}客户',
        customerType: widget.customerType,
        customer: customer,
        onSave: widget.onEditCustomer,
      ),
    );
  }
  
  void _showCustomerDetail(CustomerModel customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('客户详情 - ${customer.name}'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('客户名称', customer.name),
              _buildDetailRow('联系人', customer.contact),
              _buildDetailRow('联系电话', customer.phone),
              _buildDetailRow('邮箱地址', customer.email),
              _buildDetailRow('客户地址', customer.address),
              _buildDetailRow('客户类型', customer.type),
              _buildDetailRow('客户状态', customer.status),
              _buildDetailRow('创建时间', _formatDateTime(customer.createTime)),
              _buildDetailRow('最后下单', customer.lastOrderTime != null 
                  ? _formatDateTime(customer.lastOrderTime!) 
                  : '暂无订单'),
              _buildDetailRow('订单总数', '${customer.totalOrders}'),
              _buildDetailRow('累计金额', '¥${customer.totalAmount.toStringAsFixed(2)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
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
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  void _deleteCustomer(CustomerModel customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除客户 "${customer.name}" 吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onDeleteCustomer(customer.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('客户 ${customer.name} 已删除'),
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}

class _CustomerDialog extends StatefulWidget {
  final String title;
  final String customerType;
  final CustomerModel? customer;
  final Function(CustomerModel) onSave;
  
  const _CustomerDialog({
    required this.title,
    required this.customerType,
    this.customer,
    required this.onSave,
  });

  @override
  State<_CustomerDialog> createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<_CustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late String _selectedType;
  late String _selectedStatus;
  
  List<String> get _typeOptions {
    if (widget.customerType == 'C端') {
      return ['个人客户'];
    } else {
      return ['代理商', '经销商', '供货商', '分销商'];
    }
  }
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name ?? '');
    _contactController = TextEditingController(text: widget.customer?.contact ?? '');
    _phoneController = TextEditingController(text: widget.customer?.phone ?? '');
    _emailController = TextEditingController(text: widget.customer?.email ?? '');
    _addressController = TextEditingController(text: widget.customer?.address ?? '');
    _selectedType = widget.customer?.type ?? _typeOptions.first;
    _selectedStatus = widget.customer?.status ?? '潜在';
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '客户名称',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入客户名称';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: '联系人',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入联系人';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: '联系电话',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入联系电话';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: '邮箱地址',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入邮箱地址';
                    }
                    if (!value.contains('@')) {
                      return '请输入有效的邮箱地址';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: '客户地址',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入客户地址';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown<String>(
                        value: _selectedType,
                        items: _typeOptions,
                        itemBuilder: (item) => item,
                        label: '客户类型',
                        prefixIcon: Icons.category_outlined,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomDropdown<String>(
                        value: _selectedStatus,
                        items: const ['活跃', '潜在', '休眠'],
                        itemBuilder: (item) => item,
                        label: '客户状态',
                        prefixIcon: Icons.info_outline,
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _saveCustomer,
          child: const Text('保存'),
        ),
      ],
    );
  }
  
  void _saveCustomer() {
    if (_formKey.currentState!.validate()) {
      final customer = CustomerModel(
        id: widget.customer?.id ?? '',
        name: _nameController.text,
        contact: _contactController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        address: _addressController.text,
        type: _selectedType,
        status: _selectedStatus,
        createTime: widget.customer?.createTime ?? DateTime.now(),
        lastOrderTime: widget.customer?.lastOrderTime,
        totalOrders: widget.customer?.totalOrders ?? 0,
        totalAmount: widget.customer?.totalAmount ?? 0.0,
      );
      
      widget.onSave(customer);
      Navigator.of(context).pop();
    }
  }
}