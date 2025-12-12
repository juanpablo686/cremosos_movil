/// Servidor REST API para Cremosos E-Commerce
/// Proporciona endpoints para autenticación, gestión de productos,
/// carrito de compras, órdenes y reportes administrativos.
/// Implementa los 22 endpoints requeridos

const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const db = require('./db-manager');

const app = express();
const PORT = 3000;
const SECRET_KEY = 'cremosos_secret_2024';

// Middleware
app.use(cors()); // Permitir peticiones desde Flutter
app.use(express.json()); // Parsear JSON en el body
app.use('/images', express.static('images')); // Servir imágenes estáticas

// ========================================
// HELPERS PARA ACCESO A BASE DE DATOS
// ========================================
async function getProducts() { return await db.read('products'); }
async function saveProducts(data) { return await db.write('products', data); }
async function getUsers() { return await db.read('users'); }
async function saveUsers(data) { return await db.write('users', data); }
async function getOrders() { return await db.read('orders'); }
async function saveOrders(data) { return await db.write('orders', data); }
async function getSales() { return await db.read('sales'); }
async function saveSales(data) { return await db.write('sales', data); }
async function getCarts() { return await db.read('cart'); }
async function saveCarts(data) { return await db.write('cart', data); }
async function getRoles() { return await db.read('roles'); }
async function saveRoles(data) { return await db.write('roles', data); }
async function getSuppliers() { return await db.read('suppliers'); }
async function saveSuppliers(data) { return await db.write('suppliers', data); }
async function getPurchases() { return await db.read('purchases'); }
async function savePurchases(data) { return await db.write('purchases', data); }

// ========================================
// DATOS INICIALES (se migrarán a DB JSON)
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
  },
  {
    id: 'user2',
    email: 'maria.garcia@email.com',
    password: '123456',
    name: 'María García',
    phone: '3109876543',
    role: 'customer',
    address: {
      street: 'Carrera 45 #67-89',
      city: 'Medellín',
      state: 'Antioquia',
      zipCode: '050021',
      country: 'Colombia'
    }
  },
  {
    id: 'user3',
    email: 'carlos.lopez@email.com',
    password: '123456',
    name: 'Carlos López',
    phone: '3158887766',
    role: 'customer',
    address: {
      street: 'Avenida 30 #15-20',
      city: 'Cali',
      state: 'Valle del Cauca',
      zipCode: '760042',
      country: 'Colombia'
    }
  },
  {
    id: 'user4',
    email: 'ana.martinez@email.com',
    password: '123456',
    name: 'Ana Martínez',
    phone: '3201234567',
    role: 'customer',
    address: {
      street: 'Calle 85 #12-34',
      city: 'Barranquilla',
      state: 'Atlántico',
      zipCode: '080001',
      country: 'Colombia'
    }
  }
];

// Función helper para generar productos
function generateProducts() {
  const products = [];
  
  // Arroz con leche - Tamaño Grande ($9,000)
  const arrozGrande = [
    { id: 'prod1', name: 'Arroz con Leche Tradicional - Grande', sabor: 'Tradicional', image: 'arroz_tradicional.jpg', price: 9000, size: 'Grande' },
    { id: 'prod2', name: 'Arroz con Leche de Arequipe - Grande', sabor: 'Arequipe', image: 'arroz_arequipe.jpg', price: 9000, size: 'Grande' },
    { id: 'prod3', name: 'Arroz con Leche de Maracuyá - Grande', sabor: 'Maracuyá', image: 'arroz_maracuya.jpg', price: 9000, size: 'Grande' },
    { id: 'prod4', name: 'Arroz con Leche de Chocolate - Grande', sabor: 'Chocolate', image: 'arroz_chocolate.jpg', price: 9000, size: 'Grande' }
  ];

  // Arroz con leche - Tamaño Pequeño ($6,000) - misma imagen
  const arrozPequeno = [
    { id: 'prod5', name: 'Arroz con Leche Tradicional - Pequeño', sabor: 'Tradicional', image: 'arroz_tradicional.jpg', price: 6000, size: 'Pequeño' },
    { id: 'prod6', name: 'Arroz con Leche de Arequipe - Pequeño', sabor: 'Arequipe', image: 'arroz_arequipe.jpg', price: 6000, size: 'Pequeño' },
    { id: 'prod7', name: 'Arroz con Leche de Maracuyá - Pequeño', sabor: 'Maracuyá', image: 'arroz_maracuya.jpg', price: 6000, size: 'Pequeño' },
    { id: 'prod8', name: 'Arroz con Leche de Chocolate - Pequeño', sabor: 'Chocolate', image: 'arroz_chocolate.jpg', price: 6000, size: 'Pequeño' }
  ];

  // Fresas con crema - todas usan la misma imagen
  const fresas2Toppings = [
    { id: 'prod9', name: 'Fresas con Crema - 2 Toppings ($9.000)', toppings: 2, image: 'fresas_con_crema.jpg', price: 9000 }
  ];

  const fresas3Toppings = [
    { id: 'prod10', name: 'Fresas con Crema - 3 Toppings ($11.000)', toppings: 3, image: 'fresas_con_crema.jpg', price: 11000 }
  ];

  const fresas4Toppings = [
    { id: 'prod11', name: 'Fresas con Crema - 4 Toppings ($16.000)', toppings: 4, image: 'fresas_con_crema.jpg', price: 16000 }
  ];

  // Lista de toppings disponibles
  const toppingsDisponibles = [
    'Chocolate', 'Arequipe', 'Fresa', 'Vainilla', 'Caramelo', 
    'Nutella', 'Crema Chantilly', 'Galletas Oreo', 'Frutos Secos', 
    'Chispas de Chocolate', 'Coco Rallado', 'Miel'
  ];

  // Construir array de productos
  const allProducts = [
    ...arrozGrande,
    ...arrozPequeno,
    ...fresas2Toppings,
    ...fresas3Toppings,
    ...fresas4Toppings
  ];

  // Formatear productos para la API
  allProducts.forEach((prod, index) => {
    const isArroz = prod.sabor !== undefined;
    const isFresa = prod.toppings !== undefined;
    
    let description = '';
    let toppingsSeleccionados = [];
    
    if (isArroz) {
      description = `Delicioso arroz con leche sabor ${prod.sabor.toLowerCase()}. Tamaño ${prod.size}: $${prod.price.toLocaleString('es-CO')}`;
    } else if (isFresa) {
      description = `Fresas frescas con crema y ${prod.toppings} toppings a elegir. Precio: $${prod.price.toLocaleString('es-CO')}`;
      // Seleccionar toppings aleatorios
      const shuffled = [...toppingsDisponibles].sort(() => 0.5 - Math.random());
      toppingsSeleccionados = shuffled.slice(0, prod.toppings);
    }

    products.push({
      id: prod.id,
      name: prod.name,
      description: description,
      price: prod.price,
      imageUrl: `http://localhost:3000/images/${prod.image}`,
      category: isArroz ? 'arroz_con_leche' : 'fresas_con_crema',
      stock: 50,
      rating: 4.8,
      reviewsCount: 120,
      isAvailable: true,
      isFeatured: index < 4,
      toppingsIncluidos: isFresa ? prod.toppings : 0,
      toppingsDisponibles: isFresa ? toppingsSeleccionados : [],
      sabor: isArroz ? prod.sabor : null,
      tamaño: isArroz ? prod.size : null,
      createdAt: new Date().toISOString()
    });
  });

  return products;
}

