# API REST - Cremosos E-Commerce

Backend simple con Express.js para probar la integración API del proyecto Flutter.

## 📦 Instalación

```bash
cd backend
npm install
```

## 🚀 Ejecutar el Servidor

```bash
npm start
```

El servidor estará disponible en: **http://localhost:3000**

## 🔐 Credenciales de Prueba

- **Email:** admin@cremosos.com
- **Password:** 123456

## 📡 Probar los Endpoints

### 1. Login (obtener token)
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"admin@cremosos.com\",\"password\":\"123456\"}"
```

### 2. Ver Productos
```bash
curl http://localhost:3000/api/products
```

### 3. Ver Carrito (requiere token)
```bash
curl http://localhost:3000/api/cart \
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

## 📊 22 Endpoints Implementados

✅ **Auth (4):** login, register, profile, update profile  
✅ **Products (5):** list, detail, featured, search, by category  
✅ **Cart (6):** get, create item, update item, delete item, clear, sync  
✅ **Orders (5):** create, list, detail, cancel, track  
✅ **Reports (4):** dashboard, sales, products, customers  

## 🔧 Conectar con Flutter

1. Asegúrate que el servidor esté corriendo en **localhost:3000**
2. En tu app Flutter, los servicios ya están configurados para usar esta URL
3. Ejecuta tu app Flutter: `flutter run -d chrome`
4. Prueba el login con las credenciales de arriba

¡Listo! Ahora puedes probar toda la integración API. 🚀
