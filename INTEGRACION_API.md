## Integración API REST - Resumen Técnico

### EXPLICAR EN EXPOSICIÓN 🎯

## 1. Arquitectura de 3 Capas

```
┌─────────────────────────────────────┐
│          CAPA DE UI                 │  ← Screens (Flutter Widgets)
│  (Pantallas: Home, Cart, etc)       │
└─────────────────────────────────────┘
              ↓ ↑
         (Consumer/Watch)
              ↓ ↑
┌─────────────────────────────────────┐
│     CAPA DE ESTADO (Providers)      │  ← Riverpod Providers
│  (Gestión de estado con Riverpod)   │
└─────────────────────────────────────┘
              ↓ ↑
      (Llamadas a Services)
              ↓ ↑
┌─────────────────────────────────────┐
│      CAPA DE SERVICIOS              │  ← Services (API Calls)
│  (Comunicación con servidor)        │
└─────────────────────────────────────┘
              ↓ ↑
          (HTTP Requests)
              ↓ ↑
┌─────────────────────────────────────┐
│         SERVIDOR REST API           │  ← Backend (Node.js/Express)
│     (Base de Datos MongoDB)         │
└─────────────────────────────────────┘
```

## 2. Servicios Implementados (15+ Endpoints)

### AuthService (4 endpoints)
- ✅ POST `/api/auth/login` - Iniciar sesión
- ✅ POST `/api/auth/register` - Registrar usuario
- ✅ GET `/api/users/profile` - Obtener perfil
- ✅ PUT `/api/users/profile` - Actualizar perfil

### ProductService (3 endpoints)
- ✅ GET `/api/products` - Listar productos (con filtros)
- ✅ GET `/api/products/:id` - Detalle de producto
- ✅ GET `/api/products/featured` - Productos destacados

### CartService (5 endpoints)
- ✅ GET `/api/cart` - Ver carrito
- ✅ POST `/api/cart/items` - **CREATE** item
- ✅ PUT `/api/cart/items/:id` - **UPDATE** item
- ✅ DELETE `/api/cart/items/:id` - **DELETE** item
- ✅ DELETE `/api/cart` - Vaciar carrito

### OrderService (5 endpoints)
- ✅ POST `/api/orders` - Crear orden
- ✅ GET `/api/orders` - Historial de órdenes
- ✅ GET `/api/orders/:id` - Detalle de orden
- ✅ PUT `/api/orders/:id/cancel` - Cancelar orden
- ✅ GET `/api/orders/:id/track` - Rastrear orden

### ReportService (5 endpoints)
- ✅ GET `/api/reports/dashboard` - Dashboard principal
- ✅ GET `/api/reports/sales` - Reporte de ventas
- ✅ GET `/api/reports/products` - Rendimiento de productos
- ✅ GET `/api/reports/customers` - Estadísticas de clientes
- ✅ GET `/api/reports/export` - Exportar reportes

**TOTAL: 22 ENDPOINTS (Supera el mínimo de 10 requerido)**

## 3. Métodos HTTP - EXPLICAR EN DETALLE

### GET - Leer Datos
```dart
// No modifica datos en el servidor, solo consulta
final productos = await productService.getAllProducts();
```
**Características:**
- Idempotente (múltiples llamadas = mismo resultado)
- Se puede cachear
- Parámetros en query string (?category=bebidas&page=1)

### POST - Crear Datos
```dart
// Crea un nuevo recurso en el servidor
final nuevaOrden = await orderService.createOrder(
  shippingAddress: address,
  paymentMethod: 'credit_card',
);
```
**Características:**
- No idempotente (cada llamada crea un nuevo recurso)
- Body con datos JSON
- Retorna el recurso creado con su ID

### PUT - Actualizar Datos
```dart
// Actualiza un recurso existente completo
await cartService.updateCartItem(
  itemId: '123',
  quantity: 3,
);
```
**Características:**
- Idempotente
- Actualiza recurso completo
- Requiere ID del recurso en la URL

### DELETE - Eliminar Datos
```dart
// Elimina un recurso del servidor
await cartService.removeCartItem('123');
```
**Características:**
- Idempotente
- Solo requiere ID del recurso
- Retorna confirmación

## 4. Autenticación JWT - EXPLICAR SEGURIDAD

