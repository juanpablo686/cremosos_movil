# Documentación Completa del Proyecto Cremosos E-Commerce

## Descripción General
Sistema de e-commerce para venta de productos cremosos (arroz con leche y fresas con crema) desarrollado con Flutter (frontend) y Node.js (backend).

---

## Estructura del Proyecto

### BACKEND (Node.js + Express + MongoDB)

#### `/backend/server.js`
**Propósito:** Servidor principal de la API REST
**Funcionalidad:**
- Configura Express para manejar peticiones HTTP
- Conecta a MongoDB Atlas (base de datos en la nube)
- Implementa 22 endpoints para toda la funcionalidad del sistema
- Maneja autenticación con JWT (JSON Web Tokens)
- Serve archivos estáticos (imágenes de productos)

**Endpoints principales:**
1. Autenticación (3):
   - POST `/api/auth/login` - Iniciar sesión
   - POST `/api/auth/register` - Registrar usuario
   - GET `/api/users/profile` - Obtener perfil del usuario

2. Productos (6):
   - GET `/api/products` - Listar productos con filtros
   - GET `/api/products/:id` - Detalle de producto
   - POST `/api/products` - Crear producto (admin)
   - PUT `/api/products/:id` - Actualizar producto (admin)
   - DELETE `/api/products/:id` - Eliminar producto (admin)
   - GET `/api/products/featured` - Productos destacados

3. Carrito (4):
   - GET `/api/cart` - Obtener carrito del usuario
   - POST `/api/cart/items` - Agregar producto al carrito
   - PUT `/api/cart/items/:id` - Actualizar cantidad
   - DELETE `/api/cart/items/:id` - Eliminar del carrito

4. Órdenes (4):
   - GET `/api/orders` - Listar órdenes del usuario
   - GET `/api/orders/:id` - Detalle de orden
   - POST `/api/orders` - Crear orden (checkout)
   - PUT `/api/orders/:id` - Actualizar estado (admin)

5. Reportes (2):
   - GET `/api/reports/dashboard` - Estadísticas generales
   - GET `/api/reports/sales` - Reporte de ventas

---

#### `/backend/config/database.js`
**Propósito:** Configuración de conexión a MongoDB
**Funcionalidad:**
- Establece conexión con MongoDB Atlas usando Mongoose
- Lee la URI de conexión desde variables de entorno (.env)
- Maneja errores de conexión y termina el proceso si falla
- Muestra mensajes de confirmación cuando conecta exitosamente

**Importancia:** Este archivo centraliza la configuración de la base de datos, facilitando cambios entre ambientes (desarrollo, producción).

---

#### `/backend/models/`
**Propósito:** Definir esquemas de datos para MongoDB

##### `User.js`
Define la estructura de usuarios:
- Información personal: email, nombre, teléfono
- Dirección de envío: calle, ciudad, departamento, código postal
- Rol: admin, customer, employee
- Fecha de creación

##### `Product.js`
Define la estructura de productos:
- Información básica: nombre, descripción, precio
- Categoría: arroz_con_leche, fresas_con_crema
- Stock e inventario
- Calificación y número de reseñas
- Campos específicos:
  - Arroz: sabor, tamaño
  - Fresas: toppings incluidos, toppings disponibles

##### `Order.js`
Define la estructura de pedidos:
- Número único de orden
- Información del usuario
- Items del pedido (productos, cantidades, precios)
- Dirección de envío
- Información de pago
- Estado: pending, processing, shipped, delivered, cancelled
- Tracking de eventos
- Totales: subtotal, impuestos, envío, descuentos

##### `Cart.js`
Define la estructura del carrito:
- Usuario dueño del carrito
- Lista de items:
  - Producto seleccionado
  - Cantidad
  - Toppings seleccionados (para fresas)
- Fecha de última actualización

---

#### `/backend/.env`
**Propósito:** Variables de entorno (configuración sensible)
**Contenido:**
```
MONGODB_URI=mongodb+srv://usuario:contraseña@cluster.mongodb.net/cremosos
JWT_SECRET=cremosos_secret_2024
PORT=3000
```

**Importancia:** No debe compartirse públicamente (contiene credenciales). Cada ambiente (desarrollo, producción) tiene su propio .env.

---

