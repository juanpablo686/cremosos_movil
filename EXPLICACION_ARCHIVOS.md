# 📚 EXPLICACIÓN ARCHIVO POR ARCHIVO

## 🎯 PROPÓSITO DE ESTE DOCUMENTO

Este documento explica **qué hace cada archivo** del proyecto Cremosos Fase 2, organizado por categorías. Úsalo para entender rápidamente la función de cada componente.

---

## 📁 ESTRUCTURA Y EXPLICACIONES

### 🟦 BACKEND (Node.js/Express)

#### `backend/server.js` (524 líneas)
**¿Qué hace?**
- Es el servidor REST API completo que maneja todas las peticiones desde Flutter
- Implementa 22 endpoints organizados en 5 categorías

**Funciones principales:**
1. **Configuración** (líneas 1-15)
   - Importa Express, CORS, JWT
   - Define puerto 3000 y clave secreta

2. **Datos Mock** (líneas 17-75)
   - `users[]` - Lista de usuarios registrados
   - `products[]` - Catálogo de productos (Arroz con Leche, Fresas con Crema)
   - `carts{}` - Carritos de compra por usuario
   - `orders[]` - Historial de órdenes
   
3. **Middleware de Autenticación** (líneas 77-97)
   - `authenticateToken()` - Verifica que el JWT sea válido
   - Extrae el token del header `Authorization: Bearer <token>`
   - Si es inválido → 401 Unauthorized

4. **Endpoints de Autenticación** (líneas 99-213)
   - `POST /api/auth/login` - Valida credenciales y genera JWT
   - `POST /api/auth/register` - Crea nuevo usuario
   - `GET /api/users/profile` - Obtiene datos del usuario actual
   - `PUT /api/users/profile` - Actualiza perfil

5. **Endpoints de Productos** (líneas 215-285)
   - `GET /api/products` - Lista con filtros, búsqueda, paginación
   - `GET /api/products/:id` - Detalle de un producto
   - `GET /api/products/featured` - Productos destacados

6. **Endpoints de Carrito - CRUD COMPLETO** (líneas 287-385)
   - `GET /api/cart` - Obtener carrito (READ)
   - `POST /api/cart/items` - Agregar producto (CREATE)
   - `PUT /api/cart/items/:id` - Actualizar cantidad (UPDATE)
   - `DELETE /api/cart/items/:id` - Eliminar item (DELETE)
   - `DELETE /api/cart` - Vaciar carrito
   - `POST /api/cart/sync` - Sincronizar carrito

7. **Endpoints de Órdenes** (líneas 387-475)
   - `POST /api/orders` - Crear orden desde carrito
   - `GET /api/orders` - Historial de órdenes del usuario
   - `GET /api/orders/:id` - Detalle de orden específica
   - `PUT /api/orders/:id/cancel` - Cancelar orden
   - `GET /api/orders/:id/track` - Rastrear envío

8. **Endpoints de Reportes** (líneas 477-570)
   - `GET /api/reports/dashboard` - KPIs generales
   - `GET /api/reports/sales` - Reporte de ventas
   - `GET /api/reports/products` - Análisis de productos
   - `GET /api/reports/customers` - Datos de clientes

**¿Por qué es importante?**
- Sin este servidor, Flutter no tendría de dónde obtener/enviar datos
- Simula un backend real que en producción se conectaría a una base de datos

---

#### `backend/package.json`
**¿Qué hace?**
- Define las dependencias de Node.js necesarias para el servidor

**Dependencias:**
- `express` - Framework web para crear la API
- `cors` - Permite peticiones desde Flutter (cross-origin)
- `jsonwebtoken` - Para generar y verificar tokens JWT

**¿Cómo usarlo?**
```bash
npm install  # Instala las dependencias
npm start    # Inicia el servidor
```

---

### 🟩 SERVICIOS DE API (Flutter)

Todos los servicios están en `lib/services/` y se comunican con el backend.

