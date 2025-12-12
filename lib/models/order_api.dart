/// Modelo de Órdenes - Versión con API REST
/// EXPLICAR EN EXPOSICIÓN: Representa una orden de compra completa
/// con toda la información de pago, envío y seguimiento

import 'package:json_annotation/json_annotation.dart';

part 'order_api.g.dart';

/// Orden de Compra Completa
/// EXPLICAR: Cuando el usuario hace checkout, el carrito se convierte en orden
@JsonSerializable(explicitToJson: true)
class OrderApi {
  /// ID único de la orden
  final String id;

  /// Número de orden (para mostrar al usuario, ej: "ORD-2024-0001")
  final String orderNumber;

  /// ID del usuario que realizó la orden
  final String userId;

  /// Estado actual de la orden
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final OrderStatus status;

  /// Items de la orden (snapshot del carrito)
  /// EXPLICAR: Guardamos copia de productos para preservar precios históricos
  final List<OrderItemApi> items;

  /// Dirección de envío
  final ShippingAddressApi shippingAddress;

  /// Información de pago
  final PaymentInfoApi paymentInfo;

  /// Subtotal de productos
  final double subtotal;

  /// Impuestos aplicados
  final double tax;

  /// Costo de envío
  final double shippingCost;

  /// Descuentos aplicados (cupones, promociones)
  final double discount;

  /// Total final pagado
  final double total;

  /// Notas del cliente
  final String? notes;

  /// Seguimiento de estados
  final OrderTrackingApi tracking;

  /// Fecha de creación
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  /// Fecha de última actualización
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;

  /// Fecha estimada de entrega
  @JsonKey(fromJson: _dateTimeFromJsonNullable, toJson: _dateTimeToJsonNullable)
  final DateTime? estimatedDelivery;

  OrderApi({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.status,
    required this.items,
    required this.shippingAddress,
    required this.paymentInfo,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    this.discount = 0.0,
    required this.total,
    this.notes,
    required this.tracking,
    required this.createdAt,
    required this.updatedAt,
    this.estimatedDelivery,
  });

  factory OrderApi.fromJson(Map<String, dynamic> json) =>
      _$OrderApiFromJson(json);

  Map<String, dynamic> toJson() => _$OrderApiToJson(this);

  // Conversiones de DateTime
  static DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
  static String _dateTimeToJson(DateTime dt) => dt.toIso8601String();
  static DateTime? _dateTimeFromJsonNullable(String? json) =>
      json != null ? DateTime.parse(json) : null;
  static String? _dateTimeToJsonNullable(DateTime? dt) => dt?.toIso8601String();

  // Conversión de OrderStatus enum
  static OrderStatus _statusFromJson(String json) =>
      OrderStatus.fromString(json);
  static String _statusToJson(OrderStatus status) => status.toJson();

  /// Total de items
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// ¿Puede cancelarse?
  bool get canBeCancelled =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;

  /// ¿Está completa?
  bool get isCompleted => status == OrderStatus.delivered;

  /// ¿Fue cancelada?
  bool get isCancelled => status == OrderStatus.cancelled;
}

/// Estados de la Orden
/// EXPLICAR EN EXPOSICIÓN: Workflow completo de una orden desde creación hasta entrega
enum OrderStatus {
  pending, // Pendiente de confirmación
  confirmed, // Confirmada y en preparación
  preparing, // En preparación
  ready, // Lista para envío
  shipped, // Enviada
  outForDelivery, // En camino
  delivered, // Entregada
  cancelled; // Cancelada

  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready':
        return OrderStatus.ready;
      case 'shipped':
        return OrderStatus.shipped;
      case 'out_for_delivery':
      case 'outfordelivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  String toJson() {
    switch (this) {
      case OrderStatus.outForDelivery:
        return 'out_for_delivery';
      default:
        return name;
    }
  }

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.confirmed:
        return 'Confirmada';
      case OrderStatus.preparing:
        return 'En Preparación';
      case OrderStatus.ready:
        return 'Lista';
      case OrderStatus.shipped:
        return 'Enviada';
      case OrderStatus.outForDelivery:
        return 'En Camino';
      case OrderStatus.delivered:
        return 'Entregada';
      case OrderStatus.cancelled:
        return 'Cancelada';
    }
  }
}