#### `/backend/package.json`
**Propósito:** Gestión de dependencias y scripts de Node.js
**Dependencias principales:**
- `express` - Framework web para crear la API
- `mongoose` - ODM para MongoDB (facilita trabajar con la BD)
- `jsonwebtoken` - Crear y verificar tokens JWT
- `bcryptjs` - Encriptar contraseñas
- `cors` - Permitir peticiones desde Flutter
- `dotenv` - Cargar variables de entorno

**Scripts:**
- `npm start` - Inicia el servidor
- `npm run seed` - Pobla la base de datos con datos iniciales

---

### FRONTEND (Flutter + Dart)

#### `/lib/main.dart`
**Propósito:** Punto de entrada de la aplicación Flutter
**Funcionalidad:**
- Inicializa la app con ProviderScope (Riverpod)
- Configura el tema visual (colores azul cielo y vinotinto)
- Determina qué pantalla mostrar según autenticación:
  - No autenticado → AuthScreen (login/registro)
  - Cliente → ProductsScreen (catálogo)
  - Admin → HomeScreen (dashboard)

---

#### `/lib/config/`

##### `api_config.dart`
**Propósito:** Centralizar configuración de la API
**Contenido:**
- URL base: `http://localhost:3000/api`
- Timeouts: 30 segundos
- Endpoints de todos los servicios
- Headers por defecto (Content-Type: application/json)
- Método para agregar token de autorización

**Importancia:** Permite cambiar fácilmente entre ambientes sin modificar todo el código.

##### `toppings.dart`
**Propósito:** Lista de toppings disponibles para fresas con crema
**Contenido:** Array con 12 toppings:
- Fresas Frescas, Arándanos, Granola
- Miel, Chocolate, Coco Rallado
- Chispas de Chocolate, Crema Batida, etc.

Cada topping tiene: id, nombre, precio, imagen

---

#### `/lib/models/`
**Propósito:** Definir estructura de datos del frontend

##### `user.dart`
**Clases principales:**
- `User` - Información completa del usuario
- `Address` - Direcciones de envío
- `UserRole` - Enum (admin, customer, employee)
- `UserPreferences` - Configuración personal
- `PaymentMethod` - Métodos de pago guardados

**Métodos importantes:**
- `fromJson()` - Convertir JSON de API a objeto Dart
- `toJson()` - Convertir objeto Dart a JSON para API
- `copyWith()` - Crear copia modificada (inmutabilidad)

##### `product.dart`
**Clases principales:**
- `Product` - Información del producto
- `ProductCategory` - Enum de categorías
- `ProductVariant` - Variantes (tamaños, sabores)

**Propiedades destacadas:**
- `price` - Precio regular
- `salePrice` - Precio en oferta
- `rating` - Calificación promedio
- `stock` - Inventario disponible
- `isAvailable` - Si está disponible para venta

##### `cart.dart`
Modelo del carrito de compras con items y totales

##### `purchase.dart`
Modelo para órdenes/pedidos completados

---

#### `/lib/services/`
**Propósito:** Capa de comunicación con la API

##### `api_service.dart`
**Funcionalidad:**
- Servicio base para todas las peticiones HTTP
- Usa Dio (librería HTTP avanzada)
- Interceptores que:
  - Agregan token JWT automáticamente a cada petición
  - Manejan errores de red centralizadamente
  - Hacen logging de requests/responses
- Guarda y recupera token en storage seguro

**Métodos principales:**
- `get()` - Peticiones GET
- `post()` - Peticiones POST
- `put()` - Peticiones PUT
- `delete()` - Peticiones DELETE
- `setAuthToken()` - Guardar token
- `getAuthToken()` - Recuperar token
- `clearAuthToken()` - Eliminar token (logout)

##### `auth_service.dart`
**Funcionalidad:**
- `login()` - Autenticar usuario
- `register()` - Crear cuenta nueva
- `getProfile()` - Obtener datos del usuario
- `updateProfile()` - Actualizar información personal
- `logout()` - Cerrar sesión

##### `product_service.dart`
**Funcionalidad:**
- `getAllProducts()` - Listar productos con filtros
- `getProductById()` - Detalle de producto específico
- `getFeaturedProducts()` - Productos destacados
- `createProduct()` - Crear producto (admin)
- `updateProduct()` - Modificar producto (admin)
- `deleteProduct()` - Eliminar producto (admin)
- `searchProducts()` - Buscar por texto