#### `lib/services/api_service.dart` (219 líneas)
**¿Qué hace?**
- Es la **base de todos los servicios** HTTP
- Configura Dio (cliente HTTP potente)
- Maneja interceptores, tokens, errores

**Funciones principales:**
1. **Constructor** (líneas 20-40)
   - Crea instancia de Dio con baseUrl y timeouts
   - Llama `_setupInterceptors()`

2. **Interceptores** (líneas 42-85)
   - **onRequest**: Agrega automáticamente el token JWT al header
   - **onResponse**: Imprime logs de respuestas exitosas
   - **onError**: Imprime logs de errores
   - **PrettyDioLogger**: Muestra peticiones detalladas en consola

3. **Métodos HTTP** (líneas 87-150)
   - `get()` - Para obtener datos (GET)
   - `post()` - Para crear recursos (POST)
   - `put()` - Para actualizar recursos (PUT)
   - `delete()` - Para eliminar recursos (DELETE)

4. **Manejo de Errores** (líneas 152-195)
   - Traduce códigos HTTP a mensajes en español
   - 400 → "Datos incorrectos"
   - 401 → "No autorizado, inicie sesión"
   - 403 → "Sin permisos"
   - 404 → "No encontrado"
   - 500 → "Error del servidor"

5. **Gestión de Tokens** (líneas 197-219)
   - `setAuthToken()` - Guarda token cifrado
   - `getAuthToken()` - Recupera token guardado
   - `clearAuthToken()` - Elimina token (logout)
   - `hasAuthToken()` - Verifica si hay token

**¿Por qué es importante?**
- Centraliza toda la lógica HTTP
- Inyecta tokens automáticamente (no hay que hacerlo manualmente en cada petición)
- Maneja errores de forma consistente

**EXPLICAR EN EXPOSICIÓN:**
> "ApiService es el corazón de la comunicación con el backend. Usa Dio, que es más potente que el cliente HTTP nativo de Flutter. Los interceptores inyectan automáticamente el token JWT en cada petición autenticada, y el manejo de errores traduce los códigos HTTP a mensajes user-friendly."

---

#### `lib/services/auth_service.dart` (177 líneas)
**¿Qué hace?**
- Maneja autenticación de usuarios (login, registro, perfil)

**Métodos:**
1. `login(email, password)` → POST /api/auth/login
   - Envía credenciales
   - Recibe token JWT
   - Guarda token con `setAuthToken()`

2. `register(name, email, password)` → POST /api/auth/register
   - Crea nuevo usuario
   - Recibe token
   - Guarda token

3. `getProfile()` → GET /api/users/profile
   - Obtiene datos del usuario autenticado
   - Requiere token (agregado automáticamente por interceptor)

4. `updateProfile(data)` → PUT /api/users/profile
   - Actualiza nombre, teléfono, dirección

5. `logout()`
   - Elimina token guardado
   - Usuario vuelve a login

**EXPLICAR EN EXPOSICIÓN:**
> "AuthService gestiona todo el ciclo de autenticación. Cuando haces login, el servidor genera un JWT que guardamos de forma segura con FlutterSecureStorage. Este token se envía automáticamente en las siguientes peticiones gracias al interceptor."

---

#### `lib/services/product_service.dart` (137 líneas)
**¿Qué hace?**
- Maneja catálogo de productos

**Métodos:**
1. `getAllProducts({filters, page, limit})` → GET /api/products
   - Lista productos con filtros opcionales
   - Paginación (página, límite)
   - Ordenamiento

2. `getProductById(id)` → GET /api/products/:id
   - Detalle completo de un producto

3. `getFeaturedProducts()` → GET /api/products/featured
   - Solo productos destacados

4. `searchProducts(query)` → GET /api/products/search?q=query
   - Búsqueda por texto

5. `getProductsByCategory(category)` → GET /api/products/category/:category
   - Filtrar por categoría

**EXPLICAR EN EXPOSICIÓN:**
> "ProductService implementa 5 endpoints para el catálogo. Permite búsqueda, filtrado por categoría, paginación y obtener productos destacados."