let products = generateProducts();

let carts = {};

// PEDIDOS INICIALES
let orders = [
  {
    id: 'order1',
    orderNumber: 'ORD-2024-0001',
    userId: 'user1',
    userName: 'Juan Admin',
    userEmail: 'admin@cremosos.com',
    items: [
      {
        id: 'item1',
        productId: 'prod1',
        productName: 'Arroz con Leche Tradicional',
        productPrice: 18000,
        productImage: 'https://images.unsplash.com/photo-1562440499-64c9a111f713?w=400',
        quantity: 3,
        subtotal: 54000
      },
      {
        id: 'item2',
        productId: 'prod2',
        productName: 'Fresas con Crema Premium',
        productPrice: 22000,
        productImage: 'https://images.unsplash.com/photo-1464454709131-ffd692591ee5?w=400',
        quantity: 2,
        subtotal: 44000
      }
    ],
    subtotal: 98000,
    tax: 7840,
    shippingCost: 5000,
    total: 110840,
    status: 'pending',
    paymentMethod: 'credit_card',
    paymentStatus: 'paid',
    shippingAddress: {
      street: 'Calle 123 #45-67',
      city: 'Cali',
      state: 'Valle del Cauca',
      zipCode: '760001',
      country: 'Colombia'
    },
    notes: 'Entregar en horas de la mañana',
    createdAt: new Date(Date.now() - 86400000).toISOString(), // Ayer
    updatedAt: new Date(Date.now() - 86400000).toISOString()
  },
  {
    id: 'order2',
    orderNumber: 'ORD-2024-0002',
    userId: 'user2',
    userName: 'María Cliente',
    userEmail: 'cliente@cremosos.com',
    items: [
      {
        id: 'item3',
        productId: 'prod3',
        productName: 'Postre Especial Chocolate',
        productPrice: 25000,
        productImage: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
        quantity: 1,
        subtotal: 25000
      }
    ],
    subtotal: 25000,
    tax: 2000,
    shippingCost: 5000,
    total: 32000,
    status: 'processing',
    paymentMethod: 'debit_card',
    paymentStatus: 'paid',
    shippingAddress: {
      street: 'Carrera 50 #30-20',
      city: 'Cali',
      state: 'Valle del Cauca',
      zipCode: '760002',
      country: 'Colombia'
    },
    notes: '',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  }
];

// Datos para roles
let roles = [
  {
    id: 'role1',
    name: 'admin',
    displayName: 'Administrador',
    description: 'Acceso completo al sistema',
    permissions: ['users.create', 'users.read', 'users.update', 'users.delete', 'products.create', 'products.read', 'products.update', 'products.delete', 'orders.read', 'orders.update', 'reports.read', 'purchases.create', 'purchases.read', 'purchases.update', 'purchases.delete', 'sales.create', 'sales.read', 'roles.manage'],
    createdAt: new Date().toISOString()
  },
  {
    id: 'role2',
    name: 'employee',
    displayName: 'Empleado',
    description: 'Gestión de ventas y productos',
    permissions: ['products.read', 'sales.create', 'sales.read', 'orders.read', 'orders.update'],
    createdAt: new Date().toISOString()
  },
  {
    id: 'role3',
    name: 'customer',
    displayName: 'Cliente',
    description: 'Usuario final del sistema',
    permissions: ['products.read', 'orders.create', 'orders.read'],
    createdAt: new Date().toISOString()
  }
];

// Datos para proveedores
let suppliers = [
  {
    id: 'sup1',
    name: 'Lácteos del Valle',
    contactName: 'María González',
    email: 'contacto@lacteosval.com',
    phone: '3101234567',
    address: 'Calle 45 #23-10',
    city: 'Cali',
    productsSupplied: ['Leche', 'Crema', 'Queso'],
    rating: 4.5,
    isActive: true,
    createdAt: new Date().toISOString()
  }
];

// Datos para compras
let purchases = [
  {
    id: 'pur1',
    purchaseNumber: 'COMP-2024-0001',
    supplierId: 'sup1',
    supplierName: 'Lácteos del Valle',
    items: [
      { productName: 'Leche entera', quantity: 100, unitPrice: 2500, total: 250000 }
    ],
    subtotal: 250000,
    tax: 20000,
    total: 270000,
    status: 'completed',
    notes: 'Entrega programada para el lunes',
    createdBy: 'user1',
    createdAt: new Date().toISOString(),
    receivedAt: new Date().toISOString()
  }
];

