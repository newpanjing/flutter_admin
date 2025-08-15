class UserModel {
  final int id;
  final String username;
  final String? name;
  final String email;
  final String? role;
  final String? status;
  final bool isStaff;
  final bool isSuperuser;
  final DateTime? createTime;
  final DateTime? lastLogin;

  UserModel({
    required this.id,
    required this.username,
    this.name,
    required this.email,
    this.role,
    this.status,
    required this.isStaff,
    required this.isSuperuser,
    this.createTime,
    this.lastLogin,
  });

  UserModel copyWith({
    int? id,
    String? username,
    String? name,
    String? email,
    String? role,
    String? status,
    bool? isStaff,
    bool? isSuperuser,
    DateTime? createTime,
    DateTime? lastLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      isStaff: isStaff ?? this.isStaff,
      isSuperuser: isSuperuser ?? this.isSuperuser,
      createTime: createTime ?? this.createTime,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'role': role,
      'status': status,
      'is_staff': isStaff,
      'is_superuser': isSuperuser,
      'createTime': createTime?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      name: json['name'],
      email: json['email'] ?? '',
      role: json['role'],
      status: json['status'],
      isStaff: json['is_staff'] ?? false,
      isSuperuser: json['is_superuser'] ?? false,
      createTime: json['createTime'] != null ? DateTime.parse(json['createTime']) : null,
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, name: $name, email: $email, role: $role, status: $status, isStaff: $isStaff, isSuperuser: $isSuperuser)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}