##### `cart_service.dart`
**Funcionalidad (CRUD completo):**
- `getCart()` - Obtener carrito (READ)
- `addItemToCart()` - Agregar producto (CREATE)
- `updateCartItem()` - Cambiar cantidad (UPDATE)
- `removeFromCart()` - Eliminar producto (DELETE)
- `clearCart()` - Vaciar carrito

##### `order_service.dart`
**Funcionalidad:**
- `createOrder()` - Hacer checkout
- `getOrders()` - Historial de pedidos
- `getOrderById()` - Detalle de pedido
- `updateOrderStatus()` - Cambiar estado (admin)

---

#### `/lib/providers/`
**Propósito:** Gestión de estado con Riverpod

##### `auth_provider.dart`
**Funcionalidad:**
- Maneja estado global de autenticación
- Persiste sesión entre reinicios de la app
- Provee información del usuario a toda la app

**Clases:**
- `AuthState` - Estado inmutable con user, token, isLoading, error
- `AuthNotifier` - Lógica para modificar el estado
  - `login()` - Iniciar sesión
  - `register()` - Registrar usuario
  - `logout()` - Cerrar sesión
  - `updateProfile()` - Actualizar perfil

**Providers:**
- `apiServiceProvider` - Instancia de ApiService
- `authServiceProvider` - Instancia de AuthService
- `authProvider` - Estado de autenticación global

##### `products_provider_api.dart`
**Funcionalidad:**
- Gestiona lista de productos
- Carga productos desde la API
- Permite filtrar y buscar
- Mantiene caché de productos

---

#### `/lib/screens/`
**Propósito:** Pantallas de la aplicación

##### `auth_screen.dart`
**Funcionalidad:**
- Pantalla de login y registro
- Alterna entre modo login y registro
- Validación de formularios
- Muestra errores de autenticación
- Redirige a home después de login exitoso

**Campos del formulario:**
- Login: email, contraseña
- Registro: nombre, email, teléfono, contraseña, confirmar contraseña, aceptar términos

##### `products_screen.dart`
**Funcionalidad:**
- Muestra catálogo de productos en cuadrícula (3 columnas)
- Pull-to-refresh para actualizar
- Admin puede agregar/editar/eliminar productos
- Clientes pueden ver detalles y agregar al carrito
- Filtros por categoría
- Búsqueda por texto

##### `cart_screen.dart`
**Funcionalidad:**
- Lista de productos en el carrito
- Permite cambiar cantidades
- Permite eliminar productos
- Muestra totales:
  - Subtotal (suma de productos)
  - Impuestos (19%)
  - Envío (fijo $5,000)
  - Total a pagar
- Botón de checkout para crear orden

##### `my_orders_screen.dart`
**Funcionalidad:**
- Historial de pedidos del usuario
- Muestra estado de cada pedido
- Permite ver detalles (productos, dirección, totales)
- Tracking de envío

##### `home_screen.dart` / `home_screen_new.dart`
**Funcionalidad (Admin Dashboard):**
- Estadísticas de ventas
- Productos más vendidos
- Últimas órdenes
- Gráficas de reportes
- Acceso a gestión de productos, usuarios, pedidos

##### `pos_screen.dart`
**Funcionalidad (Punto de Venta):**
- Venta directa en tienda física
- Búsqueda rápida de productos
- Agregar productos a la venta
- Calcular totales
- Registrar método de pago
- Imprimir recibo

##### `customers_screen.dart`
**Funcionalidad (Admin):**
- Lista de clientes registrados
- Buscar clientes
- Ver historial de compras
- Editar información de cliente

##### `orders_screen.dart`
**Funcionalidad (Admin):**
- Todas las órdenes del sistema
- Filtrar por estado
- Cambiar estado de órdenes
- Asignar tracking

##### `reports_screen.dart`
**Funcionalidad (Admin):**
- Reportes de ventas por período
- Productos más vendidos
- Ingresos totales
- Gráficas y estadísticas

##### `profile_screen.dart`
**Funcionalidad:**
- Editar información personal
- Gestionar direcciones de envío
- Cambiar contraseña
- Preferencias de notificaciones

##### `settings_screen.dart`
**Funcionalidad:**
- Configuración de la app
- Tema claro/oscuro
- Idioma
- Notificaciones
- Cerrar sesión

---

#### `/lib/widgets/`
**Propósito:** Componentes reutilizables

##### `app_drawer.dart`
**Funcionalidad:**
- Menú lateral de navegación
- Muestra opciones según rol del usuario:
  - Cliente: Productos, Carrito, Mis Pedidos, Perfil
  - Admin: Dashboard, Productos, Órdenes, Clientes, Reportes, POS