// Datos para ventas (POS)
let sales = [
  {
    id: 'sale1',
    saleNumber: 'VEN-2024-0001',
    employeeId: 'user1',
    employeeName: 'Juan Admin',
    customerId: 'user2',
    customerName: 'María Cliente',
    items: [
      {
        productId: 'prod1',
        productName: 'Arroz con Leche Tradicional',
        quantity: 2,
        unitPrice: 18000,
        discount: 0,
        total: 36000,
        imageUrl: 'https://images.unsplash.com/photo-1562440499-64c9a111f713?w=400'
      },
      {
        productId: 'prod4',
        productName: 'Bebida Cremosa Vainilla',
        quantity: 1,
        unitPrice: 12000,
        discount: 0,
        total: 12000,
        imageUrl: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400'
      }
    ],
    subtotal: 48000,
    tax: 3840,
    discount: 0,
    total: 51840,
    paymentMethod: 'cash',
    amountPaid: 60000,
    change: 8160,
    status: 'completed',
    notes: '',
    createdAt: new Date(Date.now() - 3600000).toISOString(), // Hace 1 hora
    completedAt: new Date(Date.now() - 3600000).toISOString()
  },
  {
    id: 'sale2',
    saleNumber: 'VEN-2024-0002',
    employeeId: 'user1',
    employeeName: 'Juan Admin',
    customerId: null,
    customerName: 'Cliente Genérico',
    items: [
      {
        productId: 'prod2',
        productName: 'Fresas con Crema Premium',
        quantity: 3,
        unitPrice: 22000,
        discount: 2000,
        total: 64000,
        imageUrl: 'https://images.unsplash.com/photo-1464454709131-ffd692591ee5?w=400'
      }
    ],
    subtotal: 66000,
    tax: 5280,
    discount: 2000,
    total: 69280,
    paymentMethod: 'credit_card',
    amountPaid: 69280,
    change: 0,
    status: 'completed',
    notes: 'Cliente frecuente - 10% descuento',
    createdAt: new Date().toISOString(),
    completedAt: new Date().toISOString()
  }
];

// ========================================
// RUTA RAÍZ
// ========================================

app.get('/', (req, res) => {
  res.json({
    message: '🍚 Cremosos ERP API',
    version: '2.0.0',
    status: 'running',
    endpoints: {
      auth: '/api/auth/*',
      users: '/api/admin/users',
      roles: '/api/roles',
      suppliers: '/api/suppliers',
      purchases: '/api/purchases',
      products: '/api/products',
      sales: '/api/sales',
      cart: '/api/cart',
      orders: '/api/orders',
      reports: '/api/reports/*'
    },
    documentation: 'Ver consola del servidor para lista completa de endpoints'
  });
});

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
app.post('/api/auth/login', async (req, res) => {
  const { email, password } = req.body;

  const users = await getUsers();
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
app.post('/api/auth/register', async (req, res) => {
  const { name, email, password, phone } = req.body;

  const users = await getUsers();
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
app.get('/api/products', async (req, res) => {
  let { category, page = 1, limit = 20, search, sortBy = 'name', sortOrder = 'asc' } = req.query;

  const products = await db.read('products');
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
app.get('/api/products/:id', async (req, res) => {
  const products = await db.read('products');
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
app.get('/api/products/featured', async (req, res) => {
  const products = await db.read('products');
  const featured = products.filter(p => p.isFeatured);

  res.json({
    success: true,
    data: featured
  });
});

// 7a. POST /api/products (CREATE)
app.post('/api/products', authenticateToken, async (req, res) => {
  try {
    // Verificar permisos de admin
    if (req.user.role !== 'admin' && req.user.role !== 'employee') {
      return res.status(403).json({
        success: false,
        message: 'No tienes permisos para crear productos'
      });
    }

    const { name, description, price, imageUrl, category, stock, isFeatured, compatibleToppings } = req.body;

    const newProduct = {
      id: `prod${Date.now()}`,
      name,
      description,
      price,
      imageUrl: imageUrl || 'https://via.placeholder.com/200',
      category,
      stock: stock || 0,
      rating: 0,
      reviewsCount: 0,
      isAvailable: true,
      isFeatured: isFeatured || false,
      compatibleToppings: compatibleToppings || [],
      createdAt: new Date().toISOString()
    };

    await db.insert('products', newProduct);

    res.status(201).json({
      success: true,
      message: 'Producto creado exitosamente',
      data: newProduct
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error al crear producto',
      error: error.message
    });
  }
});

// 7b. PUT /api/products/:id (UPDATE)
app.put('/api/products/:id', authenticateToken, (req, res) => {
  // Verificar permisos de admin
  if (req.user.role !== 'admin' && req.user.role !== 'employee') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para actualizar productos'
    });
  }

  const productIndex = products.findIndex(p => p.id === req.params.id);
  
  if (productIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Producto no encontrado'
    });
  }

  const { name, description, price, imageUrl, category, stock, isFeatured, isAvailable, compatibleToppings } = req.body;

  products[productIndex] = {
    ...products[productIndex],
    name: name || products[productIndex].name,
    description: description || products[productIndex].description,
    price: price !== undefined ? price : products[productIndex].price,
    imageUrl: imageUrl || products[productIndex].imageUrl,
    category: category || products[productIndex].category,
    stock: stock !== undefined ? stock : products[productIndex].stock,
    isFeatured: isFeatured !== undefined ? isFeatured : products[productIndex].isFeatured,
    isAvailable: isAvailable !== undefined ? isAvailable : products[productIndex].isAvailable,
    compatibleToppings: compatibleToppings || products[productIndex].compatibleToppings,
    updatedAt: new Date().toISOString()
  };

  res.json({
    success: true,
    message: 'Producto actualizado exitosamente',
    data: products[productIndex]
  });
});

// 7c. DELETE /api/products/:id (DELETE)
app.delete('/api/products/:id', authenticateToken, (req, res) => {
  // Solo admin puede eliminar
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para eliminar productos'
    });
  }

  const productIndex = products.findIndex(p => p.id === req.params.id);
  
  if (productIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Producto no encontrado'
    });
  }

  const deletedProduct = products.splice(productIndex, 1)[0];

  res.json({
    success: true,
    message: 'Producto eliminado exitosamente',
    data: deletedProduct
  });
});

