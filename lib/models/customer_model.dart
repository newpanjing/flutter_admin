class CustomerModel {
  final String id;
  final String name;
  final String contact;
  final String phone;
  final String email;
  final String address;
  final String type;
  final String status;
  final DateTime createTime;
  final DateTime? lastOrderTime;
  final int totalOrders;
  final double totalAmount;

  CustomerModel({
    required this.id,
    required this.name,
    required this.contact,
    required this.phone,
    required this.email,
    required this.address,
    required this.type,
    required this.status,
    required this.createTime,
    this.lastOrderTime,
    required this.totalOrders,
    required this.totalAmount,
  });

  CustomerModel copyWith({
    String? id,
    String? name,
    String? contact,
    String? phone,
    String? email,
    String? address,
    String? type,
    String? status,
    DateTime? createTime,
    DateTime? lastOrderTime,
    int? totalOrders,
    double? totalAmount,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      type: type ?? this.type,
      status: status ?? this.status,
      createTime: createTime ?? this.createTime,
      lastOrderTime: lastOrderTime ?? this.lastOrderTime,
      totalOrders: totalOrders ?? this.totalOrders,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'phone': phone,
      'email': email,
      'address': address,
      'type': type,
      'status': status,
      'createTime': createTime.toIso8601String(),
      'lastOrderTime': lastOrderTime?.toIso8601String(),
      'totalOrders': totalOrders,
      'totalAmount': totalAmount,
    };
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'],
      contact: json['contact'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      type: json['type'],
      status: json['status'],
      createTime: DateTime.parse(json['createTime']),
      lastOrderTime: json['lastOrderTime'] != null 
          ? DateTime.parse(json['lastOrderTime']) 
          : null,
      totalOrders: json['totalOrders'],
      totalAmount: json['totalAmount'].toDouble(),
    );
  }

  @override
  String toString() {
    return 'CustomerModel(id: $id, name: $name, contact: $contact, type: $type, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomerModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}