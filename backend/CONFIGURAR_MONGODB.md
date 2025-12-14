# 🔧 GUÍA: Configurar MongoDB Atlas para Cremosos

## ⚠️ PROBLEMA ACTUAL
El servidor no puede conectarse a MongoDB Atlas porque tu IP no está en la whitelist (lista de IPs permitidas).

## 🎯 SOLUCIÓN RÁPIDA

### Opción 1: Permitir todas las IPs (RECOMENDADO PARA DESARROLLO)

1. **Ir a MongoDB Atlas**
   - Abre tu navegador
   - Ve a: https://cloud.mongodb.com
   - Inicia sesión con:
     - Email: devshirleycardona (o el email que usaste para crear la cuenta)
     - Contraseña: (tu contraseña de MongoDB Atlas)

2. **Configurar Network Access**
   - En el menú lateral izquierdo, haz clic en **"Network Access"** (debajo de "Security")
   - Haz clic en el botón **"+ ADD IP ADDRESS"** (verde, esquina superior derecha)

3. **Permitir todas las IPs**
   - En la ventana emergente, haz clic en **"ALLOW ACCESS FROM ANYWHERE"**
   - Esto agregará la IP: `0.0.0.0/0`
   - Haz clic en **"Confirm"**
   - Espera 1-2 minutos para que se aplique el cambio

4. **Reiniciar el servidor**
   ```bash
   cd /Users/macbook/Downloads/cremosos_movil-main/backend
   node server.js
   ```

### Opción 2: Agregar solo tu IP actual (MÁS SEGURO)

1. **Obtener tu IP pública**
   ```bash
   curl -s https://api.ipify.org
   ```
   
2. **Ir a MongoDB Atlas** (mismos pasos que Opción 1)

3. **Agregar tu IP específica**
   - En Network Access, haz clic en **"+ ADD IP ADDRESS"**
   - Haz clic en **"ADD CURRENT IP ADDRESS"**
   - O ingresa manualmente la IP que obtuviste en el paso 1
   - Agrega una descripción: "Mi computadora local"
   - Haz clic en **"Confirm"**

## ✅ VERIFICAR QUE FUNCIONA

Después de configurar la whitelist, ejecuta:

```bash
cd /Users/macbook/Downloads/cremosos_movil-main/backend
node server.js
```

Deberías ver:
```
✅ MongoDB conectado: cluster0.dhojcd0.mongodb.net
📊 Base de datos: cremosos
```

## 🗄️ POBLAR LA BASE DE DATOS CON DATOS INICIALES

Una vez que MongoDB esté conectado, ejecuta el script de seed:

```bash
cd /Users/macbook/Downloads/cremosos_movil-main/backend
node seed-mongodb.js
```

Esto creará:
- ✅ 3 usuarios (admin, María, Carlos)
- ✅ 11 productos (arroz con leche, fresas con crema, etc.)
- ✅ 2 órdenes de ejemplo

### Credenciales de prueba creadas:
- **Admin**: admin@cremosos.com / 123456
- **Cliente 1**: maria.garcia@email.com / 123456
- **Cliente 2**: carlos.lopez@email.com / 123456

## 🔄 PROBAR EL SISTEMA

1. **Iniciar el backend**:
   ```bash
   cd /Users/macbook/Downloads/cremosos_movil-main/backend
   node server.js
   ```

2. **En otra terminal, iniciar Flutter**:
   ```bash
   cd /Users/macbook/Downloads/cremosos_movil-main
   flutter run -d chrome
   ```

3. **Probar funcionalidad**:
   - Login con admin@cremosos.com / 123456
   - Crear un nuevo producto → Se guarda en MongoDB ✅
   - Crear un nuevo usuario → Se guarda en MongoDB ✅
   - Hacer un pedido → Se guarda en MongoDB ✅
   - Reiniciar el servidor → Los datos siguen ahí ✅

## 🛠️ SOLUCIÓN DE PROBLEMAS

### Problema: "Operation `products.find()` buffering timed out"
**Causa**: MongoDB no está conectado
**Solución**: Configura la whitelist de IPs (ver arriba)

### Problema: "MongooseServerSelectionError"
**Causa**: IP no está en la whitelist O credenciales incorrectas
**Solución**: 
1. Verifica la whitelist en MongoDB Atlas
2. Verifica el archivo `.env` tenga la URI correcta

### Problema: El seed falla con error de bcrypt
**Causa**: El seed-mongodb.js usa bcrypt pero el servidor no
**Solución**: Ya está creado un seed compatible, solo ejecuta `node seed-mongodb.js`

## 📝 NOTAS IMPORTANTES

1. **0.0.0.0/0** significa "permitir desde cualquier IP" - es conveniente para desarrollo pero menos seguro
2. Si tu IP cambia (cambias de red WiFi), necesitarás actualizar la whitelist
3. Para producción, usa IPs específicas de tus servidores
4. MongoDB Atlas gratuito tiene límites de conexiones simultáneas (500 conexiones)

## 🎉 UNA VEZ CONFIGURADO

Tu aplicación tendrá:
- ✅ Persistencia real en MongoDB Atlas
- ✅ Datos que sobreviven a reinicios del servidor
- ✅ Base de datos en la nube accesible desde cualquier lugar
- ✅ Backup automático de MongoDB Atlas
- ✅ Escalabilidad para cuando crezcas
