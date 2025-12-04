# 📂 ÍNDICE DE ARCHIVOS - FASE 2

## 🎯 GUÍA RÁPIDA DE NAVEGACIÓN

Este documento te ayuda a encontrar exactamente lo que necesitas según tu objetivo.

---

## 🚀 PARA EJECUTAR EL PROYECTO

### 1. Si quieres ejecutar TODO en 1 comando:
📄 **`run.ps1`**
- Script PowerShell de ejecución automática
- Verifica prerequisitos
- Inicia backend y frontend
- Opción más rápida

### 2. Si prefieres instrucciones paso a paso:
📄 **`GUIA_RAPIDA.md`**
- Ejecución manual (backend + frontend)
- Cómo verificar que funciona
- Testing con curl
- Credenciales de prueba
- Solución de problemas

### 3. Si necesitas entender el proyecto completo:
📄 **`README.md`**
- Descripción general del proyecto
- Características Fase 1 + Fase 2
- Instalación completa
- Arquitectura
- Tabla de contenidos

---

## 📖 PARA ENTENDER LA INTEGRACIÓN API

### 1. Si quieres la explicación técnica completa:
📄 **`INTEGRACION_API.md`** (650 líneas)
- Arquitectura detallada con diagramas
- Explicación de los 3 layers
- Cómo funciona JWT
- Métodos HTTP explicados
- Interceptores de Dio
- Serialización JSON
- DataState pattern
- Códigos de error HTTP
- Ejemplos de uso

### 2. Si necesitas probar los endpoints:
📄 **`COMO_PROBAR_API.md`** (470 líneas)
- 4 métodos de testing:
  1. Desde la app Flutter
  2. Con Postman
  3. Desde el navegador
  4. Con PowerShell/curl
- Los 22 endpoints documentados
- Ejemplos completos con código
- Respuestas esperadas
- Troubleshooting

### 3. Si quieres ver qué cumpliste:
📄 **`CUMPLIMIENTO_FASE2.md`** (420 líneas)
- Checklist detallado
- Estado: 95% completo
- Desglose por categorías:
  - ✅ Endpoints: 22/10 (220%)
  - ✅ Backend: 100%
  - ✅ Servicios: 100%
  - ✅ Modelos: 100%
  - ⚠️ UI: 20%
- Qué está listo vs. qué falta

---

## 🎓 PARA LA EXPOSICIÓN

### 1. Script completo de presentación:
📄 **`GUION_EXPOSICION.md`** (590 líneas)
- Guión de 5-7 minutos con tiempos exactos
- Qué decir en cada sección
- Qué archivos abrir
- Qué código mostrar
- Preguntas frecuentes y respuestas
- Checklist pre-presentación
- Tips de lenguaje corporal
- Frases power para impresionar

### 2. Resumen visual del proyecto:
📄 **`ESTADO_FINAL.md`**
- Métricas finales (95% completo)
- Todos los archivos creados
- Arquitectura visual
- Endpoints listados
- Logros destacables
- Gráficos y tablas

---

## 🔨 PARA COMPLETAR LO QUE FALTA

### Si quieres terminar el 5% pendiente:
📄 **`PASOS_PENDIENTES.md`** (580 líneas)
- Qué está completo (95%)
- Qué falta exactamente (5%)
- Cómo conectar AuthProvider con API
- Cómo conectar ProductsProvider con API
- Cómo conectar CartProvider con API
- Cómo actualizar las pantallas
- Código de ejemplo para cada paso
- Timeboxing (cuánto tarda cada cosa)
- Checklist de implementación
- Plan de acción recomendado

---

## 🖥️ CÓDIGO FUENTE

### Backend

#### Servidor principal:
📄 **`backend/server.js`** (524 líneas)
- 22 endpoints REST
- Autenticación JWT
- Middleware CORS
- Datos mock
- Lógica de negocio

```javascript
// Estructura:
- Líneas 1-50: Configuración
- Líneas 57-162: Auth endpoints (4)
- Líneas 167-232: Product endpoints (5)
- Líneas 237-331: Cart endpoints (6)
- Líneas 336-426: Order endpoints (5)
- Líneas 431-519: Report endpoints (4)
```

#### Configuración:
📄 **`backend/package.json`**
- Dependencies: express, cors, jsonwebtoken
- Scripts: start

📄 **`backend/README.md`**
- Instalación
- Ejecución
- Testing

---

### Servicios de API (Flutter)

#### Servicio base:
📄 **`lib/services/api_service.dart`** (219 líneas)
- Cliente HTTP con Dio
- Interceptores (líneas 38-72)
- Inyección automática de JWT
- Métodos HTTP: GET, POST, PUT, DELETE
- Error handling (400, 401, 403, 404, 500)
- FlutterSecureStorage integration

