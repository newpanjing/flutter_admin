class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String unit;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.unit,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  // 从JSON创建Product对象
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      unit: json['unit'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      isActive: json['isActive'] ?? true,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'unit': unit,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  // 复制并修改部分属性
  Product copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    int? stock,
    String? unit,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      unit: unit ?? this.unit,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, category: $category, price: $price, stock: $stock}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// 商品类别枚举
class ProductCategory {
  static const String electronics = '电子产品';
  static const String clothing = '服装';
  static const String food = '食品';
  static const String books = '图书';
  static const String home = '家居用品';
  static const String sports = '体育用品';
  static const String beauty = '美妆护肤';
  static const String other = '其他';

  static List<String> get all => [
    electronics,
    clothing,
    food,
    books,
    home,
    sports,
    beauty,
    other,
  ];
}

// 商品单位枚举
class ProductUnit {
  static const String piece = '件';
  static const String box = '盒';
  static const String kg = '公斤';
  static const String gram = '克';
  static const String liter = '升';
  static const String meter = '米';
  static const String pair = '双';
  static const String set = '套';

  static List<String> get all => [
    piece,
    box,
    kg,
    gram,
    liter,
    meter,
    pair,
    set,
  ];
}