---

#### `lib/services/cart_service.dart` (205 líneas) ⭐ CRUD COMPLETO
**¿Qué hace?**
- Maneja el carrito de compras con **CRUD completo**

**Métodos:**
1. `getCart()` → GET /api/cart **(READ)**
   - Obtiene carrito del usuario autenticado
   - Lista de items con precios

2. `addItemToCart(productId, quantity)` → POST /api/cart/items **(CREATE)**
   - Agrega producto al carrito
   - Puede incluir toppings

3. `updateCartItem(itemId, quantity)` → PUT /api/cart/items/:id **(UPDATE)**
   - Modifica cantidad de un producto ya en el carrito

4. `removeFromCart(itemId)` → DELETE /api/cart/items/:id **(DELETE)**
   - Elimina un producto del carrito

5. `clearCart()` → DELETE /api/cart
   - Vacía todo el carrito

6. `syncCart(items)` → POST /api/cart/sync
   - Sincroniza carrito local con servidor

**EXPLICAR EN EXPOSICIÓN:**
> "CartService es donde demostramos el CRUD completo. CREATE con POST para agregar items, READ con GET para obtener el carrito, UPDATE con PUT para cambiar cantidades, y DELETE para eliminar productos. Estas son las 4 operaciones fundamentales de cualquier API REST."

---

#### `lib/services/order_service.dart` (171 líneas)
**¿Qué hace?**
- Maneja órdenes de compra

**Métodos:**
1. `createOrder(cartId, shippingAddress, paymentMethod)` → POST /api/orders
   - Crea orden desde carrito actual
   - Vacía el carrito automáticamente

2. `getOrderHistory()` → GET /api/orders
   - Historial de órdenes del usuario

3. `getOrderById(orderId)` → GET /api/orders/:id
   - Detalle completo de una orden

4. `cancelOrder(orderId)` → PUT /api/orders/:id/cancel
   - Cancela orden (solo si está pendiente)

5. `trackOrder(orderId)` → GET /api/orders/:id/track
   - Estado de envío y tracking

---

#### `lib/services/report_service.dart` (158 líneas)
**¿Qué hace?**
- Obtiene reportes y analytics

**Métodos:**
1. `getDashboard()` → GET /api/reports/dashboard
   - KPIs generales (ventas, órdenes, clientes)

2. `getSalesReport(startDate, endDate)` → GET /api/reports/sales
   - Análisis de ventas por período

3. `getProductsReport()` → GET /api/reports/products
   - Productos más vendidos, stock, ratings

4. `getCustomersReport()` → GET /api/reports/customers
   - Datos demográficos y retención

---

### 🟨 MODELOS (Data Classes)

Todos los modelos están en `lib/models/` y usan `json_serializable`.

#### `lib/models/api_response.dart` + `.g.dart`
**¿Qué hace?**
- Define la estructura genérica de respuestas de la API

**Clases:**
1. `ApiResponse<T>` - Wrapper para todas las respuestas
   ```dart
   {
     "success": true,
     "message": "OK",
     "data": T,
     "meta": {...paginación...}
   }
   ```

2. `ResponseMeta` - Información de paginación
   - page, limit, total, hasNext, hasPrevious

3. `ApiError` - Estructura de errores
   - code, details, validationErrors

4. `DataState<T>` - Estados de la UI
   - `DataStateInitial` - Estado inicial
   - `DataStateLoading` - Cargando datos
   - `DataStateSuccess<T>` - Datos cargados
   - `DataStateError` - Error al cargar
   - `DataStateEmpty` - Sin datos

**¿Por qué es importante?**
- Estandariza cómo manejamos respuestas
- DataState permite mostrar spinners, errores, pantallas vacías

**EXPLICAR EN EXPOSICIÓN:**
> "DataState es un pattern que usamos para manejar los diferentes estados de la UI. Cuando haces una petición, empiezas en Loading (mostrar spinner), luego vas a Success (mostrar datos) o Error (mostrar mensaje). Esto hace la UX mucho más profesional."

