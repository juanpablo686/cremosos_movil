/// Modelo de Carrito - Versión con API REST
/// EXPLICAR EN EXPOSICIÓN: Representa el carrito de compras del usuario
/// con todos los items seleccionados y cálculos de totales

import 'package:json_annotation/json_annotation.dart';

part 'cart_api.g.dart';

/// Carrito de Compras Completo
/// EXPLICAR: El servidor mantiene el carrito para sincronizar entre dispositivos
@JsonSerializable(explicitToJson: true)
class CartApi {
  /// ID único del carrito (generalmente vinculado al usuario)
  final String id;

  /// ID del usuario propietario
  final String userId;

  /// Lista de items en el carrito
  /// EXPLICAR: Cada item contiene producto, cantidad y toppings seleccionados
  final List<CartItemApi> items;

  /// Fecha de última actualización
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;

  CartApi({
    required this.id,
    required this.userId,
    this.items = const [],
    required this.updatedAt,
  });

  /// Deserialización desde JSON del servidor
  factory CartApi.fromJson(Map<String, dynamic> json) =>
      _$CartApiFromJson(json);

  /// Serialización a JSON para enviar al servidor
  Map<String, dynamic> toJson() => _$CartApiToJson(this);

  static DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
  static String _dateTimeToJson(DateTime dt) => dt.toIso8601String();

  /// EXPLICAR: Getters calculados para el carrito

  /// Subtotal (suma de todos los items sin descuentos)
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Total de items (suma de cantidades)
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Total único de productos (sin contar cantidades)
  int get uniqueItems => items.length;

  /// Impuestos (ejemplo: 8% del subtotal)
  double get tax => subtotal * 0.08;

  /// Costo de envío (gratis si supera $50,000)
  double get shippingCost => subtotal >= 50000 ? 0 : 5000;

  /// Total final a pagar
  double get total => subtotal + tax + shippingCost;

  /// ¿Está vacío el carrito?
  bool get isEmpty => items.isEmpty;

  /// Copia del carrito con campos modificados
  CartApi copyWith({
    String? id,
    String? userId,
    List<CartItemApi>? items,
    DateTime? updatedAt,
  }) {
    return CartApi(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Item Individual del Carrito
/// EXPLICAR: Representa cada producto agregado con su cantidad y personalizaciones
@JsonSerializable(explicitToJson: true)
class CartItemApi {
  /// ID único del item en el carrito
  final String id;

  /// ID del producto base
  final String productId;

  /// Nombre del producto (desnormalizado para rendimiento)
  /// EXPLICAR: Guardamos el nombre para evitar hacer requests extra
  final String productName;

  /// Imagen del producto (URL)
  final String productImage;

  /// Precio unitario del producto base
  final double productPrice;

  /// Cantidad de este item
  final int quantity;

  /// Toppings seleccionados para este item
  final List<CartToppingApi> toppings;

  /// Notas especiales (ej: "Sin azúcar", "Bien frío")
  final String? notes;

  /// Fecha de creación del item
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  CartItemApi({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.quantity,
    this.toppings = const [],
    this.notes,
    required this.createdAt,
  });

  factory CartItemApi.fromJson(Map<String, dynamic> json) =>
      _$CartItemApiFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemApiToJson(this);

  static DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
  static String _dateTimeToJson(DateTime dt) => dt.toIso8601String();

  /// Precio total de toppings
  double get toppingsPrice => toppings.fold(
    0.0,
    (sum, topping) => sum + (topping.price * topping.quantity),
  );

  /// Precio unitario (producto + toppings)
  double get unitPrice => productPrice + toppingsPrice;

  /// Precio total (unitario × cantidad)
  double get totalPrice => unitPrice * quantity;

  /// Precio formateado
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(0)}';

  /// Copia con modificaciones
  CartItemApi copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImage,
    double? productPrice,
    int? quantity,
    List<CartToppingApi>? toppings,
    String? notes,
    DateTime? createdAt,
  }) {
    return CartItemApi(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      toppings: toppings ?? this.toppings,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Topping en el Carrito
/// EXPLICAR: Representa un topping seleccionado para un item específico
@JsonSerializable()
class CartToppingApi {
  final String id;
  final String name;
  final double price;
  final int quantity; // Cantidad de este topping (puede ser múltiple)

  CartToppingApi({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  factory CartToppingApi.fromJson(Map<String, dynamic> json) =>
      _$CartToppingApiFromJson(json);

  Map<String, dynamic> toJson() => _$CartToppingApiToJson(this);

  /// Precio total de este topping
  double get totalPrice => price * quantity;

  String get formattedPrice => '\$${price.toStringAsFixed(0)}';
}

/// Request para agregar item al carrito
/// EXPLICAR: DTO (Data Transfer Object) para enviar al endpoint POST /api/cart/items
@JsonSerializable()
class AddToCartRequest {
  final String productId;
  final int quantity;
  final List<String> toppingIds; // Solo los IDs de los toppings
  final String? notes;

  AddToCartRequest({
    required this.productId,
    required this.quantity,
    this.toppingIds = const [],
    this.notes,
  });

  Map<String, dynamic> toJson() => _$AddToCartRequestToJson(this);
}

/// Request para actualizar item del carrito
/// EXPLICAR: Para el endpoint PUT /api/cart/items/{id}
@JsonSerializable()
class UpdateCartItemRequest {
  final int? quantity;
  final List<String>? toppingIds;
  final String? notes;

  UpdateCartItemRequest({this.quantity, this.toppingIds, this.notes});

  Map<String, dynamic> toJson() => _$UpdateCartItemRequestToJson(this);
}

/// Request para sincronizar carrito local con servidor
/// EXPLICAR: Cuando el usuario inicia sesión, sincronizamos su carrito local
@JsonSerializable()
class SyncCartRequest {
  final List<SyncCartItemRequest> items;

  SyncCartRequest({required this.items});

  Map<String, dynamic> toJson() => _$SyncCartRequestToJson(this);
}

@JsonSerializable()
class SyncCartItemRequest {
  final String productId;
  final int quantity;
  final List<String> toppingIds;
  final String? notes;

  SyncCartItemRequest({
    required this.productId,
    required this.quantity,
    this.toppingIds = const [],
    this.notes,
  });

  factory SyncCartItemRequest.fromJson(Map<String, dynamic> json) =>
      _$SyncCartItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SyncCartItemRequestToJson(this);
}
