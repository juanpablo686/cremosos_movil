// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartApi _$CartApiFromJson(Map<String, dynamic> json) => CartApi(
  id: json['id'] as String,
  userId: json['userId'] as String,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CartItemApi.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  updatedAt: CartApi._dateTimeFromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$CartApiToJson(CartApi instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'updatedAt': CartApi._dateTimeToJson(instance.updatedAt),
};

CartItemApi _$CartItemApiFromJson(Map<String, dynamic> json) => CartItemApi(
  id: json['id'] as String,
  productId: json['productId'] as String,
  productName: json['productName'] as String,
  productImage: json['productImage'] as String,
  productPrice: (json['productPrice'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  toppings:
      (json['toppings'] as List<dynamic>?)
          ?.map((e) => CartToppingApi.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  notes: json['notes'] as String?,
  createdAt: CartItemApi._dateTimeFromJson(json['createdAt'] as String),
);

Map<String, dynamic> _$CartItemApiToJson(CartItemApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'productImage': instance.productImage,
      'productPrice': instance.productPrice,
      'quantity': instance.quantity,
      'toppings': instance.toppings.map((e) => e.toJson()).toList(),
      'notes': instance.notes,
      'createdAt': CartItemApi._dateTimeToJson(instance.createdAt),
    };

CartToppingApi _$CartToppingApiFromJson(Map<String, dynamic> json) =>
    CartToppingApi(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$CartToppingApiToJson(CartToppingApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
    };

AddToCartRequest _$AddToCartRequestFromJson(Map<String, dynamic> json) =>
    AddToCartRequest(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      toppingIds:
          (json['toppingIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$AddToCartRequestToJson(AddToCartRequest instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
      'toppingIds': instance.toppingIds,
      'notes': instance.notes,
    };

UpdateCartItemRequest _$UpdateCartItemRequestFromJson(
  Map<String, dynamic> json,
) => UpdateCartItemRequest(
  quantity: (json['quantity'] as num?)?.toInt(),
  toppingIds: (json['toppingIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$UpdateCartItemRequestToJson(
  UpdateCartItemRequest instance,
) => <String, dynamic>{
  'quantity': instance.quantity,
  'toppingIds': instance.toppingIds,
  'notes': instance.notes,
};

SyncCartRequest _$SyncCartRequestFromJson(Map<String, dynamic> json) =>
    SyncCartRequest(
      items: (json['items'] as List<dynamic>)
          .map((e) => SyncCartItemRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SyncCartRequestToJson(SyncCartRequest instance) =>
    <String, dynamic>{'items': instance.items};

SyncCartItemRequest _$SyncCartItemRequestFromJson(Map<String, dynamic> json) =>
    SyncCartItemRequest(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      toppingIds:
          (json['toppingIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$SyncCartItemRequestToJson(
  SyncCartItemRequest instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'quantity': instance.quantity,
  'toppingIds': instance.toppingIds,
  'notes': instance.notes,
};
