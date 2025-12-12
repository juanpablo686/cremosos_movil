/// Modelo de Respuesta API Genérico
/// EXPLICAR EN EXPOSICIÓN: Wrapper estándar para todas las respuestas de la API
/// Permite manejar respuestas exitosas, errores y estados de manera consistente

import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// Respuesta API Genérica
/// EXPLICAR: Envolvemos todas las respuestas en este formato para manejo uniforme
///
/// Ejemplo de respuesta exitosa:
/// {
///   "success": true,
///   "message": "Productos obtenidos exitosamente",
///   "data": [...lista de productos...],
///   "meta": { "page": 1, "total": 100 }
/// }
///
/// Ejemplo de respuesta con error:
/// {
///   "success": false,
///   "message": "Error de autenticación",
///   "error": {
///     "code": "AUTH_INVALID_TOKEN",
///     "details": "El token ha expirado"
///   }
/// }
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  /// ¿La petición fue exitosa?
  final bool success;

  /// Mensaje descriptivo (éxito o error)
  final String message;

  /// Datos de la respuesta (solo si success = true)
  @JsonKey(includeIfNull: false)
  final T? data;

  /// Información adicional (paginación, filtros, etc)
  @JsonKey(includeIfNull: false)
  final ResponseMeta? meta;

  /// Detalles del error (solo si success = false)
  @JsonKey(includeIfNull: false)
  final ApiError? error;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.meta,
    this.error,
  });

  /// Deserialización con tipo genérico
  /// EXPLICAR: fromJsonFactory convierte el data según el tipo T esperado
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  /// Factory para respuesta exitosa
  factory ApiResponse.success({
    required T data,
    String message = 'Success',
    ResponseMeta? meta,
  }) {
    return ApiResponse(success: true, message: message, data: data, meta: meta);
  }

  /// Factory para respuesta de error
  factory ApiResponse.failure({
    required String message,
    required ApiError error,
  }) {
    return ApiResponse(success: false, message: message, error: error);
  }

  /// ¿Tiene datos?
  bool get hasData => data != null;

  /// ¿Hay error?
  bool get hasError => error != null;
}

/// Metadata de la Respuesta
/// EXPLICAR: Información adicional como paginación
@JsonSerializable()
class ResponseMeta {
  /// Página actual (paginación)
  final int? page;

  /// Tamaño de página
  final int? limit;

  /// Total de items disponibles
  final int? total;

  /// Total de páginas
  final int? totalPages;

  /// ¿Hay página siguiente?
  final bool? hasNext;

  /// ¿Hay página anterior?
  final bool? hasPrevious;

  /// Filtros aplicados
  final Map<String, dynamic>? filters;

  ResponseMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.hasNext,
    this.hasPrevious,
    this.filters,
  });

  factory ResponseMeta.fromJson(Map<String, dynamic> json) =>
      _$ResponseMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseMetaToJson(this);
}

/// Error de la API
/// EXPLICAR: Estructura detallada para errores del servidor
@JsonSerializable()
class ApiError {
  /// Código de error (para identificación programática)
  /// Ejemplos: 'AUTH_INVALID_TOKEN', 'PRODUCT_NOT_FOUND', 'VALIDATION_ERROR'
  final String code;

  /// Detalles adicionales del error
  final String? details;

  /// Errores de validación por campo
  /// Ejemplo: { "email": "Email inválido", "password": "Muy corta" }
  final Map<String, dynamic>? validationErrors;

  /// Stack trace (solo en desarrollo)
  final String? stackTrace;

  ApiError({
    required this.code,
    this.details,
    this.validationErrors,
    this.stackTrace,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}

/// Lista Paginada
/// EXPLICAR: Para endpoints que retornan listas con paginación
@JsonSerializable(genericArgumentFactories: true)
class PaginatedList<T> {
  /// Items de la página actual
  final List<T> items;

  /// Página actual
  final int page;

  /// Tamaño de página
  final int limit;

  /// Total de items
  final int total;

  /// Total de páginas
  final int totalPages;

  PaginatedList({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginatedList.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginatedListFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$PaginatedListToJson(this, toJsonT);

  /// ¿Hay más páginas?
  bool get hasMore => page < totalPages;

  /// ¿Es la primera página?
  bool get isFirstPage => page == 1;

  /// ¿Es la última página?
  bool get isLastPage => page == totalPages;

  /// ¿Está vacía?
  bool get isEmpty => items.isEmpty;
}

/// Estados de Carga para UI
/// EXPLICAR EN EXPOSICIÓN: Pattern para manejar estados en los providers
///
/// Ejemplo de uso en un provider:
/// ```dart
/// final state = StateNotifier<DataState<List<Product>>>()
///
/// // Inicio de carga
/// state = DataState.loading();
///
/// // Éxito
/// state = DataState.success(products);
///
/// // Error
/// state = DataState.error('No se pudo cargar productos');
/// ```
sealed class DataState<T> {
  const DataState();

  /// Estado inicial
  factory DataState.initial() = DataStateInitial;

  /// Cargando
  factory DataState.loading() = DataStateLoading;

  /// Datos cargados exitosamente
  factory DataState.success(T data) = DataStateSuccess;

  /// Error al cargar
  factory DataState.error(String message, {StackTrace? stackTrace}) =
      DataStateError;

  /// Vacío (cargado pero sin datos)
  factory DataState.empty() = DataStateEmpty;

  /// Helpers para UI
  bool get isInitial => this is DataStateInitial;
  bool get isLoading => this is DataStateLoading;
  bool get isSuccess => this is DataStateSuccess<T>;
  bool get isError => this is DataStateError<T>;
  bool get isEmpty => this is DataStateEmpty<T>;

  /// Obtener datos (null si no es success)
  T? get dataOrNull =>
      this is DataStateSuccess<T> ? (this as DataStateSuccess<T>).data : null;

  /// Obtener error (null si no es error)
  String? get errorOrNull =>
      this is DataStateError<T> ? (this as DataStateError<T>).message : null;

  /// Pattern matching helper
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String message) error,
    required R Function() empty,
  }) {
    if (this is DataStateInitial) return initial();
    if (this is DataStateLoading) return loading();
    if (this is DataStateSuccess<T>)
      return success((this as DataStateSuccess<T>).data);
    if (this is DataStateError<T>)
      return error((this as DataStateError<T>).message);
    if (this is DataStateEmpty) return empty();
    throw Exception('Unknown state');
  }
}

class DataStateInitial<T> extends DataState<T> {
  const DataStateInitial();
}

class DataStateLoading<T> extends DataState<T> {
  const DataStateLoading();
}

class DataStateSuccess<T> extends DataState<T> {
  final T data;
  const DataStateSuccess(this.data);
}

class DataStateError<T> extends DataState<T> {
  final String message;
  final StackTrace? stackTrace;
  const DataStateError(this.message, {this.stackTrace});
}

class DataStateEmpty<T> extends DataState<T> {
  const DataStateEmpty();
}