- Botón de cerrar sesión
- Avatar del usuario

---

## Flujo de Datos

### 1. Autenticación
```
Usuario ingresa credenciales
  → auth_screen.dart llama a authProvider.login()
    → authProvider llama a auth_service.login()
      → auth_service llama a api_service.post('/auth/login')
        → api_service hace petición HTTP a backend
          → backend/server.js valida credenciales en MongoDB
            → si válido: genera JWT y retorna user + token
              → auth_service guarda token en storage seguro
                → authProvider actualiza estado global
                  → main.dart detecta cambio y navega a home
```

### 2. Cargar Productos
```
ProductsScreen se monta
  → llama a productsProvider.loadProducts()
    → productsProvider llama a product_service.getAllProducts()
      → product_service llama a api_service.get('/products')
        → api_service agrega token JWT automáticamente
          → backend valida token y retorna lista de productos desde MongoDB
            → product_service convierte JSON a objetos Product
              → productsProvider actualiza lista
                → ProductsScreen se reconstruye mostrando productos
```

### 3. Agregar al Carrito
```
Usuario hace clic en "Agregar al Carrito"
  → cart_screen.dart llama a cart_service.addItemToCart()
    → cart_service llama a api_service.post('/cart/items', data)
      → backend identifica usuario por token JWT
        → busca carrito del usuario en MongoDB
          → agrega item al carrito o incrementa cantidad si ya existe
            → calcula nuevos totales
              → retorna carrito actualizado
                → cart_screen actualiza UI con nuevo total
```

### 4. Checkout
```
Usuario hace clic en "Finalizar Compra"
  → cart_screen navega a checkout
    → usuario selecciona dirección de envío
      → confirma método de pago
        → presiona "Confirmar Orden"
          → cart_screen llama a order_service.createOrder()
            → backend crea documento Order en MongoDB
              → genera número de orden único (ORD-2024-XXXX)
                → vacía el carrito del usuario
                  → envía email de confirmación
                    → retorna orden creada
                      → navega a my_orders_screen mostrando nueva orden
```

---

## Tecnologías y Librerías

### Backend
- **Node.js** - Entorno de ejecución JavaScript
- **Express** - Framework web minimalista
- **MongoDB Atlas** - Base de datos NoSQL en la nube
- **Mongoose** - ODM para modelar datos
- **JWT** - Tokens de autenticación seguros
- **bcryptjs** - Encriptación de contraseñas
- **cors** - Permitir peticiones cross-origin
- **dotenv** - Variables de entorno

### Frontend
- **Flutter** - Framework de UI multiplataforma
- **Dart** - Lenguaje de programación
- **Riverpod** - Gestión de estado reactiva
- **Dio** - Cliente HTTP avanzado
- **flutter_secure_storage** - Almacenamiento seguro
- **pretty_dio_logger** - Logging de peticiones HTTP

---

## Seguridad

### Backend
1. **JWT Tokens** - Autenticación sin estado
2. **bcrypt** - Contraseñas hasheadas (no texto plano)
3. **Validación de entrada** - Prevenir inyección SQL/NoSQL
4. **CORS configurado** - Solo Flutter puede acceder
5. **Variables de entorno** - Credenciales no en código

### Frontend
1. **flutter_secure_storage** - Token encriptado en Keychain/KeyStore
2. **HTTPS** - En producción, todas las peticiones encriptadas
3. **Validación de formularios** - Prevenir datos inválidos
4. **Manejo de errores** - No exponer información sensible

---

## Cómo Funciona el Sistema Completo

### Inicio de la App
1. App abre → main.dart se ejecuta
2. Verifica si hay token guardado
3. Si hay token → obtiene perfil del usuario
4. Si es válido → muestra home según rol
5. Si no hay token → muestra login

### Ciclo de Compra Completo
1. Cliente se registra o inicia sesión
2. Navega a ProductsScreen
3. Ve catálogo de productos (arroz, fresas)
4. Hace clic en producto → ve detalles
5. Selecciona cantidad y toppings (si aplica)
6. Agrega al carrito
7. Repite para más productos
8. Va a CartScreen
9. Revisa productos y totales
10. Hace clic en "Finalizar Compra"
11. Confirma dirección de envío
12. Selecciona método de pago
13. Confirma orden
14. Recibe confirmación con número de orden
15. Puede hacer tracking en MyOrdersScreen

