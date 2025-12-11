# 🔌 06_SERVICIOS

## Descripción
Esta carpeta contiene los servicios que se comunican con el backend API REST.

## Contenido

### `api_service.dart`
Servicio base para peticiones HTTP
- GET, POST, PUT, DELETE
- Manejo de headers y autenticación
- Manejo de errores de red

### Servicios Específicos
- `auth_service.dart` - Login, registro, validación de tokens
- `product_service.dart` - CRUD de productos
- `cart_service.dart` - Gestión del carrito
- `order_service.dart` - Creación y consulta de órdenes
- `sales_service.dart` - Registro de ventas
- `purchases_service.dart` - Gestión de compras
- `suppliers_service.dart` - Gestión de proveedores
- `users_service.dart` - Gestión de usuarios
- `roles_service.dart` - Gestión de roles y permisos
- `report_service.dart` - Generación de reportes

## Arquitectura
Los servicios son la capa de comunicación entre la app Flutter y el backend Node.js/SQL Server.

```
Flutter App (Provider) 
    ↓
Servicio (HTTP Request)
    ↓
Backend API (Express.js)
    ↓
SQL Server (CremososDB)
```

## Uso
```dart
import 'package:crema/06_servicios/product_service.dart';

final products = await ProductService.getProducts();
```

## Características
- Async/Await para operaciones asíncronas
- Serialización automática JSON ↔ Dart
- Manejo de errores y timeouts
- Caché local (futuro)
