# Migración Automática a Base de Datos JSON

## Estado Actual

✅ **Ya completado:**
- Helpers creados (`getProducts()`, `saveProducts()`, etc.)
- Endpoints POST migrados con `await db.insert()`
- Base de datos JSON inicializada

⚠️ **Pendiente:**
- ~40 endpoints GET/PUT/DELETE que aún usan variables globales
- Todos necesitan ser `async` y usar helpers

## Solución Rápida

Para completar la migración de TODOS los endpoints restantes, ejecuta este script:

```bash
cd /Users/macbook/cremosos_movil/backend
node << 'EOF'
const fs = require('fs');
let content = fs.readFileSync('server.js', 'utf8');

// Hacer async todos los GET/PUT/DELETE que faltan
const endpoints = [
  "/api/users/profile",
  "/api/admin/users",
  "/api/admin/users/:id",
  "/api/roles",
  "/api/roles/:id",
  "/api/suppliers",
  "/api/suppliers/:id",
  "/api/purchases",
  "/api/purchases/:id",
  "/api/sales",
  "/api/sales/:id",
  "/api/sales/summary/today",
  "/api/orders",
  "/api/orders/:id",
  "/api/orders/:id/cancel",
  "/api/orders/:id/track",
  "/api/cart",
  "/api/cart/items",
  "/api/cart/items/:id",
  "/api/reports/dashboard",
  "/api/reports/sales",
  "/api/reports/products",
  "/api/reports/customers"
];

endpoints.forEach(ep => {
  // Convertir a async
  const regex1 = new RegExp(`(app\\.(get|put|delete)\\('${ep.replace(/:/g, '\\:')}', authenticateToken, )\\(req, res\\) =>`, 'g');
  content = content.replace(regex1, '$1async (req, res) =>');
  
  const regex2 = new RegExp(`(app\\.(get|put|delete)\\('${ep.replace(/:/g, '\\:')}', )\\(req, res\\) =>`, 'g');
  content = content.replace(regex2, '$1async (req, res) =>');
});

// Reemplazar accesos directos a variables por helpers
const replacements = {
  'const filtered = [...products]': 'const products = await getProducts();\\n  const filtered = [...products]',
  'const product = products.find': 'const products = await getProducts();\\n  const product = products.find',
  'const productIndex = products.findIndex': 'const products = await getProducts();\\n  const productIndex = products.findIndex',
  
  'const filtered = [...users]': 'const users = await getUsers();\\n  const filtered = [...users]',
  'const user = users.find': 'const users = await getUsers();\\n  const user = users.find',
  'const userIndex = users.findIndex': 'const users = await getUsers();\\n  const userIndex = users.findIndex',
  
  'const filtered = [...orders]': 'const orders = await getOrders();\\n  const filtered = [...orders]',
  'const order = orders.find': 'const orders = await getOrders();\\n  const order = orders.find',
  'const orderIndex = orders.findIndex': 'const orders = await getOrders();\\n  const orderIndex = orders.findIndex',
  
  'const filtered = [...sales]': 'const sales = await getSales();\\n  const filtered = [...sales]',
  'const sale = sales.find': 'const sales = await getSales();\\n  const sale = sales.find',
  
  'const filtered = [...roles]': 'const roles = await getRoles();\\n  const filtered = [...roles]',
  'const role = roles.find': 'const roles = await getRoles();\\n  const role = roles.find',
  
  'const filtered = [...suppliers]': 'const suppliers = await getSuppliers();\\n  const filtered = [...suppliers]',
  'const supplier = suppliers.find': 'const suppliers = await getSuppliers();\\n  const supplier = suppliers.find',
  
  'const filtered = [...purchases]': 'const purchases = await getPurchases();\\n  const filtered = [...purchases]',
  'const purchase = purchases.find': 'const purchases = await getPurchases();\\n  const purchase = purchases.find',
};

Object.entries(replacements).forEach(([old, rep]) => {
  content = content.replace(new RegExp(old, 'g'), rep);
});

// Agregar saveXxx() después de modificaciones
content = content.replace(/(product\.updatedAt = new Date\(\)\.toISOString\(\);[\s\n]*)([\s]*res\.json\()/g, '$1  await saveProducts(products);\\n$2');
content = content.replace(/(user\.updatedAt = new Date\(\)\.toISOString\(\);[\s\n]*)([\s]*res\.json\()/g, '$1  await saveUsers(users);\\n$2');
content = content.replace(/(order\.updatedAt = new Date\(\)\.toISOString\(\);[\s\n]*)([\s]*res\.json\()/g, '$1  await saveOrders(orders);\\n$2');
content = content.replace(/(role\.updatedAt = new Date\(\)\.toISOString\(\);[\s\n]*)([\s]*res\.json\()/g, '$1  await saveRoles(roles);\\n$2');
content = content.replace(/(supplier\.updatedAt = new Date\(\)\.toISOString\(\);[\s\n]*)([\s]*res\.json\()/g, '$1  await saveSuppliers(suppliers);\\n$2');
content = content.replace(/(purchase\.updatedAt = new Date\(\)\.toISOString\(\);[\s\n]*)([\s]*res\.json\()/g, '$1  await savePurchases(purchases);\\n$2');

// Agregar save() después de .splice (eliminaciones)
content = content.replace(/(products\.splice\([^)]+\);[\s\n]*)([\s]*res\.json\()/g, '$1  await saveProducts(products);\\n$2');
content = content.replace(/(users\.splice\([^)]+\);[\s\n]*)([\s]*res\.json\()/g, '$1  await saveUsers(users);\\n$2');
content = content.replace(/(orders\.splice\([^)]+\);[\s\n]*)([\s]*res\.json\()/g, '$1  await saveOrders(orders);\\n$2');
content = content.replace(/(roles\.splice\([^)]+\);[\s\n]*)([\s]*res\.json\()/g, '$1  await saveRoles(roles);\\n$2');
content = content.replace(/(suppliers\.splice\([^)]+\);[\s\n]*)([\s]*res\.json\()/g, '$1  await saveSuppliers(suppliers);\\n$2');
content = content.replace(/(purchases\.splice\([^)]+\);[\s\n]*)([\s]*res\.json\()/g, '$1  await savePurchases(purchases);\\n$2');

fs.writeFileSync('server.js', content, 'utf8');
console.log('✅ Migración automática completada!');
console.log('🔄 Reinicia el servidor para aplicar cambios.');
EOF
```

## Alternativa Manual

Si prefieres no usar el script, necesitas:

1. **Hacer async** todos los endpoints que no lo son
2. **Agregar** `const xxx = await getXxx()` al inicio de cada endpoint
3. **Agregar** `await saveXxx(xxx)` después de cada modificación

Esto es TEDIOSO pero garantiza control total.

## Recomendación

👉 **Usa el script automático** - Es más rápido y menos propenso a errores.
