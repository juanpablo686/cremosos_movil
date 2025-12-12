# 🗂️ ESTRUCTURA DEL PROYECTO CREMOSOS E-COMMERCE

## 📊 BASE DE DATOS: SQL SERVER

### Conexión
- **Servidor**: `JUANPABLO\SQLEXPRESS`
- **Base de datos**: `CremososDB`
- **Autenticación**: Windows Authentication
- **Puerto**: Por defecto (1433)

### 🔧 Cómo Ver la Base de Datos

#### Opción 1: SQL Server Management Studio (SSMS)
1. Abre **SQL Server Management Studio**
2. Conecta con:
   - Server name: `JUANPABLO\SQLEXPRESS`
   - Authentication: `Windows Authentication`
3. En Object Explorer, expande:
   ```
   Databases → CremososDB → Tables
   ```
4. Click derecho en cualquier tabla → "Select Top 1000 Rows"

#### Opción 2: Visual Studio Code
1. Instala extensión: **SQL Server (mssql)**
2. Ctrl+Shift+P → "MS SQL: Connect"
3. Ingresa: `JUANPABLO\SQLEXPRESS`
4. Selecciona: `CremososDB`

#### Opción 3: Azure Data Studio
1. Descarga **Azure Data Studio** (gratis)
2. New Connection → `JUANPABLO\SQLEXPRESS`
3. Navigate a `CremososDB`

### 📋 Tablas Creadas

| Tabla | Descripción | Registros |
|-------|-------------|-----------|
| `Users` | Usuarios del sistema | 3 usuarios (1 admin, 2 clientes) |
| `Products` | Catálogo de productos | 80 productos con imágenes |
| `Categories` | Categorías de productos | 6 categorías |
| `Suppliers` | Proveedores | 3 proveedores |
| `Orders` | Pedidos de clientes | Vacía (se llena al hacer pedidos) |
| `OrderItems` | Items de pedidos | Vacía |
| `Sales` | Ventas en POS | Vacía |
| `SaleItems` | Items de ventas | Vacía |
| `Purchases` | Compras a proveedores | Vacía |
| `PurchaseItems` | Items de compras | Vacía |
| `Cart` | Carritos de compra | Vacía |
| `Roles` | Roles y permisos | Vacía |

### 🚀 Inicializar Base de Datos

```powershell
# 1. Instalar dependencias
cd backend
npm install

# 2. Crear tablas
npm run init-db

# 3. Poblar con datos iniciales
npm run seed

# 4. Iniciar servidor
npm start
```

### 📁 ESTRUCTURA DEL BACKEND

```
backend/
├── config/
│   └── database.js          # Configuración de SQL Server
├── database/
│   ├── init-database.sql    # Script SQL de creación de tablas
│   ├── init-db.js          # Script JS para ejecutar SQL
│   └── seed.js             # Poblar datos iniciales
├── .env                     # Variables de entorno
├── server.js               # Servidor Express (API REST)
├── package.json            # Dependencias Node.js
└── README.md              # Esta documentación
```

### 🔍 Queries Útiles SQL

```sql
-- Ver todos los usuarios
SELECT * FROM Users;

-- Ver productos por categoría
SELECT * FROM Products WHERE category = 'arroz_con_leche';

-- Ver productos con stock bajo
SELECT name, stock FROM Products WHERE stock < 20 ORDER BY stock;

-- Ver ventas del día
SELECT * FROM Sales WHERE CAST(created_at AS DATE) = CAST(GETDATE() AS DATE);

-- Total de ventas
SELECT SUM(total) as total_ventas FROM Sales;

-- Productos más vendidos
SELECT 
    p.name,
    SUM(si.quantity) as total_vendido,
    SUM(si.subtotal) as total_ingresos
FROM SaleItems si
JOIN Products p ON si.product_id = p.id
GROUP BY p.name
ORDER BY total_vendido DESC;
```

---

## 📱 ESTRUCTURA DEL FRONTEND (FLUTTER)

