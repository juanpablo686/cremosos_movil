# 📦 02_MODELOS

## Descripción
Esta carpeta contiene todas las clases de modelo (entidades) que representan los datos de la aplicación.

## Contenido

### Modelos Principales
- `product.dart` - Modelo de Producto (id, name, price, image, stock, etc.)
- `cart.dart` - Modelo de Carrito de compras
- `user.dart` - Modelo de Usuario (email, password, role, address)
- `reports.dart` - Modelos de reportes y estadísticas

### Modelos API (con serialización JSON)
- `product_api.dart` - Producto con fromJson/toJson
- `cart_api.dart` - Carrito con serialización
- `order_api.dart` - Orden con serialización
- `report_api.dart` - Reportes con serialización
- `api_response.dart` - Respuesta genérica del API

### Modelos de Negocio
- `sale.dart` - Modelo de Venta
- `purchase.dart` - Modelo de Compra
- `role.dart` - Modelo de Rol de usuario

### Archivos Generados
- `*.g.dart` - Archivos generados automáticamente por json_serializable

## Uso
Los modelos son usados por providers, services y pantallas para estructurar los datos.

## Ejemplo
```dart
import 'package:crema/02_modelos/product.dart';

final product = Product(
  id: 'prod1',
  name: 'Arroz con Leche',
  price: 8000,
);
```
