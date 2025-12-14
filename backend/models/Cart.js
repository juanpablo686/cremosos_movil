// Importar Mongoose para definir esquemas de MongoDB
const mongoose = require('mongoose');

// Definir el esquema de Carrito de Compras
// Cada usuario tiene un carrito que persiste entre sesiones
const cartSchema = new mongoose.Schema({
  // ID del usuario dueño del carrito
  userId: {
    type: String,
    required: true,
    unique: true          // Cada usuario tiene solo un carrito
  },
  // Lista de productos en el carrito
  items: [{
    id: String,                 // ID único del item en el carrito
    productId: String,          // ID del producto
    productName: String,        // Nombre del producto
    productImage: String,       // URL de la imagen del producto
    productPrice: Number,       // Precio unitario del producto
    quantity: Number,           // Cantidad seleccionada
    toppings: [String],        // Toppings seleccionados (para fresas con crema)
    createdAt: Date            // Fecha cuando se agregó al carrito
  }],
  // Fecha de última actualización del carrito
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

// Exportar el modelo Cart basado en el esquema
// Mongoose creará automáticamente la colección 'carts' en MongoDB
module.exports = mongoose.model('Cart', cartSchema);
