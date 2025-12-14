// Script para verificar datos en MongoDB
require('dotenv').config();
const mongoose = require('mongoose');
const User = require('./models/User');
const Product = require('./models/Product');

async function checkData() {
  try {
    console.log('🔌 Conectando a MongoDB...');
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✅ Conectado a MongoDB Atlas\n');
    
    // Verificar usuarios
    const users = await User.find().select('name email role');
    console.log(`📊 USUARIOS EN MONGODB: ${users.length} usuarios`);
    users.forEach(u => {
      console.log(`   - ${u.name} (${u.email}) - ${u.role}`);
    });
    
    // Verificar productos
    const products = await Product.find().select('name price category');
    console.log(`\n📦 PRODUCTOS EN MONGODB: ${products.length} productos`);
    products.slice(0, 8).forEach(p => {
      console.log(`   - ${p.name} - $${p.price} (${p.category})`);
    });
    
    await mongoose.disconnect();
    console.log('\n✅ Verificación completada');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

checkData();
