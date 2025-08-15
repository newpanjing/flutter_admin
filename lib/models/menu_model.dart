class MenuConfig {
  final bool success;
  final String message;
  final MenuData data;

  MenuConfig({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MenuConfig.fromJson(Map<String, dynamic> json) {
    var data = json['data'] ?? {};
    return MenuConfig(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: MenuData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class MenuData {
  final String siteName;
  final List<MenuItemConfig> menus;

  MenuData({required this.siteName, required this.menus});

  factory MenuData.fromJson(Map<String, dynamic> json) {
    return MenuData(
      siteName: json['siteName'] ?? '',
      menus: (json['menus'] as List<dynamic>? ?? [])
          .map((item) => MenuItemConfig.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'siteName': siteName,
      'menus': menus.map((menu) => menu.toJson()).toList(),
    };
  }
}

class MenuItemConfig {
  final String name;
  final String url;
  final String icon;
  final List<MenuItemConfig> children;

  MenuItemConfig({
    required this.name,
    required this.url,
    this.icon = '',
    this.children = const [],
  });

  factory MenuItemConfig.fromJson(Map<String, dynamic> json) {
    return MenuItemConfig(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      icon: json['icon'] ?? '',
      children: (json['children'] as List<dynamic>? ?? [])
          .map((item) => MenuItemConfig.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'icon': icon,
      'children': children.map((child) => child.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuItemConfig &&
        other.name == name &&
        other.url == url &&
        other.icon == icon;
  }

  @override
  int get hashCode => name.hashCode ^ url.hashCode ^ icon.hashCode;

  @override
  String toString() {
    return 'MenuItemConfig(name: $name, url: $url, icon: $icon, children: ${children.length})';
  }
}
