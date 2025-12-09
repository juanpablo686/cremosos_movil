// models/role.dart - Modelo de Role

class Role {
  final String id;
  final String name;
  final String displayName;
  final String description;
  final List<String> permissions;
  final String createdAt;
  final String? updatedAt;

  Role({
    required this.id,
    required this.name,
    required this.displayName,
    required this.description,
    required this.permissions,
    required this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((p) => p as String)
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'description': description,
      'permissions': permissions,
      'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  Role copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    List<String>? permissions,
    String? createdAt,
    String? updatedAt,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Lista de permisos disponibles en el sistema
class AppPermissions {
  static const String usersCreate = 'users.create';
  static const String usersRead = 'users.read';
  static const String usersUpdate = 'users.update';
  static const String usersDelete = 'users.delete';

  static const String productsCreate = 'products.create';
  static const String productsRead = 'products.read';
  static const String productsUpdate = 'products.update';
  static const String productsDelete = 'products.delete';

  static const String ordersCreate = 'orders.create';
  static const String ordersRead = 'orders.read';
  static const String ordersUpdate = 'orders.update';
  static const String ordersDelete = 'orders.delete';

  static const String purchasesCreate = 'purchases.create';
  static const String purchasesRead = 'purchases.read';
  static const String purchasesUpdate = 'purchases.update';
  static const String purchasesDelete = 'purchases.delete';

  static const String salesCreate = 'sales.create';
  static const String salesRead = 'sales.read';

  static const String reportsRead = 'reports.read';
  static const String rolesManage = 'roles.manage';

  static List<String> get all => [
    usersCreate,
    usersRead,
    usersUpdate,
    usersDelete,
    productsCreate,
    productsRead,
    productsUpdate,
    productsDelete,
    ordersCreate,
    ordersRead,
    ordersUpdate,
    ordersDelete,
    purchasesCreate,
    purchasesRead,
    purchasesUpdate,
    purchasesDelete,
    salesCreate,
    salesRead,
    reportsRead,
    rolesManage,
  ];

  static String getDisplayName(String permission) {
    final map = {
      usersCreate: 'Crear usuarios',
      usersRead: 'Ver usuarios',
      usersUpdate: 'Actualizar usuarios',
      usersDelete: 'Eliminar usuarios',
      productsCreate: 'Crear productos',
      productsRead: 'Ver productos',
      productsUpdate: 'Actualizar productos',
      productsDelete: 'Eliminar productos',
      ordersCreate: 'Crear pedidos',
      ordersRead: 'Ver pedidos',
      ordersUpdate: 'Actualizar pedidos',
      ordersDelete: 'Eliminar pedidos',
      purchasesCreate: 'Crear compras',
      purchasesRead: 'Ver compras',
      purchasesUpdate: 'Actualizar compras',
      purchasesDelete: 'Eliminar compras',
      salesCreate: 'Crear ventas',
      salesRead: 'Ver ventas',
      reportsRead: 'Ver reportes',
      rolesManage: 'Gestionar roles',
    };
    return map[permission] ?? permission;
  }
}
