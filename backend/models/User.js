// Importar Mongoose para definir esquemas de MongoDB
const mongoose = require('mongoose');

// Definir el esquema de Usuario
// Un esquema define la estructura de los documentos en la colección
const userSchema = new mongoose.Schema({
  // Email del usuario
  email: {
    type: String,
    required: true,        // Campo obligatorio
    unique: true,          // No puede haber dos usuarios con el mismo email
    lowercase: true,       // Convertir a minúsculas automáticamente
    trim: true            // Eliminar espacios en blanco al inicio y final
  },
  // Contraseña del usuario (en texto plano por ahora, en producción usar bcrypt)
  password: {
    type: String,
    required: true
  },
  // Nombre completo del usuario
  name: {
    type: String,
    required: true
  },
  // Número de teléfono del usuario
  phone: {
    type: String,
    default: ''           // Valor por defecto si no se proporciona
  },
  // Rol del usuario en el sistema
  role: {
    type: String,
    enum: ['admin', 'customer', 'employee'],  // Solo estos valores son válidos
    default: 'customer'                        // Por defecto todos son clientes
  },
  // Dirección de envío del usuario
  address: {
    street: String,       // Calle y número
    city: String,         // Ciudad
    state: String,        // Departamento o estado
    zipCode: String,      // Código postal
    country: { type: String, default: 'Colombia' }  // País (por defecto Colombia)
  },
  // Fecha de creación del usuario
  createdAt: {
    type: Date,
    default: Date.now     // Automáticamente la fecha actual
  }
});

// Exportar el modelo User basado en el esquema
// Mongoose creará automáticamente la colección 'users' en MongoDB
module.exports = mongoose.model('User', userSchema);
