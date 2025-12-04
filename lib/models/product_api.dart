/// Modelo de Producto - Versión con API REST
/// EXPLICAR EN EXPOSICIÓN: Representa un producto del catálogo
/// con toda la información necesaria para mostrar y vender

import 'package:json_annotation/json_annotation.dart';

part 'product_api.g.dart';

/// Producto principal
/// EXPLICAR: @JsonSerializable automatiza la conversión JSON ↔ Dart
@JsonSerializable(explicitToJson: true)
class ProductApi {
  /// ID único del producto
  final String id;

  /// Nombre del producto
  final String name;

  /// Descripción detallada
  final String description;

  /// Precio en pesos colombianos
  final double price;

  /// URL de la imagen principal
  final String imageUrl;

  /// Categoría del producto
  @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
  final ProductCategory category;

  /// Cantidad disponible en inventario
  /// EXPLICAR: El servidor controla el stock para evitar sobreventa
  final int stock;

  /// Calificación promedio (0.0 - 5.0)
  final double rating;

  /// Número total de reseñas
  final int reviewsCount;

  /// ¿Está disponible para venta?
  final bool isAvailable;

  /// ¿Es un producto destacado?
  final bool isFeatured;

  /// Lista de toppings compatibles (solo IDs)
  /// EXPLICAR: Para ahorrar bandwidth, solo enviamos IDs, no objetos completos
  final List<String> compatibleToppings;

  /// Información nutricional (opcional)
  final NutritionalInfo? nutritionalInfo;

  /// Fecha de creación
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  ProductApi({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.stock = 0,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.isAvailable = true,
    this.isFeatured = false,
    this.compatibleToppings = const [],
    this.nutritionalInfo,
    required this.createdAt,
  });

  /// Deserialización desde JSON
  /// EXPLICAR: El código generado por build_runner maneja la conversión
  factory ProductApi.fromJson(Map<String, dynamic> json) =>
      _$ProductApiFromJson(json);

  /// Serialización a JSON
  Map<String, dynamic> toJson() => _$ProductApiToJson(this);

  // Conversiones custom para DateTime
  static DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
  static String _dateTimeToJson(DateTime dt) => dt.toIso8601String();

  // Conversión custom para ProductCategory enum
  static ProductCategory _categoryFromJson(String json) =>
      ProductCategory.fromString(json);
  static String _categoryToJson(ProductCategory category) => category.toJson();

  /// Verifica si el producto tiene stock disponible
  bool get hasStock => stock > 0 && isAvailable;

  /// Precio formateado en pesos colombianos
  String get formattedPrice => '\$${price.toStringAsFixed(0)}';

  /// Copia del producto con campos modificados
  ProductApi copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    ProductCategory? category,
    int? stock,
    double? rating,
    int? reviewsCount,
    bool? isAvailable,
    bool? isFeatured,
    List<String>? compatibleToppings,
    NutritionalInfo? nutritionalInfo,
    DateTime? createdAt,
  }) {
    return ProductApi(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
      compatibleToppings: compatibleToppings ?? this.compatibleToppings,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Categorías de Productos
/// EXPLICAR: Enum para tipado fuerte y evitar errores de strings
enum ProductCategory {
  arrozConLeche,
  fresasConCrema,
  postresEspeciales,
  bebidasCremosas,
  toppings,
  bebidas,
  postres;

  /// Convertir string del servidor a enum
  static ProductCategory fromString(String category) {
    switch (category.toLowerCase()) {
      case 'arrozconleche':
      case 'arroz_con_leche':
        return ProductCategory.arrozConLeche;
      case 'fresasconcrema':
      case 'fresas_con_crema':
        return ProductCategory.fresasConCrema;
      case 'postresespeciales':
      case 'postres_especiales':
        return ProductCategory.postresEspeciales;
      case 'bebidascremosas':
      case 'bebidas_cremosas':
        return ProductCategory.bebidasCremosas;
      case 'toppings':
        return ProductCategory.toppings;
      case 'bebidas':
        return ProductCategory.bebidas;
      case 'postres':
        return ProductCategory.postres;
      default:
        return ProductCategory.postres;
    }
  }

  /// Convertir enum a string para el servidor
  String toJson() {
    switch (this) {
      case ProductCategory.arrozConLeche:
        return 'arroz_con_leche';
      case ProductCategory.fresasConCrema:
        return 'fresas_con_crema';
      case ProductCategory.postresEspeciales:
        return 'postres_especiales';
      case ProductCategory.bebidasCremosas:
        return 'bebidas_cremosas';
      case ProductCategory.toppings:
        return 'toppings';
      case ProductCategory.bebidas:
        return 'bebidas';
      case ProductCategory.postres:
        return 'postres';
    }
  }

  /// Nombre legible para mostrar en UI
  String get displayName {
    switch (this) {
      case ProductCategory.arrozConLeche:
        return 'Arroz con Leche';
      case ProductCategory.fresasConCrema:
        return 'Fresas con Crema';
      case ProductCategory.postresEspeciales:
        return 'Postres Especiales';
      case ProductCategory.bebidasCremosas:
        return 'Bebidas Cremosas';
      case ProductCategory.toppings:
        return 'Toppings';
      case ProductCategory.bebidas:
        return 'Bebidas';
      case ProductCategory.postres:
        return 'Postres';
    }
  }
}

/// Información Nutricional
/// EXPLICAR: Datos opcionales sobre el producto
@JsonSerializable()
class NutritionalInfo {
  final int calories; // Calorías
  final double protein; // Proteínas (g)
  final double carbs; // Carbohidratos (g)
  final double fats; // Grasas (g)
  final double sugar; // Azúcares (g)
  final int servingSize; // Tamaño de la porción (ml o g)

  NutritionalInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.sugar,
    required this.servingSize,
  });

  factory NutritionalInfo.fromJson(Map<String, dynamic> json) =>
      _$NutritionalInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionalInfoToJson(this);
}

/// Topping (Complemento)
/// EXPLICAR: Representa un topping que se puede agregar a productos
@JsonSerializable()
class ToppingApi {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final bool isAvailable;

  ToppingApi({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.isAvailable = true,
  });

  factory ToppingApi.fromJson(Map<String, dynamic> json) =>
      _$ToppingApiFromJson(json);

  Map<String, dynamic> toJson() => _$ToppingApiToJson(this);

  String get formattedPrice => '\$${price.toStringAsFixed(0)}';
}

/// Reseña de Producto
/// EXPLICAR: Representa una review/calificación de un usuario
@JsonSerializable()
class ProductReviewApi {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final int rating; // 1-5 estrellas
  final String comment;
  final List<String> images; // Imágenes de la reseña (opcional)
  final int helpfulCount; // Cuántas personas marcaron como útil

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  ProductReviewApi({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    this.images = const [],
    this.helpfulCount = 0,
    required this.createdAt,
  });

  factory ProductReviewApi.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewApiFromJson(json);

  Map<String, dynamic> toJson() => _$ProductReviewApiToJson(this);

  static DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
  static String _dateTimeToJson(DateTime dt) => dt.toIso8601String();
}