#### Servicios específicos:
📄 **`lib/services/auth_service.dart`** (177 líneas)
- 5 métodos:
  - login() → POST /api/auth/login
  - register() → POST /api/auth/register
  - getProfile() → GET /api/auth/profile
  - updateProfile() → PUT /api/auth/profile
  - logout() → elimina token

📄 **`lib/services/product_service.dart`** (137 líneas)
- 5 métodos:
  - getAllProducts() → GET /api/products
  - getProductById() → GET /api/products/:id
  - getFeaturedProducts() → GET /api/products/featured
  - searchProducts() → GET /api/products/search
  - getProductsByCategory() → GET /api/products/category/:c

📄 **`lib/services/cart_service.dart`** (205 líneas) ⭐ CRUD COMPLETO
- 6 métodos:
  - getCart() → GET (READ)
  - addToCart() → POST (CREATE)
  - updateCartItem() → PUT (UPDATE)
  - removeFromCart() → DELETE (DELETE)
  - clearCart() → POST /clear
  - syncCart() → POST /sync

📄 **`lib/services/order_service.dart`** (171 líneas)
- 5 métodos:
  - createOrder() → POST /api/orders
  - getOrderHistory() → GET /api/orders/user/:id
  - getOrderById() → GET /api/orders/:id
  - cancelOrder() → PUT /api/orders/:id/cancel
  - trackOrder() → GET /api/orders/:id/track

📄 **`lib/services/report_service.dart`** (158 líneas)
- 4 métodos:
  - getDashboard() → GET /api/reports/dashboard
  - getSalesReport() → GET /api/reports/sales
  - getProductsReport() → GET /api/reports/products
  - getCustomersReport() → GET /api/reports/customers

---

### Modelos con Serialización JSON

Cada modelo tiene:
- Archivo `.dart` con la clase
- Archivo `.g.dart` generado por build_runner
- Anotación `@JsonSerializable()`
- Métodos `fromJson()` y `toJson()`

📄 **`lib/models/user_api.dart`** + `.g.dart`
- UserApi: id, name, email, phone, address, role

📄 **`lib/models/product_api.dart`** + `.g.dart`
- ProductApi: id, name, description, price, stock, image
- CategoryApi, ReviewApi, NutritionApi

📄 **`lib/models/cart_api.dart`** + `.g.dart`
- CartApi: userId, items, subtotal, tax, total
- CartItemApi, CartToppingApi
- Requests: AddToCartRequest, UpdateCartItemRequest, SyncCartRequest

📄 **`lib/models/order_api.dart`** + `.g.dart`
- OrderApi: id, userId, items, total, status, createdAt
- OrderItemApi, ShippingAddressApi, PaymentMethodApi
- TrackingInfoApi

📄 **`lib/models/report_api.dart`** + `.g.dart`
- DashboardReportApi: totalSales, totalOrders, totalCustomers, avgOrderValue
- SalesReportApi, ProductReportApi, CustomerReportApi

📄 **`lib/models/api_response.dart`** + `.g.dart`
- ApiResponse<T>: success, message, data
- LoginResponse, RegisterResponse
- DataState pattern (sealed class)

---

### Configuración

📄 **`lib/config/api_config.dart`** (91 líneas)
- Base URL: http://localhost:3000/api
- Timeouts: connection, receive, send
- Todos los endpoints como constantes
- Paths organizados por categoría

📄 **`.env.example`** (95 líneas)
- Template de variables de ambiente
- API_BASE_URL
- JWT_SECRET
- JWT_EXPIRATION
- Test credentials
- Database options
- External services

---

### Providers (State Management)

📄 **`lib/providers/products_provider_api.dart`** (409 líneas) ⭐ EJEMPLO COMPLETO
- ProductsNotifier con API integration
- ProductsState con DataState pattern
- Métodos:
  - loadProducts()
  - filterByCategory()
  - search()
  - sortBy()
  - loadMore() (paginación)
  - refresh()

**Providers existentes que usan mock:**
- `lib/providers/auth_provider.dart` → Necesita conectarse a AuthService
- `lib/providers/products_provider.dart` → Puede ser reemplazado por products_provider_api.dart
- `lib/providers/cart_provider.dart` → Necesita conectarse a CartService

---

## 🎨 ARCHIVOS DE CONFIGURACIÓN

📄 **`pubspec.yaml`**
- Dependencies de Flutter
- Dio, FlutterSecureStorage, json_annotation, etc.

📄 **`analysis_options.yaml`**
- Reglas de linting

---

## 📱 PANTALLAS (UI)