---

#### `lib/models/user_api.dart` + `.g.dart`
**¿Qué hace?**
- Modelo del usuario

**Propiedades:**
- id, email, name, phone, role, address

**Métodos generados:**
- `fromJson()` - Deserializa JSON a objeto Dart
- `toJson()` - Serializa objeto Dart a JSON

---

#### `lib/models/product_api.dart` + `.g.dart`
**¿Qué hace?**
- Modelo del producto

**Propiedades:**
- id, name, description, price, imageUrl
- category, stock, rating, reviews
- isAvailable, isFeatured

**EXPLICAR EN EXPOSICIÓN:**
> "Cada modelo tiene anotación @JsonSerializable. Cuando ejecutamos build_runner, se genera automáticamente el archivo .g.dart con todo el código de conversión JSON. Esto nos ahorra escribir código boilerplate manualmente."

---

#### `lib/models/cart_api.dart` + `.g.dart`
**¿Qué hace?**
- Modelos relacionados al carrito

**Clases:**
1. `CartApi` - Carrito completo
   - userId, items[], subtotal, tax, total

2. `CartItemApi` - Item individual en carrito
   - productId, product, quantity, toppings, subtotal

3. `AddToCartRequest` - DTO para agregar item
4. `UpdateCartItemRequest` - DTO para actualizar
5. `SyncCartRequest` - DTO para sincronizar

---

#### `lib/models/order_api.dart` + `.g.dart`
**¿Qué hace?**
- Modelos de órdenes

**Clases:**
1. `OrderApi` - Orden completa
   - id, orderNumber, userId, status
   - items, shippingAddress, paymentInfo
   - subtotal, tax, shipping, total
   - tracking, estimatedDelivery

2. `OrderItemApi` - Item de la orden
3. `TrackingInfoApi` - Información de rastreo

---

#### `lib/models/report_api.dart` + `.g.dart`
**¿Qué hace?**
- Modelos de reportes

**Clases:**
1. `DashboardReportApi` - KPIs del dashboard
2. `SalesReportApi` - Datos de ventas
3. `ProductReportApi` - Análisis de productos
4. `CustomerReportApi` - Datos de clientes

---

### 🟪 CONFIGURACIÓN

#### `lib/config/api_config.dart` (91 líneas)
**¿Qué hace?**
- Centraliza toda la configuración de la API

