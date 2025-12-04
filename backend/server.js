/// Servidor REST API para Cremosos E-Commerce
/// Proporciona endpoints para autenticación, gestión de productos,
/// carrito de compras, órdenes y reportes administrativos.
/// Implementa los 22 endpoints requeridos

const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');

const app = express();
const PORT = 3000;
const SECRET_KEY = 'cremosos_secret_2024';

// Middleware
app.use(cors()); // Permitir peticiones desde Flutter
app.use(express.json()); // Parsear JSON en el body

// ========================================
// DATOS MOCK EN MEMORIA
// ========================================

let users = [
  {
    id: 'user1',
    email: 'admin@cremosos.com',
    password: '123456', // En producción usar bcrypt
    name: 'Juan Admin',
    phone: '3001234567',
    role: 'admin',
    address: {
      street: 'Calle 123',
      city: 'Bogotá',
      state: 'Cundinamarca',
      zipCode: '110111',
      country: 'Colombia'
    }
  }
];

let products = [
  {
    id: 'prod1',
    name: 'Arroz con Leche Clásico',
    description: 'Delicioso arroz con leche casero',
    price: 8000,
    imageUrl: 'https://via.placeholder.com/200',
    category: 'arroz_con_leche',
    stock: 50,
    rating: 4.5,
    reviewsCount: 23,
    isAvailable: true,
    isFeatured: true,
    compatibleToppings: ['top1', 'top2'],
    createdAt: new Date().toISOString()
  },
  {
    id: 'prod2',
    name: 'Fresas con Crema Premium',
    description: 'Fresas frescas con crema batida',
    price: 12000,
    imageUrl: 'https://via.placeholder.com/200',
    category: 'fresas_con_crema',
    stock: 30,
    rating: 4.8,
    reviewsCount: 45,
    isAvailable: true,
    isFeatured: true,
    compatibleToppings: ['top1', 'top3'],
    createdAt: new Date().toISOString()
  }
];

let carts = {};
let orders = [];

// ========================================
// MIDDLEWARE DE AUTENTICACIÓN
// ========================================

function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

  if (!token) {
    return res.status(401).json({ 
      success: false, 
      message: 'Token no proporcionado' 
    });
  }

  jwt.verify(token, SECRET_KEY, (err, user) => {
    if (err) {
      return res.status(401).json({ 
        success: false, 
        message: 'Token inválido o expirado' 
      });
    }
    req.user = user;
    next();
  });
}

// ========================================
// ENDPOINTS DE AUTENTICACIÓN (4)
// ========================================

// 1. POST /api/auth/login
app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body;

  const user = users.find(u => u.email === email && u.password === password);

  if (!user) {
    return res.status(401).json({
      success: false,
      message: 'Credenciales inválidas'
    });
  }

  // Generar JWT
  const token = jwt.sign(
    { id: user.id, email: user.email, role: user.role },
    SECRET_KEY,
    { expiresIn: '24h' }
  );

  res.json({
    success: true,
    message: 'Login exitoso',
    data: {
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role
      }
    }
  });
});

// 2. POST /api/auth/register
app.post('/api/auth/register', (req, res) => {
  const { name, email, password, phone } = req.body;

  if (users.find(u => u.email === email)) {
    return res.status(400).json({
      success: false,
      message: 'El email ya está registrado'
    });
  }

  const newUser = {
    id: `user${users.length + 1}`,
    email,
    password,
    name,
    phone,
    role: 'customer',
    address: null
  };

  users.push(newUser);

  const token = jwt.sign(
    { id: newUser.id, email: newUser.email, role: newUser.role },
    SECRET_KEY,
    { expiresIn: '24h' }
  );

  res.status(201).json({
    success: true,
    message: 'Usuario registrado exitosamente',
    data: {
      token,
      user: {
        id: newUser.id,
        name: newUser.name,
        email: newUser.email,
        role: newUser.role
      }
    }
  });
});

// 3. GET /api/users/profile
app.get('/api/users/profile', authenticateToken, (req, res) => {
  const user = users.find(u => u.id === req.user.id);

  if (!user) {
    return res.status(404).json({
      success: false,
      message: 'Usuario no encontrado'
    });
  }

  const { password, ...userWithoutPassword } = user;

  res.json({
    success: true,
    data: userWithoutPassword
  });
});