### ¿Qué es JWT?
**JSON Web Token**: Token firmado digitalmente que contiene información del usuario.

```
Estructura:
header.payload.signature
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

### Flujo de Autenticación
```
1. Usuario ingresa email + password
   ↓
2. App envía POST /api/auth/login
   ↓
3. Servidor valida credenciales
   ↓
4. Servidor genera JWT y lo retorna
   ↓
5. App guarda JWT en FlutterSecureStorage (encriptado)
   ↓
6. Para cada petición protegida, agregamos header:
   Authorization: Bearer <token>
   ↓
7. Servidor valida el token y procesa la petición
```

### Implementación en el Código
```dart
// Interceptor automático (api_service.dart)
_dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await getAuthToken();
      if (token != null) {
        // Inyecta automáticamente el token en cada petición
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
  ),
);
```

## 5. Manejo de Errores - EXPLICAR CÓDIGOS HTTP

### Códigos de Estado HTTP

| Código | Significado | Ejemplo |
|--------|-------------|---------|
| **200** | OK - Éxito | Producto encontrado y retornado |
| **201** | Created - Creado | Nueva orden creada exitosamente |
| **400** | Bad Request - Petición inválida | Datos de formulario incorrectos |
| **401** | Unauthorized - No autenticado | Token inválido o expirado |
| **403** | Forbidden - Sin permisos | Usuario no es admin |
| **404** | Not Found - No encontrado | Producto con ese ID no existe |
| **500** | Internal Server Error - Error del servidor | Error en la base de datos |

### Implementación en el Código
```dart
void _handleError(DioException error) {
  switch (error.response?.statusCode) {
    case 400:
      throw Exception('Datos inválidos: ${error.response?.data}');
    case 401:
      throw Exception('No autenticado. Inicia sesión nuevamente.');
    case 404:
      throw Exception('Recurso no encontrado');
    case 500:
      throw Exception('Error del servidor. Intenta más tarde.');
    default:
      throw Exception('Error: ${error.message}');
  }
}
```

## 6. Serialización JSON - EXPLICAR PROCESO

### ¿Por qué Serialización?

**JSON del servidor:**
```json
{
  "id": "abc123",
  "name": "Arroz con Leche",
  "price": 8000
}
```

**Clase Dart:**
```dart
class Product {
  final String id;
  final String name;
  final double price;
}
```

**Necesitamos convertir JSON ↔ Dart automáticamente**

### Proceso con json_serializable

1. **Definimos el modelo con anotaciones:**
```dart
@JsonSerializable()
class ProductApi {
  final String id;
  final String name;
  final double price;
  
  factory ProductApi.fromJson(Map<String, dynamic> json) => 
      _$ProductApiFromJson(json);
  
  Map<String, dynamic> toJson() => _$ProductApiToJson(this);
}
```

2. **build_runner genera el código automáticamente:**
```bash
flutter pub run build_runner build
```

3. **Se crea product_api.g.dart con la implementación:**
```dart
ProductApi _$ProductApiFromJson(Map<String, dynamic> json) => ProductApi(
  id: json['id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
);
```

## 7. Estados de Carga - EXPLICAR PATRÓN

### DataState Pattern

```dart
sealed class DataState<T> {
  DataStateInitial()   // Estado inicial, nada cargado aún
  DataStateLoading()   // Mostrando spinner/progress
  DataStateSuccess(T)  // Datos cargados correctamente
  DataStateError(msg)  // Error al cargar
  DataStateEmpty()     // Cargado pero sin datos
}
```

### Uso en Providers
```dart
class ProductsNotifier extends StateNotifier<DataState<List<Product>>> {
  ProductsNotifier(this._productService) 
    : super(DataState.initial());
  
  Future<void> loadProducts() async {
    // Cambiar a loading
    state = DataState.loading();
    
    try {
      final products = await _productService.getAllProducts();
      
      if (products.isEmpty) {
        state = DataState.empty();
      } else {
        state = DataState.success(products);
      }
    } catch (e) {
      state = DataState.error(e.toString());
    }
  }
}
```

### Uso en UI
```dart
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(productsProvider);
  
  return state.when(
    initial: () => Text('Presiona para cargar'),
    loading: () => CircularProgressIndicator(),
    success: (products) => ListView.builder(...),
    error: (msg) => Text('Error: $msg'),
    empty: () => Text('No hay productos'),
  );
}
```

## 8. Interceptores - EXPLICAR CONCEPTO

Los interceptores son "middleware" que se ejecutan antes/después de cada petición HTTP.

```dart
// ANTES de enviar la petición
onRequest: (options, handler) async {
  print('→ ${options.method} ${options.path}');
  
  // Agregar token automáticamente
  final token = await getAuthToken();
  if (token != null) {
    options.headers['Authorization'] = 'Bearer $token';
  }
  
  // Agregar timestamp
  options.headers['X-Request-Time'] = DateTime.now().toIso8601String();
  
  return handler.next(options);
}