/// Item de la Orden
/// EXPLICAR: Snapshot del producto al momento de la compra
@JsonSerializable(explicitToJson: true)
class OrderItemApi {
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final int quantity;
  final List<OrderToppingApi> toppings;
  final String? notes;

  OrderItemApi({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.quantity,
    this.toppings = const [],
    this.notes,
  });

  factory OrderItemApi.fromJson(Map<String, dynamic> json) =>
      _$OrderItemApiFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemApiToJson(this);

  double get toppingsPrice => toppings.fold(0.0, (sum, t) => sum + t.price);
  double get unitPrice => productPrice + toppingsPrice;
  double get totalPrice => unitPrice * quantity;
}

@JsonSerializable()
class OrderToppingApi {
  final String name;
  final double price;

  OrderToppingApi({required this.name, required this.price});

  factory OrderToppingApi.fromJson(Map<String, dynamic> json) =>
      _$OrderToppingApiFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToppingApiToJson(this);
}

/// Dirección de Envío
@JsonSerializable()
class ShippingAddressApi {
  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? additionalInfo; // Ej: "Apto 301", "Casa blanca"

  ShippingAddressApi({
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.country = 'Colombia',
    this.additionalInfo,
  });

  factory ShippingAddressApi.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressApiFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressApiToJson(this);

  /// Dirección completa en una línea
  String get fullAddress =>
      '$street${additionalInfo != null ? ', $additionalInfo' : ''}, $city, $state $zipCode';
}

/// Información de Pago
/// EXPLICAR: Datos sensibles se procesan en backend, aquí solo metadata
@JsonSerializable()
class PaymentInfoApi {
  final String method; // 'credit_card', 'debit_card', 'pse', 'cash'
  final String? last4Digits; // Últimos 4 dígitos (si es tarjeta)
  final String? cardBrand; // 'Visa', 'Mastercard', etc
  final String transactionId; // ID de transacción del procesador
  final PaymentStatus status;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime paidAt;

  PaymentInfoApi({
    required this.method,
    this.last4Digits,
    this.cardBrand,
    required this.transactionId,
    required this.status,
    required this.paidAt,
  });

  factory PaymentInfoApi.fromJson(Map<String, dynamic> json) =>
      _$PaymentInfoApiFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentInfoApiToJson(this);

  static DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
  static String _dateTimeToJson(DateTime dt) => dt.toIso8601String();
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded;

  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pendiente';
      case PaymentStatus.completed:
        return 'Completado';
      case PaymentStatus.failed:
        return 'Fallido';
      case PaymentStatus.refunded:
        return 'Reembolsado';
    }
  }
}

/// Seguimiento de la Orden
/// EXPLICAR: Timeline de eventos de la orden
@JsonSerializable(explicitToJson: true)
class OrderTrackingApi {
  final List<TrackingEventApi> events;
  final String? currentLocation;
  final String? courierName;
  final String? trackingNumber;

  OrderTrackingApi({
    required this.events,
    this.currentLocation,
    this.courierName,
    this.trackingNumber,
  });

  factory OrderTrackingApi.fromJson(Map<String, dynamic> json) =>
      _$OrderTrackingApiFromJson(json);

  Map<String, dynamic> toJson() => _$OrderTrackingApiToJson(this);
}

@JsonSerializable()
class TrackingEventApi {
  final String status;
  final String description;
  final String? location;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime timestamp;

  TrackingEventApi({
    required this.status,
    required this.description,
    this.location,
    required this.timestamp,
  });

  factory TrackingEventApi.fromJson(Map<String, dynamic> json) =>
      _$TrackingEventApiFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingEventApiToJson(this);

  static DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
  static String _dateTimeToJson(DateTime dt) => dt.toIso8601String();
}

/// Request para crear orden
/// EXPLICAR: DTO enviado al endpoint POST /api/orders
@JsonSerializable()
class CreateOrderRequest {
  final ShippingAddressApi shippingAddress;
  final String paymentMethod;
  final Map<String, dynamic>? paymentDetails; // Datos sensibles encriptados
  final String? notes;

  CreateOrderRequest({
    required this.shippingAddress,
    required this.paymentMethod,
    this.paymentDetails,
    this.notes,
  });

  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}
