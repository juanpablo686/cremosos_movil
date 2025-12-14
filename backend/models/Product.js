// Importar Mongoose para definir esquemas de MongoDB
const mongoose = require('mongoose');

// Definir el esquema de Producto
// Representa los productos de Cremosos (arroz con leche y fresas con crema)
const productSchema = new mongoose.Schema({
  // Nombre del producto
  name: {
    type: String,
    required: true        // Campo obligatorio
  },
  // Descripción detallada del producto
  description: String,
  // Precio del producto en pesos colombianos
  price: {
    type: Number,
    required: true
  },
  // URL de la imagen del producto
  imageUrl: String,
  // Categoría del producto (arroz con leche, fresas con crema, etc.)
  category: {
    type: String,
    required: true
  },
  // Cantidad disponible en inventario
  stock: {
    type: Number,
    default: 0
  },
  // Calificación promedio del producto (0-5 estrellas)
  rating: {
    type: Number,
    default: 0,
    min: 0,               // Mínimo 0 estrellas
    max: 5                // Máximo 5 estrellas
  },
  // Número total de reseñas del producto
  reviewsCount: {
    type: Number,
    default: 0
  },
  // Indica si el producto está disponible para la venta
  isAvailable: {
    type: Boolean,
    default: true
  },
  // Indica si el producto se muestra como destacado en la página principal
  isFeatured: {
    type: Boolean,
    default: false
  },
  // Campos específicos para productos de fresas con crema
  toppingsIncluidos: Number,        // Número de toppings incluidos
  toppingsDisponibles: [String],    // Lista de toppings disponibles
  // Campos específicos para arroz con leche
  sabor: String,                    // Sabor del arroz (tradicional, arequipe, etc.)
  tamaño: String,                   // Tamaño del producto (grande, mediano, pequeño)
  // Fecha de creación del producto
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Exportar el modelo Product basado en el esquema
// Mongoose creará automáticamente la colección 'products' en MongoDB
module.exports = mongoose.model('Product', productSchema);
