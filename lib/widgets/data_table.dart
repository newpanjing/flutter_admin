import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductDataTable extends StatefulWidget {
  const ProductDataTable({super.key});

  @override
  State<ProductDataTable> createState() => _ProductDataTableState();
}

class _ProductDataTableState extends State<ProductDataTable> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _sortColumn = 'name';
  bool _sortAscending = true;
  int _currentPage = 0;
  final int _rowsPerPage = 10;
  String _selectedCategory = '全部类别';
  
  // 类别选项
  final List<String> _categories = ['全部类别', '电子产品', '服装', '食品', '图书'];
  
  // 批量选择相关状态
  Set<int> _selectedItems = <int>{};
  bool _selectAll = false;

  int get _totalPages => (_filteredProducts.length / _rowsPerPage).ceil();

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadMockData() {
    _products = [
      Product(
        id: '1',
        name: 'iPhone 15 Pro',
        category: '电子产品',
        price: 7999.0,
        stock: 25,
        unit: '台',
        description: '最新款苹果手机，配备A17 Pro芯片',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: '2',
        name: '小米13 Ultra',
        category: '电子产品',
        price: 5999.0,
        stock: 15,
        unit: '台',
        description: '徕卡影像旗舰手机',
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: '3',
        name: '优衣库基础T恤',
        category: '服装',
        price: 99.0,
        stock: 200,
        unit: '件',
        description: '100%纯棉，多色可选',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: '4',
        name: '星巴克咖啡豆',
        category: '食品',
        price: 128.0,
        stock: 50,
        unit: '包',
        description: '中度烘焙，香味浓郁',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: '5',
        name: '《Flutter实战》',
        category: '图书',
        price: 89.0,
        stock: 30,
        unit: '本',
        description: 'Flutter开发入门到精通',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
      ),
    ];
    _filteredProducts = List.from(_products);
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        // 文本搜索条件
        bool matchesText = query.isEmpty ||
            product.name.toLowerCase().contains(query) ||
            product.category.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);
        
        // 类别筛选条件
        bool matchesCategory = _selectedCategory == '全部类别' ||
            product.category == _selectedCategory;
        
        return matchesText && matchesCategory;
      }).toList();
      _currentPage = 0; // 重置到第一页
     });
   }
   
   void _resetSearch() {
     setState(() {
       _searchController.clear();
       _selectedCategory = '全部';
       _filteredProducts = List.from(_products);
     });
   }
  
  // 批量选择相关方法
  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      if (_selectAll) {
        _selectedItems = Set.from(List.generate(_filteredProducts.length, (index) => index));
      } else {
        _selectedItems.clear();
      }
    });
  }
  
  void _toggleItemSelection(int index) {
    setState(() {
      if (_selectedItems.contains(index)) {
        _selectedItems.remove(index);
      } else {
        _selectedItems.add(index);
      }
      _selectAll = _selectedItems.length == _filteredProducts.length;
    });
  }
  
  // 批量删除
  void _batchDelete() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择要删除的商品')),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除选中的 ${_selectedItems.length} 个商品吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // 按索引倒序删除，避免索引变化问题
                final sortedIndices = _selectedItems.toList()..sort((a, b) => b.compareTo(a));
                for (int index in sortedIndices) {
                  if (index < _filteredProducts.length) {
                    _products.remove(_filteredProducts[index]);
                  }
                }
                _performSearch(); // 重新搜索以更新显示
                _selectedItems.clear();
                _selectAll = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('删除成功')),
              );
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
  
  // 导入功能
  void _importData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.file_upload_outlined, color: Color(0xFF1976D2)),
            SizedBox(width: 8),
            Text('导入商品数据'),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '支持导入Excel文件(.xlsx, .xls)，请确保文件格式正确：',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('文件格式要求：', style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text('• 第一行为表头：商品名称、类别、价格、库存、描述'),
                    Text('• 价格列请使用数字格式'),
                    Text('• 库存列请使用整数格式'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF1976D2), style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 32, color: Color(0xFF1976D2)),
                    SizedBox(height: 8),
                    Text('点击选择文件或拖拽文件到此处', style: TextStyle(color: Color(0xFF1976D2))),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // 模拟导入成功
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('导入成功！已添加 5 个商品'),
                  backgroundColor: Colors.green,
                ),
              );
              // 这里可以添加实际的导入逻辑
              _addMockImportedProducts();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
            ),
            child: const Text('开始导入'),
          ),
        ],
      ),
    );
  }
  
  // 模拟添加导入的商品
  void _addMockImportedProducts() {
    final importedProducts = [
      Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: '导入商品1',
        category: '电子产品',
        price: 299.99,
        stock: 50,
        unit: '件',
        description: '通过Excel导入的商品',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        name: '导入商品2',
        category: '服装',
        price: 199.99,
        stock: 30,
        unit: '件',
        description: '通过Excel导入的商品',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
    
    setState(() {
      _products.addAll(importedProducts);
      _performSearch(); // 刷新显示
    });
  }
  
  // 导出功能
  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.file_download_outlined, color: Color(0xFF1976D2)),
            SizedBox(width: 8),
            Text('导出商品数据'),
          ],
        ),
        content: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('选择导出格式：', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF1976D2)),
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFE3F2FD),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.table_chart, color: Color(0xFF1976D2)),
                          SizedBox(height: 4),
                          Text('Excel (.xlsx)', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.description, color: Colors.grey),
                          SizedBox(height: 4),
                          Text('CSV (.csv)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('导出范围：', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF1976D2), size: 16),
                        const SizedBox(width: 8),
                        Text('当前页面数据 (${_filteredProducts.length} 条)'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 16),
                        const SizedBox(width: 8),
                        Text('全部数据 (${_products.length} 条)', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // 模拟导出成功
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('导出成功！已导出 ${_filteredProducts.length} 条商品数据'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
            ),
            child: const Text('开始导出'),
          ),
        ],
      ),
    );
  }
  
  // 打印功能
  void _printData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.print_outlined, color: Color(0xFF1976D2)),
            SizedBox(width: 8),
            Text('打印商品列表'),
          ],
        ),
        content: SizedBox(
          width: 400,
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('打印设置：', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.description, size: 16),
                        const SizedBox(width: 8),
                        Text('打印内容：当前筛选的商品列表 (${_filteredProducts.length} 条)'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.format_size, size: 16),
                        SizedBox(width: 8),
                        Text('纸张大小：A4'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.rotate_90_degrees_ccw, size: 16),
                        SizedBox(width: 8),
                        Text('方向：横向'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('打印预览：', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1976D2),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '商品列表报表',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('打印时间：${DateTime.now().toString().substring(0, 19)}'),
                              const SizedBox(height: 4),
                              Text('商品总数：${_filteredProducts.length} 条'),
                              const SizedBox(height: 8),
                              const Text('包含字段：商品名称、类别、价格、库存、单位'),
                              const SizedBox(height: 8),
                              const Expanded(
                                child: Center(
                                  child: Icon(Icons.table_view, size: 48, color: Colors.grey),
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // 模拟打印成功
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('打印任务已发送！共 ${_filteredProducts.length} 条商品数据'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
            ),
            child: const Text('开始打印'),
          ),
        ],
      ),
    );
  }

  void _sortData(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }

      _filteredProducts.sort((a, b) {
        dynamic aValue, bValue;
        switch (column) {
          case 'name':
            aValue = a.name;
            bValue = b.name;
            break;
          case 'category':
            aValue = a.category;
            bValue = b.category;
            break;
          case 'price':
            aValue = a.price;
            bValue = b.price;
            break;
          case 'stock':
            aValue = a.stock;
            bValue = b.stock;
            break;
          case 'createdAt':
            aValue = a.createdAt;
            bValue = b.createdAt;
            break;
          default:
            aValue = a.name;
            bValue = b.name;
        }

        if (_sortAscending) {
          return aValue.compareTo(bValue);
        } else {
          return bValue.compareTo(aValue);
        }
      });
    });
  }

  List<Product> _getCurrentPageData() {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, _filteredProducts.length);
    return _filteredProducts.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 页面标题
            const Text(
              '商品管理',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 24),
            
            // 搜索栏
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 搜索输入框
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: '搜索商品名称、类别或描述...',
                        prefixIcon: Icon(Icons.search, color: Color(0xFF1976D2)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Color(0xFF1976D2)),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // 类别下拉选择
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: '类别',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Color(0xFF1976D2)),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // 搜索按钮
                  ElevatedButton.icon(
                    onPressed: _performSearch,
                    icon: const Icon(Icons.search, size: 18),
                    label: const Text('搜索'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // 重置按钮
                  OutlinedButton.icon(
                    onPressed: _resetSearch,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('重置'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1976D2),
                      side: const BorderSide(color: Color(0xFF1976D2)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // 操作按钮栏
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 批量操作提示
                  if (_selectedItems.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1976D2).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '已选择 ${_selectedItems.length} 项',
                        style: const TextStyle(
                          color: Color(0xFF1976D2),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (_selectedItems.isNotEmpty) const SizedBox(width: 16),
                  
                  // 新增按钮
                  ElevatedButton.icon(
                    onPressed: _showAddProductDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('新增'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // 批量删除按钮
                  ElevatedButton.icon(
                    onPressed: _selectedItems.isNotEmpty ? _batchDelete : null,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('删除'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedItems.isNotEmpty ? Colors.red : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // 导入按钮
                  OutlinedButton.icon(
                    onPressed: _importData,
                    icon: const Icon(Icons.file_upload_outlined, size: 18),
                    label: const Text('导入'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1976D2),
                      side: const BorderSide(color: Color(0xFF1976D2)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // 导出按钮
                  OutlinedButton.icon(
                    onPressed: _exportData,
                    icon: const Icon(Icons.file_download_outlined, size: 18),
                    label: const Text('导出'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1976D2),
                      side: const BorderSide(color: Color(0xFF1976D2)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // 打印按钮
                  OutlinedButton.icon(
                    onPressed: _printData,
                    icon: const Icon(Icons.print_outlined, size: 18),
                    label: const Text('打印'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1976D2),
                      side: const BorderSide(color: Color(0xFF1976D2)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // 数据表格
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          // 全选复选框
                          Expanded(
                            flex: 1,
                            child: Checkbox(
                              value: _selectAll,
                              onChanged: _toggleSelectAll,
                              activeColor: const Color(0xFF1976D2),
                            ),
                          ),
                          _buildHeaderCell('商品信息', 'name', flex: 3),
                          _buildHeaderCell('类别', 'category', flex: 2),
                          _buildHeaderCell('价格', 'price', flex: 2),
                          _buildHeaderCell('库存', 'stock', flex: 2),
                          _buildHeaderCell('创建时间', 'createdAt', flex: 2),
                          _buildHeaderCell('操作', '', flex: 2),
                        ],
                      ),
                    ),
                    
                    // 数据行
                    Expanded(
                      child: _filteredProducts.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 64,
                                    color: Color(0xFFBDBDBD),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '暂无商品数据',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF757575),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _getCurrentPageData().length,
                              itemBuilder: (context, index) {
                                final product = _getCurrentPageData()[index];
                                return _buildDataRow(product, index);
                              },
                            ),
                    ),
                    
                    // 分页控件
                    if (_filteredProducts.isNotEmpty) _buildPaginationControls(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String title, String column, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: column.isNotEmpty ? () => _sortData(column) : null,
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF424242),
              ),
            ),
            if (column.isNotEmpty && _sortColumn == column) ...[
              const SizedBox(width: 4),
              Icon(
                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: const Color(0xFF1976D2),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(Product product, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: index.isEven ? Colors.white : const Color(0xFFFAFAFA),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // 复选框
          Expanded(
            flex: 1,
            child: Checkbox(
              value: _selectedItems.contains(index),
              onChanged: (bool? value) {
                _toggleItemSelection(index);
              },
              activeColor: const Color(0xFF1976D2),
            ),
          ),
          // 商品名称
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212121),
                  ),
                ),
                if (product.description.isNotEmpty)
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          // 类别
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getCategoryColor(product.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getCategoryColor(product.category).withOpacity(0.3),
                ),
              ),
              child: Text(
                product.category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _getCategoryColor(product.category),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // 价格
          Expanded(
            flex: 2,
            child: Text(
              '¥${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1976D2),
              ),
            ),
          ),
          // 库存
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: product.stock > 10
                        ? Colors.green
                        : product.stock > 0
                            ? Colors.orange
                            : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${product.stock} ${product.unit}',
                  style: TextStyle(
                    color: product.stock > 10
                        ? Colors.green[700]
                        : product.stock > 0
                            ? Colors.orange[700]
                            : Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // 创建时间
          Expanded(
            flex: 2,
            child: Text(
              _formatDate(product.createdAt),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
          // 操作按钮
          Expanded(
            flex: 2,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _showEditProductDialog(product),
                  icon: const Icon(Icons.edit_outlined),
                  color: const Color(0xFF1976D2),
                  tooltip: '编辑',
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showDeleteConfirmDialog(product),
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red[600],
                  tooltip: '删除',
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '显示 ${_currentPage * _rowsPerPage + 1}-${(_currentPage * _rowsPerPage + _getCurrentPageData().length)} 条，共 ${_filteredProducts.length} 条',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _currentPage > 0
                    ? () => setState(() => _currentPage--)
                    : null,
                icon: const Icon(Icons.chevron_left),
                color: const Color(0xFF1976D2),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${_currentPage + 1} / $_totalPages',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                onPressed: _currentPage < _totalPages - 1
                    ? () => setState(() => _currentPage++)
                    : null,
                icon: const Icon(Icons.chevron_right),
                color: const Color(0xFF1976D2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '电子产品':
        return const Color(0xFF2196F3);
      case '服装':
        return const Color(0xFF9C27B0);
      case '食品':
        return const Color(0xFF4CAF50);
      case '图书':
        return const Color(0xFFFF9800);
      case '家居用品':
        return const Color(0xFF795548);
      case '体育用品':
        return const Color(0xFFF44336);
      case '美妆护肤':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF607D8B);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _showAddProductDialog() {
    _showProductDialog();
  }

  void _showEditProductDialog(Product product) {
    _showProductDialog(product: product);
  }

  void _showProductDialog({Product? product}) {
    final isEditing = product != null;
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final stockController = TextEditingController(text: product?.stock.toString() ?? '');
    final descriptionController = TextEditingController(text: product?.description ?? '');
    
    String selectedCategory = product?.category ?? ProductCategory.all.first;
    String selectedUnit = product?.unit ?? ProductUnit.all.first;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? '编辑商品' : '添加商品'),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: '商品名称',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: '商品类别',
                      border: OutlineInputBorder(),
                    ),
                    items: ProductCategory.all.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedCategory = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: '价格',
                      border: OutlineInputBorder(),
                      prefixText: '¥ ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: stockController,
                          decoration: const InputDecoration(
                            labelText: '库存数量',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedUnit,
                          decoration: const InputDecoration(
                            labelText: '单位',
                            border: OutlineInputBorder(),
                          ),
                          items: ProductUnit.all.map((unit) {
                            return DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() => selectedUnit = value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: '商品描述',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_validateProductForm(
                  nameController.text,
                  priceController.text,
                  stockController.text,
                )) {
                  final newProduct = Product(
                    id: isEditing ? product!.id : DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    category: selectedCategory,
                    price: double.parse(priceController.text),
                    stock: int.parse(stockController.text),
                    unit: selectedUnit,
                    description: descriptionController.text.trim(),
                    createdAt: isEditing ? product!.createdAt : DateTime.now(),
                    updatedAt: DateTime.now(),
                  );

                  setState(() {
                    if (isEditing) {
                      final index = _products.indexWhere((p) => p.id == product!.id);
                      if (index != -1) {
                        _products[index] = newProduct;
                      }
                    } else {
                      _products.add(newProduct);
                    }
                    _performSearch(); // 重新过滤数据
                  });

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEditing ? '商品更新成功' : '商品添加成功'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
              ),
              child: Text(isEditing ? '更新' : '添加'),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateProductForm(String name, String price, String stock) {
    if (name.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入商品名称'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (double.tryParse(price) == null || double.parse(price) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入有效的价格'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (int.tryParse(stock) == null || int.parse(stock) < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入有效的库存数量'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  void _showDeleteConfirmDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除商品「${product.name}」吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _products.removeWhere((p) => p.id == product.id);
                _performSearch(); // 重新过滤数据
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('商品删除成功'),
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
