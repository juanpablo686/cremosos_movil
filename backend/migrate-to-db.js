// Script para migrar server.js a usar base de datos JSON
const fs = require('fs');
const path = require('path');

const serverPath = path.join(__dirname, 'server.js');
let content = fs.readFileSync(serverPath, 'utf8');

// Reemplazos necesarios
const replacements = [
  // GET endpoints - agregar async y await db.read
  {
    pattern: /app\.get\('\/api\/products',\s*\(req,\s*res\)\s*=>\s*\{/g,
    replacement: "app.get('/api/products', async (req, res) => {"
  },
  {
    pattern: /app\.get\('\/api\/products\/:id',\s*\(req,\s*res\)\s*=>\s*\{/g,
    replacement: "app.get('/api/products/:id', async (req, res) => {"
  },
  {
    pattern: /app\.get\('\/api\/products\/featured',\s*\(req,\s*res\)\s*=>\s*\{/g,
    replacement: "app.get('/api/products/featured', async (req, res) => {"
  },
  {
    pattern: /app\.get\('\/api\/orders',\s*authenticateToken,\s*\(req,\s*res\)\s*=>\s*\{/g,
    replacement: "app.get('/api/orders', authenticateToken, async (req, res) => {"
  },
  {
    pattern: /app\.get\('\/api\/orders\/:id',\s*authenticateToken,\s*\(req,\s*res\)\s*=>\s*\{/g,
    replacement: "app.get('/api/orders/:id', authenticateToken, async (req, res) => {"
  },
  {
    pattern: /app\.get\('\/api\/sales',\s*authenticateToken,\s*\(req,\s*res\)\s*=>\s*\{/g,
    replacement: "app.get('/api/sales', authenticateToken, async (req, res) => {"
  },
  {
    pattern: /app\.get\('\/api\/sales\/:id',\s*authenticateToken,\s*\(req,\s*res\)\s*=>\s*\{/g,
    replacement: "app.get('/api/sales/:id', authenticateToken, async (req, res) => {"
  },
  {
    pattern: /app\.post\('\/api\/orders',\s*authenticateToken,\s*\(req,\s*res\)\s*=>\s*\{/g,
    replacement: "app.post('/api/orders', authenticateToken, async (req, res) => {"
  },
  {
    pattern: /app\.post\('\/api\/sales',\s*authenticateToken,\s*\(req,\s*res\)\s*=>\s*\{/g,
    replacement: "app.post('/api/sales', authenticateToken, async (req, res) => {"
  },
  {
    pattern: /app\.put\('\/api\/products\/:id',\s*authenticateToken,\s*\(req,\s*res\)\s*=>\s*\{/g,
    replacement: "app.put('/api/products/:id', authenticateToken, async (req, res) => {"
  },
  {
    pattern: /app\.put\('\/api\/orders\/:id',\s*authenticateToken,\s*\(req,\s*res\)\s*=>\s*\{/g,
    replacement: "app.put('/api/orders/:id', authenticateToken, async (req, res) => {"
  },
  {
    pattern: /app\.delete\('\/api\/products\/:id',\s*authenticateToken,\s*\(req,\s*res\)\s*=>\s*\{/g,
    replacement: "app.delete('/api/products/:id', authenticateToken, async (req, res) => {"
  },
  
  // Insertar await db.read() al principio de funciones
  {
    pattern: /(app\.get\('\/api\/products', async \(req, res\) => \{[\s\S]*?)(let filtered = \[\.\.\.products\];)/,
    replacement: "$1const products = await db.read('products');\n  $2"
  },
  {
    pattern: /(app\.get\('\/api\/products\/:id', async \(req, res\) => \{[\s\S]*?)(const product = products\.find)/,
    replacement: "$1const products = await db.read('products');\n  $2"
  },
  {
    pattern: /(app\.get\('\/api\/products\/featured', async \(req, res\) => \{[\s\S]*?)(const featured = products\.filter)/,
    replacement: "$1const products = await db.read('products');\n  $2"
  },
  {
    pattern: /(app\.get\('\/api\/orders', authenticateToken, async \(req, res\) => \{[\s\S]*?)(let filtered = \[\.\.\.orders\];)/,
    replacement: "$1const orders = await db.read('orders');\n  $2"
  },
  {
    pattern: /(app\.get\('\/api\/orders\/:id', authenticateToken, async \(req, res\) => \{[\s\S]*?)(const order = orders\.find)/,
    replacement: "$1const orders = await db.read('orders');\n  $2"
  },
  {
    pattern: /(app\.get\('\/api\/sales', authenticateToken, async \(req, res\) => \{[\s\S]*?)(let filtered = \[\.\.\.sales\];)/,
    replacement: "$1const sales = await db.read('sales');\n  $2"
  },
  {
    pattern: /(app\.get\('\/api\/sales\/:id', authenticateToken, async \(req, res\) => \{[\s\S]*?)(const sale = sales\.find)/,
    replacement: "$1const sales = await db.read('sales');\n  $2"
  },
  
  // POST/PUT/DELETE - agregar await db.write()
  {
    pattern: /(products\.push\(newProduct\);[\s]*)(res\.status\(201\))/g,
    replacement: "$1await db.write('products', products);\n  $2"
  },
  {
    pattern: /(orders\.push\(newOrder\);[\s]*)(res\.status\(201\))/g,
    replacement: "$1await db.write('orders', orders);\n  $2"
  },
  {
    pattern: /(sales\.push\(newSale\);[\s]*)(res\.(status\(201\)|json\())/g,
    replacement: "$1await db.write('sales', sales);\n  $2"
  },
  {
    pattern: /(product\.updatedAt = new Date\(\)\.toISOString\(\);[\s]*)(res\.json\()/g,
    replacement: "$1await db.write('products', products);\n  $2"
  },
  {
    pattern: /(order\.updatedAt = new Date\(\)\.toISOString\(\);[\s]*)(res\.json\()/g,
    replacement: "$1await db.write('orders', orders);\n  $2"
  },
  {
    pattern: /(products\.splice\(productIndex, 1\);[\s]*)(res\.json\()/g,
    replacement: "$1await db.write('products', products);\n  $2"
  },
];

console.log('🔄 Aplicando migraciones...\n');

replacements.forEach((r, index) => {
  const before = content.length;
  content = content.replace(r.pattern, r.replacement);
  const after = content.length;
  if (before !== after) {
    console.log(`✅ Reemplazo ${index + 1} aplicado`);
  }
});

fs.writeFileSync(serverPath, content, 'utf8');
console.log('\n✅ Migración completada! Reinicia el servidor.');
