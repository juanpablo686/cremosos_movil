// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductApi _$ProductApiFromJson(Map<String, dynamic> json) => ProductApi(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  imageUrl: json['imageUrl'] as String,
  category: ProductApi._categoryFromJson(json['category'] as String),
  stock: (json['stock'] as num?)?.toInt() ?? 0,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
  isAvailable: json['isAvailable'] as bool? ?? true,
  isFeatured: json['isFeatured'] as bool? ?? false,
  compatibleToppings:
      (json['compatibleToppings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  nutritionalInfo: json['nutritionalInfo'] == null
      ? null
      : NutritionalInfo.fromJson(
          json['nutritionalInfo'] as Map<String, dynamic>,
        ),
  createdAt: ProductApi._dateTimeFromJson(json['createdAt'] as String),
);

Map<String, dynamic> _$ProductApiToJson(ProductApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'category': ProductApi._categoryToJson(instance.category),
      'stock': instance.stock,
      'rating': instance.rating,
      'reviewsCount': instance.reviewsCount,
      'isAvailable': instance.isAvailable,
      'isFeatured': instance.isFeatured,
      'compatibleToppings': instance.compatibleToppings,
      'nutritionalInfo': instance.nutritionalInfo?.toJson(),
      'createdAt': ProductApi._dateTimeToJson(instance.createdAt),
    };

NutritionalInfo _$NutritionalInfoFromJson(Map<String, dynamic> json) =>
    NutritionalInfo(
      calories: (json['calories'] as num).toInt(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fats: (json['fats'] as num).toDouble(),
      sugar: (json['sugar'] as num).toDouble(),
      servingSize: (json['servingSize'] as num).toInt(),
    );

Map<String, dynamic> _$NutritionalInfoToJson(NutritionalInfo instance) =>
    <String, dynamic>{
      'calories': instance.calories,
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fats': instance.fats,
      'sugar': instance.sugar,
      'servingSize': instance.servingSize,
    };

ToppingApi _$ToppingApiFromJson(Map<String, dynamic> json) => ToppingApi(
  id: json['id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  imageUrl: json['imageUrl'] as String?,
  isAvailable: json['isAvailable'] as bool? ?? true,
);

Map<String, dynamic> _$ToppingApiToJson(ToppingApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
    };

ProductReviewApi _$ProductReviewApiFromJson(
  Map<String, dynamic> json,
) => ProductReviewApi(
  id: json['id'] as String,
  productId: json['productId'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  userAvatar: json['userAvatar'] as String?,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  helpfulCount: (json['helpfulCount'] as num?)?.toInt() ?? 0,
  createdAt: ProductReviewApi._dateTimeFromJson(json['createdAt'] as String),
);

Map<String, dynamic> _$ProductReviewApiToJson(ProductReviewApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'rating': instance.rating,
      'comment': instance.comment,
      'images': instance.images,
      'helpfulCount': instance.helpfulCount,
      'createdAt': ProductReviewApi._dateTimeToJson(instance.createdAt),
    };
