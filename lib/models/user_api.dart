/// Modelo de Usuario - Versión con API REST
/// EXPLICAR EN EXPOSICIÓN: Este modelo representa un usuario en el sistema
/// y se encarga de la serialización/deserialización de JSON (fromJson/toJson)

import 'package:json_annotation/json_annotation.dart';

// Genera el archivo user.g.dart con el código de serialización
// EXPLICAR: build_runner genera automáticamente el código repetitivo
part 'user_api.g.dart';

/// Clase principal de Usuario
/// EXPLICAR: @JsonSerializable genera automáticamente fromJson y toJson
@JsonSerializable(explicitToJson: true)
class UserApi {
  /// ID único del usuario (generado por el servidor)
  final String id;

  /// Nombre completo del usuario
  final String name;

  /// Email (también sirve como username para login)
  final String email;

  /// Teléfono (opcional)
  final String? phone;

  /// Fecha de nacimiento en formato ISO 8601
  final String? birthDate;

  /// URL de la imagen de perfil
  final String? avatar;

  /// Lista de direcciones guardadas del usuario
  /// EXPLICAR: Relación uno a muchos (un usuario puede tener múltiples direcciones)
  final List<AddressApi> addresses;

  /// Rol del usuario (customer, admin, etc.)
  final UserRole role;

  /// Preferencias de notificaciones y configuración
  final UserPreferencesApi preferences;

  /// Métodos de pago guardados
  final List<PaymentMethodApi> paymentMethods;

  /// Fecha de creación de la cuenta
  /// EXPLICAR: DateTime se serializa automáticamente a ISO 8601
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  /// Indica si la cuenta está activa
  final bool isActive;

  UserApi({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.birthDate,
    this.avatar,
    this.addresses = const [],
    this.role = UserRole.customer,
    required this.preferences,
    this.paymentMethods = const [],
    required this.createdAt,
    this.isActive = true,
  });

  /// fromJson - Convertir JSON del servidor a objeto Dart
  /// EXPLICAR EN EXPOSICIÓN: El servidor envía JSON, necesitamos convertirlo
  /// a objetos Dart para trabajar con ellos en la aplicación
  ///
  /// Ejemplo de JSON del servidor:
  /// {
  ///   "id": "user-123",
  ///   "name": "Juan Pérez",
  ///   "email": "juan@example.com",
  ///   "role": "customer",
  ///   ...
  /// }
  factory UserApi.fromJson(Map<String, dynamic> json) =>
      _$UserApiFromJson(json);

  /// toJson - Convertir objeto Dart a JSON para enviar al servidor
  /// EXPLICAR: Cuando actualizamos datos, necesitamos convertir el objeto
  /// Dart de vuelta a JSON para enviarlo en la petición HTTP
  Map<String, dynamic> toJson() => _$UserApiToJson(this);

  // Funciones helper para conversión de DateTime
  // EXPLICAR: JSON no tiene tipo DateTime nativo, se usa string ISO 8601
  static DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
  static String _dateTimeToJson(DateTime dateTime) =>
      dateTime.toIso8601String();

  /// Método para copiar el usuario con algunos campos modificados
  /// EXPLICAR: Dart no tiene mutabilidad, necesitamos crear una copia
  /// modificada cuando queremos actualizar datos
  UserApi copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? birthDate,
    String? avatar,
    List<AddressApi>? addresses,
    UserRole? role,
    UserPreferencesApi? preferences,
    List<PaymentMethodApi>? paymentMethods,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return UserApi(
      id: id ?? this.id,
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

/// Modelo de Dirección
/// EXPLICAR: Representa una dirección de envío del usuario
@JsonSerializable()
class AddressApi {
  final String id;
  final String street; // Calle y número
  final String city; // Ciudad
  final String state; // Departamento/Estado
  final String postalCode; // Código postal
  final bool isDefault; // ¿Es la dirección predeterminada?

  AddressApi({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    this.isDefault = false,
  });

  factory AddressApi.fromJson(Map<String, dynamic> json) =>
      _$AddressApiFromJson(json);

  Map<String, dynamic> toJson() => _$AddressApiToJson(this);

  /// Dirección formateada para mostrar en UI
  String get fullAddress => '$street, $city, $state $postalCode';
}

/// Enum de Roles de Usuario
/// EXPLICAR: Define los diferentes tipos de usuarios en el sistema
enum UserRole {
  customer, // Cliente normal
  admin, // Administrador (acceso a reportes)
  employee; // Empleado (puede procesar órdenes)

  /// Convertir string del JSON a enum
  /// EXPLICAR: El servidor envía "customer" como string, lo convertimos a enum
  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'employee':
        return UserRole.employee;
      case 'customer':
      default:
        return UserRole.customer;
    }
  }

  /// Convertir enum a string para enviar al servidor
  String toJson() => toString().split('.').last;
}

/// Preferencias del Usuario
/// EXPLICAR: Configuración de notificaciones y preferencias de la app
@JsonSerializable()
class UserPreferencesApi {
  final bool pushNotifications; // Notificaciones push
  final bool emailNotifications; // Notificaciones por email
  final bool promotions; // Recibir promociones
  final bool newsletter; // Recibir newsletter
  final String language; // Idioma preferido (es, en)
  final String currency; // Moneda preferida (COP, USD)

  UserPreferencesApi({
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.promotions = false,
    this.newsletter = true,
    this.language = 'es',
    this.currency = 'COP',
  });

  factory UserPreferencesApi.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesApiFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesApiToJson(this);
}

/// Método de Pago
/// EXPLICAR: Representa una tarjeta de crédito/débito guardada
@JsonSerializable()
class PaymentMethodApi {
  final String id;
  final String type; // credit_card, debit_card, etc.
  final String cardBrand; // Visa, Mastercard, etc.
  final String cardLast4; // Últimos 4 dígitos
  final String expiryMonth; // Mes de expiración (01-12)
  final String expiryYear; // Año de expiración (2025)
  final bool isDefault; // ¿Es el método predeterminado?

  PaymentMethodApi({
    required this.id,
    required this.type,
    required this.cardBrand,
    required this.cardLast4,
    required this.expiryMonth,
    required this.expiryYear,
    this.isDefault = false,
  });

  factory PaymentMethodApi.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodApiFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodApiToJson(this);

  /// Información de la tarjeta formateada
  /// Ejemplo: "Visa **** 1234"
  String get displayInfo => '$cardBrand **** $cardLast4';

  /// Verifica si la tarjeta está vencida
  bool get isExpired {
    final now = DateTime.now();
    final expiry = DateTime(int.parse(expiryYear), int.parse(expiryMonth));
    return now.isAfter(expiry);
  }
}
