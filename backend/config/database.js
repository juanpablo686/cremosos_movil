// Importar librería Mongoose para trabajar con MongoDB
const mongoose = require('mongoose');

// Función asíncrona para establecer conexión con MongoDB Atlas
// Esta función se ejecuta al iniciar el servidor
const connectDB = async () => {
  try {
    // Intentar conectar a MongoDB usando la URI del archivo .env
    // MONGODB_URI contiene la URL completa de conexión a MongoDB Atlas
    const conn = await mongoose.connect(process.env.MONGODB_URI, {
      serverSelectionTimeoutMS: 5000, // Timeout de 5 segundos
      socketTimeoutMS: 45000,
    });

    // Mostrar mensaje de éxito con el host de la base de datos
    console.log(`✅ MongoDB conectado: ${conn.connection.host}`);
    // Mostrar el nombre de la base de datos utilizada
    console.log(`📊 Base de datos: ${conn.connection.name}`);
  } catch (error) {
    // Si hay error en la conexión, mostrar mensaje de advertencia
    console.error(`\n⚠️  ADVERTENCIA: No se pudo conectar a MongoDB`);
    console.error(`❌ Error: ${error.message}`);
    console.error(`\n💡 SOLUCIÓN:`);
    console.error(`   1. Verifica que tu IP esté en la whitelist de MongoDB Atlas`);
    console.error(`   2. Ve a https://cloud.mongodb.com → Network Access`);
    console.error(`   3. Agrega tu IP actual o usa 0.0.0.0/0 para permitir todas`);
    console.error(`\n⚠️  El servidor continuará pero NO guardará datos en MongoDB\n`);
    // NO detenemos el servidor, solo advertimos
  }
};

// Exportar la función para usarla en server.js
module.exports = connectDB;
