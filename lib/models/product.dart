// models/product.dart - Modelo de Product

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final ProductCategory category;
  final int stock;
  final bool? featured;
  final bool? onSale;
  final double? salePrice;
  final double rating;
  final int reviewCount;
  final List<String> ingredients;
  final List<String>? allergens;
  final List<ProductVariant>? variants; // Variantes (tallas, colores, etc.)
  final List<String>? images; // Imágenes adicionales
  final bool isAvailable; // Disponibilidad

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.stock,
    this.featured,
    this.onSale,
    this.salePrice,
    required this.rating,
    required this.reviewCount,
    required this.ingredients,
    this.allergens,
    this.variants,
    this.images,
    this.isAvailable = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      category: ProductCategory.fromString(json['category'] as String),
      stock: json['stock'] as int,
      featured: json['featured'] as bool?,
      onSale: json['onSale'] as bool?,
      salePrice: json['salePrice'] != null
          ? (json['salePrice'] as num).toDouble()
          : null,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      ingredients: List<String>.from(json['ingredients'] as List),
      allergens: json['allergens'] != null
          ? List<String>.from(json['allergens'] as List)
          : null,
      variants: json['variants'] != null
          ? (json['variants'] as List)
              .map((v) => ProductVariant.fromJson(v as Map<String, dynamic>))
              .toList()
          : null,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : null,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category.value,
      'stock': stock,
      'featured': featured,
      'onSale': onSale,
      'salePrice': salePrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'ingredients': ingredients,
      'allergens': allergens,
      'variants': variants?.map((v) => v.toJson()).toList(),
      'images': images,
      'isAvailable': isAvailable,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? image,
    ProductCategory? category,
    int? stock,
    bool? featured,
    bool? onSale,
    double? salePrice,
    double? rating,
    int? reviewCount,
    List<String>? ingredients,
    List<String>? allergens,
    List<ProductVariant>? variants,
    List<String>? images,
    bool? isAvailable,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      featured: featured ?? this.featured,
      onSale: onSale ?? this.onSale,
      salePrice: salePrice ?? this.salePrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      ingredients: ingredients ?? this.ingredients,
      allergens: allergens ?? this.allergens,
      variants: variants ?? this.variants,
      images: images ?? this.images,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  double get effectivePrice =>
      (onSale ?? false) && salePrice != null ? salePrice! : price;
}

// Modelo de variante de producto (tallas, colores, etc.)
class ProductVariant {
  final String id;
  final String name; // Ej: "Grande", "Rojo", "500ml"
  final VariantType type; // Talla, Color, Tamaño
  final double? priceModifier; // +500 para talla grande
  final int stock;
  final String? colorCode; // Código hex para colores

  ProductVariant({
    required this.id,
    required this.name,
    required this.type,
    this.priceModifier,
    required this.stock,
    this.colorCode,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] as String,
      name: json['name'] as String,
      type: VariantType.fromString(json['type'] as String),
      priceModifier: json['priceModifier'] != null
          ? (json['priceModifier'] as num).toDouble()
          : null,
      stock: json['stock'] as int,
      colorCode: json['colorCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.value,
      'priceModifier': priceModifier,
      'stock': stock,
      'colorCode': colorCode,
    };
  }
}

enum VariantType {
  size('size'),
  color('color'),
  flavor('flavor');

  final String value;
  const VariantType(this.value);

  static VariantType fromString(String value) {
    return VariantType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => VariantType.size,
    );
  }

  String get displayName {
    switch (this) {
      case VariantType.size:
        return 'Tamaño';
      case VariantType.color:
        return 'Color';
      case VariantType.flavor:
        return 'Sabor';
    }
  }
}

enum ProductCategory {
  arrozConLeche('arroz-con-leche'),
  fresasConCrema('fresas-con-crema'),
  postresEspeciales('postres-especiales'),
  bebidasCremosas('bebidas-cremosas'),
  toppings('toppings'),
  bebidas('bebidas'),
  postres('postres');

  final String value;
  const ProductCategory(this.value);

  static ProductCategory fromString(String value) {
    return ProductCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => ProductCategory.postresEspeciales,
    );
  }

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

class Topping {
  final String id;
  final String name;
  final double price;
  final ToppingCategory category;
  final String image;

  Topping({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
  });

  factory Topping.fromJson(Map<String, dynamic> json) {
    return Topping(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      category: ToppingCategory.fromString(json['category'] as String),
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category.value,
      'image': image,
    };
  }
}

enum ToppingCategory {
  frutas('frutas'),
  dulces('dulces'),
  frutosSeco('frutos-secos'),
  salsas('salsas');

  final String value;
  const ToppingCategory(this.value);

  static ToppingCategory fromString(String value) {
    return ToppingCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => ToppingCategory.dulces,
    );
  }
}

class Review {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String userAvatar;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final int helpful;
  final bool verified;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.helpful,
    required this.verified,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      productId: json['productId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      helpful: json['helpful'] as int,
      verified: json['verified'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'helpful': helpful,
      'verified': verified,
    };
  }
}