// 4. PUT /api/users/profile
app.put('/api/users/profile', authenticateToken, (req, res) => {
  const userIndex = users.findIndex(u => u.id === req.user.id);

  if (userIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Usuario no encontrado'
    });
  }

  const { name, phone, address } = req.body;
  users[userIndex] = { ...users[userIndex], name, phone, address };

  const { password, ...updatedUser } = users[userIndex];

  res.json({
    success: true,
    message: 'Perfil actualizado',
    data: updatedUser
  });
});

// ========================================
// ENDPOINTS DE PRODUCTOS (5)
// ========================================

// 5. GET /api/products
app.get('/api/products', (req, res) => {
  let { category, page = 1, limit = 20, search, sortBy = 'name', sortOrder = 'asc' } = req.query;

  let filtered = [...products];

  // Filtrar por categoría
  if (category) {
    filtered = filtered.filter(p => p.category === category);
  }

  // Buscar por texto
  if (search) {
    const searchLower = search.toLowerCase();
    filtered = filtered.filter(p => 
      p.name.toLowerCase().includes(searchLower) ||
      p.description.toLowerCase().includes(searchLower)
    );
  }

  // Ordenar
  filtered.sort((a, b) => {
    let comparison = 0;
    if (sortBy === 'price') comparison = a.price - b.price;
    else if (sortBy === 'rating') comparison = a.rating - b.rating;
    else comparison = a.name.localeCompare(b.name);

    return sortOrder === 'desc' ? -comparison : comparison;
  });

  // Paginación
  const start = (page - 1) * limit;
  const end = start + parseInt(limit);
  const paginated = filtered.slice(start, end);

  res.json({
    success: true,
    data: paginated,
    meta: {
      page: parseInt(page),
      limit: parseInt(limit),
      total: filtered.length,
      totalPages: Math.ceil(filtered.length / limit),
      hasNext: end < filtered.length,
      hasPrevious: page > 1
    }
  });
});

// 6. GET /api/products/:id
app.get('/api/products/:id', (req, res) => {
  const product = products.find(p => p.id === req.params.id);

  if (!product) {
    return res.status(404).json({
      success: false,
      message: 'Producto no encontrado'
    });
  }

  res.json({
    success: true,
    data: product
  });
});

// 7. GET /api/products/featured
app.get('/api/products/featured', (req, res) => {
  const featured = products.filter(p => p.isFeatured);

  res.json({
    success: true,
    data: featured
  });
});

// ========================================
// ENDPOINTS DE CARRITO (6)
// ========================================

// 8. GET /api/cart
app.get('/api/cart', authenticateToken, (req, res) => {
  const cart = carts[req.user.id] || { id: req.user.id, userId: req.user.id, items: [], updatedAt: new Date().toISOString() };

  res.json({
    success: true,
    data: cart
  });
});

// 9. POST /api/cart/items (CREATE)
app.post('/api/cart/items', authenticateToken, (req, res) => {
  const { productId, quantity, toppingIds = [], notes } = req.body;

  const product = products.find(p => p.id === productId);
  if (!product) {
    return res.status(404).json({
      success: false,
      message: 'Producto no encontrado'
    });
  }

  if (!carts[req.user.id]) {
    carts[req.user.id] = {
      id: req.user.id,
      userId: req.user.id,
      items: [],
      updatedAt: new Date().toISOString()
    };
  }

  const newItem = {
    id: `item${Date.now()}`,
    productId,
    productName: product.name,
    productImage: product.imageUrl,
    productPrice: product.price,
    quantity,
    toppings: [],
    notes,
    createdAt: new Date().toISOString()
  };

  carts[req.user.id].items.push(newItem);
  carts[req.user.id].updatedAt = new Date().toISOString();

  res.status(201).json({
    success: true,
    message: 'Producto agregado al carrito',
    data: carts[req.user.id]
  });
});

// 10. PUT /api/cart/items/:id (UPDATE)
app.put('/api/cart/items/:id', authenticateToken, (req, res) => {
  const cart = carts[req.user.id];
  if (!cart) {
    return res.status(404).json({
      success: false,
      message: 'Carrito no encontrado'
    });
  }

  const itemIndex = cart.items.findIndex(i => i.id === req.params.id);
  if (itemIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Item no encontrado'
    });
  }

  const { quantity } = req.body;
  cart.items[itemIndex].quantity = quantity;
  cart.updatedAt = new Date().toISOString();

  res.json({
    success: true,
    message: 'Item actualizado',
    data: cart
  });
});