```
lib/
├── 📂 screens/              # Pantallas de la aplicación
│   ├── home_screen.dart          # 🏠 Dashboard principal
│   ├── auth_screen.dart          # 🔐 Login y registro
│   ├── products_screen.dart      # 🛍️ Catálogo de productos
│   ├── product_detail_screen.dart # 📦 Detalle del producto
│   ├── cart_screen.dart          # 🛒 Carrito de compras
│   ├── profile_screen.dart       # 👤 Perfil de usuario
│   ├── reports_screen.dart       # 📊 Reportes (Admin)
│   │
│   ├── 📂 admin/            # Pantallas de administración
│   │   ├── users_management_screen.dart       # 👥 Gestión de usuarios
│   │   ├── roles_management_screen.dart       # 🔒 Roles y permisos
│   │   ├── products_management_screen.dart    # 📦 CRUD productos
│   │   ├── suppliers_management_screen.dart   # 🚚 Proveedores
│   │   ├── purchases_management_screen.dart   # 📥 Compras
│   │   └── sales_management_screen.dart       # 💰 Ventas
│   │
│   └── 📂 pos/              # Punto de Venta
│       └── pos_screen.dart           # 🏪 Sistema POS
│
├── 📂 models/               # Modelos de datos
│   ├── user.dart                # Usuario
│   ├── product.dart             # Producto
│   ├── cart.dart                # Carrito y órdenes
│   ├── purchase.dart            # Compra
│   ├── sale.dart                # Venta
│   ├── supplier.dart            # Proveedor
│   ├── role.dart                # Rol
│   └── reports.dart             # Reportes
│
├── 📂 providers/            # Gestión de estado (Riverpod)
│   ├── auth_provider.dart       # Autenticación
│   ├── products_provider.dart   # Productos
│   ├── cart_provider.dart       # Carrito
│   └── reports_provider.dart    # Reportes
│
├── 📂 services/             # Servicios API (HTTP)
│   ├── auth_service.dart        # Login, registro
│   ├── product_service.dart     # CRUD productos
│   ├── cart_service.dart        # Gestión carrito
│   ├── order_service.dart       # Pedidos
│   ├── users_service.dart       # Usuarios
│   ├── roles_service.dart       # Roles
│   ├── suppliers_service.dart   # Proveedores
│   ├── purchases_service.dart   # Compras
│   ├── sales_service.dart       # Ventas
│   └── report_service.dart      # Reportes
│
├── 📂 widgets/              # Componentes reutilizables
│   └── app_drawer.dart          # 🍔 Menú hamburguesa
│
├── 📂 data/                 # Datos mock (fallback)
│   ├── products_data.dart       # Productos mock
│   ├── users_data.dart          # Usuarios mock
│   └── reports_data.dart        # Reportes mock
│
└── main.dart                # 🚀 Punto de entrada
```

### 🎯 Navegación de la Aplicación

```
┌─────────────────────────────────────────┐
│          MENÚ HAMBURGUESA               │
├─────────────────────────────────────────┤
│  🏠 Dashboard                           │
│  ────────────────────                   │
│  VENTAS:                                │
│  🛍️ Productos                           │
│  🛒 Carrito                             │
│  ────────────────────                   │
│  ADMINISTRACIÓN (Solo Admin):           │
│  👥 Usuarios                            │
│  🔒 Roles y Permisos                    │
│  📦 Gestión de Productos                │
│  🚚 Proveedores                         │
│  📥 Compras                             │
│  💰 Ventas                              │
│  🏪 Punto de Venta (POS)                │
│  📊 Reportes                            │
│  ────────────────────                   │
│  CUENTA:                                │
│  👤 Mi Perfil                           │
│  🚪 Cerrar Sesión                       │
└─────────────────────────────────────────┘
```

---

## 🔄 FLUJO DE DATOS (Backend ↔️ Frontend)

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   Flutter    │  HTTP   │   Express    │  mssql  │  SQL Server  │
│   (Client)   │ ←────→  │   (Server)   │ ←────→  │  (Database)  │
└──────────────┘         └──────────────┘         └──────────────┘
     Screens           REST API Endpoints        CremososDB
        ↓                      ↓                       ↓
    Providers            Controllers              Tables
        ↓                      ↓                       ↓
    Services              Routes                  Queries
```

### 🔐 Credenciales de Prueba

| Email | Contraseña | Rol | Acceso |
|-------|-----------|-----|--------|
| `admin@cremosos.com` | `123456` | Admin | ✅ Todas las funciones |
| `maria.garcia@email.com` | `123456` | Customer | ❌ Solo compras |
| `carlos.lopez@email.com` | `123456` | Customer | ❌ Solo compras |

---

## 📊 Verificación en Tiempo Real

### Cómo ver cambios en la BD en tiempo real:

1. **Abrir SSMS** y conectar a `JUANPABLO\SQLEXPRESS`

2. **Ejecutar query de monitoreo**:
```sql
-- Ver últimos pedidos (se actualiza al crear pedidos)
SELECT TOP 10 * FROM Orders ORDER BY created_at DESC;

-- Ver productos agregados al carrito
SELECT 
    u.name as usuario,
    p.name as producto,
    c.quantity as cantidad,
    c.created_at as agregado
FROM Cart c
JOIN Users u ON c.user_id = u.id
JOIN Products p ON c.product_id = p.id
ORDER BY c.created_at DESC;

-- Ver ventas en tiempo real
SELECT 
    s.id,
    s.customer_name,
    s.total,
    s.payment_method,
    s.created_at
FROM Sales s
ORDER BY s.created_at DESC;
```

3. **Presiona F5** para refrescar después de hacer acciones en la app

---

## 🚀 Comandos Rápidos

```powershell
# Backend
cd backend
npm install              # Instalar dependencias
npm run init-db         # Crear tablas
npm run seed            # Poblar datos
npm start               # Iniciar servidor (puerto 3000)

# Frontend
cd ..
flutter pub get         # Instalar dependencias
flutter run -d chrome   # Ejecutar en Chrome
```

---

## 📞 Soporte

Si tienes problemas de conexión a SQL Server:

1. Verifica que SQL Server esté corriendo:
   ```powershell
   Get-Service -Name "MSSQL$SQLEXPRESS"
   ```

2. Si no está corriendo:
   ```powershell
   Start-Service -Name "MSSQL$SQLEXPRESS"
   ```

3. Verifica la conexión en el código:
   - Archivo: `backend/config/database.js`
   - Server debe ser: `JUANPABLO\\SQLEXPRESS`
