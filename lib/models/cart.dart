// models/cart.dart - Modelo de Carrito de Compras

import 'user.dart' show Address, PaymentMethod;

class CartItem {
  final String productId;
  final int quantity;
  final List<String> selectedToppings;

  CartItem({
    required this.productId,
    required this.quantity,
    this.selectedToppings = const [],
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] as String,
      quantity: json['quantity'] as int,
      selectedToppings: json['selectedToppings'] != null
          ? List<String>.from(json['selectedToppings'] as List)
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'selectedToppings': selectedToppings,
    };
  }

  CartItem copyWith({
    String? productId,
    int? quantity,
    List<String>? selectedToppings,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      selectedToppings: selectedToppings ?? this.selectedToppings,
    );
  }
}

class Cart {
  final List<CartItem> items;
  final int subtotal;
  final int tax;
  final int shipping;
  final int discount;
  final int total;
  final String? couponCode;

  Cart({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.discount,
    required this.total,
    this.couponCode,
  });

  factory Cart.empty() {
    return Cart(
      items: [],
      subtotal: 0,
      tax: 0,
      shipping: 0,
      discount: 0,
      total: 0,
    );
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: json['subtotal'] as int,
      tax: json['tax'] as int,
      shipping: json['shipping'] as int,
      discount: json['discount'] as int,
      total: json['total'] as int,
      couponCode: json['couponCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'shipping': shipping,
      'discount': discount,
      'total': total,
      'couponCode': couponCode,
    };
  }

  Cart copyWith({
    List<CartItem>? items,
    int? subtotal,
    int? tax,
    int? shipping,
    int? discount,
    int? total,
    String? couponCode,
  }) {
    return Cart(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      shipping: shipping ?? this.shipping,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      couponCode: couponCode ?? this.couponCode,
    );
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final PaymentMethod paymentMethod;
  final Address shippingAddress;
  final int subtotal;
  final int tax;
  final int shipping;
  final int discount;
  final int total;
  final String? couponCode;
  final String? notes;
  final String? trackingNumber;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.createdAt,
    this.deliveredAt,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.discount,
    required this.total,
    this.couponCode,
    this.notes,
    this.trackingNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: OrderStatus.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'] as String)
          : null,
      paymentMethod: PaymentMethod.fromJson(
        json['paymentMethod'] as Map<String, dynamic>,
      ),
      shippingAddress: Address.fromJson(
        json['shippingAddress'] as Map<String, dynamic>,
      ),
      subtotal: json['subtotal'] as int,
      tax: json['tax'] as int,
      shipping: json['shipping'] as int,
      discount: json['discount'] as int,
      total: json['total'] as int,
      couponCode: json['couponCode'] as String?,
      notes: json['notes'] as String?,
      trackingNumber: json['trackingNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'paymentMethod': paymentMethod.toJson(),
      'shippingAddress': shippingAddress.toJson(),
      'subtotal': subtotal,
      'tax': tax,
      'shipping': shipping,
      'discount': discount,
      'total': total,
      'couponCode': couponCode,
      'notes': notes,
      'trackingNumber': trackingNumber,
    };
  }
}

enum OrderStatus {
  pending('pending'),
  processing('processing'),
  shipped('shipped'),
  delivered('delivered'),
  cancelled('cancelled');

  final String value;
  const OrderStatus(this.value);

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => OrderStatus.pending,
    );
  }
}
