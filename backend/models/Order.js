// Importar Mongoose para definir esquemas de MongoDB
const mongoose = require('mongoose');

// Definir el esquema de Orden/Pedido
// Representa los pedidos realizados por los clientes
const orderSchema = new mongoose.Schema({
  // Número único del pedido (ej: ORD-1001)
  orderNumber: {
    type: String,
    required: true,
    unique: true          // Cada pedido tiene un número único
  },
  // ID del usuario que realizó el pedido
  userId: {
    type: String,
    required: true
  },
  // Email del usuario (para enviar confirmaciones)
  userEmail: String,
  // Nombre del usuario
  userName: String,
  // Lista de productos en el pedido
  items: [{
    id: String,                 // ID del item en el carrito
    productId: String,          // ID del producto
    productName: String,        // Nombre del producto
    productImage: String,       // Imagen del producto
    productPrice: Number,       // Precio unitario
    quantity: Number,           // Cantidad ordenada
    toppings: [String],        // Toppings seleccionados (para fresas)
    createdAt: Date            // Fecha de agregado al carrito
  }],
  // Dirección de envío del pedido
  shippingAddress: {
    street: String,             // Calle y número
    city: String,               // Ciudad
    state: String,              // Departamento
    zipCode: String,            // Código postal
    country: String             // País
  },
  // Información de pago del pedido
  paymentInfo: {
    method: String,             // Método de pago (tarjeta, efectivo, etc.)
    transactionId: String,      // ID de la transacción
    status: String,             // Estado del pago (pagado, pendiente, etc.)
    paidAt: Date               // Fecha de pago
  },
  // Subtotal del pedido (suma de productos sin impuestos ni envío)
  subtotal: Number,
  // Impuestos aplicados al pedido
  tax: Number,
  // Costo de envío
  shippingCost: Number,
  // Descuento aplicado al pedido
  discount: {
    type: Number,
    default: 0
  },
  // Total a pagar (subtotal + tax + shippingCost - discount)
  total: Number,
  // Estado actual del pedido
  status: {
    type: String,
    // Solo estos estados son válidos
    enum: ['pending', 'processing', 'shipped', 'delivered', 'cancelled'],
    default: 'pending'        // Por defecto el pedido está pendiente
  },
  // Notas adicionales del cliente o administrador
  notes: String,
  // Información de seguimiento del pedido
  tracking: {
    events: [{                // Historial de eventos del pedido
      status: String,         // Estado en ese momento
      description: String,    // Descripción del evento
      timestamp: Date        // Fecha y hora del evento
    }]
  },
  // Fecha estimada de entrega
  estimatedDelivery: Date,
  // Fecha de creación del pedido
  createdAt: {
    type: Date,
    default: Date.now
  },
  // Fecha de última actualización del pedido
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

// Exportar el modelo Order basado en el esquema
// Mongoose creará automáticamente la colección 'orders' en MongoDB
module.exports = mongoose.model('Order', orderSchema);
