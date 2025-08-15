class UserModel {
  final String id;
  final String username;
  final String name;
  final String email;
  final String role;
  final String status;
  final DateTime createTime;
  final DateTime lastLogin;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.createTime,
    required this.lastLogin,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? name,
    String? email,
    String? role,
    String? status,
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
      'createTime': createTime.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      status: json['status'],
      createTime: DateTime.parse(json['createTime']),
      lastLogin: DateTime.parse(json['lastLogin']),
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, name: $name, email: $email, role: $role, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}