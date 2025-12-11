# 🍨 CREMOSOS - E-COMMERCE

Sistema de gestión y ventas de postres cremosos desarrollado con Flutter y Node.js/SQL Server.

---

## 📁 ESTRUCTURA DEL PROYECTO

### 🎨 FRONTEND (Flutter)

```
lib/
├── main.dart                      # Punto de entrada de la aplicación
├── 01_configuracion/              # ⚙️ Configuración general
│   ├── api_config.dart           # URLs y endpoints del API
│   └── toppings.dart             # Configuración de toppings
│
├── 02_modelos/                    # 📦 Modelos de datos
│   ├── product.dart              # Modelo de Producto
│   ├── cart.dart                 # Modelo de Carrito
│   ├── user.dart                 # Modelo de Usuario
│   ├── reports.dart              # Modelos de Reportes
│   ├── sale.dart                 # Modelo de Venta
│   ├── purchase.dart             # Modelo de Compra
│   ├── role.dart                 # Modelo de Rol
│   └── *_api.dart                # Modelos con serialización JSON
│
├── 03_proveedores/                # 🔄 State Management (Riverpod)
│   ├── auth_provider.dart        # Provider de Autenticación
│   ├── products_provider.dart    # Provider de Productos
│   ├── cart_provider.dart        # Provider de Carrito
│   └── reports_provider.dart     # Provider de Reportes
│
├── 04_pantallas/                  # 📱 Pantallas de la App
│   ├── auth_screen.dart          # Login/Registro
│   ├── home_screen.dart          # Dashboard con estadísticas
│   ├── products_screen.dart      # Catálogo de productos
│   ├── product_detail_screen.dart # Detalle de producto
│   ├── cart_screen.dart          # Carrito de compras
│   ├── profile_screen.dart       # Perfil del usuario
│   ├── admin_menu_screen.dart    # Menú de administración
│   └── reports_screen.dart       # Reportes y gráficas
│
├── 05_widgets/                    # 🧩 Widgets Reutilizables
│   └── app_drawer.dart           # Menú hamburguesa lateral
│
├── 06_servicios/                  # 🔌 Servicios API REST
│   ├── api_service.dart          # Servicio base HTTP
│   ├── auth_service.dart         # Autenticación
│   ├── product_service.dart      # CRUD Productos
│   ├── cart_service.dart         # Gestión de Carrito
│   ├── order_service.dart        # Órdenes
│   ├── sales_service.dart        # Ventas
│   ├── purchases_service.dart    # Compras
│   ├── suppliers_service.dart    # Proveedores
│   ├── users_service.dart        # Usuarios
│   ├── roles_service.dart        # Roles
│   └── report_service.dart       # Reportes
│
└── 07_datos/                      # 💾 Datos de prueba (mock data)
    ├── products_data.dart        # Productos de ejemplo
    ├── users_data.dart           # Usuarios de ejemplo
    └── reports_data.dart         # Reportes de ejemplo
```

### 🖥️ BACKEND (Node.js + Express + SQL Server)

```
backend/
├── server.js                      # Servidor Express principal
├── package.json                   # Dependencias npm
├── init-db.bat                    # Script para inicializar DB
│
├── 01_configuracion/              # ⚙️ Configuración
│   ├── .env                      # Variables de entorno (credenciales)
│   └── database.js               # Conexión a SQL Server
│
├── 02_base_datos/                 # 🗄️ Scripts SQL
│   ├── init-database.sql         # Crear esquema (12 tablas)
│   ├── seed-data.sql             # Datos iniciales
│   └── init-db.js                # Script Node.js (legacy)
│
├── 03_modelos/                    # 📦 Modelos (pendiente ORM)
├── 04_controladores/              # 🎮 Controladores (pendiente)
├── 05_rutas/                      # 🛣️ Rutas API (pendiente)
└── 06_middleware/                 # 🛡️ Middleware (pendiente)
```

---

## 🗄️ BASE DE DATOS SQL SERVER

### Servidor
- **Instancia**: `JUANPABLO\SQLEXPRESS`
- **Base de datos**: `CremososDB`
- **Autenticación**: Windows Authentication

### Tablas (12 tablas)
1. **Roles** - Roles de usuario (admin, customer)
2. **Users** - Usuarios del sistema
3. **Categories** - Categorías de productos
4. **Products** - Productos disponibles
5. **Suppliers** - Proveedores
6. **Purchases** - Compras a proveedores
7. **PurchaseItems** - Detalle de compras
8. **Sales** - Ventas realizadas
9. **SaleItems** - Detalle de ventas
10. **Orders** - Órdenes de clientes
11. **OrderItems** - Detalle de órdenes
12. **Cart** - Carrito de compras

### Estado Actual
✅ Base de datos creada
✅ Todas las tablas creadas
✅ Datos poblados:
   - 3 usuarios
   - 6 categorías
   - 80 productos
   - 3 proveedores