Ubicadas en `lib/screens/`:
- `auth_screen.dart` - Login/Register
- `home_screen.dart` - Dashboard
- `products_screen.dart` - Catálogo
- `product_detail_screen.dart` - Detalle
- `cart_screen.dart` - Carrito
- `profile_screen.dart` - Perfil
- `reports_screen.dart` - Reportes

**Nota:** Actualmente usan providers con datos mock. Necesitan conectarse a providers con API.

---

## 📊 DATOS MOCK

Ubicados en `lib/data/`:
- `users_data.dart` - Usuarios de prueba
- `products_data.dart` - 140 productos
- `reports_data.dart` - Datos de reportes

**Nota:** El backend tiene sus propios datos mock en `backend/server.js`

---

## 🗂️ ESTRUCTURA COMPLETA DEL PROYECTO

```
crema/
│
├── 📄 README.md                         → Descripción general
├── 📄 GUIA_RAPIDA.md                    → Cómo ejecutar
├── 📄 CUMPLIMIENTO_FASE2.md             → Checklist 95%
├── 📄 COMO_PROBAR_API.md                → Testing endpoints
├── 📄 INTEGRACION_API.md                → Docs técnica
├── 📄 PASOS_PENDIENTES.md               → Qué falta (5%)
├── 📄 GUION_EXPOSICION.md               → Script presentación
├── 📄 ESTADO_FINAL.md                   → Resumen visual
├── 📄 .env.example                      → Config ambiente
├── 📄 run.ps1                           → Script ejecución
├── 📄 pubspec.yaml                      → Dependencies Flutter
├── 📄 analysis_options.yaml             → Linting rules
│
├── 📁 backend/
│   ├── server.js                        → 22 endpoints REST
│   ├── package.json                     → Dependencies Node
│   └── README.md                        → Guía backend
│
├── 📁 lib/
│   ├── main.dart                        → Entry point
│   │
│   ├── 📁 config/
│   │   └── api_config.dart              → URLs y endpoints
│   │
│   ├── 📁 services/
│   │   ├── api_service.dart             → Base HTTP (Dio)
│   │   ├── auth_service.dart            → 5 métodos auth
│   │   ├── product_service.dart         → 5 métodos products
│   │   ├── cart_service.dart            → 6 métodos CRUD
│   │   ├── order_service.dart           → 5 métodos orders
│   │   └── report_service.dart          → 4 métodos reports
│   │
│   ├── 📁 models/
│   │   ├── user_api.dart + .g.dart
│   │   ├── product_api.dart + .g.dart
│   │   ├── cart_api.dart + .g.dart
│   │   ├── order_api.dart + .g.dart
│   │   ├── report_api.dart + .g.dart
│   │   └── api_response.dart + .g.dart
│   │
│   ├── 📁 providers/
│   │   ├── auth_provider.dart           → Mock (actualizar)
│   │   ├── products_provider.dart       → Mock (actualizar)
│   │   ├── products_provider_api.dart   → ✅ API (usar este)
│   │   ├── cart_provider.dart           → Mock (actualizar)
│   │   └── reports_provider.dart        → Mock (actualizar)
│   │
│   ├── 📁 screens/
│   │   ├── auth_screen.dart
│   │   ├── home_screen.dart
│   │   ├── products_screen.dart
│   │   ├── product_detail_screen.dart
│   │   ├── cart_screen.dart
│   │   ├── profile_screen.dart
│   │   └── reports_screen.dart
│   │
│   └── 📁 data/
│       ├── users_data.dart              → Mock users
│       ├── products_data.dart           → Mock products
│       └── reports_data.dart            → Mock reports
│
└── 📁 assets/
    └── images/
```

---

## 🎯 FLUJOS DE TRABAJO RECOMENDADOS

### 🚀 "Solo quiero ejecutar el proyecto"
1. Leer: `GUIA_RAPIDA.md`
2. Ejecutar: `run.ps1`
3. Listo ✅

### 📚 "Necesito entender cómo funciona la API"
1. Leer: `INTEGRACION_API.md` (explicación técnica)
2. Leer: `lib/services/api_service.dart` (código base)
3. Leer: `lib/services/cart_service.dart` (ejemplo CRUD)
4. Leer: `backend/server.js` (ver endpoints)

### 🧪 "Quiero probar que funciona"
1. Ejecutar backend: `node backend/server.js`
2. Leer: `COMO_PROBAR_API.md`
3. Probar con curl/Postman según guía

### 🎓 "Tengo que exponer mañana"
1. Leer: `GUION_EXPOSICION.md` (script completo)
2. Leer: `ESTADO_FINAL.md` (métricas y resumen)
3. Practicar el flujo 2-3 veces
4. Verificar checklist pre-presentación

