// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderApi _$OrderApiFromJson(Map<String, dynamic> json) => OrderApi(
  id: json['id'] as String,
  orderNumber: json['orderNumber'] as String,
  userId: json['userId'] as String,
  status: OrderApi._statusFromJson(json['status'] as String),
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItemApi.fromJson(e as Map<String, dynamic>))
      .toList(),
  shippingAddress: ShippingAddressApi.fromJson(
    json['shippingAddress'] as Map<String, dynamic>,
  ),
  paymentInfo: PaymentInfoApi.fromJson(
    json['paymentInfo'] as Map<String, dynamic>,
  ),
  subtotal: (json['subtotal'] as num).toDouble(),
  tax: (json['tax'] as num).toDouble(),
  shippingCost: (json['shippingCost'] as num).toDouble(),
  discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
  total: (json['total'] as num).toDouble(),
  notes: json['notes'] as String?,
  tracking: OrderTrackingApi.fromJson(json['tracking'] as Map<String, dynamic>),
  createdAt: OrderApi._dateTimeFromJson(json['createdAt'] as String),
  updatedAt: OrderApi._dateTimeFromJson(json['updatedAt'] as String),
  estimatedDelivery: OrderApi._dateTimeFromJsonNullable(
    json['estimatedDelivery'] as String?,
  ),
);

Map<String, dynamic> _$OrderApiToJson(OrderApi instance) => <String, dynamic>{
  'id': instance.id,
  'orderNumber': instance.orderNumber,
  'userId': instance.userId,
  'status': OrderApi._statusToJson(instance.status),
  'items': instance.items.map((e) => e.toJson()).toList(),
  'shippingAddress': instance.shippingAddress.toJson(),
  'paymentInfo': instance.paymentInfo.toJson(),
  'subtotal': instance.subtotal,
  'tax': instance.tax,
  'shippingCost': instance.shippingCost,
  'discount': instance.discount,
  'total': instance.total,
  'notes': instance.notes,
  'tracking': instance.tracking.toJson(),
  'createdAt': OrderApi._dateTimeToJson(instance.createdAt),
  'updatedAt': OrderApi._dateTimeToJson(instance.updatedAt),
  'estimatedDelivery': OrderApi._dateTimeToJsonNullable(
    instance.estimatedDelivery,
  ),
};

OrderItemApi _$OrderItemApiFromJson(Map<String, dynamic> json) => OrderItemApi(
  productId: json['productId'] as String,
  productName: json['productName'] as String,
  productImage: json['productImage'] as String,
  productPrice: (json['productPrice'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  toppings:
      (json['toppings'] as List<dynamic>?)
          ?.map((e) => OrderToppingApi.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$OrderItemApiToJson(OrderItemApi instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'productImage': instance.productImage,
      'productPrice': instance.productPrice,
      'quantity': instance.quantity,
      'toppings': instance.toppings.map((e) => e.toJson()).toList(),
      'notes': instance.notes,
    };

OrderToppingApi _$OrderToppingApiFromJson(Map<String, dynamic> json) =>
    OrderToppingApi(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderToppingApiToJson(OrderToppingApi instance) =>
    <String, dynamic>{'name': instance.name, 'price': instance.price};

ShippingAddressApi _$ShippingAddressApiFromJson(Map<String, dynamic> json) =>
    ShippingAddressApi(
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      country: json['country'] as String? ?? 'Colombia',
      additionalInfo: json['additionalInfo'] as String?,
    );

Map<String, dynamic> _$ShippingAddressApiToJson(ShippingAddressApi instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'phone': instance.phone,
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'country': instance.country,
      'additionalInfo': instance.additionalInfo,
    };

PaymentInfoApi _$PaymentInfoApiFromJson(Map<String, dynamic> json) =>
    PaymentInfoApi(
      method: json['method'] as String,
      last4Digits: json['last4Digits'] as String?,
      cardBrand: json['cardBrand'] as String?,
      transactionId: json['transactionId'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      paidAt: PaymentInfoApi._dateTimeFromJson(json['paidAt'] as String),
    );

Map<String, dynamic> _$PaymentInfoApiToJson(PaymentInfoApi instance) =>
    <String, dynamic>{
      'method': instance.method,
      'last4Digits': instance.last4Digits,
      'cardBrand': instance.cardBrand,
      'transactionId': instance.transactionId,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'paidAt': PaymentInfoApi._dateTimeToJson(instance.paidAt),
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.completed: 'completed',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
};

OrderTrackingApi _$OrderTrackingApiFromJson(Map<String, dynamic> json) =>
    OrderTrackingApi(
      events: (json['events'] as List<dynamic>)
          .map((e) => TrackingEventApi.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentLocation: json['currentLocation'] as String?,
      courierName: json['courierName'] as String?,
      trackingNumber: json['trackingNumber'] as String?,
    );

Map<String, dynamic> _$OrderTrackingApiToJson(OrderTrackingApi instance) =>
    <String, dynamic>{
      'events': instance.events.map((e) => e.toJson()).toList(),
      'currentLocation': instance.currentLocation,
      'courierName': instance.courierName,
      'trackingNumber': instance.trackingNumber,
    };

TrackingEventApi _$TrackingEventApiFromJson(Map<String, dynamic> json) =>
    TrackingEventApi(
      status: json['status'] as String,
      description: json['description'] as String,
      location: json['location'] as String?,
      timestamp: TrackingEventApi._dateTimeFromJson(
        json['timestamp'] as String,
      ),
    );

Map<String, dynamic> _$TrackingEventApiToJson(TrackingEventApi instance) =>
    <String, dynamic>{
      'status': instance.status,
      'description': instance.description,
      'location': instance.location,
      'timestamp': TrackingEventApi._dateTimeToJson(instance.timestamp),
    };

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    CreateOrderRequest(
      shippingAddress: ShippingAddressApi.fromJson(
        json['shippingAddress'] as Map<String, dynamic>,
      ),
      paymentMethod: json['paymentMethod'] as String,
      paymentDetails: json['paymentDetails'] as Map<String, dynamic>?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$CreateOrderRequestToJson(CreateOrderRequest instance) =>
    <String, dynamic>{
      'shippingAddress': instance.shippingAddress,
      'paymentMethod': instance.paymentMethod,
      'paymentDetails': instance.paymentDetails,
      'notes': instance.notes,
    };
