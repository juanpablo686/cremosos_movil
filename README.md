# Cremosos E-Commerce 🍨

Aplicación de comercio electrónico desarrollada en Flutter para la venta de postres cremosos, bebidas y toppings. **Incluye backend REST API con 22 endpoints funcionales.**

## 🚀 INICIO RÁPIDO

### Ejecución Automática (Recomendado)
```powershell
powershell -ExecutionPolicy Bypass -File run.ps1
```

### Credenciales de Prueba
- **Email:** admin@cremosos.com
- **Password:** 123456

📖 **Ver `GUIA_RAPIDA.md` para instrucciones detalladas**

---

## 📋 Tabla de Contenidos

- [Inicio Rápido](#-inicio-rápido)
- [Características](#características)
- [Instalación](#instalación)
- [Fase 2: API REST](#-fase-2-integración-api-rest)
- [Arquitectura de Estados](#arquitectura-de-estados)
- [Decisiones Técnicas](#decisiones-técnicas)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Estados Implementados](#estados-implementados)
- [Demo Funcional](#demo-funcional)

## ✨ Características

### Fase 1: Interfaz de Usuario
- **Catálogo de Productos**: 140 productos organizados en 7 categorías
- **Carrito de Compras**: Sistema completo con checkout y procesamiento de órdenes
- **Autenticación**: Login y registro de usuarios
- **Perfil Interactivo**: Gestión completa de cuenta, direcciones, métodos de pago
- **Reportes**: Dashboard con estadísticas de ventas y análisis
- **Responsive**: Optimizado para web y escritorio (Windows)
- **Hot Reload**: Desarrollo rápido con actualización en tiempo real

### Fase 2: Integración API REST ✨
- **Backend Node.js/Express**: 22 endpoints REST funcionales
- **Autenticación JWT**: Tokens seguros con FlutterSecureStorage
- **CRUD Completo**: Create, Read, Update, Delete en carrito
- **Métodos HTTP**: GET, POST, PUT, DELETE correctamente implementados
- **Serialización JSON**: Automática con json_serializable y build_runner
- **Manejo de Estados**: DataState pattern (Loading, Success, Error, Empty)
- **Interceptores Dio**: Inyección automática de tokens de autenticación
- **Manejo de Errores**: Códigos HTTP 400, 401, 403, 404, 500
- **Arquitectura Limpia**: Services → Providers → UI

## 🚀 Instalación

### Prerrequisitos

**Fase 1 (Solo Flutter):**
- Flutter SDK 3.35.6 o superior
- Dart SDK 3.9.2 o superior
- Chrome (para ejecución web)
- Visual Studio 2022 con C++ Desktop Development (para Windows)

**Fase 2 (Flutter + Backend):**
- Todo lo anterior +
- Node.js 16+ (para backend API)
- npm o yarn

### Instalación Completa (Fase 1 + Fase 2)

1. **Clonar el repositorio**
```bash
git clone https://github.com/juanpablo686/flutter_dart-cremosos.git
cd flutter_dart-cremosos
```

2. **Instalar dependencias de Flutter**
```bash
flutter pub get
```

3. **Generar archivos de serialización JSON**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Instalar dependencias del backend**
```bash
cd backend
npm install
cd ..
```

5. **Ejecutar con script automático (Windows)**
```powershell
powershell -ExecutionPolicy Bypass -File run.ps1
```

**O manualmente:**

6a. **Terminal 1: Iniciar backend**
```bash
cd backend
node server.js
```

6b. **Terminal 2: Iniciar Flutter**
```bash
# Web Chrome
flutter run -d chrome

# Windows
flutter run -d windows
```

### Credenciales de Prueba

**Usuario de prueba:**
- Email: `admin@cremosos.com`
**Fase 1 (UI Mock):**
- Email: `admin@cremosos.com`
- Password: `admin123`

**Usuario regular:**
- Email: `juan@example.com`
- Password: `password123`

**Fase 2 (API Real):**
- Email: `admin@cremosos.com`
- Password: `123456`

## 🌐 Fase 2: Integración API REST

### Backend Disponible
- **URL Base**: http://localhost:3000/api
- **Servidor**: Node.js + Express.js
- **Autenticación**: JWT (JSON Web Tokens)
- **Endpoints**: 22 disponibles

### Categorías de Endpoints

#### 1. Autenticación (4 endpoints)
- `POST /api/auth/login` - Login con credenciales
- `POST /api/auth/register` - Registro de nuevo usuario
- `GET /api/auth/profile` - Obtener perfil actual
- `PUT /api/auth/profile` - Actualizar perfil

#### 2. Productos (5 endpoints)
- `GET /api/products` - Listar productos (con filtros y paginación)
- `GET /api/products/:id` - Obtener producto por ID
- `GET /api/products/featured` - Productos destacados
- `GET /api/products/search?q=query` - Buscar productos
- `GET /api/products/category/:category` - Productos por categoría

#### 3. Carrito (6 endpoints) - CRUD Completo
- `GET /api/cart/:userId` - Obtener carrito
- `POST /api/cart/:userId/items` - Agregar item (CREATE)
- `PUT /api/cart/:userId/items/:itemId` - Actualizar cantidad (UPDATE)
- `DELETE /api/cart/:userId/items/:itemId` - Eliminar item (DELETE)
- `POST /api/cart/:userId/clear` - Vaciar carrito
- `POST /api/cart/:userId/sync` - Sincronizar carrito

#### 4. Órdenes (5 endpoints)
- `POST /api/orders` - Crear orden desde carrito
- `GET /api/orders/user/:userId` - Historial de órdenes
- `GET /api/orders/:id` - Obtener orden por ID
- `PUT /api/orders/:id/cancel` - Cancelar orden
- `GET /api/orders/:id/track` - Rastrear envío

#### 5. Reportes (4 endpoints)
- `GET /api/reports/dashboard` - Dashboard con KPIs
- `GET /api/reports/sales` - Reporte de ventas
- `GET /api/reports/products` - Reporte de productos
- `GET /api/reports/customers` - Reporte de clientes

### Arquitectura de Integración

```
┌──────────────────────────────────────────────────┐
│              Flutter App (UI)                    │
│  ┌────────────────────────────────────────────┐  │
│  │         Screens (Widgets)                  │  │
│  └────────────┬───────────────────────────────┘  │
│               │ consume                          │
│  ┌────────────▼───────────────────────────────┐  │
│  │    Providers (Riverpod StateNotifier)     │  │
│  └────────────┬───────────────────────────────┘  │
│               │ call methods                     │
│  ┌────────────▼───────────────────────────────┐  │
│  │       Services (API Communication)        │  │
│  │  - AuthService                            │  │
│  │  - ProductService                         │  │
│  │  - CartService                            │  │
│  │  - OrderService                           │  │
│  │  - ReportService                          │  │
│  └────────────┬───────────────────────────────┘  │
│               │ HTTP requests                    │
│  ┌────────────▼───────────────────────────────┐  │
│  │      Dio Client (with Interceptors)       │  │
│  │  - Token injection                        │  │
│  │  - Error handling                         │  │
│  │  - Logging                                │  │
│  └────────────┬───────────────────────────────┘  │
└───────────────┼──────────────────────────────────┘
                │ REST API calls
┌───────────────▼──────────────────────────────────┐
│           Backend Server (Node.js)               │
│  ┌────────────────────────────────────────────┐  │
│  │      Express Routes + Middleware           │  │
│  │  - CORS                                    │  │
│  │  - JWT Authentication                      │  │
│  │  - JSON parsing                            │  │
│  └────────────┬───────────────────────────────┘  │
│               │                                  │
│  ┌────────────▼───────────────────────────────┐  │
│  │      In-Memory Data Storage                │  │
│  │  - Users array                             │  │
│  │  - Products array                          │  │
│  │  - Carts object                            │  │
│  │  - Orders array                            │  │
│  └────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────┘
```

### Flujo de Autenticación JWT

```
1. Usuario ingresa credenciales en LoginScreen
         ↓
2. AuthService.login() envía POST /api/auth/login
         ↓
3. Backend valida y genera JWT token
         ↓
4. Flutter recibe token y lo guarda en FlutterSecureStorage
         ↓
5. Interceptor Dio inyecta automáticamente token en todas las peticiones
         ↓
6. Backend middleware verifica token en cada request
```

### Manejo de Estados DataState

```dart
// Pattern utilizado en todas las respuestas
sealed class DataState<T> {
  const DataState();
}

class DataInitial<T> extends DataState<T> {}
class DataLoading<T> extends DataState<T> {}
class DataSuccess<T> extends DataState<T> {
  final T data;
}
class DataError<T> extends DataState<T> {
  final String message;
  final int? statusCode;
}
class DataEmpty<T> extends DataState<T> {}
```

### Serialización JSON Automática

Todos los modelos utilizan `json_serializable`:

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

Archivos `.g.dart` generados con:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Documentación Adicional

- **GUIA_RAPIDA.md**: Instrucciones de ejecución y testing
- **CUMPLIMIENTO_FASE2.md**: Checklist de requisitos (95% completo)
- **COMO_PROBAR_API.md**: Guía para probar los 22 endpoints
- **INTEGRACION_API.md**: Documentación técnica detallada
- **backend/README.md**: Documentación del servidor

## 🏗️ Arquitectura de Estados

Este proyecto utiliza **Riverpod 2.6.1** como solución de gestión de estado, siguiendo el patrón **Provider + StateNotifier** para mantener la separación de responsabilidades y facilitar el testing.

### Diagrama de Flujo de Estados

```
┌─────────────────────────────────────────────────────────┐
│                     App Root                            │
│              (Consumer de Auth State)                   │
└────────────────┬────────────────────────────────────────┘
                 │
        ┌────────┴────────┐
        │                 │
    ┌───▼────┐      ┌────▼──────┐
    │ Auth   │      │   Main    │
    │ Screen │      │ Navigator │
    └────────┘      └─────┬─────┘
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
    ┌───▼──────┐    ┌────▼─────┐    ┌─────▼────┐
    │  Home    │    │ Products │    │ Profile  │
    │  Screen  │    │  Screen  │    │  Screen  │
    └──────────┘    └──────────┘    └──────────┘
```

### Providers Principales

#### 1. **AuthProvider** (`lib/providers/auth_provider.dart`)
- **Tipo**: `StateNotifier<AuthState>`
- **Responsabilidad**: Gestión de autenticación y sesión de usuario
- **Estado**:
  ```dart
  class AuthState {
    final User? user;
    final bool isLoading;
    final String? errorMessage;
  }
  ```

#### 2. **CartProvider** (`lib/providers/cart_provider.dart`)
- **Tipo**: `StateNotifier<CartState>`
- **Responsabilidad**: Gestión del carrito de compras
- **Estado**:
  ```dart
  class CartState {
    final List<CartItem> items;
    final double subtotal;
    final double tax;
    final double total;
  }
  ```

#### 3. **ProductsProvider** (`lib/providers/products_provider.dart`)
- **Tipo**: `StateNotifier<ProductsState>`
- **Responsabilidad**: Catálogo de productos y filtrado
- **Estado**:
  ```dart
  class ProductsState {
    final List<Product> allProducts;
    final List<Product> filteredProducts;
    final ProductCategory? selectedCategory;
    final String searchQuery;
  }
  ```

#### 4. **ReportsProvider** (`lib/providers/reports_provider.dart`)
- **Tipo**: `StateNotifier<ReportsState>`
- **Responsabilidad**: Dashboard y estadísticas de ventas
- **Estado**:
  ```dart
  class ReportsState {
    final List<SalesData> salesData;
    final Map<ProductCategory, double> categoryPerformance;
    final double totalRevenue;
  }
  ```

### Computed Providers

```dart
// Verificar si el usuario está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user != null;
});

// Obtener total de items en el carrito
final cartItemCountProvider = Provider<int>((ref) {
  final cartState = ref.watch(cartProvider);
  return cartState.items.length;
});
```

## 🎯 Decisiones Técnicas

### 1. **¿Por qué Riverpod en lugar de Provider o Bloc?**

**Riverpod** fue elegido por las siguientes razones:

- ✅ **Compile-time safety**: Detección de errores en tiempo de compilación
- ✅ **No requiere BuildContext**: Acceso a providers desde cualquier lugar
- ✅ **Mejor testing**: Fácil de mockear y testear
- ✅ **Sin SingletonProvider**: Evita problemas de estado global
- ✅ **Hot Reload mejorado**: Soporte nativo para recarga en caliente

**Alternativas consideradas:**
- **Provider**: Más simple pero requiere BuildContext
- **Bloc**: Más verboso, curva de aprendizaje mayor

### 2. **Arquitectura de Capas**

```
┌─────────────────────────────────────┐
│         UI Layer (Screens)          │
│     - Widgets de presentación       │
│     - Consumidores de estado        │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│    State Management (Providers)     │
│     - StateNotifiers                │
│     - Business Logic                │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│      Data Layer (Models/Data)       │
│     - Modelos de datos              │
│     - Mock data / Future APIs       │
└─────────────────────────────────────┘
```

**Ventajas:**
- Separación clara de responsabilidades
- Fácil de escalar y mantener
- Testeable a nivel unitario

### 3. **Uso de Mock Data en lugar de Backend Real**

Para esta demo, se utilizan datos simulados (`lib/data/*.dart`) por:

- ⚡ **Rapidez de desarrollo**: No requiere configuración de backend
- 🎨 **Prototipado rápido**: Fácil de modificar y expandir
- 📱 **Demo offline**: Funciona sin conexión a internet
- 🔄 **Fácil migración**: Estructura preparada para integrar APIs reales

**Plan de migración futuro:**
```dart
// Actual (Mock)
final products = allProducts;

// Futuro (API)
final products = await api.getProducts();
```

### 4. **Imágenes desde Unsplash**

Se utilizan imágenes de Unsplash API por:

- 🖼️ **Alta calidad**: Imágenes profesionales
- 🆓 **Gratuito**: Sin costo de licencias
- 🔗 **CDN rápido**: Carga optimizada
- 📐 **Parámetros flexibles**: Control de tamaño (w, h, fit, crop)

### 5. **Moneda en Pesos Colombianos ($)**

Se configuró toda la aplicación en pesos colombianos para:

- 🌎 **Localización**: Mercado colombiano
- 💰 **Consistencia**: Mismo símbolo en toda la app
- 📊 **Formato**: `\$${price.toStringAsFixed(0)}`

### 6. **Navegación con BottomNavigationBar**

Elegido sobre Drawer o TabBar por:

- 📱 **UX móvil**: Patrón familiar en apps móviles
- 👆 **Accesibilidad**: Fácil alcance del pulgar
- 🎯 **Claridad**: 4 secciones principales visibles

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada
├── data/                        # Datos mock
│   ├── products_data.dart       # 140 productos
│   ├── users_data.dart          # Usuarios y reseñas
│   └── reports_data.dart        # Datos de reportes
├── models/                      # Modelos de datos
│   ├── product.dart             # Modelo de producto
│   ├── user.dart                # Modelo de usuario
│   ├── cart.dart                # Modelo de carrito
│   └── reports.dart             # Modelo de reportes
├── providers/                   # Gestión de estado
│   ├── auth_provider.dart       # Autenticación
│   ├── cart_provider.dart       # Carrito
│   ├── products_provider.dart   # Productos
│   └── reports_provider.dart    # Reportes
└── screens/                     # Pantallas UI
    ├── auth_screen.dart         # Login/Registro
    ├── home_screen.dart         # Inicio
    ├── products_screen.dart     # Catálogo
    ├── product_detail_screen.dart # Detalle
    ├── cart_screen.dart         # Carrito
    ├── profile_screen.dart      # Perfil
    └── reports_screen.dart      # Dashboard
```

## 📊 Estados Implementados

### Estado 1: Autenticación (AuthState)

**Ubicación**: `lib/providers/auth_provider.dart`

**Descripción**: Gestiona el estado de autenticación del usuario, incluyendo login, registro y logout.

**Propiedades del Estado**:
```dart
class AuthState {
  final User? user;           // Usuario actual (null si no autenticado)
  final bool isLoading;       // Cargando operación de auth
  final String? errorMessage; // Mensaje de error si falla
}
```

**Acciones**:
- `login(email, password)`: Autenticar usuario
- `register(email, password, name)`: Registrar nuevo usuario
- `logout()`: Cerrar sesión
- `clearError()`: Limpiar mensajes de error

**Flujo de Estados**:
```
Initial (user: null, isLoading: false)
    ↓ login()
Loading (user: null, isLoading: true)
    ↓ Success
Authenticated (user: User, isLoading: false)
    ↓ Error
Error (user: null, isLoading: false, error: "mensaje")
```

**Uso en UI**:
```dart
final authState = ref.watch(authProvider);
if (authState.user != null) {
  // Usuario autenticado
} else {
  // Mostrar login
}
```

---

### Estado 2: Carrito de Compras (CartState)

**Ubicación**: `lib/providers/cart_provider.dart`

**Descripción**: Administra el carrito de compras, incluyendo items, cantidades, toppings y cálculo de totales.

**Propiedades del Estado**:
```dart
class CartState {
  final List<Map<String, dynamic>> items; // Items en carrito
  // Cada item: {product, quantity, toppings, subtotal}
}
```

**Acciones**:
- `addItem(product, quantity, toppings)`: Agregar producto
- `removeItem(productId)`: Eliminar producto
- `updateQuantity(productId, newQuantity)`: Actualizar cantidad
- `clearCart()`: Vaciar carrito
- `calculateTotal()`: Calcular total con impuestos

**Computed Values**:
```dart
double get subtotal => items.fold(0, (sum, item) => 
  sum + item['subtotal']);
double get tax => subtotal * 0.19; // IVA 19%
double get total => subtotal + tax;
int get itemCount => items.length;
```

**Flujo de Estados**:
```
Empty (items: [])
    ↓ addItem()
HasItems (items: [item1])
    ↓ addItem()
HasItems (items: [item1, item2])
    ↓ checkout()
Processing → Success → Empty
```

**Uso en UI**:
```dart
final cartState = ref.watch(cartProvider);
Text('Total: \$${cartState.total.toStringAsFixed(0)}');
Text('Items: ${cartState.itemCount}');
```

---

### Estado 3: Productos (ProductsState)

**Ubicación**: `lib/providers/products_provider.dart`

**Descripción**: Gestiona el catálogo de productos, filtrado por categoría y búsqueda.

**Propiedades del Estado**:
```dart
class ProductsState {
  final List<Product> allProducts;      // Todos los productos (140)
  final List<Product> filteredProducts; // Productos filtrados
  final ProductCategory? selectedCategory; // Categoría seleccionada
  final String searchQuery;             // Búsqueda actual
  final bool isLoading;                 // Cargando productos
}
```

**Categorías**:
```dart
enum ProductCategory {
  arrozConLeche,      // 20 productos
  fresasConCrema,     // 20 productos
  postresEspeciales,  // 20 productos
  bebidasCremosas,    // 20 productos
  toppings,           // 20 productos
  bebidas,            // 20 productos
  postres,            // 20 productos
}
```

**Acciones**:
- `filterByCategory(category)`: Filtrar por categoría
- `searchProducts(query)`: Buscar productos
- `clearFilters()`: Limpiar filtros
- `getProductById(id)`: Obtener producto específico

**Flujo de Estados**:
```
Initial (allProducts: [], filteredProducts: [], category: null)
    ↓ loadProducts()
Loaded (allProducts: [140], filteredProducts: [140])
    ↓ filterByCategory(arrozConLeche)
Filtered (filteredProducts: [20], category: arrozConLeche)
    ↓ searchProducts("vainilla")
Searched (filteredProducts: [5], searchQuery: "vainilla")
```

**Uso en UI**:
```dart
final productsState = ref.watch(productsProvider);
ListView.builder(
  itemCount: productsState.filteredProducts.length,
  itemBuilder: (context, index) {
    final product = productsState.filteredProducts[index];
    return ProductCard(product: product);
  },
);
```

---

### Estado 4: Reportes (ReportsState)

**Ubicación**: `lib/providers/reports_provider.dart`

**Descripción**: Dashboard con estadísticas de ventas, rendimiento por categoría y gráficos.

**Propiedades del Estado**:
```dart
class ReportsState {
  final List<SalesData> salesData;                    // Ventas por mes
  final Map<ProductCategory, double> categoryPerformance; // % por categoría
  final double totalRevenue;                          // Ingresos totales
  final int totalOrders;                              // Órdenes totales
  final double averageOrderValue;                     // Valor promedio
  final String selectedPeriod;                        // Período seleccionado
}
```

**Acciones**:
- `loadReports()`: Cargar datos de reportes
- `filterByPeriod(period)`: Filtrar por período (día, semana, mes, año)
- `exportReport()`: Exportar reporte a CSV/PDF

**Métricas Calculadas**:
```dart
// Crecimiento mensual
double get monthlyGrowth => 
  ((currentMonth - lastMonth) / lastMonth) * 100;

// Producto más vendido
Product get topProduct => 
  products.reduce((a, b) => a.sales > b.sales ? a : b);

// Categoría más popular
ProductCategory get topCategory =>
  categoryPerformance.entries.reduce((a, b) => 
    a.value > b.value ? a : b).key;
```

**Flujo de Estados**:
```
Initial (salesData: [], totalRevenue: 0)
    ↓ loadReports()
Loading (isLoading: true)
    ↓ Success
Loaded (salesData: [data], totalRevenue: 15000000)
    ↓ filterByPeriod("month")
Filtered (salesData: [monthData], period: "month")
```

**Uso en UI**:
```dart
final reportsState = ref.watch(reportsProvider);
Text('Ingresos: \$${reportsState.totalRevenue.toStringAsFixed(0)}');
BarChart(data: reportsState.salesData);
PieChart(data: reportsState.categoryPerformance);
```

---

### Estado 5: Navegación (NavigationState)

**Ubicación**: Implementado en `lib/screens/home_screen.dart` con estado local

**Descripción**: Gestiona la navegación entre las 4 pantallas principales mediante BottomNavigationBar.

**Propiedades**:
```dart
int _selectedIndex = 0; // Índice de pantalla actual
```

**Pantallas**:
```dart
final List<Widget> _screens = [
  HomeScreen(),      // Index 0: Inicio
  ProductsScreen(),  // Index 1: Productos
  CartScreen(),      // Index 2: Carrito
  ProfileScreen(),   // Index 3: Perfil
];
```

**Acciones**:
- `onTap(index)`: Cambiar a pantalla seleccionada

**Flujo**:
```
Home (index: 0)
  ↓ tap Products
Products (index: 1)
  ↓ tap Cart
Cart (index: 2)
  ↓ tap Profile
Profile (index: 3)
```

---

### Estado 6: Perfil de Usuario (ProfileState)

**Ubicación**: `lib/screens/profile_screen.dart` con estado local

**Descripción**: Gestiona la información del perfil del usuario, direcciones, métodos de pago y órdenes.

**Propiedades**:
```dart
class ProfileState {
  final User user;
  final List<Address> addresses;
  final List<PaymentMethod> paymentMethods;
  final List<Order> orders;
  final NotificationSettings notifications;
}
```

**Acciones**:
- `updateProfile(name, phone)`: Actualizar datos personales
- `addAddress(address)`: Agregar dirección
- `deleteAddress(addressId)`: Eliminar dirección
- `addPaymentMethod(method)`: Agregar método de pago
- `toggleNotifications(type)`: Activar/desactivar notificaciones
- `changePassword(oldPassword, newPassword)`: Cambiar contraseña

**Diálogos Interactivos**:
1. **Editar Perfil**: Modificar nombre y teléfono
2. **Direcciones**: Gestionar direcciones de envío
3. **Métodos de Pago**: Tarjetas y cuentas
4. **Favoritos**: Productos guardados
5. **Notificaciones**: Preferencias de notificaciones
6. **Cambiar Contraseña**: Seguridad de cuenta
7. **Centro de Ayuda**: FAQ y soporte
8. **Órdenes**: Historial de pedidos

**Uso en UI**:
```dart
final user = ref.watch(authProvider).user;
Text('${user?.name ?? "Usuario"}');
Text('Órdenes: ${orders.length}');
```

## 🎬 Demo Funcional

### Navegación Completa por Estados

#### 1. **Estado Inicial: No Autenticado**
```
Pantalla: AuthScreen
Estado: AuthState(user: null)
Acción: Usuario ve formulario de login
```

#### 2. **Login → Autenticado**
```
Acción: Ingresar credenciales y presionar "Iniciar Sesión"
Estado Anterior: AuthState(user: null, isLoading: false)
Estado Durante: AuthState(user: null, isLoading: true)
Estado Nuevo: AuthState(user: User, isLoading: false)
Navegación: AuthScreen → MainNavigator(Home)
```

#### 3. **Explorar Productos**
```
Pantalla: HomeScreen
Estado: ProductsState(filteredProducts: [140])
Acción: Ver carrusel de categorías, click en "Arroz con Leche"
Nuevo Estado: ProductsState(category: arrozConLeche, filteredProducts: [20])
```

#### 4. **Ver Detalle de Producto**
```
Pantalla: ProductDetailScreen
Estado: Product seleccionado
Acciones disponibles:
- Seleccionar toppings
- Ajustar cantidad
- Agregar al carrito
```

#### 5. **Agregar al Carrito**
```
Acción: Presionar "Agregar al Carrito"
Estado Anterior: CartState(items: [], total: 0)
Estado Nuevo: CartState(items: [item], total: 18000)
UI Update: Badge en ícono de carrito muestra "1"
```

#### 6. **Proceso de Checkout**
```
Pantalla: CartScreen
Estado: CartState(items: [item1, item2], total: 35000)
Flujo:
1. Ver resumen de items
2. Presionar "Proceder al Pago"
3. Diálogo de confirmación con detalles
4. Presionar "Confirmar Pedido"
5. Estado: CartState(isProcessing: true)
6. Completado: CartState(items: [], total: 0)
7. Mensaje: "Pedido #12345 confirmado"
```

#### 7. **Gestión de Perfil**
```
Pantalla: ProfileScreen
Acciones disponibles:
1. Ver estadísticas (órdenes, total gastado)
2. Editar perfil → Diálogo con campos editables
3. Gestionar direcciones → Lista con CRUD completo
4. Ver métodos de pago → Tarjetas guardadas
5. Configurar notificaciones → Switches de preferencias
6. Cambiar contraseña → Validación de seguridad
7. Ver órdenes → Historial completo
```

#### 8. **Dashboard de Reportes**
```
Pantalla: ReportsScreen (Solo Admin)
Estado: ReportsState(
  totalRevenue: 15000000,
  totalOrders: 234,
  salesData: [...]
)
Visualizaciones:
- Gráfico de barras: Ventas por mes
- Gráfico circular: Rendimiento por categoría
- Cards de métricas: Ingresos, órdenes, promedio
- Tabla: Top productos
```

#### 9. **Logout**
```
Pantalla: ProfileScreen
Acción: Presionar "Cerrar Sesión"
Estado Anterior: AuthState(user: User)
Estado Nuevo: AuthState(user: null)
Navegación: MainNavigator → AuthScreen
```

### Video Demo

Para ver la aplicación en funcionamiento:

1. Clonar el repositorio
2. Ejecutar `flutter run -d chrome`
3. Usar credenciales: `admin@cremosos.com` / `admin123`
4. Navegar por todas las pantallas usando el BottomNavigationBar

### Screenshots

**Pantalla de Login**
- Estado no autenticado
- Formulario con validación

**Pantalla Principal**
- Carrusel de categorías con flechas de navegación
- Grid de productos destacados
- Badge de carrito con contador

**Catálogo de Productos**
- 140 productos organizados por categoría
- Filtrado en tiempo real
- Cards con imágenes de Unsplash

**Detalle de Producto**
- Imágenes, descripción, precio
- Selector de toppings
- Control de cantidad
- Reviews de usuarios

**Carrito**
- Lista de items con subtotales
- Resumen de costos (subtotal, IVA, total)
- Diálogo de checkout

**Perfil**
- Cards de estadísticas
- Menú de acciones
- 8 diálogos interactivos

**Dashboard de Reportes**
- Gráficos de ventas
- Métricas clave
- Análisis por categoría

## 🧪 Testing

### Ejecutar Tests
```bash
flutter test
```

### Test de Providers
```dart
test('AuthProvider - Login exitoso', () {
  final container = ProviderContainer();
  final authNotifier = container.read(authProvider.notifier);
  
  authNotifier.login('admin@cremosos.com', 'admin123');
  
  final state = container.read(authProvider);
  expect(state.user, isNotNull);
  expect(state.user?.email, 'admin@cremosos.com');
});
```

## 📦 Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1  # State management
  fl_chart: ^0.70.1          # Charts para reportes

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## 🚀 Deployment

### Web
```bash
flutter build web
# Los archivos compilados estarán en build/web/
```

### Windows
```bash
flutter build windows
# El ejecutable estará en build/windows/x64/runner/Release/
```

## 📝 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 👨‍💻 Autor

**Juan Pablo**
- GitHub: [@juanpablo686](https://github.com/juanpablo686)
- Repositorio: [flutter_dart-cremosos](https://github.com/juanpablo686/flutter_dart-cremosos)

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📞 Soporte

Si tienes preguntas o problemas:

1. Revisa la documentación en este README
2. Busca en [Issues](https://github.com/juanpablo686/flutter_dart-cremosos/issues)
3. Abre un nuevo issue si es necesario

---

**Hecho con ❤️ usando Flutter y Riverpod**
