// Modelo de Usuario
// EXPLICAR EN EXPOSICIÓN: Este archivo define la estructura de datos del usuario
// Incluye métodos para convertir entre JSON (API) y objetos Dart (App)

/// Clase principal que representa a un usuario del sistema
/// Contiene toda la información personal, direcciones, preferencias y métodos de pago
class User {
  // Propiedades básicas del usuario
  final String id; // ID único del usuario en la base de datos
  final String name; // Nombre completo del usuario
  final String email; // Email (usado para login)
  final String? phone; // Teléfono (opcional, por eso el ?)
  final String? birthDate; // Fecha de nacimiento (opcional)
  final String? avatar; // URL de la foto de perfil (opcional)

  // Propiedades complejas (listas y objetos)
  final List<Address> addresses; // Lista de direcciones de envío
  final UserRole role; // Rol del usuario (admin, customer, employee)
  final UserPreferences
  preferences; // Preferencias de notificaciones, tema, etc.
  final List<PaymentMethod> paymentMethods; // Métodos de pago guardados

  // Metadatos
  final DateTime createdAt; // Fecha de registro
  final bool isActive; // Indica si la cuenta está activa

  // Constructor
  // EXPLICAR: required significa que el parámetro es obligatorio
  // this.propertyName es una forma corta de asignar el parámetro a la propiedad
  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.birthDate,
    this.avatar,
    this.addresses = const [], // Lista vacía por defecto
    required this.role,
    required this.preferences,
    this.paymentMethods = const [], // Lista vacía por defecto
    required this.createdAt,
    this.isActive = true, // Activo por defecto
  });

  /// Factory constructor para crear User desde JSON
  /// EXPLICAR: Se usa cuando recibimos datos de la API en formato JSON
  /// Convierte Map<String, dynamic> a objeto User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      birthDate: json['birthDate'] as String?,
      avatar: json['avatar'] as String?,
      // Convertir array de JSON a lista de objetos Address
      addresses:
          (json['addresses'] as List<dynamic>?)
              ?.map((e) => Address.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      // Convertir string del rol a enum UserRole
      role: UserRole.fromString(json['role'] as String),
      // Si preferences existe en JSON, convertirlo, sino crear uno nuevo
      preferences: json['preferences'] != null
          ? UserPreferences.fromJson(
              json['preferences'] as Map<String, dynamic>,
            )
          : UserPreferences(), // Valores por defecto si no vienen del servidor
      // Convertir array de JSON a lista de objetos PaymentMethod
      paymentMethods:
          (json['paymentMethods'] as List<dynamic>?)
              ?.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      // Parsear fecha ISO 8601 a objeto DateTime
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(), // Fecha actual si no viene del servidor
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Convertir objeto User a JSON
  /// EXPLICAR: Se usa cuando enviamos datos a la API
  /// Convierte objeto User a Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'birthDate': birthDate,
      'avatar': avatar,
      // Convertir lista de Address a lista de JSON
      'addresses': addresses.map((e) => e.toJson()).toList(),
      // Convertir enum UserRole a string
      'role': role.value,
      // Convertir objeto UserPreferences a JSON
      'preferences': preferences.toJson(),
      // Convertir lista de PaymentMethod a lista de JSON
      'paymentMethods': paymentMethods.map((e) => e.toJson()).toList(),
      // Convertir DateTime a string ISO 8601
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// Método copyWith para crear una copia modificada del usuario
  /// EXPLICAR: Permite modificar algunas propiedades manteniendo las demás igual
  /// Esto es importante porque los objetos deberían ser inmutables
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? birthDate,
    String? avatar,
    List<Address>? addresses,
    UserRole? role,
    UserPreferences? preferences,
    List<PaymentMethod>? paymentMethods,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id, // Si se pasa id, usarlo, sino usar el actual
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      avatar: avatar ?? this.avatar,
      addresses: addresses ?? this.addresses,
      role: role ?? this.role,
      preferences: preferences ?? this.preferences,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

enum UserRole {
  customer('customer'),
  admin('admin');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.customer,
    );
  }
}

