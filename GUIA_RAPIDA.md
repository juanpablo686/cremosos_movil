# 🎯 GUÍA RÁPIDA DE EJECUCIÓN

## ⚡ OPCIÓN 1: EJECUCIÓN AUTOMÁTICA (RECOMENDADO)

### Windows PowerShell
```powershell
# Ejecutar el script automático
powershell -ExecutionPolicy Bypass -File run.ps1
```

El script hará automáticamente:
1. ✅ Verificar que Node.js y Flutter estén instalados
2. ✅ Instalar dependencias si es necesario
3. ✅ Iniciar el servidor backend en una terminal nueva
4. ✅ Esperar 5 segundos para que el servidor esté listo
5. ✅ Preguntarte en qué plataforma ejecutar (Chrome/Edge/Windows)
6. ✅ Iniciar la aplicación Flutter

---

## 🔧 OPCIÓN 2: EJECUCIÓN MANUAL

### Paso 1: Iniciar Backend
```bash
# Terminal 1
cd backend
node server.js
```

Deberías ver:
```
╔════════════════════════════════════════════════════════╗
║     🍚 CREMOSOS API SERVER - RUNNING                   ║
╚════════════════════════════════════════════════════════╝

📡 URL: http://localhost:3000
📊 Endpoints: 22 disponibles
👤 Usuario test: admin@cremosos.com / 123456
```

### Paso 2: Iniciar Flutter
```bash
# Terminal 2 (nueva terminal)
# Opción A: Web Chrome
flutter run -d chrome

# Opción B: Web Edge
flutter run -d edge

# Opción C: Windows (requiere Visual Studio)
flutter run -d windows
```

---

## 🧪 VERIFICAR QUE TODO FUNCIONA

### Test 1: Servidor Backend Responde
```powershell
curl http://localhost:3000/api/products
```

✅ Si ves JSON con productos → Servidor funcionando

### Test 2: Login desde PowerShell
```powershell
curl -X POST http://localhost:3000/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{"email":"admin@cremosos.com","password":"123456"}'
```

✅ Si recibes un token → Autenticación funcionando

---

## 🔐 CREDENCIALES DE PRUEBA

| Campo | Valor |
|-------|-------|
| **Email** | admin@cremosos.com |
| **Password** | 123456 |

---

## 📡 ENDPOINTS DISPONIBLES

### Ver en el Navegador
- http://localhost:3000/api/products
- http://localhost:3000/api/products/featured
- http://localhost:3000/api/products/prod1

### Probar con Postman
1. Importar colección o crear requests manualmente
2. POST Login → obtener token
3. Usar token en header: `Authorization: Bearer <token>`

---

## 🎓 PARA LA EXPOSICIÓN

### 1. Demostrar Login
```
✅ Abrir app → Ir a login
✅ Ingresar: admin@cremosos.com / 123456
✅ Mostrar que se guarda el token (ver logs en consola)
✅ Navegar a otra pantalla → mostrar que sigue autenticado
```

### 2. Demostrar CRUD en Carrito
```
✅ Ver productos → Agregar al carrito (CREATE)
✅ Ver carrito → Cambiar cantidad (UPDATE)
✅ Ver carrito → Ver items (READ)
✅ Ver carrito → Eliminar producto (DELETE)
```

### 3. Demostrar Endpoints
```
✅ Abrir consola del navegador (F12)
✅ Ver logs de Dio mostrando requests/responses
✅ Mostrar códigos HTTP (200, 201, 401, 404)
```

### 4. Explicar Arquitectura
```
✅ Mostrar estructura de carpetas
✅ Explicar Services → Providers → Screens
✅ Mostrar serialización JSON automática
✅ Explicar interceptores de Dio
```

### 5. Mostrar Backend
```
✅ Abrir backend/server.js
✅ Mostrar los 22 endpoints
✅ Explicar autenticación JWT
✅ Mostrar datos mock
```

---

## ❓ SOLUCIÓN DE PROBLEMAS

### Problema: "Puerto 3000 ya está en uso"
```powershell
# Ver qué proceso usa el puerto
netstat -ano | findstr :3000

# Matar el proceso
taskkill /PID <PID> /F

# O cambiar el puerto en backend/server.js
const PORT = 3001;
```

### Problema: "Visual Studio toolchain not found"
```bash
# Opción 1: Ejecutar en web (Chrome)
flutter run -d chrome

# Opción 2: Instalar componentes de Visual Studio
# - Desktop development with C++
# - MSVC v142
# - Windows 10 SDK
```

### Problema: "Dio throws timeout error"
```dart
// Aumentar timeout en lib/config/api_config.dart
static const Duration connectionTimeout = Duration(seconds: 60);
```

### Problema: "Token expirado"
```
1. Hacer login nuevamente
2. El token dura 24 horas
3. Se guarda automáticamente en FlutterSecureStorage
```

---

## 📊 CHECKLIST PRE-PRESENTACIÓN

- [ ] Servidor backend corriendo (http://localhost:3000)
- [ ] App Flutter ejecutándose en Chrome
- [ ] Login funcional con credenciales de prueba
- [ ] Productos cargando desde API
- [ ] Carrito sincronizando con backend
- [ ] Consola del navegador abierta (para mostrar logs)
- [ ] Tener backend/server.js abierto para mostrar código
- [ ] Tener un endpoint de ejemplo en Postman (opcional)

---

## 🎬 FLUJO DE DEMOSTRACIÓN SUGERIDO

1. **Mostrar Backend Corriendo** (30 segundos)
   - Terminal con servidor activo
   - Explicar que tiene 22 endpoints

2. **Mostrar App Flutter** (1 minuto)
   - Navegar por las pantallas
   - Mostrar diseño responsive

3. **Demostrar Login/Autenticación** (1 minuto)
   - Login con credenciales
   - Mostrar token en logs
   - Explicar JWT y seguridad

4. **Demostrar Integración API** (2 minutos)
   - Ver productos (GET)
   - Agregar al carrito (POST)
   - Modificar cantidad (PUT)
   - Eliminar item (DELETE)
   - Mostrar logs de peticiones HTTP

5. **Explicar Arquitectura** (1 minuto)
   - Mostrar carpeta de servicios
   - Explicar serialización JSON
   - Mostrar modelo de ejemplo

6. **Mostrar Código Backend** (1 minuto)
   - Abrir server.js
   - Mostrar un endpoint completo
   - Explicar autenticación con JWT

7. **Q&A** (tiempo restante)

**Total: ~7 minutos**

---

## 📱 CONTACTO Y SOPORTE

- **Documentación:** Ver archivos .md en la raíz del proyecto
- **Código comentado:** Todos los archivos tienen explicaciones en español
- **Marcadores:** Buscar "EXPLICAR EN EXPOSICIÓN" en el código

---

✅ **¡LISTO PARA PRESENTAR!** 🚀