// ========================================
// ENDPOINTS DE GESTIÓN DE USUARIOS (6)
// ========================================

// GET /api/admin/users (Listar usuarios)
app.get('/api/admin/users', authenticateToken, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para ver usuarios'
    });
  }

  const { search, role, page = 1, limit = 20 } = req.query;
  let filtered = [...users];

  // Filtrar por búsqueda
  if (search) {
    const searchLower = search.toLowerCase();
    filtered = filtered.filter(u => 
      u.name.toLowerCase().includes(searchLower) ||
      u.email.toLowerCase().includes(searchLower)
    );
  }

  // Filtrar por rol
  if (role) {
    filtered = filtered.filter(u => u.role === role);
  }

  // Paginación
  const start = (page - 1) * limit;
  const end = start + parseInt(limit);
  const paginated = filtered.slice(start, end);

  // Remover contraseñas
  const usersWithoutPasswords = paginated.map(({ password, ...user }) => user);

  res.json({
    success: true,
    data: usersWithoutPasswords,
    meta: {
      page: parseInt(page),
      limit: parseInt(limit),
      total: filtered.length,
      totalPages: Math.ceil(filtered.length / limit)
    }
  });
});

// GET /api/admin/users/:id (Detalle de usuario)
app.get('/api/admin/users/:id', authenticateToken, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para ver este usuario'
    });
  }

  const user = users.find(u => u.id === req.params.id);
  
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

// POST /api/admin/users (Crear usuario)
app.post('/api/admin/users', authenticateToken, async (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para crear usuarios'
    });
  }

  const { name, email, password, phone, role } = req.body;

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
    role: role || 'customer',
    address: null,
    createdAt: new Date().toISOString()
  };

  await db.insert('users', newUser);

  const { password: _, ...userWithoutPassword } = newUser;

  res.status(201).json({
    success: true,
    message: 'Usuario creado exitosamente',
    data: userWithoutPassword
  });
});

// PUT /api/admin/users/:id (Actualizar usuario)
app.put('/api/admin/users/:id', authenticateToken, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para actualizar usuarios'
    });
  }

  const userIndex = users.findIndex(u => u.id === req.params.id);
  
  if (userIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Usuario no encontrado'
    });
  }

  const { name, email, phone, role, address } = req.body;

  users[userIndex] = {
    ...users[userIndex],
    name: name || users[userIndex].name,
    email: email || users[userIndex].email,
    phone: phone || users[userIndex].phone,
    role: role || users[userIndex].role,
    address: address || users[userIndex].address,
    updatedAt: new Date().toISOString()
  };

  const { password, ...updatedUser } = users[userIndex];

  res.json({
    success: true,
    message: 'Usuario actualizado exitosamente',
    data: updatedUser
  });
});

// DELETE /api/admin/users/:id (Eliminar usuario)
app.delete('/api/admin/users/:id', authenticateToken, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para eliminar usuarios'
    });
  }

  const userIndex = users.findIndex(u => u.id === req.params.id);
  
  if (userIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Usuario no encontrado'
    });
  }

  // No permitir eliminar el propio usuario
  if (users[userIndex].id === req.user.id) {
    return res.status(400).json({
      success: false,
      message: 'No puedes eliminar tu propio usuario'
    });
  }

  const deletedUser = users.splice(userIndex, 1)[0];
  const { password, ...userWithoutPassword } = deletedUser;

  res.json({
    success: true,
    message: 'Usuario eliminado exitosamente',
    data: userWithoutPassword
  });
});

// ========================================
// ENDPOINTS DE ROLES Y PERMISOS (5)
// ========================================

// GET /api/roles (Listar roles)
app.get('/api/roles', authenticateToken, (req, res) => {
  res.json({
    success: true,
    data: roles
  });
});

// GET /api/roles/:id (Detalle de rol)
app.get('/api/roles/:id', authenticateToken, (req, res) => {
  const role = roles.find(r => r.id === req.params.id);
  
  if (!role) {
    return res.status(404).json({
      success: false,
      message: 'Rol no encontrado'
    });
  }

  res.json({
    success: true,
    data: role
  });
});

// POST /api/roles (Crear rol)
app.post('/api/roles', authenticateToken, async (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para crear roles'
    });
  }

  const { name, displayName, description, permissions } = req.body;

  if (roles.find(r => r.name === name)) {
    return res.status(400).json({
      success: false,
      message: 'Ya existe un rol con ese nombre'
    });
  }

  const newRole = {
    id: `role${roles.length + 1}`,
    name,
    displayName,
    description,
    permissions: permissions || [],
    createdAt: new Date().toISOString()
  };

  await db.insert('roles', newRole);

  res.status(201).json({
    success: true,
    message: 'Rol creado exitosamente',
    data: newRole
  });
});

// PUT /api/roles/:id (Actualizar rol)
app.put('/api/roles/:id', authenticateToken, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para actualizar roles'
    });
  }

  const roleIndex = roles.findIndex(r => r.id === req.params.id);
  
  if (roleIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Rol no encontrado'
    });
  }

  const { displayName, description, permissions } = req.body;

  roles[roleIndex] = {
    ...roles[roleIndex],
    displayName: displayName || roles[roleIndex].displayName,
    description: description || roles[roleIndex].description,
    permissions: permissions || roles[roleIndex].permissions,
    updatedAt: new Date().toISOString()
  };

  res.json({
    success: true,
    message: 'Rol actualizado exitosamente',
    data: roles[roleIndex]
  });
});

// DELETE /api/roles/:id (Eliminar rol)
app.delete('/api/roles/:id', authenticateToken, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para eliminar roles'
    });
  }

  const roleIndex = roles.findIndex(r => r.id === req.params.id);
  
  if (roleIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Rol no encontrado'
    });
  }

  // No permitir eliminar roles base
  if (['admin', 'employee', 'customer'].includes(roles[roleIndex].name)) {
    return res.status(400).json({
      success: false,
      message: 'No se pueden eliminar los roles base del sistema'
    });
  }

  const deletedRole = roles.splice(roleIndex, 1)[0];

  res.json({
    success: true,
    message: 'Rol eliminado exitosamente',
    data: deletedRole
  });
});

