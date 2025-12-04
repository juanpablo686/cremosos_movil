## 🧪 GUÍA DE PRUEBAS - API REST Cremosos

### ✅ SERVIDOR FUNCIONANDO
- **URL Base:** http://localhost:3000
- **Usuario test:** admin@cremosos.com / 123456
- **Total Endpoints:** 22

---

## 📋 CÓMO PROBAR LOS ENDPOINTS

### Opción 1: Desde tu App Flutter ✨ (RECOMENDADO)

**Tu app Flutter ya está lista** - solo necesitas:

1. ✅ Servidor corriendo (ya está ✓)
2. ✅ Flutter corriendo en Chrome (ya está ✓)
3. Usar la app normalmente - los endpoints se llamarán automáticamente

---

### Opción 2: Desde Postman 📮

1. **Descargar Postman:** https://www.postman.com/downloads/

2. **Probar Login:**
   - URL: `POST http://localhost:3000/api/auth/login`
   - Body (JSON):
     ```json
     {
       "email": "admin@cremosos.com",
       "password": "123456"
     }
     ```
   - Respuesta: Te dará un **token JWT**

3. **Ver Productos:**
   - URL: `GET http://localhost:3000/api/products`
   - Sin autenticación necesaria

4. **Ver Carrito (con autenticación):**
   - URL: `GET http://localhost:3000/api/cart`
   - Headers: `Authorization: Bearer TU_TOKEN_AQUI`

---

### Opción 3: Desde el Navegador 🌐

Abre estas URLs directamente:

- **Ver Productos:** http://localhost:3000/api/products
- **Productos Destacados:** http://localhost:3000/api/products/featured
- **Producto por ID:** http://localhost:3000/api/products/prod1

---

### Opción 4: Desde PowerShell 💻

```powershell
# 1. LOGIN - Obtener token
$response = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/login" `
  -Method Post `
  -ContentType "application/json" `
  -Body '{"email":"admin@cremosos.com","password":"123456"}'

$token = $response.data.token
Write-Host "Token: $token"

# 2. VER PRODUCTOS
Invoke-RestMethod -Uri "http://localhost:3000/api/products"

# 3. VER CARRITO (con token)
Invoke-RestMethod -Uri "http://localhost:3000/api/cart" `
  -Headers @{Authorization="Bearer $token"}
```

---

## 🎯 ENDPOINTS PARA DEMOSTRAR EN EXPOSICIÓN

### 1. AUTENTICACIÓN (JWT)
```
POST /api/auth/login
→ Retorna token JWT para las demás peticiones
→ EXPLICAR: Seguridad con tokens encriptados
```

### 2. CRUD COMPLETO (Carrito)
```
GET    /api/cart           → READ (Leer)
POST   /api/cart/items     → CREATE (Crear)
PUT    /api/cart/items/:id → UPDATE (Actualizar)
DELETE /api/cart/items/:id → DELETE (Eliminar)
```

### 3. PAGINACIÓN Y FILTROS
```
GET /api/products?category=arroz_con_leche&page=1&limit=20
→ EXPLICAR: Query parameters para filtrado
```

### 4. REPORTES Y ANALYTICS
```
GET /api/reports/dashboard
→ EXPLICAR: Datos para gráficos y KPIs
```

---

## 🔍 VERIFICAR QUE TODO FUNCIONA

### Test Rápido desde PowerShell:

```powershell
# Verificar que el servidor responde
Invoke-RestMethod http://localhost:3000/api/products

# Si ves productos en JSON → ✅ TODO FUNCIONA
```

---

## 📱 EN TU APP FLUTTER

### Los servicios ya están configurados:

```dart
// lib/services/product_service.dart
final products = await productService.getAllProducts();
// ↑ Esto llamará a: GET http://localhost:3000/api/products

// lib/services/auth_service.dart  
await authService.login('admin@cremosos.com', '123456');
// ↑ Esto llamará a: POST http://localhost:3000/api/auth/login
```

### Ver logs en la consola de Flutter:

Cuando uses la app, verás en la consola:
```
→ POST /api/auth/login
← 200 OK
→ GET /api/products
← 200 OK
```

Gracias al `PrettyDioLogger` configurado en `ApiService`.

---

## 🎓 PUNTOS CLAVE PARA LA EXPOSICIÓN

1. **22 Endpoints** implementados (supera el mínimo de 10)
2. **JWT Authentication** con tokens seguros
3. **CRUD Completo** demostrado en carrito
4. **Métodos HTTP**: GET, POST, PUT, DELETE
5. **Códigos de estado**: 200, 201, 400, 401, 404
6. **Serialización JSON** automática con json_serializable
7. **Arquitectura 3 capas**: UI → Providers → Services → API
8. **Manejo de errores** centralizado
9. **Paginación** del lado servidor
10. **Interceptores** para inyección automática de tokens

---

## 🚀 ¡TODO LISTO!

✅ Servidor API corriendo en http://localhost:3000  
✅ Flutter app corriendo en Chrome  
✅ 22 endpoints funcionando  
✅ Datos mock para pruebas  
✅ Documentación completa  

**Ahora puedes usar tu app y todos los endpoints funcionarán correctamente!** 🎉
