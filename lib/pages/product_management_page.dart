import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/modern_dialog.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  final List<Product> _products = [
    Product(
      id: 'P001',
      name: 'iPhone 15 Pro',
      barcode: '1234567890123',
      imageUrl: 'https://via.placeholder.com/150x150/2E7D32/FFFFFF?text=iPhone',
      category: '电子产品',
      price: 7999.00,
      stock: 50,
      unit: '台',
      description: '苹果最新旗舰手机',
      status: '在售',
      createTime: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Product(
      id: 'P002',
      name: 'MacBook Pro 14"',
      barcode: '2345678901234',
      imageUrl: 'https://via.placeholder.com/150x150/2E7D32/FFFFFF?text=MacBook',
      category: '电子产品',
      price: 14999.00,
      stock: 25,
      unit: '台',
      description: '专业级笔记本电脑',
      status: '在售',
      createTime: DateTime.now().subtract(const Duration(days: 25)),
    ),
    Product(
      id: 'P003',
      name: 'AirPods Pro',
      barcode: '3456789012345',
      imageUrl: 'https://via.placeholder.com/150x150/2E7D32/FFFFFF?text=AirPods',
      category: '配件',
      price: 1899.00,
      stock: 100,
      unit: '副',
      description: '主动降噪无线耳机',
      status: '在售',
      createTime: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Product(
      id: 'P004',
      name: 'iPad Air',
      barcode: '4567890123456',
      imageUrl: 'https://via.placeholder.com/150x150/2E7D32/FFFFFF?text=iPad',
      category: '电子产品',
      price: 4399.00,
      stock: 0,
      unit: '台',
      description: '轻薄平板电脑',
      status: '缺货',
      createTime: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Product(
      id: 'P005',
      name: 'Apple Watch Series 9',
      barcode: '5678901234567',
      imageUrl: 'https://via.placeholder.com/150x150/2E7D32/FFFFFF?text=Watch',
      category: '配件',
      price: 2999.00,
      stock: 75,
      unit: '块',
      description: '智能手表',
      status: '在售',
      createTime: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  String _searchQuery = '';
  String _selectedCategory = '全部';
  String _selectedStatus = '全部';
  final List<String> _categories = ['全部', '电子产品', '配件', '服装', '食品', '其他'];
  final List<String> _statusOptions = ['全部', '在售', '缺货', '停售'];

  List<Product> get _filteredProducts {
    return _products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           product.id.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == '全部' || product.category == _selectedCategory;
      final matchesStatus = _selectedStatus == '全部' || product.status == _selectedStatus;
      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(
            child: _buildProductList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppTheme.primaryWhite,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const FaIcon(
              FontAwesomeIcons.boxOpen,
              color: AppTheme.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '商品管理',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '管理商品信息、库存状态和价格设置',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showAddProductDialog(),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('新增商品'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppTheme.primaryWhite,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 搜索框
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: '搜索商品名称或编号...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.primaryBlue),
                ),
                filled: true,
                fillColor: AppColors.backgroundGray,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 分类筛选
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (value) => setState(() => _selectedCategory = value!),
              decoration: InputDecoration(
                labelText: '商品分类',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: AppColors.backgroundGray,
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 16),
          // 状态筛选
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              onChanged: (value) => setState(() => _selectedStatus = value!),
              decoration: InputDecoration(
                labelText: '商品状态',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: AppColors.backgroundGray,
              ),
              items: _statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    final filteredProducts = _filteredProducts;
    
    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              '暂无商品数据',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '点击右上角"新增商品"按钮添加商品',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 表头
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.backgroundGray,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    '商品信息',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    '分类',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    '价格',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    '库存',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    '状态',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 100,
                  child: Text(
                    '操作',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // 商品列表
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return _buildProductItem(product, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Product product, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
          // 商品图片
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.borderColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.backgroundGray,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppColors.textMuted,
                            size: 24,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: AppColors.backgroundGray,
                      child: const Icon(
                        Icons.image,
                        color: AppColors.textMuted,
                        size: 24,
                      ),
                    ),
            ),
          ),
          // 商品信息
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '编号: ${product.id}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '条码: ${product.barcode}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                if (product.description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // 分类
          Expanded(
            child: Text(
              product.category,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          // 价格
          Expanded(
            child: Text(
              '¥${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
          // 库存
          Expanded(
            child: Row(
              children: [
                Text(
                  '${product.stock}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: product.stock > 0 ? AppColors.textPrimary : Colors.red,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  product.unit,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // 状态
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(product.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                product.status,
                style: TextStyle(
                  color: _getStatusColor(product.status),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // 操作按钮
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _showEditProductDialog(product),
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppTheme.primaryBlue,
                  ),
                  tooltip: '编辑',
                ),
                IconButton(
                  onPressed: () => _showDeleteConfirmDialog(product),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red,
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
      case '在售':
        return Colors.green;
      case '缺货':
        return Colors.red;
      case '停售':
        return Colors.orange;
      default:
        return AppColors.textMuted;
    }
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => _ProductDialog(
        onSave: (product) {
          setState(() {
            _products.add(product);
          });
        },
      ),
    );
  }

  void _showEditProductDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) => _ProductDialog(
        product: product,
        onSave: (updatedProduct) {
          setState(() {
            final index = _products.indexWhere((p) => p.id == product.id);
            if (index != -1) {
              _products[index] = updatedProduct;
            }
          });
        },
      ),
    );
  }

  void _showDeleteConfirmDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除商品"${product.name}"吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _products.removeWhere((p) => p.id == product.id);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('商品"${product.name}"已删除'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}

class _ProductDialog extends StatefulWidget {
  final Product? product;
  final Function(Product) onSave;

  const _ProductDialog({
    this.product,
    required this.onSave,
  });

  @override
  State<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<_ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _barcodeController;
  late TextEditingController _imageUrlController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _unitController;
  late TextEditingController _descriptionController;
  String _selectedCategory = '电子产品';
  String _selectedStatus = '在售';

  final List<String> _categories = ['电子产品', '配件', '服装', '食品', '其他'];
  final List<String> _statusOptions = ['在售', '缺货', '停售'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _barcodeController = TextEditingController(text: widget.product?.barcode ?? '');
    _imageUrlController = TextEditingController(text: widget.product?.imageUrl ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _stockController = TextEditingController(text: widget.product?.stock.toString() ?? '');
    _unitController = TextEditingController(text: widget.product?.unit ?? '台');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _selectedCategory = widget.product?.category ?? '电子产品';
    _selectedStatus = widget.product?.status ?? '在售';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _unitController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product == null ? '新增商品' : '编辑商品',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              // 商品名称
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '商品名称',
                  hintText: '请输入商品名称',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入商品名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 条码和图片URL
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _barcodeController,
                      decoration: const InputDecoration(
                        labelText: '商品条码',
                        hintText: '请输入商品条码',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入商品条码';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(
                        labelText: '商品图片URL',
                        hintText: '请输入图片链接',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // 分类和状态
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      onChanged: (value) => setState(() => _selectedCategory = value!),
                      decoration: const InputDecoration(
                        labelText: '商品分类',
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      onChanged: (value) => setState(() => _selectedStatus = value!),
                      decoration: const InputDecoration(
                        labelText: '商品状态',
                      ),
                      items: _statusOptions.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // 价格、库存和单位
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: '价格',
                        hintText: '0.00',
                        prefixText: '¥ ',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入价格';
                        }
                        if (double.tryParse(value) == null) {
                          return '请输入有效的价格';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(
                        labelText: '库存',
                        hintText: '0',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入库存';
                        }
                        if (int.tryParse(value) == null) {
                          return '请输入有效的库存数量';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: '单位',
                        hintText: '台',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入单位';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // 商品描述
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '商品描述',
                  hintText: '请输入商品描述（可选）',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              
              // 操作按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('取消'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveProduct,
                    child: Text(widget.product == null ? '添加' : '保存'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id ?? 'P${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        name: _nameController.text,
        barcode: _barcodeController.text,
        imageUrl: _imageUrlController.text,
        category: _selectedCategory,
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        unit: _unitController.text,
        description: _descriptionController.text,
        status: _selectedStatus,
        createTime: widget.product?.createTime ?? DateTime.now(),
      );
      
      widget.onSave(product);
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.product == null ? '商品添加成功' : '商品更新成功'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

class Product {
  final String id;
  final String name;
  final String barcode;
  final String imageUrl;
  final String category;
  final double price;
  final int stock;
  final String unit;
  final String description;
  final String status;
  final DateTime createTime;

  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.imageUrl,
    required this.category,
    required this.price,
    required this.stock,
    required this.unit,
    required this.description,
    required this.status,
    required this.createTime,
  });

  Product copyWith({
    String? id,
    String? name,
    String? barcode,
    String? imageUrl,
    String? category,
    double? price,
    int? stock,
    String? unit,
    String? description,
    String? status,
    DateTime? createTime,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      unit: unit ?? this.unit,
      description: description ?? this.description,
      status: status ?? this.status,
      createTime: createTime ?? this.createTime,
    );
  }
}