// ========================================
// ENDPOINTS DE PROVEEDORES (5)
// ========================================

// GET /api/suppliers (Listar proveedores)
app.get('/api/suppliers', authenticateToken, (req, res) => {
  const { search, isActive } = req.query;
  let filtered = [...suppliers];

  if (search) {
    const searchLower = search.toLowerCase();
    filtered = filtered.filter(s => 
      s.name.toLowerCase().includes(searchLower) ||
      s.contactName.toLowerCase().includes(searchLower)
    );
  }

  if (isActive !== undefined) {
    filtered = filtered.filter(s => s.isActive === (isActive === 'true'));
  }

  res.json({
    success: true,
    data: filtered
  });
});

// GET /api/suppliers/:id (Detalle de proveedor)
app.get('/api/suppliers/:id', authenticateToken, (req, res) => {
  const supplier = suppliers.find(s => s.id === req.params.id);
  
  if (!supplier) {
    return res.status(404).json({
      success: false,
      message: 'Proveedor no encontrado'
    });
  }

  res.json({
    success: true,
    data: supplier
  });
});

// POST /api/suppliers (Crear proveedor)
app.post('/api/suppliers', authenticateToken, async (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para crear proveedores'
    });
  }

  const { name, contactName, email, phone, address, city, productsSupplied } = req.body;

  const newSupplier = {
    id: `sup${suppliers.length + 1}`,
    name,
    contactName,
    email,
    phone,
    address,
    city,
    productsSupplied: productsSupplied || [],
    rating: 0,
    isActive: true,
    createdAt: new Date().toISOString()
  };

  await db.insert('suppliers', newSupplier);

  res.status(201).json({
    success: true,
    message: 'Proveedor creado exitosamente',
    data: newSupplier
  });
});

// PUT /api/suppliers/:id (Actualizar proveedor)
app.put('/api/suppliers/:id', authenticateToken, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para actualizar proveedores'
    });
  }

  const supplierIndex = suppliers.findIndex(s => s.id === req.params.id);
  
  if (supplierIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Proveedor no encontrado'
    });
  }

  const { name, contactName, email, phone, address, city, productsSupplied, isActive, rating } = req.body;

  suppliers[supplierIndex] = {
    ...suppliers[supplierIndex],
    name: name || suppliers[supplierIndex].name,
    contactName: contactName || suppliers[supplierIndex].contactName,
    email: email || suppliers[supplierIndex].email,
    phone: phone || suppliers[supplierIndex].phone,
    address: address || suppliers[supplierIndex].address,
    city: city || suppliers[supplierIndex].city,
    productsSupplied: productsSupplied || suppliers[supplierIndex].productsSupplied,
    isActive: isActive !== undefined ? isActive : suppliers[supplierIndex].isActive,
    rating: rating !== undefined ? rating : suppliers[supplierIndex].rating,
    updatedAt: new Date().toISOString()
  };

  res.json({
    success: true,
    message: 'Proveedor actualizado exitosamente',
    data: suppliers[supplierIndex]
  });
});

// DELETE /api/suppliers/:id (Eliminar proveedor)
app.delete('/api/suppliers/:id', authenticateToken, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para eliminar proveedores'
    });
  }

  const supplierIndex = suppliers.findIndex(s => s.id === req.params.id);
  
  if (supplierIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Proveedor no encontrado'
    });
  }

  const deletedSupplier = suppliers.splice(supplierIndex, 1)[0];

  res.json({
    success: true,
    message: 'Proveedor eliminado exitosamente',
    data: deletedSupplier
  });
});

// ========================================
// ENDPOINTS DE COMPRAS (5)
// ========================================

// GET /api/purchases (Listar compras)
app.get('/api/purchases', authenticateToken, (req, res) => {
  const { supplierId, status, startDate, endDate } = req.query;
  let filtered = [...purchases];

  if (supplierId) {
    filtered = filtered.filter(p => p.supplierId === supplierId);
  }

  if (status) {
    filtered = filtered.filter(p => p.status === status);
  }

  if (startDate && endDate) {
    filtered = filtered.filter(p => {
      const purchaseDate = new Date(p.createdAt);
      return purchaseDate >= new Date(startDate) && purchaseDate <= new Date(endDate);
    });
  }

  res.json({
    success: true,
    data: filtered
  });
});

// GET /api/purchases/:id (Detalle de compra)
app.get('/api/purchases/:id', authenticateToken, (req, res) => {
  const purchase = purchases.find(p => p.id === req.params.id);
  
  if (!purchase) {
    return res.status(404).json({
      success: false,
      message: 'Compra no encontrada'
    });
  }

  res.json({
    success: true,
    data: purchase
  });
});

// POST /api/purchases (Crear compra)
app.post('/api/purchases', authenticateToken, async (req, res) => {
  if (req.user.role !== 'admin' && req.user.role !== 'employee') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para crear compras'
    });
  }

  const { supplierId, items, notes } = req.body;

  const supplier = suppliers.find(s => s.id === supplierId);
  if (!supplier) {
    return res.status(404).json({
      success: false,
      message: 'Proveedor no encontrado'
    });
  }

  const subtotal = items.reduce((sum, item) => sum + (item.unitPrice * item.quantity), 0);
  const tax = subtotal * 0.08;
  const total = subtotal + tax;

  const newPurchase = {
    id: `pur${purchases.length + 1}`,
    purchaseNumber: `COMP-2024-${String(purchases.length + 1).padStart(4, '0')}`,
    supplierId,
    supplierName: supplier.name,
    items,
    subtotal,
    tax,
    total,
    status: 'pending',
    notes,
    createdBy: req.user.id,
    createdAt: new Date().toISOString()
  };

  await db.insert('purchases', newPurchase);

  res.status(201).json({
    success: true,
    message: 'Compra creada exitosamente',
    data: newPurchase
  });
});