### 🔨 "Quiero completar el 5% que falta"
1. Leer: `PASOS_PENDIENTES.md`
2. Seguir plan de acción recomendado
3. Empezar por AuthProvider
4. Continuar con ProductsProvider
5. Terminar con CartProvider y pantallas

### 📊 "Quiero saber qué he logrado"
1. Leer: `CUMPLIMIENTO_FASE2.md` (checklist detallado)
2. Leer: `ESTADO_FINAL.md` (métricas y logros)

---

## 💡 ARCHIVOS CLAVE POR CATEGORÍA

### Documentación General
- `README.md` - Inicio
- `ESTADO_FINAL.md` - Resumen completo

### Ejecución
- `run.ps1` - Script automático
- `GUIA_RAPIDA.md` - Manual paso a paso

### Aprendizaje
- `INTEGRACION_API.md` - Docs técnica completa
- `COMO_PROBAR_API.md` - Testing práctico

### Seguimiento
- `CUMPLIMIENTO_FASE2.md` - Qué está hecho
- `PASOS_PENDIENTES.md` - Qué falta

### Presentación
- `GUION_EXPOSICION.md` - Script 5-7 min
- `ESTADO_FINAL.md` - Métricas visuales

### Código Backend
- `backend/server.js` - Todos los endpoints

### Código Services
- `lib/services/api_service.dart` - Base
- `lib/services/cart_service.dart` - CRUD completo

### Código Models
- `lib/models/cart_api.dart` - Ejemplo serialización
- `lib/models/api_response.dart` - DataState pattern

### Configuración
- `lib/config/api_config.dart` - URLs y endpoints
- `.env.example` - Variables de ambiente

---

## 🔍 BÚSQUEDAS RÁPIDAS

### "¿Dónde está el código de login?"
- Backend: `backend/server.js` líneas 57-110
- Service: `lib/services/auth_service.dart` líneas 20-60
- Provider: `lib/providers/auth_provider.dart` líneas 20-50
- Screen: `lib/screens/auth_screen.dart`

### "¿Dónde está el CRUD del carrito?"
- Backend: `backend/server.js` líneas 237-331
- Service: `lib/services/cart_service.dart` (completo)
- Provider: `lib/providers/cart_provider.dart`
- Screen: `lib/screens/cart_screen.dart`

### "¿Dónde están los interceptores de Dio?"
- `lib/services/api_service.dart` líneas 38-72

### "¿Dónde se genera el JWT?"
- `backend/server.js` líneas 85-95

### "¿Dónde se definen los modelos?"
- `lib/models/` (todos los archivos .dart)

### "¿Dónde está la lista de endpoints?"
- `lib/config/api_config.dart`
- `backend/server.js` (console.log al inicio)
- `COMO_PROBAR_API.md`

---

## ✅ CHECKLIST RÁPIDO

### Para ejecutar:
- [ ] Leer `GUIA_RAPIDA.md` O ejecutar `run.ps1`
- [ ] Backend corriendo en localhost:3000
- [ ] Flutter corriendo en Chrome

### Para entender:
- [ ] Leer `INTEGRACION_API.md`
- [ ] Revisar `lib/services/cart_service.dart`
- [ ] Revisar `backend/server.js`

### Para probar:
- [ ] Leer `COMO_PROBAR_API.md`
- [ ] Probar login con curl
- [ ] Probar endpoint de productos

### Para exponer:
- [ ] Leer `GUION_EXPOSICION.md`
- [ ] Revisar `ESTADO_FINAL.md`
- [ ] Practicar flujo de demo

### Para completar:
- [ ] Leer `PASOS_PENDIENTES.md`
- [ ] Conectar AuthProvider
- [ ] Conectar ProductsProvider
- [ ] Actualizar screens

---

## 📞 AYUDA ADICIONAL

Si no encuentras algo:

1. **Busca en archivos:**
   - Usa Ctrl+P en VSCode
   - Escribe el nombre del archivo

2. **Busca en código:**
   - Usa Ctrl+Shift+F en VSCode
   - Busca palabras clave

3. **Busca en documentación:**
   - Todos los `.md` están indexados
   - Usa Ctrl+F dentro del archivo

4. **Revisa estructura:**
   - Este archivo (`INDICE_ARCHIVOS.md`)
   - `README.md` tabla de contenidos

---

```
╔═══════════════════════════════════════════════════════════╗
║  Este índice te ayuda a navegar los 35+ archivos         ║
║  del proyecto Cremosos Fase 2.                           ║
║                                                           ║
║  ¿Perdido? Vuelve aquí para orientarte.                  ║
╚═══════════════════════════════════════════════════════════╝
```

**Última actualización:** Diciembre 2024