### Administración (Admin)
1. Admin inicia sesión
2. Ve Dashboard con estadísticas
3. Puede:
   - Agregar nuevos productos
   - Actualizar precios e inventario
   - Ver todas las órdenes
   - Cambiar estado de órdenes
   - Ver reportes de ventas
   - Gestionar clientes
   - Usar POS para ventas presenciales

---

## Comandos Importantes

### Backend
```bash
# Instalar dependencias
npm install

# Iniciar servidor
npm start

# Poblar base de datos con datos iniciales
npm run seed
```

### Frontend
```bash
# Instalar dependencias
flutter pub get

# Ejecutar en Chrome (web)
flutter run -d chrome

# Ejecutar en dispositivo Android
flutter run -d android

# Ejecutar en dispositivo iOS
flutter run -d ios
```

---

## Variables de Entorno Necesarias

### Backend (.env)
```
MONGODB_URI=mongodb+srv://usuario:contraseña@cluster.mongodb.net/cremosos
JWT_SECRET=cremosos_secret_2024
PORT=3000
```

### Frontend (lib/config/api_config.dart)
```dart
static const String baseUrl = 'http://localhost:3000/api';
// En producción cambiar a URL del servidor real
```

---

## Estructura de Datos en MongoDB

### Colecciones
1. **users** - Usuarios del sistema
2. **products** - Catálogo de productos
3. **carts** - Carritos de compras
4. **orders** - Pedidos/órdenes

### Ejemplo de Documento en MongoDB

#### Usuario
```json
{
  "_id": "user123",
  "email": "cliente@cremosos.com",
  "password": "$2a$10$hashdecontraseña",
  "name": "María García",
  "phone": "3001234567",
  "role": "customer",
  "address": {
    "street": "Calle 45 #23-10",
    "city": "Cali",
    "state": "Valle del Cauca",
    "zipCode": "760001",
    "country": "Colombia"
  },
  "createdAt": "2024-01-15T10:30:00Z"
}
```

#### Producto
```json
{
  "_id": "prod001",
  "name": "Arroz con Leche Tradicional - Grande",
  "description": "Delicioso arroz con leche sabor tradicional",
  "price": 9000,
  "imageUrl": "http://localhost:3000/images/arroz_tradicional.jpg",
  "category": "arroz_con_leche",
  "stock": 50,
  "rating": 4.8,
  "reviewsCount": 120,
  "isAvailable": true,
  "isFeatured": true,
  "sabor": "Tradicional",
  "tamaño": "Grande",
  "createdAt": "2024-01-10T08:00:00Z"
}
```

#### Orden
```json
{
  "_id": "order001",
  "orderNumber": "ORD-2024-0001",
  "userId": "user123",
  "userName": "María García",
  "userEmail": "cliente@cremosos.com",
  "items": [
    {
      "id": "item1",
      "productId": "prod001",
      "productName": "Arroz con Leche Tradicional - Grande",
      "quantity": 2,
      "productPrice": 9000,
      "toppings": []
    }
  ],
  "shippingAddress": {
    "street": "Calle 45 #23-10",
    "city": "Cali",
    "state": "Valle del Cauca",
    "zipCode": "760001",
    "country": "Colombia"
  },
  "subtotal": 18000,
  "tax": 3420,
  "shippingCost": 5000,
  "total": 26420,
  "status": "pending",
  "createdAt": "2024-12-12T14:30:00Z"
}
```

---

## Próximos Pasos para Mejorar

### Backend
1. Implementar bcrypt para encriptar contraseñas
2. Agregar validación de datos más robusta
3. Implementar rate limiting (prevenir ataques)
4. Agregar paginación a todos los endpoints
5. Implementar caché con Redis
6. Agregar tests unitarios

### Frontend
1. Agregar tests de widgets
2. Implementar caché offline
3. Agregar animaciones
4. Soporte multiidioma
5. Modo oscuro
6. Notificaciones push

### General
1. Desplegar backend en Heroku/AWS/Azure
2. Desplegar frontend en Firebase Hosting
3. Configurar CI/CD
4. Monitoreo con Sentry
5. Analytics con Google Analytics
6. Sistema de reviews y calificaciones

---

Esta documentación explica cada componente del proyecto Cremosos E-Commerce. Cualquier desarrollador puede usar este documento para entender cómo funciona el sistema completo.