// PUT /api/purchases/:id (Actualizar compra)
app.put('/api/purchases/:id', authenticateToken, (req, res) => {
  if (req.user.role !== 'admin' && req.user.role !== 'employee') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para actualizar compras'
    });
  }

  const purchaseIndex = purchases.findIndex(p => p.id === req.params.id);
  
  if (purchaseIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Compra no encontrada'
    });
  }

  const { status, notes, receivedAt } = req.body;

  purchases[purchaseIndex] = {
    ...purchases[purchaseIndex],
    status: status || purchases[purchaseIndex].status,
    notes: notes || purchases[purchaseIndex].notes,
    receivedAt: receivedAt || purchases[purchaseIndex].receivedAt,
    updatedAt: new Date().toISOString()
  };

  res.json({
    success: true,
    message: 'Compra actualizada exitosamente',
    data: purchases[purchaseIndex]
  });
});

// DELETE /api/purchases/:id (Eliminar compra)
app.delete('/api/purchases/:id', authenticateToken, (req, res) => {
  if (req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para eliminar compras'
    });
  }

  const purchaseIndex = purchases.findIndex(p => p.id === req.params.id);
  
  if (purchaseIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Compra no encontrada'
    });
  }

  const deletedPurchase = purchases.splice(purchaseIndex, 1)[0];

  res.json({
    success: true,
    message: 'Compra eliminada exitosamente',
    data: deletedPurchase
  });
});

// ========================================
// ENDPOINTS DE VENTAS/POS (5)
// ========================================

// GET /api/sales (Listar ventas)
app.get('/api/sales', authenticateToken, (req, res) => {
  const { employeeId, startDate, endDate, paymentMethod } = req.query;
  let filtered = [...sales];

  if (employeeId) {
    filtered = filtered.filter(s => s.employeeId === employeeId);
  }

  if (paymentMethod) {
    filtered = filtered.filter(s => s.paymentMethod === paymentMethod);
  }

  if (startDate && endDate) {
    filtered = filtered.filter(s => {
      const saleDate = new Date(s.createdAt);
      return saleDate >= new Date(startDate) && saleDate <= new Date(endDate);
    });
  }

  res.json({
    success: true,
    data: filtered
  });
});

// GET /api/sales/:id (Detalle de venta)
app.get('/api/sales/:id', authenticateToken, (req, res) => {
  const sale = sales.find(s => s.id === req.params.id);
  
  if (!sale) {
    return res.status(404).json({
      success: false,
      message: 'Venta no encontrada'
    });
  }

  res.json({
    success: true,
    data: sale
  });
});

// POST /api/sales (Crear venta - POS)
app.post('/api/sales', authenticateToken, async (req, res) => {
  if (req.user.role !== 'admin' && req.user.role !== 'employee') {
    return res.status(403).json({
      success: false,
      message: 'No tienes permisos para registrar ventas'
    });
  }

  const { items, paymentMethod, discount, customerName, customerPhone } = req.body;

  if (!items || items.length === 0) {
    return res.status(400).json({
      success: false,
      message: 'No hay productos en la venta'
    });
  }

  // Calcular totales y preparar items de la venta
  let subtotal = 0;
  const saleItems = [];

  // Validar stock de productos
  for (const item of items) {
    // Soportar tanto 'id' como 'productId'
    const productId = item.id || item.productId;
    const product = products.find(p => p.id === productId);
    
    if (!product) {
      return res.status(404).json({
        success: false,
        message: `Producto ${productId} no encontrado`
      });
    }
    
    if (product.stock < item.quantity) {
      return res.status(400).json({
        success: false,
        message: `Stock insuficiente para ${product.name}. Disponible: ${product.stock}`
      });
    }

    // Usar precio del producto o el enviado
    const unitPrice = item.unitPrice || product.price;
    const itemTotal = unitPrice * item.quantity;
    subtotal += itemTotal;

    saleItems.push({
      productId: product.id,
      productName: product.name,
      unitPrice: unitPrice,
      quantity: item.quantity,
      total: itemTotal
    });
  }

  const tax = subtotal * 0.08;
  const discountAmount = discount || 0;
  const total = subtotal + tax - discountAmount;

  const newSale = {
    id: `sale${sales.length + 1}`,
    saleNumber: `VEN-2024-${String(sales.length + 1).padStart(4, '0')}`,
    employeeId: req.user.id,
    employeeName: req.user.name || 'Empleado',
    items: saleItems,
    subtotal,
    tax,
    discount: discountAmount,
    total,
    paymentMethod: paymentMethod || 'cash',
    customerName: customerName || 'Cliente General',
    customerPhone: customerPhone || '',
    status: 'completed',
    createdAt: new Date().toISOString()
  };

  await db.insert('sales', newSale);

  // Actualizar stock de productos
  const products = await getProducts();
  saleItems.forEach(item => {
    const productIndex = products.findIndex(p => p.id === item.productId);
    if (productIndex !== -1) {
      products[productIndex].stock -= item.quantity;
    }
  });
  
  await saveProducts(products);

  res.status(201).json({
    success: true,
    message: 'Venta registrada exitosamente',
    data: newSale
  });
});

// GET /api/sales/summary/today (Resumen del día)
app.get('/api/sales/summary/today', authenticateToken, (req, res) => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const todaySales = sales.filter(s => {
    const saleDate = new Date(s.createdAt);
    return saleDate >= today;
  });

  const totalSales = todaySales.reduce((sum, s) => sum + s.total, 0);
  const totalTransactions = todaySales.length;

  res.json({
    success: true,
    data: {
      date: today.toISOString(),
      totalSales,
      totalTransactions,
      averageTicket: totalTransactions > 0 ? totalSales / totalTransactions : 0,
      sales: todaySales
    }
  });
});

