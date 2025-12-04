// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApi _$UserApiFromJson(Map<String, dynamic> json) => UserApi(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  birthDate: json['birthDate'] as String?,
  avatar: json['avatar'] as String?,
  addresses:
      (json['addresses'] as List<dynamic>?)
          ?.map((e) => AddressApi.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  role:
      $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.customer,
  preferences: UserPreferencesApi.fromJson(
    json['preferences'] as Map<String, dynamic>,
  ),
  paymentMethods:
      (json['paymentMethods'] as List<dynamic>?)
          ?.map((e) => PaymentMethodApi.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: UserApi._dateTimeFromJson(json['createdAt'] as String),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$UserApiToJson(UserApi instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'birthDate': instance.birthDate,
  'avatar': instance.avatar,
  'addresses': instance.addresses.map((e) => e.toJson()).toList(),
  'role': instance.role.toJson(),
  'preferences': instance.preferences.toJson(),
  'paymentMethods': instance.paymentMethods.map((e) => e.toJson()).toList(),
  'createdAt': UserApi._dateTimeToJson(instance.createdAt),
  'isActive': instance.isActive,
};

const _$UserRoleEnumMap = {
  UserRole.customer: 'customer',
  UserRole.admin: 'admin',
  UserRole.employee: 'employee',
};

AddressApi _$AddressApiFromJson(Map<String, dynamic> json) => AddressApi(
  id: json['id'] as String,
  street: json['street'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  postalCode: json['postalCode'] as String,
  isDefault: json['isDefault'] as bool? ?? false,
);

Map<String, dynamic> _$AddressApiToJson(AddressApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'postalCode': instance.postalCode,
      'isDefault': instance.isDefault,
    };

UserPreferencesApi _$UserPreferencesApiFromJson(Map<String, dynamic> json) =>
    UserPreferencesApi(
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      promotions: json['promotions'] as bool? ?? false,
      newsletter: json['newsletter'] as bool? ?? true,
      language: json['language'] as String? ?? 'es',
      currency: json['currency'] as String? ?? 'COP',
    );

Map<String, dynamic> _$UserPreferencesApiToJson(UserPreferencesApi instance) =>
    <String, dynamic>{
      'pushNotifications': instance.pushNotifications,
      'emailNotifications': instance.emailNotifications,
      'promotions': instance.promotions,
      'newsletter': instance.newsletter,
      'language': instance.language,
      'currency': instance.currency,
    };

PaymentMethodApi _$PaymentMethodApiFromJson(Map<String, dynamic> json) =>
    PaymentMethodApi(
      id: json['id'] as String,
      type: json['type'] as String,
      cardBrand: json['cardBrand'] as String,
      cardLast4: json['cardLast4'] as String,
      expiryMonth: json['expiryMonth'] as String,
      expiryYear: json['expiryYear'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$PaymentMethodApiToJson(PaymentMethodApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'cardBrand': instance.cardBrand,
      'cardLast4': instance.cardLast4,
      'expiryMonth': instance.expiryMonth,
      'expiryYear': instance.expiryYear,
      'isDefault': instance.isDefault,
    };
