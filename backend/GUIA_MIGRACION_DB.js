// ========================================
// GUÍA DE MIGRACIÓN A BASE DE DATOS JSON
// ========================================
// Este archivo muestra ejemplos de cómo reemplazar las operaciones 
// en memoria por operaciones con la base de datos JSON persistente.

// ANTES (en memoria - se pierde al reiniciar):
// products.push(newProduct);

// DESPUÉS (persistente - se guarda en disco):
// await db.insert('products', newProduct);

// ========================================
// EJEMPLO 1: CREAR PRODUCTO
// ========================================
app.post('/api/products', authenticateToken, async (req, res) => {
  try {
    if (req.user.role !== 'admin' && req.user.role !== 'employee') {
      return res.status(403).json({
        success: false,
        message: 'No tienes permisos para crear productos'
      });
    }

    const { name, description, price, imageUrl, category, stock, isFeatured, compatibleToppings } = req.body;

    // Obtener productos para generar ID
    const products = await db.read('products');
    
    const newProduct = {
      id: `prod${Date.now()}`, // ID único basado en timestamp
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

    // GUARDAR EN BASE DE DATOS JSON
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

// ========================================
// EJEMPLO 2: ACTUALIZAR PRODUCTO
// ========================================
app.put('/api/products/:id', authenticateToken, async (req, res) => {
  try {
    if (req.user.role !== 'admin' && req.user.role !== 'employee') {
      return res.status(403).json({
        success: false,
        message: 'No tienes permisos para actualizar productos'
      });
    }

    const updates = {
      name: req.body.name,
      description: req.body.description,
      price: req.body.price,
      imageUrl: req.body.imageUrl,
      category: req.body.category,
      stock: req.body.stock,
      isFeatured: req.body.isFeatured,
      isAvailable: req.body.isAvailable,
      compatibleToppings: req.body.compatibleToppings
    };

    // ACTUALIZAR EN BASE DE DATOS JSON
    const updatedProduct = await db.update('products', req.params.id, updates);

    res.json({
      success: true,
      message: 'Producto actualizado exitosamente',
      data: updatedProduct
    });
  } catch (error) {
    if (error.message.includes('no encontrado')) {
      return res.status(404).json({
        success: false,
        message: 'Producto no encontrado'
      });
    }
    res.status(500).json({
      success: false,
      message: 'Error al actualizar producto',
      error: error.message
    });
  }
});

// ========================================
// EJEMPLO 3: ELIMINAR PRODUCTO
// ========================================
app.delete('/api/products/:id', authenticateToken, async (req, res) => {
  try {
    if (req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'No tienes permisos para eliminar productos'
      });
    }

    // ELIMINAR DE BASE DE DATOS JSON
    await db.delete('products', req.params.id);

    res.json({
      success: true,
      message: 'Producto eliminado exitosamente'
    });
  } catch (error) {
    if (error.message.includes('no encontrado')) {
      return res.status(404).json({
        success: false,
        message: 'Producto no encontrado'
      });
    }
    res.status(500).json({
      success: false,
      message: 'Error al eliminar producto',
      error: error.message
    });
  }
});

// ========================================
// EJEMPLO 4: LISTAR PRODUCTOS
// ========================================
app.get('/api/products', async (req, res) => {
  try {
    const { category, search, minPrice, maxPrice, featured, page = 1, limit = 20 } = req.query;

    // LEER DE BASE DE DATOS JSON
    let products = await db.read('products');

    // Filtros
    if (category && category !== 'all') {
      products = products.filter(p => p.category === category);
    }

    if (search) {
      const searchLower = search.toLowerCase();
      products = products.filter(p =>
        p.name.toLowerCase().includes(searchLower) ||
        p.description.toLowerCase().includes(searchLower)
      );
    }

    if (minPrice) {
      products = products.filter(p => p.price >= parseFloat(minPrice));
    }

    if (maxPrice) {
      products = products.filter(p => p.price <= parseFloat(maxPrice));
    }

    if (featured === 'true') {
      products = products.filter(p => p.isFeatured);
    }

    // Paginación
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + parseInt(limit);
    const paginatedProducts = products.slice(startIndex, endIndex);

    res.json({
      success: true,
      data: paginatedProducts,
      meta: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: products.length,
        totalPages: Math.ceil(products.length / limit)
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error al obtener productos',
      error: error.message
    });
  }
});

// ========================================
// EJEMPLO 5: CREAR VENTA (POS)
// ========================================
app.post('/api/sales', authenticateToken, async (req, res) => {
  try {
    const { items, paymentMethod, customerName, customerEmail } = req.body;

    if (!items || items.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'No hay items en la venta'
      });
    }

    // Calcular total
    let subtotal = 0;
    const saleItems = [];

    for (const item of items) {
      const productId = item.id || item.productId;
      const product = await db.findById('products', productId);

      if (!product) {
        return res.status(404).json({
          success: false,
          message: `Producto ${productId} no encontrado`
        });
      }

      if (product.stock < item.quantity) {
        return res.status(400).json({
          success: false,
          message: `Stock insuficiente para ${product.name}`
        });
      }

      const itemSubtotal = product.price * item.quantity;
      subtotal += itemSubtotal;

      saleItems.push({
        productId: product.id,
        productName: product.name,
        productPrice: product.price,
        quantity: item.quantity,
        subtotal: itemSubtotal
      });

      // Actualizar stock
      await db.update('products', product.id, {
        stock: product.stock - item.quantity
      });
    }

    const tax = subtotal * 0.19;
    const total = subtotal + tax;

    const newSale = {
      id: `sale${Date.now()}`,
      userId: req.user.id,
      userName: req.user.name,
      items: saleItems,
      subtotal,
      tax,
      total,
      paymentMethod: paymentMethod || 'cash',
      status: 'completed',
      customerName: customerName || req.user.name,
      customerEmail: customerEmail || req.user.email,
      createdAt: new Date().toISOString()
    };

    // GUARDAR VENTA EN BASE DE DATOS JSON
    await db.insert('sales', newSale);

    res.status(201).json({
      success: true,
      message: 'Venta procesada exitosamente',
      data: newSale
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error al procesar venta',
      error: error.message
    });
  }
});

// ========================================
// RESUMEN DE OPERACIONES DISPONIBLES
// ========================================
/*
await db.read('products')              // Leer todos los productos
await db.insert('products', producto)   // Agregar nuevo producto
await db.update('products', id, datos)  // Actualizar producto
await db.delete('products', id)         // Eliminar producto
await db.findById('products', id)       // Buscar por ID
await db.find('products', filtro)       // Buscar con filtro
await db.count('products')              // Contar productos
await db.write('products', array)       // Reemplazar todos

COLECCIONES DISPONIBLES:
- 'products'
- 'users'
- 'orders'
- 'sales'
- 'cart'
- 'roles'
- 'suppliers'
- 'purchases'
*/
