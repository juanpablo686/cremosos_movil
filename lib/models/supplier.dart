// models/supplier.dart - Modelo de Supplier (Proveedor)

class Supplier {
  final String id;
  final String name;
  final String contactName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final List<String> productsSupplied;
  final double rating;
  final bool isActive;
  final String createdAt;
  final String? updatedAt;

  Supplier({
    required this.id,
    required this.name,
    required this.contactName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.productsSupplied,
    required this.rating,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] as String,
      name: json['name'] as String,
      contactName: json['contactName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      productsSupplied: (json['productsSupplied'] as List<dynamic>)
          .map((p) => p as String)
          .toList(),
      rating: (json['rating'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contactName': contactName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'productsSupplied': productsSupplied,
      'rating': rating,
      'isActive': isActive,
      'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  Supplier copyWith({
    String? id,
    String? name,
    String? contactName,
    String? email,
    String? phone,
    String? address,
    String? city,
    List<String>? productsSupplied,
    double? rating,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      contactName: contactName ?? this.contactName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      productsSupplied: productsSupplied ?? this.productsSupplied,
      rating: rating ?? this.rating,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
