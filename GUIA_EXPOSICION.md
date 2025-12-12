# 📚 GUÍA DE EXPOSICIÓN - CREMOSOS E-COMMERCE ERP

## 📋 TABLA DE CONTENIDOS
1. [Demo en Vivo (5 min)](#1-demo-en-vivo)
2. [Explicación Técnica (10 min)](#2-explicación-técnica)
3. [Respuestas a Preguntas Frecuentes](#3-preguntas-técnicas)

---

## 1. DEMO EN VIVO (5 minutos)

### 🎯 Flujo Completo a Demostrar

#### A. Inicio de Sesión
```
Usuario: admin@cremosos.com
Contraseña: 123456
```

**Qué mostrar:**
- Pantalla de login con validación de campos
- Consumo de API `/api/auth/login` en tiempo real
- Almacenamiento seguro del token JWT
- Redirección automática al Home

#### B. Navegación Cliente (E-commerce)
1. **Home Screen** - Pantalla principal
   - Ver productos destacados
   - Consumo de API: `GET /api/products/featured`
   
2. **Products Screen** - Catálogo
   - Listado completo de productos
   - Consumo de API: `GET /api/products`
   - Filtrado por categoría
   - Búsqueda en tiempo real
   
3. **Product Detail** - Detalle de producto
   - Ver información completa
   - Consumo de API: `GET /api/products/:id`
   - Agregar al carrito
   - Consumo de API: `POST /api/cart/items`

4. **Cart Screen** - Carrito de compras
   - Ver items agregados
   - Consumo de API: `GET /api/cart`
   - Modificar cantidades
   - Consumo de API: `PUT /api/cart/items/:id`
   - Eliminar items
   - Consumo de API: `DELETE /api/cart/items/:id`
   - Crear orden
   - Consumo de API: `POST /api/orders`

5. **Profile Screen** - Perfil de usuario
   - Ver datos del usuario
   - Consumo de API: `GET /api/users/profile`
   - Historial de órdenes
   - Consumo de API: `GET /api/orders`

#### C. Navegación Administrador (ERP)
6. **Admin Screen** - Panel administrativo
   - Menú con 5 módulos principales
   - Solo visible para usuarios con rol admin/employee

7. **Users Management** - Gestión de usuarios
   - Listar usuarios con paginación
   - Consumo de API: `GET /api/admin/users`
   - Crear nuevo usuario
   - Consumo de API: `POST /api/admin/users`
   - Editar usuario existente
   - Consumo de API: `PUT /api/admin/users/:id`
   - Eliminar usuario
   - Consumo de API: `DELETE /api/admin/users/:id`

8. **POS Screen** - Punto de Venta
   - Buscar productos
   - Consumo de API: `GET /api/products?search=...`
   - Construir venta
   - Seleccionar método de pago
   - Completar venta
   - Consumo de API: `POST /api/sales`

### ⚡ Puntos Clave en la Demostración
- ✅ Mostrar la consola de DevTools con las peticiones HTTP
- ✅ Evidenciar los estados de carga (CircularProgressIndicator)
- ✅ Demostrar manejo de errores (desconectar backend)
- ✅ Mostrar persistencia del token (cerrar y reabrir navegador)

---

## 2. EXPLICACIÓN TÉCNICA (10 minutos)

### 🏗️ A. Arquitectura y Patrones

#### Patrón: Clean Architecture con Provider
```
lib/
├── config/          # Configuración (API URLs, constantes)
├── models/          # Entidades de dominio (Product, User, etc.)
├── services/        # Capa de datos (API calls)
├── providers/       # Estado global (Riverpod)
└── screens/         # UI (Widgets)
```

**Explicar:**
- **Separación de responsabilidades**: Cada capa tiene una función específica
- **Models**: Representan las entidades del negocio
- **Services**: Encapsulan la lógica de comunicación con la API
- **Providers**: Gestionan el estado de la aplicación
- **Screens**: Solo se encargan de la UI

#### Código Ejemplo - Arquitectura:
```dart
// 1. Model (lib/models/product.dart)
class Product {
  final String id;
  final String name;
  final double price;
  
  Product.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      price = json['price'].toDouble();
}

// 2. Service (lib/services/product_service.dart)
class ProductService {
  Future<List<Product>> getProducts() async {
    final response = await _apiService.get('/products');
    return (response.data as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }
}

// 3. Provider (lib/providers/products_provider.dart)
final productsProvider = StateNotifierProvider<ProductsNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductsNotifier(ref.read(apiServiceProvider));
});

// 4. Screen (lib/screens/products_screen.dart)
class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    return productsAsync.when(
      data: (products) => ListView.builder(...),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
```

---

### 🎯 B. Gestión de Estado

#### Solución: Riverpod
**¿Por qué Riverpod?**
- ✅ Compile-time safety (detecta errores en compilación)
- ✅ No requiere BuildContext
- ✅ Fácil testing
- ✅ Soporte para estados asíncronos (AsyncValue)
- ✅ Auto-dispose (libera memoria automáticamente)

#### Flujo de Estado:
```
User Action (tap button)
    ↓
Provider notifica cambio
    ↓
Widget rebuild automático
    ↓
UI actualizada
```

#### Código Ejemplo - Estado:
```dart
// Provider de Carrito
class CartNotifier extends StateNotifier<AsyncValue<List<CartItem>>> {
  final ApiService _apiService;
  
  CartNotifier(this._apiService) : super(const AsyncValue.loading()) {
    loadCart(); // Cargar al iniciar
  }
  
  // Cargar carrito desde API
  Future<void> loadCart() async {
    state = const AsyncValue.loading();
    try {
      final items = await CartService(_apiService).getCart();
      state = AsyncValue.data(items);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  // Agregar item al carrito
  Future<void> addItem(String productId, int quantity) async {
    try {
      await CartService(_apiService).addItem(productId, quantity);
      await loadCart(); // Recargar para actualizar UI
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
```

---

### 🌐 C. Integración con API

#### Librería: Dio
**¿Por qué Dio?**
- ✅ Interceptores (agregar token automáticamente)
- ✅ Manejo de errores centralizado
- ✅ Timeout configurable
- ✅ Pretty logging para debugging
- ✅ Transformación de respuestas

#### Servicio Base - ApiService:
```dart
class ApiService {
  late final Dio _dio;
  final _secureStorage = const FlutterSecureStorage();
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:3000/api',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ));
    
    // Interceptor: Agregar token automáticamente
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        // Manejo centralizado de errores
        if (error.response?.statusCode == 401) {
          // Token expirado - logout
        }
        return handler.next(error);
      },
    ));
    
    // Logger para debugging
    _dio.interceptors.add(PrettyDioLogger());
  }
}
```

#### 3 Servicios Explicados:

**1. AuthService - Autenticación:**
```dart
class AuthService {
  final ApiService _apiService;
  
  // Login con email y password
  Future<User> login(String email, String password) async {
    final response = await _apiService.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    
    // Guardar token
    await _apiService.setToken(response.data['token']);
    
    // Retornar usuario
    return User.fromJson(response.data['user']);
  }
}
```

**2. ProductService - Productos:**
```dart
class ProductService {
  final ApiService _apiService;
  
  // Obtener todos los productos
  Future<List<Product>> getProducts({String? search, String? category}) async {
    final response = await _apiService.get('/products', queryParameters: {
      if (search != null) 'search': search,
      if (category != null) 'category': category,
    });
    
    return (response.data as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }
  
  // Crear producto (Admin)
  Future<Product> createProduct(Map<String, dynamic> data) async {
    final response = await _apiService.post('/products', data: data);
    return Product.fromJson(response.data);
  }
}
```

**3. UsersService - Gestión de usuarios:**
```dart
class UsersService {
  final ApiService _apiService;
  
  // Listar usuarios con filtros
  Future<List<User>> getUsers({
    String? search,
    String? role,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _apiService.get('/admin/users', queryParameters: {
      if (search != null) 'search': search,
      if (role != null) 'role': role,
      'page': page,
      'limit': limit,
    });
    
    return (response.data as List)
        .map((json) => User.fromJson(json))
        .toList();
  }
  
  // Eliminar usuario
  Future<void> deleteUser(String id) async {
    await _apiService.delete('/admin/users/$id');
  }
}
```

#### Manejo de Autenticación JWT:
```dart
// 1. Login - Recibe token
final response = await dio.post('/auth/login', data: {...});
final token = response.data['token'];

// 2. Guardar token de forma segura
await secureStorage.write(key: 'auth_token', value: token);

// 3. Usar token en requests (automático con interceptor)
headers: { 'Authorization': 'Bearer $token' }

// 4. Verificar si está autenticado
final token = await secureStorage.read(key: 'auth_token');
return token != null;
```

#### Manejo de Errores:
```dart
try {
  final products = await productService.getProducts();
  state = AsyncValue.data(products);
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    // No autorizado - logout
  } else if (e.response?.statusCode == 404) {
    // Recurso no encontrado
  } else if (e.type == DioExceptionType.connectionTimeout) {
    // Timeout - sin conexión
  }
  state = AsyncValue.error('Error al cargar productos', StackTrace.current);
} catch (e) {
  state = AsyncValue.error(e, StackTrace.current);
}
```

#### Estados de Carga:
```dart
// En el Widget
productsAsync.when(
  data: (products) => ListView.builder(...),      // Datos listos
  loading: () => CircularProgressIndicator(),     // Cargando
  error: (err, stack) => Text('Error: $err'),     // Error
);
```

---

### 📦 D. Modelos y Serialización

#### Conversión JSON ↔ Dart Objects

**¿Por qué es importante?**
- La API devuelve JSON (texto)
- Dart necesita objetos tipados para trabajar
- fromJson convierte JSON → Object
- toJson convierte Object → JSON

#### Modelo Completo Explicado:
```dart
class Product {
  // Propiedades finales (inmutables)
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final int stock;
  final double rating;
  final int reviewsCount;
  
  // Constructor
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    required this.rating,
    required this.reviewsCount,
  });
  
  // Factory constructor: Convierte JSON → Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),  // Manejar int o double
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      stock: json['stock'] as int,
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviewsCount'] as int,
    );
  }
  
  // Método: Convierte Product → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'stock': stock,
      'rating': rating,
      'reviewsCount': reviewsCount,
    };
  }
  
  // copyWith: Crear copia con cambios
  Product copyWith({
    String? name,
    double? price,
    int? stock,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      description: description,
      price: price ?? this.price,
      imageUrl: imageUrl,
      category: category,
      stock: stock ?? this.stock,
      rating: rating,
      reviewsCount: reviewsCount,
    );
  }
}
```

#### Uso en la práctica:
```dart
// API retorna: {"id": "prod1", "name": "Arroz", "price": 8000, ...}
final json = response.data;

// Convertir a objeto Product
final product = Product.fromJson(json);

// Ahora podemos usar propiedades tipadas
print(product.name);        // String
print(product.price * 2);   // double - operaciones matemáticas

// Convertir de vuelta a JSON para enviar a API
final jsonToSend = product.toJson();
await api.post('/products', data: jsonToSend);
```

---

### ⚡ E. Programación Asíncrona

#### Future, async/await

**¿Qué es un Future?**
- Representa un valor que estará disponible en el futuro
- Como una "promesa" de un resultado
- Usado para operaciones que toman tiempo (HTTP, DB, File I/O)

**Ejemplo sin async/await:**
```dart
Future<String> fetchUserName() {
  return http.get('/user').then((response) {
    return response.data['name'];
  });
}
```

**Mismo ejemplo con async/await (más legible):**
```dart
Future<String> fetchUserName() async {
  final response = await http.get('/user');
  return response.data['name'];
}
```

#### FutureBuilder - Widget para Futures:
```dart
FutureBuilder<Product>(
  future: productService.getProduct(id),
  builder: (context, snapshot) {
    // Verificar estado de la petición
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    
    if (!snapshot.hasData) {
      return Text('No hay datos');
    }
    
    // Datos listos
    final product = snapshot.data!;
    return Text(product.name);
  },
)
```

#### Operaciones Concurrentes:
```dart
// Ejecutar múltiples peticiones en paralelo
Future<void> loadDashboard() async {
  // Esperar a que TODAS terminen
  final results = await Future.wait([
    reportsService.getSalesReport(),
    reportsService.getProductsReport(),
    reportsService.getCustomersReport(),
  ]);
  
  final salesReport = results[0];
  final productsReport = results[1];
  final customersReport = results[2];
  
  // Actualizar UI con todos los datos
}

// Ejecutar en secuencia (una después de otra)
Future<void> checkout() async {
  final order = await orderService.createOrder();
  final payment = await paymentService.processPayment(order.id);
  final confirmation = await emailService.sendConfirmation(order.id);
}
```

#### Stream - Datos continuos:
```dart
// Stream emite múltiples valores a lo largo del tiempo
Stream<int> countDown() async* {
  for (int i = 10; i >= 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i; // Emitir valor
  }
}

// Escuchar stream
StreamBuilder<int>(
  stream: countDown(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return Text('...');
    return Text('${snapshot.data}');
  },
)
```

---

## 3. PREGUNTAS TÉCNICAS

### 📱 Sobre Flutter y Dart

#### P: ¿Cuál es la diferencia entre StatefulWidget y StatelessWidget?

**R:** 
- **StatelessWidget**: No tiene estado mutable. Se reconstruye solo cuando sus parámetros cambian desde el padre.
  ```dart
  class MyButton extends StatelessWidget {
    final String text;
    MyButton({required this.text});
    
    @override
    Widget build(BuildContext context) {
      return ElevatedButton(
        child: Text(text),
        onPressed: () {},
      );
    }
  }
  ```

- **StatefulWidget**: Tiene estado interno que puede cambiar. Llama a `setState()` para reconstruirse.
  ```dart
  class Counter extends StatefulWidget {
    @override
    State<Counter> createState() => _CounterState();
  }
  
  class _CounterState extends State<Counter> {
    int count = 0;
    
    @override
    Widget build(BuildContext context) {
      return ElevatedButton(
        child: Text('Count: $count'),
        onPressed: () {
          setState(() => count++); // Actualiza UI
        },
      );
    }
  }
  ```

#### P: ¿Qué es el widget tree y cómo funciona?

**R:** El widget tree es una jerarquía de widgets que describe la UI.

```
MaterialApp
  └─ Scaffold
      ├─ AppBar
      │   └─ Text("Título")
      └─ Body
          └─ Column
              ├─ Text("Hola")
              └─ ElevatedButton
                  └─ Text("Click")
```

**Funcionamiento:**
1. Flutter recorre el árbol de arriba hacia abajo
2. Cada widget describe su parte de la UI
3. Flutter crea elementos y render objects
4. Solo reconstruye widgets que cambiaron (eficiente)

#### P: Explique el ciclo de vida de un StatefulWidget

**R:** 
```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // 1. createState() - Crea el State
  
  // 2. initState() - Se llama UNA vez al crear
  @override
  void initState() {
    super.initState();
    // Inicializar datos, suscripciones
    loadData();
  }
  
  // 3. didChangeDependencies() - Después de initState
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reaccionar a cambios en InheritedWidget
  }
  
  // 4. build() - Se llama cada vez que hay cambios
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
  // 5. didUpdateWidget() - Cuando el widget padre cambia
  @override
  void didUpdateWidget(MyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Comparar widget.prop con oldWidget.prop
  }
  
  // 6. setState() - Marca el widget como dirty
  void updateData() {
    setState(() {
      // Cambiar estado
    });
    // build() se llamará automáticamente
  }
  
  // 7. dispose() - Limpiar recursos
  @override
  void dispose() {
    // Cancelar suscripciones, controllers, etc.
    super.dispose();
  }
}
```

#### P: ¿Qué son los Streams en Dart?

**R:** Los Streams son secuencias de eventos asíncronos.

```dart
// Stream de un solo valor
Stream<int> getSingleValue() async* {
  yield 42;
}

// Stream de múltiples valores
Stream<int> getNumbers() async* {
  for (int i = 0; i < 5; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i; // Emitir valor
  }
}

// Escuchar stream
getNumbers().listen((number) {
  print(number); // 0, 1, 2, 3, 4 (cada segundo)
});

// En Flutter con StreamBuilder
StreamBuilder<int>(
  stream: getNumbers(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    return Text('Número: ${snapshot.data}');
  },
)
```

**Tipos:**
- **Single subscription**: Solo un listener
- **Broadcast**: Múltiples listeners

---

### 🌐 Sobre HTTP y APIs

#### P: ¿Cuál es la diferencia entre los métodos GET, POST, PUT y DELETE?

**R:**

| Método | Propósito | Tiene Body | Idempotente |
|--------|-----------|------------|-------------|
| GET | Obtener recursos | No | Sí |
| POST | Crear recursos | Sí | No |
| PUT | Actualizar recursos | Sí | Sí |
| DELETE | Eliminar recursos | No | Sí |

**Ejemplos:**
```dart
// GET - Obtener lista de productos
await dio.get('/api/products');

// POST - Crear nuevo producto
await dio.post('/api/products', data: {
  'name': 'Arroz',
  'price': 8000,
});

// PUT - Actualizar producto existente
await dio.put('/api/products/prod1', data: {
  'price': 9000,
});

// DELETE - Eliminar producto
await dio.delete('/api/products/prod1');
```

**Idempotente:** Múltiples llamadas idénticas tienen el mismo efecto que una sola.

#### P: ¿Qué son los códigos de estado HTTP y qué significan 200, 400, 401, 500?

**R:**

**Rangos:**
- **2xx**: Éxito
- **3xx**: Redirección
- **4xx**: Error del cliente
- **5xx**: Error del servidor

**Códigos específicos:**
- **200 OK**: Solicitud exitosa
- **201 Created**: Recurso creado exitosamente
- **400 Bad Request**: Datos inválidos (validación falló)
- **401 Unauthorized**: No autenticado (falta token o token inválido)
- **403 Forbidden**: Autenticado pero sin permisos
- **404 Not Found**: Recurso no existe
- **500 Internal Server Error**: Error en el servidor

**Manejo en código:**
```dart
try {
  final response = await dio.post('/api/products', data: {...});
  if (response.statusCode == 201) {
    // Producto creado
  }
} on DioException catch (e) {
  if (e.response?.statusCode == 400) {
    print('Datos inválidos');
  } else if (e.response?.statusCode == 401) {
    print('No autorizado - hacer logout');
  } else if (e.response?.statusCode == 500) {
    print('Error del servidor');
  }
}
```

#### P: ¿Cómo funciona la autenticación JWT?

**R:** JWT (JSON Web Token) es un estándar para transmitir información de forma segura.

**Estructura del Token:**
```
header.payload.signature

eyJhbGci0iJIUzI1NiIsInR5cCI6IkpXVCJ9.
eyJ1c2VySWQiOiJ1c2VyMSIsInJvbGUiOiJhZG1pbiJ9.
SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

**Flujo:**
```
1. Cliente → POST /api/auth/login {email, password}
2. Servidor → Verifica credenciales
3. Servidor → Genera JWT con datos del usuario
4. Servidor → Retorna {token, user}
5. Cliente → Guarda token en SecureStorage
6. Cliente → Incluye token en requests: Authorization: Bearer <token>
7. Servidor → Verifica token en cada request
8. Servidor → Extrae userId del token y procesa request
```

**Implementación:**
```dart
// En el servidor (Node.js)
const token = jwt.sign(
  { userId: user.id, role: user.role },
  SECRET_KEY,
  { expiresIn: '24h' }
);

// En Flutter - Guardar token
await secureStorage.write(key: 'auth_token', value: token);

// En Flutter - Usar token
final token = await secureStorage.read(key: 'auth_token');
dio.options.headers['Authorization'] = 'Bearer $token';

// En el servidor - Verificar token
const decoded = jwt.verify(token, SECRET_KEY);
const userId = decoded.userId; // Extraer información
```

#### P: ¿Qué es un token Bearer?

**R:** Bearer es un esquema de autenticación HTTP que usa tokens.

**Formato:**
```
Authorization: Bearer <token>
```

**"Bearer" significa "portador"** - quien posee el token tiene acceso.

**Ejemplo:**
```dart
// En Dio interceptor
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) async {
    final token = await storage.read(key: 'auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  },
));
```

---

### 💻 Sobre la Implementación

#### P: ¿Por qué eligió esa librería para HTTP?

**R:** Elegí **Dio** sobre http porque:

1. **Interceptores**: Agregar token automáticamente
2. **Mejor manejo de errores**: DioException con más contexto
3. **Timeout configurable**: connectTimeout, receiveTimeout
4. **Transformadores**: Conversión automática de JSON
5. **Logging**: Pretty logger para debugging
6. **Cancelación de requests**: CancelToken
7. **Retry automático**: Con dio_retry

**Comparación:**
```dart
// Con http (básico)
final response = await http.get(
  Uri.parse('http://localhost:3000/api/products'),
  headers: {'Authorization': 'Bearer $token'}, // Manual cada vez
);
final data = jsonDecode(response.body); // Manual

// Con Dio (avanzado)
final response = await dio.get('/products'); // Token automático
final data = response.data; // Ya parseado
```

#### P: ¿Cómo manejaría la pérdida de conexión?

**R:** Múltiples estrategias:

**1. Timeout:**
```dart
Dio(BaseOptions(
  connectTimeout: Duration(seconds: 30),
  receiveTimeout: Duration(seconds: 30),
));
```

**2. Retry automático:**
```dart
dio.interceptors.add(RetryInterceptor(
  dio: dio,
  retries: 3,
  retryDelays: [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 3),
  ],
));
```

**3. Verificar conectividad:**
```dart
final connectivityResult = await Connectivity().checkConnectivity();
if (connectivityResult == ConnectivityResult.none) {
  throw Exception('Sin conexión a internet');
}
```

**4. Cache local:**
```dart
// Guardar datos en SharedPreferences
if (response != null) {
  prefs.setString('cached_products', jsonEncode(response.data));
}

// Cargar desde cache si no hay conexión
try {
  return await loadFromApi();
} catch (e) {
  final cached = prefs.getString('cached_products');
  if (cached != null) {
    return jsonDecode(cached);
  }
  throw e;
}
```

**5. UI feedback:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Sin conexión. Usando datos en cache.'),
    action: SnackBarAction(
      label: 'Reintentar',
      onPressed: () => retry(),
    ),
  ),
);
```

#### P: ¿Cómo implementó el caché de datos?

**R:** Usé múltiples niveles de caché:

**1. Caché en memoria (Provider state):**
```dart
class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  List<Product>? _cachedProducts;
  DateTime? _lastFetch;
  
  Future<void> getProducts({bool forceRefresh = false}) async {
    // Si hay cache reciente, usarlo
    if (!forceRefresh && 
        _cachedProducts != null && 
        _lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < Duration(minutes: 5)) {
      state = AsyncValue.data(_cachedProducts!);
      return;
    }
    
    // Fetch desde API
    final products = await _service.getProducts();
    _cachedProducts = products;
    _lastFetch = DateTime.now();
    state = AsyncValue.data(products);
  }
}
```

**2. Caché persistente (SharedPreferences):**
```dart
// Guardar
final prefs = await SharedPreferences.getInstance();
await prefs.setString('products_cache', jsonEncode(products));

// Cargar
final cached = prefs.getString('products_cache');
if (cached != null) {
  return (jsonDecode(cached) as List)
      .map((json) => Product.fromJson(json))
      .toList();
}
```

**3. Caché de imágenes (cached_network_image):**
```dart
CachedNetworkImage(
  imageUrl: product.imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  cacheManager: CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  ),
)
```

#### P: Explique una decisión técnica importante que tomó

**R:** **Separar ApiService de los servicios específicos.**

**Problema inicial:**
Cada servicio creaba su propia instancia de Dio, duplicando configuración.

**Solución:**
```dart
// ApiService - Singleton con configuración única
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  
  late final Dio dio;
  
  ApiService._internal() {
    dio = Dio(BaseOptions(...));
    dio.interceptors.add(...);
  }
  
  Future<Response> get(String path) => dio.get(path);
  Future<Response> post(String path, {data}) => dio.post(path, data: data);
}

// Servicios específicos - Reutilizan ApiService
class ProductService {
  final ApiService _api;
  ProductService(this._api);
  
  Future<List<Product>> getProducts() async {
    final response = await _api.get('/products');
    return ...;
  }
}

// Provider - Inyección de dependencias
final apiServiceProvider = Provider((ref) => ApiService());

final productServiceProvider = Provider((ref) {
  return ProductService(ref.read(apiServiceProvider));
});
```

**Beneficios:**
- ✅ DRY (Don't Repeat Yourself)
- ✅ Fácil testing (mock ApiService)
- ✅ Configuración centralizada
- ✅ Un solo interceptor para todas las peticiones

---

## 📊 RESUMEN DE ENDPOINTS IMPLEMENTADOS

### Backend: 51 endpoints REST

#### Autenticación (4)
- `POST /api/auth/login` - Iniciar sesión
- `POST /api/auth/register` - Registrar usuario
- `GET /api/users/profile` - Obtener perfil
- `PUT /api/users/profile` - Actualizar perfil

#### Productos (8)
- `GET /api/products` - Listar productos (con filtros)
- `GET /api/products/:id` - Detalle de producto
- `GET /api/products/featured` - Productos destacados
- `POST /api/products` - Crear producto (Admin)
- `PUT /api/products/:id` - Actualizar producto (Admin)
- `DELETE /api/products/:id` - Eliminar producto (Admin)

#### Gestión de Usuarios (6)
- `GET /api/admin/users` - Listar usuarios (Admin)
- `GET /api/admin/users/:id` - Detalle de usuario (Admin)
- `POST /api/admin/users` - Crear usuario (Admin)
- `PUT /api/admin/users/:id` - Actualizar usuario (Admin)
- `DELETE /api/admin/users/:id` - Eliminar usuario (Admin)

#### Roles y Permisos (5)
- `GET /api/roles` - Listar roles
- `GET /api/roles/:id` - Detalle de rol
- `POST /api/roles` - Crear rol (Admin)
- `PUT /api/roles/:id` - Actualizar rol (Admin)
- `DELETE /api/roles/:id` - Eliminar rol (Admin)

#### Proveedores (5)
- `GET /api/suppliers` - Listar proveedores
- `GET /api/suppliers/:id` - Detalle de proveedor
- `POST /api/suppliers` - Crear proveedor
- `PUT /api/suppliers/:id` - Actualizar proveedor
- `DELETE /api/suppliers/:id` - Eliminar proveedor

#### Compras (5)
- `GET /api/purchases` - Listar compras
- `GET /api/purchases/:id` - Detalle de compra
- `POST /api/purchases` - Crear orden de compra
- `PUT /api/purchases/:id` - Actualizar compra
- `DELETE /api/purchases/:id` - Eliminar compra

#### Ventas/POS (5)
- `GET /api/sales` - Listar ventas
- `GET /api/sales/:id` - Detalle de venta
- `POST /api/sales` - Registrar venta
- `GET /api/sales/summary/today` - Resumen del día
- `POST /api/sales/:id/print` - Imprimir recibo

#### Carrito (6)
- `GET /api/cart` - Ver carrito
- `POST /api/cart/items` - Agregar al carrito
- `PUT /api/cart/items/:id` - Actualizar cantidad
- `DELETE /api/cart/items/:id` - Eliminar item
- `DELETE /api/cart` - Vaciar carrito
- `POST /api/cart/sync` - Sincronizar carrito

#### Órdenes (5)
- `POST /api/orders` - Crear orden
- `GET /api/orders` - Historial de órdenes (con filtros)
- `GET /api/orders/:id` - Detalle de orden
- `PUT /api/orders/:id/cancel` - Cancelar orden
- `GET /api/orders/:id/track` - Rastrear orden

#### Reportes (4)
- `GET /api/reports/dashboard` - Dashboard general
- `GET /api/reports/sales` - Reporte de ventas
- `GET /api/reports/products` - Reporte de productos
- `GET /api/reports/customers` - Reporte de clientes

---

## 🎯 CHECKLIST ANTES DE LA EXPOSICIÓN

### Preparación Técnica
- [ ] Backend corriendo en puerto 3000
- [ ] Frontend corriendo en Chrome
- [ ] Abrir DevTools (Network tab)
- [ ] Probar login con admin@cremosos.com / 123456
- [ ] Verificar que aparezca botón Admin
- [ ] Probar flujo completo: productos → carrito → orden
- [ ] Probar creación de usuario en Admin
- [ ] Probar POS (punto de venta)

### Código a Mostrar
- [ ] `lib/services/api_service.dart` - Interceptores
- [ ] `lib/models/product.dart` - Serialización
- [ ] `lib/providers/auth_provider.dart` - State management
- [ ] `lib/screens/products_screen.dart` - FutureBuilder
- [ ] `backend/server.js` - Endpoints y JWT

### Documentos a Tener Abiertos
- [ ] Esta guía (GUIA_EXPOSICION.md)
- [ ] backend/server.js
- [ ] lib/services/api_service.dart
- [ ] lib/providers/auth_provider.dart

---

## 💡 TIPS PARA LA EXPOSICIÓN

1. **Demostración en vivo:**
   - Ten la app ya iniciada pero en pantalla de login
   - Usa el login admin@cremosos.com / 123456
   - Muestra la consola de DevTools para ver las peticiones HTTP en tiempo real

2. **Explicación técnica:**
   - Habla con confianza - conoces tu código
   - Usa analogías simples (JWT = pase de entrada)
   - Señala partes específicas del código mientras explicas

3. **Preguntas:**
   - Si no sabes algo, di "No lo implementé pero lo investigaría así..."
   - Relaciona todo con tu código real
   - Da ejemplos concretos de tu app

4. **Lenguaje técnico correcto:**
   - "Riverpod gestiona el estado reactivamente"
   - "Dio intercepta las peticiones para inyectar el token JWT"
   - "FutureBuilder maneja los 3 estados: loading, error, data"
   - "La serialización convierte JSON a objetos Dart tipados"

¡Mucha suerte en tu exposición! 🚀
