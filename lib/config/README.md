# 📋 01_CONFIGURACION

## Descripción
Esta carpeta contiene todos los archivos de configuración de la aplicación Flutter.

## Contenido

### `api_config.dart`
Configuración de URLs y endpoints del API REST
- URL base del servidor backend
- Endpoints para productos, usuarios, carrito, órdenes
- Configuración de timeouts y headers

### `toppings.dart`
Configuración de toppings disponibles para productos
- Lista de ingredientes adicionales
- Precios de cada topping
- Iconos y descripciones

## Uso
Los archivos de esta carpeta son importados por services y providers para conectarse al backend.

## Ejemplo
```dart
import 'package:crema/01_configuracion/api_config.dart';

final url = ApiConfig.baseUrl;
```
