// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponse<T>(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  meta: json['meta'] == null
      ? null
      : ResponseMeta.fromJson(json['meta'] as Map<String, dynamic>),
  error: json['error'] == null
      ? null
      : ApiError.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': ?_$nullableGenericToJson(instance.data, toJsonT),
  'meta': ?instance.meta,
  'error': ?instance.error,
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

ResponseMeta _$ResponseMetaFromJson(Map<String, dynamic> json) => ResponseMeta(
  page: (json['page'] as num?)?.toInt(),
  limit: (json['limit'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  hasNext: json['hasNext'] as bool?,
  hasPrevious: json['hasPrevious'] as bool?,
  filters: json['filters'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ResponseMetaToJson(ResponseMeta instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'totalPages': instance.totalPages,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
      'filters': instance.filters,
    };

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) => ApiError(
  code: json['code'] as String,
  details: json['details'] as String?,
  validationErrors: json['validationErrors'] as Map<String, dynamic>?,
  stackTrace: json['stackTrace'] as String?,
);

Map<String, dynamic> _$ApiErrorToJson(ApiError instance) => <String, dynamic>{
  'code': instance.code,
  'details': instance.details,
  'validationErrors': instance.validationErrors,
  'stackTrace': instance.stackTrace,
};

PaginatedList<T> _$PaginatedListFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => PaginatedList<T>(
  items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _$PaginatedListToJson<T>(
  PaginatedList<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items.map(toJsonT).toList(),
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
  'totalPages': instance.totalPages,
};