// DESPUÉS de recibir la respuesta
onResponse: (response, handler) async {
  print('← ${response.statusCode}');
  return handler.next(response);
}

// SI hay un error
onError: (error, handler) async {
  print('✗ Error: ${error.message}');
  
  // Si es 401, cerrar sesión automáticamente
  if (error.response?.statusCode == 401) {
    await clearAuthToken();
    // Redirigir a login
  }
  
  return handler.next(error);
}
```

## 9. Paginación - EXPLICAR IMPLEMENTACIÓN

### Request con Paginación
```dart
Future<List<Product>> getAllProducts({
  String? category,
  int page = 1,
  int limit = 20,
}) async {
  final response = await _apiService.get(
    ApiConfig.products,
    queryParameters: {
      'category': category,
      'page': page,
      'limit': limit,
    },
  );
  
  return ApiResponse<List<Product>>.fromJson(
    response.data,
    (json) => (json as List).map((p) => Product.fromJson(p)).toList(),
  );
}
```

### Response del Servidor
```json
{
  "success": true,
  "data": [...productos...],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 156,
    "totalPages": 8,
    "hasNext": true,
    "hasPrevious": false
  }
}
```

## 10. Conclusiones para la Exposición

### Puntos Clave a Mencionar:

1. **Arquitectura en Capas** → Separación de responsabilidades
2. **22 Endpoints** → Cumple con requerimientos (mínimo 10)
3. **CRUD Completo** → Demostrado en CartService
4. **JWT Authentication** → Seguridad con tokens encriptados
5. **Métodos HTTP** → GET, POST, PUT, DELETE correctamente usados
6. **Manejo de Errores** → Códigos HTTP interpretados correctamente
7. **Estados de UI** → Loading, Success, Error, Empty
8. **Serialización Automática** → json_serializable con build_runner
9. **Interceptores** → Inyección automática de tokens
10. **Código Documentado** → Comentarios en español para exposición

### Flujo Completo (Ejemplo: Agregar al Carrito)

```
1. Usuario presiona "Agregar al Carrito" en UI
   ↓
2. Provider llama a cartService.addItemToCart()
   ↓
3. CartService construye el body JSON con producto y cantidad
   ↓
4. ApiService.post() envía POST a /api/cart/items
   ↓
5. Interceptor agrega automáticamente token JWT
   ↓
6. Servidor valida token, procesa petición, actualiza DB
   ↓
7. Servidor retorna carrito actualizado como JSON
   ↓
8. json_serializable deserializa JSON → CartApi object
   ↓
9. Provider actualiza estado a DataState.success(cart)
   ↓
10. UI reacciona automáticamente mostrando carrito actualizado
```

## Archivos Creados

### Configuración
- `lib/config/api_config.dart` → URLs y constantes

### Servicios
- `lib/services/api_service.dart` → Base HTTP con Dio
- `lib/services/auth_service.dart` → Autenticación
- `lib/services/product_service.dart` → Productos
- `lib/services/cart_service.dart` → Carrito
- `lib/services/order_service.dart` → Órdenes
- `lib/services/report_service.dart` → Reportes

### Modelos con Serialización
- `lib/models/user_api.dart` + `.g.dart`
- `lib/models/product_api.dart` + `.g.dart`
- `lib/models/cart_api.dart` + `.g.dart`
- `lib/models/order_api.dart` + `.g.dart`
- `lib/models/report_api.dart` + `.g.dart`
- `lib/models/api_response.dart` + `.g.dart`

### Próximos Pasos
1. Actualizar providers para usar servicios
2. Modificar pantallas para mostrar estados de carga
3. Implementar manejo de errores en UI
4. Crear/configurar servidor backend
5. Probar integración completa
