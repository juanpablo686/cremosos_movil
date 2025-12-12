# Base de Datos JSON - Cremosos ERP

## ¿Qué es esto?

Este sistema guarda **TODOS tus datos de forma permanente** en archivos JSON en la carpeta `/backend/data/`.

## ✅ Ventajas

- **Persistencia**: Los datos NO se pierden al reiniciar el servidor
- **Sin instalación**: No necesitas instalar SQL Server
- **Fácil de ver**: Los archivos JSON son legibles y editables
- **Backup simple**: Solo copia la carpeta `data/` para respaldar todo

## 📁 Estructura de archivos

```
backend/
├── data/
│   ├── products.json      ← Productos (con imágenes y precios)
│   ├── users.json         ← Usuarios registrados
│   ├── orders.json        ← Pedidos de clientes
│   ├── sales.json         ← Ventas del POS
│   ├── cart.json          ← Carritos de compra
│   ├── roles.json         ← Roles y permisos
│   ├── suppliers.json     ← Proveedores
│   └── purchases.json     ← Compras a proveedores
├── db-manager.js          ← Gestor de base de datos
└── server.js              ← API principal
```

## 🔄 ¿Cómo funciona?

### 1. Al iniciar el servidor

```
1. Se crea la carpeta /data/ si no existe
2. Se crean los archivos JSON vacíos si no existen
3. Se migran los datos iniciales (productos, usuarios, etc.)
4. El servidor está listo para usar
```

### 2. Cuando creas algo nuevo

Por ejemplo, cuando agregas un producto:
```javascript
// ANTES (se perdía al reiniciar):
products.push(newProduct);

// AHORA (se guarda permanentemente):
await db.insert('products', newProduct);
```

Los datos se escriben inmediatamente en `data/products.json`.

### 3. Cuando consultas datos

```javascript
// Leer todos los productos
const products = await db.read('products');

// Buscar por ID
const product = await db.findById('products', 'prod1');

// Actualizar
await db.update('products', 'prod1', { price: 10000 });

// Eliminar
await db.delete('products', 'prod1');
```

## 🛠️ Operaciones disponibles

| Operación | Código | Descripción |
|-----------|--------|-------------|
| **Leer todos** | `await db.read('products')` | Obtiene todos los registros |
| **Buscar por ID** | `await db.findById('products', id)` | Encuentra un registro específico |
| **Crear** | `await db.insert('products', dato)` | Agrega un nuevo registro |
| **Actualizar** | `await db.update('products', id, cambios)` | Modifica un registro |
| **Eliminar** | `await db.delete('products', id)` | Borra un registro |
| **Contar** | `await db.count('products')` | Cuenta registros |
| **Buscar con filtro** | `await db.find('products', filtro)` | Busca con condición |

## 📊 Ejemplo real: Ver tus productos

Abre el archivo `backend/data/products.json` y verás algo así:

```json
[
  {
    "id": "prod1",
    "name": "Arroz con Leche Tradicional - Grande",
    "description": "Delicioso arroz con leche sabor tradicional. Tamaño Grande: $9.000",
    "price": 9000,
    "imageUrl": "http://localhost:3000/images/arroz_tradicional.jpg",
    "category": "arroz_con_leche",
    "stock": 50,
    "rating": 4.8,
    "createdAt": "2025-12-12T04:03:52.075Z"
  }
]
```

## 🔐 Seguridad

- Los archivos JSON están en tu servidor local
- No son accesibles desde internet
- Solo el servidor Node.js puede modificarlos

## 💾 Cómo hacer backup

```bash
# Copiar toda la carpeta data
cp -r backend/data backend/data_backup_$(date +%Y%m%d)

# O comprimir
tar -czf backup_cremosos_$(date +%Y%m%d).tar.gz backend/data
```

## 🔄 Estado actual

Después del primer reinicio del servidor, verás:

```
💾 Inicializando base de datos JSON...
📄 Creado archivo: products.json
📄 Creado archivo: users.json
📄 Creado archivo: orders.json
📄 Creado archivo: sales.json
... (resto de archivos)
📦 Migrando productos iniciales...
👥 Migrando usuarios iniciales...
✅ Base de datos JSON lista y sincronizada
```

## ⚠️ Importante

### ANTES del cambio:
❌ Al reiniciar el servidor, perdías:
- Productos creados
- Ventas registradas
- Usuarios nuevos
- Pedidos realizados

### DESPUÉS del cambio:
✅ Al reiniciar el servidor, conservas:
- ✅ Todos los productos
- ✅ Todas las ventas
- ✅ Todos los usuarios
- ✅ Todos los pedidos

## 🎯 Próximos pasos

1. ✅ Base de datos JSON configurada
2. ✅ Endpoints de productos migrados
3. ⏳ Migrar endpoints de ventas
4. ⏳ Migrar endpoints de usuarios
5. ⏳ Migrar endpoints de pedidos

---

**¿Necesitas ayuda?** Consulta `GUIA_MIGRACION_DB.js` para ver ejemplos de código.