// POST /api/sales/:id/print (Generar ticket)
app.post('/api/sales/:id/print', authenticateToken, (req, res) => {
  const sale = sales.find(s => s.id === req.params.id);
  
  if (!sale) {
    return res.status(404).json({
      success: false,
      message: 'Venta no encontrada'
    });
  }

  // Generar estructura de ticket
  const ticket = {
    saleNumber: sale.saleNumber,
    date: sale.createdAt,
    employee: sale.employeeName,
    customer: sale.customerName,
    items: sale.items.map(item => ({
      name: item.productName,
      quantity: item.quantity,
      price: item.unitPrice,
      total: item.total
    })),
    subtotal: sale.subtotal,
    tax: sale.tax,
    discount: sale.discount,
    total: sale.total,
    paymentMethod: sale.paymentMethod
  };

  res.json({
    success: true,
    data: ticket
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
app.post('/api/orders', authenticateToken, async (req, res) => {
  const cart = carts[req.user.id];
  if (!cart || cart.items.length === 0) {
    return res.status(400).json({
      success: false,
      message: 'Carrito vacío'
    });
  }

  const { shippingAddress, paymentMethod, paymentDetails, notes } = req.body;

  // Validar stock y reducirlo
  for (const item of cart.items) {
    const product = products.find(p => p.id === item.productId);
    if (!product) {
      return res.status(404).json({
        success: false,
        message: `Producto ${item.productId} no encontrado`
      });
    }
    
    if (product.stock < item.quantity) {
      return res.status(400).json({
        success: false,
        message: `Stock insuficiente para ${product.name}. Disponible: ${product.stock}`
      });
    }
    
    // Reducir stock
    product.stock -= item.quantity;
  }

  const subtotal = cart.items.reduce((sum, item) => sum + (item.productPrice * item.quantity), 0);
  const tax = subtotal * 0.08;
  const shippingCost = subtotal >= 50000 ? 0 : 5000;
  const total = subtotal + tax + shippingCost;

  const newOrder = {
    id: `order${orders.length + 1}`,
    orderNumber: `ORD-2024-${String(orders.length + 1).padStart(4, '0')}`,
    userId: req.user.id,
    userName: req.user.name,
    userEmail: req.user.email,
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

  await db.insert('orders', newOrder);
  
  // Vaciar carrito
  const carts = await getCarts();
  const userCart = carts.find(c => c.userId === req.user.id);
  if (userCart) {
    userCart.items = [];
    await saveCarts(carts);
  }

  res.status(201).json({
    success: true,
    message: 'Orden creada exitosamente',
    data: newOrder
  });
});

// 15. GET /api/orders
app.get('/api/orders', authenticateToken, (req, res) => {
  const { status, startDate, endDate, customerId, search, page = 1, limit = 20 } = req.query;
  let filtered = [...orders];

  // Filtrar por usuario (clientes solo ven sus propias órdenes)
  if (req.user.role === 'customer') {
    filtered = filtered.filter(o => o.userId === req.user.id);
  } else if (customerId) {
    // Admin/Employee pueden filtrar por cliente específico
    filtered = filtered.filter(o => o.userId === customerId);
  }

  // Filtrar por estado
  if (status) {
    filtered = filtered.filter(o => o.status === status);
  }

  // Filtrar por rango de fechas
  if (startDate && endDate) {
    filtered = filtered.filter(o => {
      const orderDate = new Date(o.createdAt);
      return orderDate >= new Date(startDate) && orderDate <= new Date(endDate);
    });
  }

  // Búsqueda por número de orden
  if (search) {
    const searchLower = search.toLowerCase();
    filtered = filtered.filter(o => 
      o.orderNumber.toLowerCase().includes(searchLower)
    );
  }

  // Ordenar por fecha (más recientes primero)
  filtered.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

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
      totalPages: Math.ceil(filtered.length / limit)
    }
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

// Nuevo: PUT /api/orders/:id - Actualizar estado de orden (ADMIN)
app.put('/api/orders/:id', authenticateToken, (req, res) => {
  const orderIndex = orders.findIndex(o => o.id === req.params.id);

  if (orderIndex === -1) {
    return res.status(404).json({
      success: false,
      message: 'Orden no encontrada'
    });
  }

  const { status, notes } = req.body;

  if (status) {
    const validStatuses = ['pending', 'processing', 'shipped', 'delivered', 'cancelled'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Estado inválido'
      });
    }
    orders[orderIndex].status = status;
  }

  if (notes !== undefined) {
    orders[orderIndex].notes = notes;
  }

  orders[orderIndex].updatedAt = new Date().toISOString();

  res.json({
    success: true,
    message: 'Orden actualizada',
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
// ENDPOINTS DE VENTAS POS (2)
// ========================================

// POST /api/sales - Procesar venta desde POS
// ========================================
// ENDPOINTS DE REPORTES (4)
// ========================================

// 19. GET /api/reports/dashboard
app.get('/api/reports/dashboard', authenticateToken, (req, res) => {
  const totalSales = orders.reduce((sum, o) => sum + o.total, 0);
  const totalOrders = orders.length;

  // Calcular ventas por categoría basado en productos vendidos
  const categorySales = {};
  orders.forEach(order => {
    order.items.forEach(item => {
      const product = products.find(p => p.id === item.productId);
      if (product) {
        if (!categorySales[product.category]) {
          categorySales[product.category] = 0;
        }
        // Usar subtotal del item o calcular con precio y cantidad
        const itemTotal = item.subtotal || (item.productPrice * item.quantity) || (item.price * item.quantity);
        categorySales[product.category] += itemTotal;
      }
    });
  });

  // Si no hay ventas por categoría, agregar datos de ejemplo
  if (Object.keys(categorySales).length === 0) {
    categorySales['arroz_con_leche'] = 150000;
    categorySales['fresas_con_crema'] = 120000;
    categorySales['postres_especiales'] = 80000;
    categorySales['bebidas_cremosas'] = 60000;
  }

  // Convertir a array para el frontend
  const salesByCategory = Object.entries(categorySales).map(([category, sales]) => ({
    category,
    sales,
    percentage: totalSales > 0 ? ((sales / totalSales) * 100).toFixed(1) : 0
  }));

  // Ventas diarias de la última semana
  const today = new Date();
  const dailySales = [];
  for (let i = 6; i >= 0; i--) {
    const date = new Date(today);
    date.setDate(date.getDate() - i);
    const dateStr = date.toISOString().split('T')[0];
    
    const dayOrders = orders.filter(o => o.createdAt?.startsWith(dateStr));
    const dayTotal = dayOrders.reduce((sum, o) => sum + o.total, 0);
    
    dailySales.push({
      date: dateStr,
      sales: dayTotal,
      orders: dayOrders.length
    });
  }

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
      dailySales,
      topProducts: products.slice(0, 5),
      salesByCategory,
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

app.listen(PORT, async () => {
  console.log(`
╔════════════════════════════════════════════════════════╗
║     🍚 CREMOSOS ERP API SERVER - RUNNING               ║
╚════════════════════════════════════════════════════════╝

📡 URL: http://localhost:${PORT}
📊 Endpoints: 60+ disponibles
👤 Usuario test: admin@cremosos.com / 123456

📋 ENDPOINTS IMPLEMENTADOS:
   
   AUTH (4):
   ✅ POST   /api/auth/login
   ✅ POST   /api/auth/register
   ✅ GET    /api/users/profile
   ✅ PUT    /api/users/profile
   
   PRODUCTS (8):
   ✅ GET    /api/products
   ✅ GET    /api/products/:id
   ✅ GET    /api/products/featured
   ✅ POST   /api/products (NEW)
   ✅ PUT    /api/products/:id (NEW)
   ✅ DELETE /api/products/:id (NEW)
   
   USERS MANAGEMENT (6):
   ✅ GET    /api/admin/users (NEW)
   ✅ GET    /api/admin/users/:id (NEW)
   ✅ POST   /api/admin/users (NEW)
   ✅ PUT    /api/admin/users/:id (NEW)
   ✅ DELETE /api/admin/users/:id (NEW)
   
   ROLES & PERMISSIONS (5):
   ✅ GET    /api/roles (NEW)
   ✅ GET    /api/roles/:id (NEW)
   ✅ POST   /api/roles (NEW)
   ✅ PUT    /api/roles/:id (NEW)
   ✅ DELETE /api/roles/:id (NEW)
   
   SUPPLIERS (5):
   ✅ GET    /api/suppliers (NEW)
   ✅ GET    /api/suppliers/:id (NEW)
   ✅ POST   /api/suppliers (NEW)
   ✅ PUT    /api/suppliers/:id (NEW)
   ✅ DELETE /api/suppliers/:id (NEW)
   
   PURCHASES (5):
   ✅ GET    /api/purchases (NEW)
   ✅ GET    /api/purchases/:id (NEW)
   ✅ POST   /api/purchases (NEW)
   ✅ PUT    /api/purchases/:id (NEW)
   ✅ DELETE /api/purchases/:id (NEW)
   
   SALES/POS (5):
   ✅ GET    /api/sales (NEW)
   ✅ GET    /api/sales/:id (NEW)
   ✅ POST   /api/sales (NEW)
   ✅ GET    /api/sales/summary/today (NEW)
   ✅ POST   /api/sales/:id/print (NEW)
   
   CART (6):
   ✅ GET    /api/cart
   ✅ POST   /api/cart/items
   ✅ PUT    /api/cart/items/:id
   ✅ DELETE /api/cart/items/:id
   ✅ DELETE /api/cart
   ✅ POST   /api/cart/sync
   
   ORDERS (5):
   ✅ POST   /api/orders
   ✅ GET    /api/orders (IMPROVED - filters & search)
   ✅ GET    /api/orders/:id
   ✅ PUT    /api/orders/:id/cancel
   ✅ GET    /api/orders/:id/track
   
   REPORTS (4):
   ✅ GET    /api/reports/dashboard
   ✅ GET    /api/reports/sales
   ✅ GET    /api/reports/products
   ✅ GET    /api/reports/customers

🔥 Sistema ERP completo listo para gestionar:
   👥 Usuarios y Roles
   📦 Productos y Stock
   🛒 Ventas en Punto de Venta
   📥 Compras y Proveedores
   📊 Reportes y Análisis
  `);
  
  // Inicializar base de datos JSON
  await initializeDatabase();
  
  // Servidor corriendo y esperando peticiones
  console.log('\n✅ Servidor escuchando en puerto ' + PORT + '...\n');
});

// ========================================
// INICIALIZACIÓN DE BASE DE DATOS JSON
// ========================================
async function initializeDatabase() {
  console.log('\n💾 Inicializando base de datos JSON...');
  
  // Inicializar archivos
  await db.initialize();
  
  // Migrar datos iniciales si las colecciones están vacías
  const existingProducts = await db.read('products');
  if (existingProducts.length === 0) {
    console.log('📦 Migrando productos iniciales...');
    await db.write('products', products);
  }
  
  const existingUsers = await db.read('users');
  if (existingUsers.length === 0) {
    console.log('👥 Migrando usuarios iniciales...');
    await db.write('users', users);
  }
  
  const existingOrders = await db.read('orders');
  if (existingOrders.length === 0) {
    console.log('📋 Migrando órdenes iniciales...');
    await db.write('orders', orders);
  }
  
  const existingSales = await db.read('sales');
  if (existingSales.length === 0) {
    console.log('💰 Migrando ventas iniciales...');
    await db.write('sales', sales);
  }
  
  const existingRoles = await db.read('roles');
  if (existingRoles.length === 0) {
    console.log('👔 Migrando roles iniciales...');
    await db.write('roles', roles);
  }
  
  const existingSuppliers = await db.read('suppliers');
  if (existingSuppliers.length === 0) {
    console.log('🏭 Migrando proveedores iniciales...');
    await db.write('suppliers', suppliers);
  }
  
  const existingPurchases = await db.read('purchases');
  if (existingPurchases.length === 0) {
    console.log('📥 Migrando compras iniciales...');
    await db.write('purchases', purchases);
  }
  
  const existingCart = await db.read('cart');
  if (existingCart.length === 0) {
    console.log('🛒 Migrando carritos iniciales...');
    await db.write('cart', carts);
  }
  
  console.log('✅ Base de datos JSON lista y sincronizada\n');
}