---

## 🚀 CÓMO EJECUTAR EL PROYECTO

### 1️⃣ Backend (Node.js)

```powershell
# Navegar a carpeta backend
cd backend

# Instalar dependencias (primera vez)
npm install

# Inicializar base de datos (primera vez)
sqlcmd -S "JUANPABLO\SQLEXPRESS" -E -i "02_base_datos\init-database.sql"

# Poblar con datos (primera vez)
sqlcmd -S "JUANPABLO\SQLEXPRESS" -E -d "CremososDB" -i "02_base_datos\seed-data.sql"

# Ejecutar servidor
npm start
```

El servidor estará corriendo en `http://localhost:3000`

### 2️⃣ Frontend (Flutter)

```powershell
# Navegar a carpeta raíz
cd ..

# Instalar dependencias (primera vez)
flutter pub get

# Ejecutar en Chrome
flutter run -d chrome
```

---

## 🔑 USUARIOS DE PRUEBA

| Email | Password | Rol |
|-------|----------|-----|
| admin@cremosos.com | 123456 | admin |
| maria.garcia@email.com | 123456 | customer |
| carlos.lopez@email.com | 123456 | customer |

---

## 🛠️ TECNOLOGÍAS UTILIZADAS

### Frontend
- **Flutter** - Framework de UI multiplataforma
- **Riverpod** - State management reactivo
- **Material 3** - Diseño moderno
- **Google Fonts** - Tipografía personalizada
- **HTTP** - Peticiones al backend

### Backend
- **Node.js** - Runtime de JavaScript
- **Express.js** - Framework web
- **SQL Server** - Base de datos relacional
- **mssql** - Driver de SQL Server para Node.js
- **dotenv** - Variables de entorno
- **bcryptjs** - Encriptación de contraseñas
- **jsonwebtoken** - Autenticación JWT

---

## 📊 VER DATOS EN SQL SERVER

### Opción 1: SQL Server Management Studio (SSMS)
1. Abrir SSMS
2. Conectar a: `JUANPABLO\SQLEXPRESS`
3. Expandir: Databases → CremososDB → Tables
4. Clic derecho en tabla → Select Top 1000 Rows

### Opción 2: Azure Data Studio
1. Abrir Azure Data Studio
2. Nueva conexión: `JUANPABLO\SQLEXPRESS`
3. Explorar CremososDB

### Opción 3: VS Code + SQL Server Extension
1. Instalar extensión: SQL Server (mssql)
2. Conectar a: `JUANPABLO\SQLEXPRESS`
3. Ejecutar queries

---

## 📝 CONSULTAS SQL ÚTILES

```sql
-- Ver todos los productos
SELECT * FROM Products;

-- Ver productos por categoría
SELECT * FROM Products WHERE category = 'arroz_con_leche';

-- Ver usuarios
SELECT id, email, name, role FROM Users;

-- Ver productos con bajo stock
SELECT name, stock FROM Products WHERE stock < 20;

-- Ver categorías con cantidad de productos
SELECT category, COUNT(*) as total
FROM Products
GROUP BY category;
```

---

## 🎯 FUNCIONALIDADES IMPLEMENTADAS

### ✅ Completadas
- [x] Sistema de autenticación (Login/Registro)
- [x] Dashboard con estadísticas
- [x] Catálogo de productos con categorías
- [x] Carrito de compras
- [x] Menú hamburguesa con navegación
- [x] Base de datos SQL Server
- [x] 80 productos de ejemplo
- [x] Sistema de roles (admin/customer)

### ⏳ Pendientes
- [ ] Migrar endpoints a SQL Server (actualmente usan mock data)
- [ ] Sistema de órdenes real
- [ ] Sistema de ventas (POS)
- [ ] Gestión de compras
- [ ] Gestión de proveedores
- [ ] Reportes con gráficas
- [ ] Autenticación JWT completa
- [ ] Validaciones de permisos por rol

---

## 📚 DOCUMENTACIÓN ADICIONAL

Cada carpeta tiene su propio **README.md** explicando su contenido:

- `lib/01_configuracion/README.md`
- `lib/02_modelos/README.md`
- `lib/03_proveedores/README.md`
- `lib/04_pantallas/README.md`
- `lib/05_widgets/README.md`
- `lib/06_servicios/README.md`
- `lib/07_datos/README.md`
- `backend/01_configuracion/README.md`
- `backend/02_base_datos/README.md`
- `backend/03_modelos/README.md`
- `backend/04_controladores/README.md`
- `backend/05_rutas/README.md`
- `backend/06_middleware/README.md`

---

## 👥 EQUIPO

Desarrollado para el proyecto de grado - Sistema de ventas Cremosos

---

## 📄 LICENCIA

Este proyecto es privado y está destinado únicamente para fines educativos.