// 11. DELETE /api/cart/items/:id (DELETE)
app.delete('/api/cart/items/:id', authenticateToken, (req, res) => {
  const cart = carts[req.user.id];
  if (!cart) {
    return res.status(404).json({
      success: false,
      message: 'Carrito no encontrado'
    });
  }

  cart.items = cart.items.filter(i => i.id !== req.params.id);
  cart.updatedAt = new Date().toISOString();

  res.json({
    success: true,
    message: 'Item eliminado',
    data: cart
  });
});

// 12. DELETE /api/cart
app.delete('/api/cart', authenticateToken, (req, res) => {
  if (carts[req.user.id]) {
    carts[req.user.id].items = [];
    carts[req.user.id].updatedAt = new Date().toISOString();
  }

  res.json({
    success: true,
    message: 'Carrito vaciado'
  });
});

// 13. POST /api/cart/sync
app.post('/api/cart/sync', authenticateToken, (req, res) => {
  const { items } = req.body;

  carts[req.user.id] = {
    id: req.user.id,
    userId: req.user.id,
    items: items.map(item => ({
      id: `item${Date.now()}${Math.random()}`,
      ...item,
      createdAt: new Date().toISOString()
    })),
    updatedAt: new Date().toISOString()
  };

  res.json({
    success: true,
    message: 'Carrito sincronizado',
    data: carts[req.user.id]
  });
});

// ========================================
// ENDPOINTS DE ÓRDENES (5)
// ========================================

// 14. POST /api/orders
app.post('/api/orders', authenticateToken, (req, res) => {
  const cart = carts[req.user.id];
  if (!cart || cart.items.length === 0) {
    return res.status(400).json({
      success: false,
      message: 'Carrito vacío'
    });
  }

  const { shippingAddress, paymentMethod, paymentDetails, notes } = req.body;

  const subtotal = cart.items.reduce((sum, item) => sum + (item.productPrice * item.quantity), 0);
  const tax = subtotal * 0.08;
  const shippingCost = subtotal >= 50000 ? 0 : 5000;
  const total = subtotal + tax + shippingCost;

  const newOrder = {
    id: `order${orders.length + 1}`,
    orderNumber: `ORD-2024-${String(orders.length + 1).padStart(4, '0')}`,
    userId: req.user.id,
    status: 'pending',
    items: cart.items,
    shippingAddress,
    paymentInfo: {
      method: paymentMethod,
      transactionId: `TXN${Date.now()}`,
      status: 'completed',
      paidAt: new Date().toISOString()
    },
    subtotal,
    tax,
    shippingCost,
    discount: 0,
    total,
    notes,
    tracking: {
      events: [{
        status: 'pending',
        description: 'Orden creada',
        timestamp: new Date().toISOString()
      }]
    },
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    estimatedDelivery: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000).toISOString()
  };

  orders.push(newOrder);
  carts[req.user.id].items = []; // Vaciar carrito

  res.status(201).json({
    success: true,
    message: 'Orden creada exitosamente',
    data: newOrder
  });
});

// 15. GET /api/orders
app.get('/api/orders', authenticateToken, (req, res) => {
  const userOrders = orders.filter(o => o.userId === req.user.id);

  res.json({
    success: true,
    data: userOrders
  });
});

// 16. GET /api/orders/:id
app.get('/api/orders/:id', authenticateToken, (req, res) => {
  const order = orders.find(o => o.id === req.params.id && o.userId === req.user.id);

  if (!order) {
    return res.status(404).json({
      success: false,
      message: 'Orden no encontrada'
    });
  }

  res.json({
    success: true,
    data: order
  });
});

// 17. PUT /api/orders/:id/cancel
app.put('/api/orders/:id/cancel', authenticateToken, (req, res) => {
  const orderIndex = orders.findIndex(o => o.id === req.params.id && o.userId === req.user.id);

  if (orderIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Orden no encontrada'
    });
  }

  if (!['pending', 'confirmed'].includes(orders[orderIndex].status)) {
    return res.status(400).json({
      success: false,
      message: 'No se puede cancelar esta orden'
    });
  }

  orders[orderIndex].status = 'cancelled';
  orders[orderIndex].updatedAt = new Date().toISOString();

  res.json({
    success: true,
    message: 'Orden cancelada',
    data: orders[orderIndex]
  });
});

