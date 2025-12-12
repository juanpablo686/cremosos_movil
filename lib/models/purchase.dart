// models/purchase.dart - Modelo de Purchase (Compra)

class Purchase {
  final String id;
  final String purchaseNumber;
  final String supplierId;
  final String supplierName;
  final List<PurchaseItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final String status; // pending, completed, cancelled
  final String? notes;
  final String createdBy;
  final String createdAt;
  final String? receivedAt;
  final String? updatedAt;

  Purchase({
    required this.id,
    required this.purchaseNumber,
    required this.supplierId,
    required this.supplierName,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.status,
    this.notes,
    required this.createdBy,
    required this.createdAt,
    this.receivedAt,
    this.updatedAt,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'] as String,
      purchaseNumber: json['purchaseNumber'] as String,
      supplierId: json['supplierId'] as String,
      supplierName: json['supplierName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => PurchaseItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String,
      receivedAt: json['receivedAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purchaseNumber': purchaseNumber,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'status': status,
      if (notes != null) 'notes': notes,
      'createdBy': createdBy,
      'createdAt': createdAt,
      if (receivedAt != null) 'receivedAt': receivedAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'completed':
        return 'Completada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return status;
    }
  }
}

class PurchaseItem {
  final String productName;
  final int quantity;
  final double unitPrice;
  final double total;

  PurchaseItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'total': total,
    };
  }
}