**Constantes:**
1. `baseUrl` - URL del servidor (http://localhost:3000/api)
2. `connectionTimeout` - 30 segundos
3. `receiveTimeout` - 30 segundos

4. **Endpoints organizados:**
   - Auth: login, register, profile
   - Products: products, featured
   - Cart: cart, cart/items
   - Orders: orders, orders/history
   - Reports: dashboard, sales, products, customers

**¿Por qué es importante?**
- Si cambias de servidor (localhost → producción), solo modificas un archivo
- Evita hardcodear URLs en múltiples lugares

---

#### `.env.example` (95 líneas)
**¿Qué hace?**
- Template de variables de ambiente

**Variables:**
- API_BASE_URL
- JWT_SECRET
- JWT_EXPIRATION
- Test credentials
- Database config (para futuro)

**¿Cómo usarlo?**
```bash
# Copiar a .env
cp .env.example .env

# Editar valores según ambiente
nano .env
```

---

### 🟧 PROVIDERS (State Management)

#### `lib/providers/products_provider_api.dart` (409 líneas) ⭐ EJEMPLO COMPLETO
**¿Qué hace?**
- Provider con integración completa a la API
- Maneja estado de productos con Riverpod

**Clases:**
1. `ProductsState` - Estado del provider
   ```dart
   {
     dataState: DataState.loading(),
     products: [],
     selectedCategory: null,
     searchQuery: '',
     sortBy: 'name',
     page: 1,
     hasMore: true
   }
   ```

2. `ProductsNotifier` - Lógica del provider
   - `loadProducts()` - Carga productos desde API
   - `filterByCategory(category)` - Filtra por categoría
   - `search(query)` - Busca por texto
   - `sortBy(field)` - Ordena resultados
   - `loadMore()` - Paginación (cargar más)
   - `refresh()` - Recargar todo

**Flujo:**
```
1. Usuario abre ProductsScreen
2. Screen llama loadProducts()
3. State → DataState.loading()
4. Screen muestra CircularProgressIndicator
5. API responde con productos
6. State → DataState.success(products)
7. Screen muestra lista de productos
```

**EXPLICAR EN EXPOSICIÓN:**
> "Este provider es el ejemplo completo de integración. Usa ProductService para llamar la API, maneja estados con DataState, y la UI reacciona automáticamente a los cambios. Cuando el estado es Loading, mostramos un spinner. Cuando es Success, mostramos los productos. Si es Error, mostramos un mensaje."

---

### 🟥 PANTALLAS (UI)

#### `lib/main.dart` (ahora comentado)
**¿Qué hace?**
- Punto de entrada de la aplicación

**Flujo:**
1. `main()` → Inicia app con ProviderScope
2. `CremososApp` → Configura tema Material3
3. `AppRoot` → Decide si mostrar Login o App
4. `MainNavigator` → Navegación entre pantallas

**EXPLICAR EN EXPOSICIÓN:**
> "Main.dart es el punto de entrada. ProviderScope envuelve la app para que Riverpod funcione. AppRoot decide qué mostrar según si el usuario está autenticado. Si no lo está, ve el login. Si sí, ve el navigator principal con 4 tabs."

---

### 📜 SCRIPTS Y AUTOMATIZACIÓN

#### `run.ps1` (106 líneas)
**¿Qué hace?**
- Script PowerShell para ejecutar todo el proyecto en 1 comando

**Funciones:**
1. Verifica Node.js y Flutter instalados
2. Instala dependencias si faltan (npm install, flutter pub get)
3. Inicia backend en terminal separada
4. Espera 5 segundos para warmup
5. Health check del servidor
6. Pregunta en qué plataforma ejecutar (Chrome/Edge/Windows)
7. Inicia Flutter

**¿Cómo usarlo?**
```powershell
powershell -ExecutionPolicy Bypass -File run.ps1
```

---

### 📖 DOCUMENTACIÓN

#### `README.md` (actualizado)
**¿Qué contiene?**
- Descripción general del proyecto
- Características Fase 1 + Fase 2
- Instalación paso a paso
- Endpoints implementados (22)
- Arquitectura explicada
- Credenciales de prueba

---

#### `GUIA_RAPIDA.md` (350 líneas)
**¿Qué contiene?**
- Ejecución automática (run.ps1)
- Ejecución manual (backend + frontend)
- Testing con curl
- Credenciales de prueba
- Solución de problemas
- Checklist pre-presentación
- Flujo de demostración sugerido

---

#### `CUMPLIMIENTO_FASE2.md` (420 líneas)
**¿Qué contiene?**
- Checklist detallado de requisitos
- Estado: 95% completo
- Desglose por categorías:
  - Endpoints: 22/10 ✅ 220%
  - Backend: 100% ✅
  - Servicios: 100% ✅
  - Modelos: 100% ✅
  - UI: 20% ⚠️
- Qué está listo vs qué falta

---

#### `COMO_PROBAR_API.md` (470 líneas)
**¿Qué contiene?**
- 4 métodos de testing:
  1. Desde la app Flutter
  2. Con Postman
  3. Desde el navegador
  4. Con PowerShell/curl
- Los 22 endpoints documentados
- Ejemplos completos
- Respuestas esperadas

---

#### `INTEGRACION_API.md` (650 líneas)
**¿Qué contiene?**
- Arquitectura detallada con diagramas
- Explicación de 3 capas (UI → Providers → Services)
- Cómo funciona JWT
- Métodos HTTP explicados (GET, POST, PUT, DELETE)
- Interceptores de Dio
- Serialización JSON con build_runner
- DataState pattern
- Códigos de error HTTP
- Ejemplos de uso

---

#### `PASOS_PENDIENTES.md` (580 líneas)
**¿Qué contiene?**
- Qué está completo (95%)
- Qué falta exactamente (5%)
- Cómo conectar cada provider con API
- Código de ejemplo para cada paso
- Timeboxing (cuánto tarda)
- Checklist de implementación
- Plan de acción recomendado

---

#### `GUION_EXPOSICION.md` (590 líneas)
**¿Qué contiene?**
- Script completo de 5-7 minutos
- Tiempos exactos por sección
- Qué archivos abrir
- Qué código mostrar
- Preguntas frecuentes y respuestas
- Checklist pre-presentación
- Tips de lenguaje corporal
- Frases power para impresionar

---

#### `ESTADO_FINAL.md`
**¿Qué contiene?**
- Resumen ejecutivo del proyecto
- Métricas finales (95% completo)
- Todos los archivos creados listados
- Arquitectura visual
- 22 endpoints explicados
- Logros destacables

---

#### `INDICE_ARCHIVOS.md`
**¿Qué contiene?**
- Índice de navegación
- Dónde encontrar cada cosa
- Flujos de trabajo recomendados
- Búsquedas rápidas

---

## 🎯 ARCHIVOS MÁS IMPORTANTES PARA LA EXPOSICIÓN

### 1. Backend
- `backend/server.js` - Mostrar endpoints implementados

### 2. Servicios
- `lib/services/api_service.dart` - Interceptores y Dio
- `lib/services/cart_service.dart` - CRUD completo

### 3. Modelos
- `lib/models/api_response.dart` - DataState pattern
- `lib/models/product_api.dart` - json_serializable

### 4. Configuración
- `lib/config/api_config.dart` - Centralización de endpoints

### 5. Providers
- `lib/providers/products_provider_api.dart` - Integración completa

### 6. UI
- `lib/main.dart` - Punto de entrada y navegación

### 7. Documentación
- `CUMPLIMIENTO_FASE2.md` - Mostrar 95% completo
- `GUION_EXPOSICION.md` - Seguir el script

---

## 💡 CÓMO USAR ESTE DOCUMENTO

### Para estudiar el proyecto:
1. Lee este archivo primero (visión general)
2. Abre los archivos mencionados en VSCode
3. Lee los comentarios en el código
4. Revisa `INTEGRACION_API.md` para detalles técnicos

### Para la exposición:
1. Lee `GUION_EXPOSICION.md` (script completo)
2. Practica con los archivos mencionados ahí
3. Ten este archivo a mano como referencia rápida

### Para completar el proyecto:
1. Lee `PASOS_PENDIENTES.md`
2. Identifica qué archivos modificar
3. Usa los ejemplos de código proporcionados

---

## 🔍 BÚSQUEDA RÁPIDA

**¿Dónde está...?**
- Login: `lib/services/auth_service.dart` + `backend/server.js` líneas 99-138
- CRUD Carrito: `lib/services/cart_service.dart` + `backend/server.js` líneas 287-385
- Interceptores: `lib/services/api_service.dart` líneas 42-85
- JWT: `backend/server.js` líneas 77-97 + 118-128
- Serialización: `lib/models/*.dart` (todos con @JsonSerializable)
- Endpoints: `lib/config/api_config.dart`
- Estados UI: `lib/models/api_response.dart` (DataState)

---

```
╔════════════════════════════════════════════════════════╗
║  Este documento explica TODOS los archivos del        ║
║  proyecto Cremosos Fase 2.                            ║
║                                                        ║
║  Úsalo como referencia rápida para entender qué       ║
║  hace cada componente.                                ║
╚════════════════════════════════════════════════════════╝
```

**Última actualización:** Diciembre 2024