// 18. GET /api/orders/:id/track
app.get('/api/orders/:id/track', authenticateToken, (req, res) => {
  const order = orders.find(o => o.id === req.params.id && o.userId === req.user.id);

  if (!order) {
    return res.status(404).json({
      success: false,
      message: 'Orden no encontrada'
    });
  }

  res.json({
    success: true,
    data: order.tracking
  });
});

// ========================================
// ENDPOINTS DE REPORTES (4)
// ========================================

// 19. GET /api/reports/dashboard
app.get('/api/reports/dashboard', authenticateToken, (req, res) => {
  const totalSales = orders.reduce((sum, o) => sum + o.total, 0);
  const totalOrders = orders.length;

  res.json({
    success: true,
    data: {
      totalSales,
      totalOrders,
      activeCustomers: users.length,
      averageOrderValue: totalOrders > 0 ? totalSales / totalOrders : 0,
      comparison: {
        salesChange: 15.5,
        ordersChange: 8.3,
        customersChange: 12.1,
        aovChange: 5.2
      },
      dailySales: [],
      topProducts: products.slice(0, 5),
      salesByCategory: [],
      recentOrders: orders.slice(-5)
    }
  });
});

// 20. GET /api/reports/sales
app.get('/api/reports/sales', (req, res) => {
  res.json({
    success: true,
    data: {
      period: 'monthly',
      startDate: new Date().toISOString(),
      endDate: new Date().toISOString(),
      totals: {
        revenue: 1250000,
        orders: 45,
        customers: 32,
        averageOrderValue: 27777,
        tax: 100000,
        shipping: 50000
      },
      breakdown: [],
      trends: {
        direction: 'up',
        growthRate: 12.5,
        projectedSales: 1400000
      }
    }
  });
});

// 21. GET /api/reports/products
app.get('/api/reports/products', (req, res) => {
  res.json({
    success: true,
    data: {
      products: products.map(p => ({
        productId: p.id,
        productName: p.name,
        category: p.category,
        unitsSold: Math.floor(Math.random() * 100),
        revenue: p.price * Math.floor(Math.random() * 100),
        averageRating: p.rating,
        reviewsCount: p.reviewsCount,
        currentStock: p.stock,
        profitMargin: 0.3
      })),
      categoryPerformance: {
        bestPerforming: 'fresas_con_crema',
        worstPerforming: 'bebidas',
        categoryRevenue: {}
      }
    }
  });
});

// 22. GET /api/reports/customers
app.get('/api/reports/customers', (req, res) => {
  res.json({
    success: true,
    data: {
      totalCustomers: users.length,
      newCustomers: 5,
      returningCustomers: users.length - 5,
      retentionRate: 0.75,
      topCustomers: [],
      demographics: {
        byCity: { 'Bogotá': 10, 'Medellín': 5 },
        byAgeGroup: { '18-25': 8, '26-35': 12 },
        maleCount: 8,
        femaleCount: 12,
        otherCount: 0
      }
    }
  });
});

// ========================================
// INICIAR SERVIDOR
// ========================================

app.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════════════════════════╗
║     🍚 CREMOSOS API SERVER - RUNNING                   ║
╚════════════════════════════════════════════════════════╝

📡 URL: http://localhost:${PORT}
📊 Endpoints: 22 disponibles
👤 Usuario test: admin@cremosos.com / 123456

📋 ENDPOINTS IMPLEMENTADOS:
   
   AUTH (4):
   ✅ POST   /api/auth/login
   ✅ POST   /api/auth/register
   ✅ GET    /api/users/profile
   ✅ PUT    /api/users/profile
   
   PRODUCTS (5):
   ✅ GET    /api/products
   ✅ GET    /api/products/:id
   ✅ GET    /api/products/featured
   
   CART (6):
   ✅ GET    /api/cart
   ✅ POST   /api/cart/items
   ✅ PUT    /api/cart/items/:id
   ✅ DELETE /api/cart/items/:id
   ✅ DELETE /api/cart
   ✅ POST   /api/cart/sync
   
   ORDERS (5):
   ✅ POST   /api/orders
   ✅ GET    /api/orders
   ✅ GET    /api/orders/:id
   ✅ PUT    /api/orders/:id/cancel
   ✅ GET    /api/orders/:id/track
   
   REPORTS (4):
   ✅ GET    /api/reports/dashboard
   ✅ GET    /api/reports/sales
   ✅ GET    /api/reports/products
   ✅ GET    /api/reports/customers

🔥 Servidor listo para recibir peticiones desde Flutter!
  `);
});