class Address {
  final String? id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final AddressType type;
  final bool isDefault;
  final String recipientName;
  final String recipientPhone;
  final String? additionalInfo;

  Address({
    this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.type,
    required this.isDefault,
    required this.recipientName,
    required this.recipientPhone,
    this.additionalInfo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String?,
      label: json['label'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      postalCode: json['postalCode'] as String,
      country: json['country'] as String,
      type: AddressType.fromString(json['type'] as String),
      isDefault: json['isDefault'] as bool,
      recipientName: json['recipientName'] as String,
      recipientPhone: json['recipientPhone'] as String,
      additionalInfo: json['additionalInfo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'type': type.value,
      'isDefault': isDefault,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'additionalInfo': additionalInfo,
    };
  }

  Address copyWith({
    String? id,
    String? label,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    AddressType? type,
    bool? isDefault,
    String? recipientName,
    String? recipientPhone,
    String? additionalInfo,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}

enum AddressType {
  home('home'),
  work('work'),
  other('other');

  final String value;
  const AddressType(this.value);

  static AddressType fromString(String value) {
    return AddressType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AddressType.home,
    );
  }
}

class UserPreferences {
  final List<String> favoriteProducts;
  final List<String> dietaryRestrictions;
  final bool newsletter;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final String theme;
  final String language;

  UserPreferences({
    this.favoriteProducts = const [],
    this.dietaryRestrictions = const [],
    this.newsletter = false,
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.theme = 'light',
    this.language = 'es',
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      favoriteProducts: json['favoriteProducts'] != null
          ? List<String>.from(json['favoriteProducts'] as List)
          : [],
      dietaryRestrictions: json['dietaryRestrictions'] != null
          ? List<String>.from(json['dietaryRestrictions'] as List)
          : [],
      newsletter: json['newsletter'] as bool? ?? false,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? false,
      theme: json['theme'] as String? ?? 'light',
      language: json['language'] as String? ?? 'es',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favoriteProducts': favoriteProducts,
      'dietaryRestrictions': dietaryRestrictions,
      'newsletter': newsletter,
      'pushNotifications': pushNotifications,
      'emailNotifications': emailNotifications,
      'smsNotifications': smsNotifications,
      'theme': theme,
      'language': language,
    };
  }

  UserPreferences copyWith({
    List<String>? favoriteProducts,
    List<String>? dietaryRestrictions,
    bool? newsletter,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
    String? theme,
    String? language,
  }) {
    return UserPreferences(
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      newsletter: newsletter ?? this.newsletter,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      theme: theme ?? this.theme,
      language: language ?? this.language,
    );
  }
}

class LoginCredentials {
  final String email;
  final String password;
  final bool rememberMe;

  LoginCredentials({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
}

class RegisterData {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String? phone;
  final bool acceptTerms;

  RegisterData({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.phone,
    required this.acceptTerms,
  });
}

class AuthResponse {
  final User user;
  final String token;
  final String refreshToken;
  final int expiresIn;

  AuthResponse({
    required this.user,
    required this.token,
    required this.refreshToken,
    required this.expiresIn,
  });
}

class PaymentMethod {
  final String id;
  final String type;
  final String last4;
  final String brand;
  final int? expiryMonth;
  final int? expiryYear;
  final bool isDefault;
  final String holderName;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
    required this.brand,
    this.expiryMonth,
    this.expiryYear,
    required this.isDefault,
    required this.holderName,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      type: json['type'] as String,
      last4: json['last4'] as String,
      brand: json['brand'] as String,
      expiryMonth: json['expiryMonth'] as int?,
      expiryYear: json['expiryYear'] as int?,
      isDefault: json['isDefault'] as bool,
      holderName: json['holderName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'last4': last4,
      'brand': brand,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'isDefault': isDefault,
      'holderName': holderName,
    };
  }
}
