// Script para ver todos los datos guardados en MongoDB
// Ejecutar con: node ver-datos-mongo.js

require('dotenv').config();
const mongoose = require('mongoose');

const User = require('./models/User');
const Product = require('./models/Product');
const Order = require('./models/Order');
const Cart = require('./models/Cart');

async function verDatos() {
  try {
    // Conectar a MongoDB
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✅ Conectado a MongoDB\n');

    // Ver usuarios
    console.log('👥 USUARIOS REGISTRADOS:');
    console.log('========================');
    const users = await User.find({});
    users.forEach(user => {
      console.log(`- Email: ${user.email}`);
      console.log(`  Nombre: ${user.name}`);
      console.log(`  Rol: ${user.role}`);
      console.log(`  Creado: ${user.createdAt}`);
      console.log('');
    });
    console.log(`Total: ${users.length} usuarios\n`);

    // Ver productos
    console.log('📦 PRODUCTOS EN CATÁLOGO:');
    console.log('========================');
    const products = await Product.find({});
    products.forEach(product => {
      console.log(`- ${product.name}`);
      console.log(`  Precio: $${product.price.toLocaleString('es-CO')}`);
      console.log(`  Categoría: ${product.category}`);
      console.log(`  Stock: ${product.stock}`);
      console.log('');
    });
    console.log(`Total: ${products.length} productos\n`);

    // Ver órdenes
    console.log('🛒 ÓRDENES/PEDIDOS CREADOS:');
    console.log('===========================');
    const orders = await Order.find({}).sort({ createdAt: -1 });
    if (orders.length === 0) {
      console.log('No hay órdenes creadas aún\n');
    } else {
      orders.forEach(order => {
        console.log(`- Orden: ${order.orderNumber}`);
        console.log(`  Usuario: ${order.userName} (${order.userEmail})`);
        console.log(`  Total: $${order.total?.toLocaleString('es-CO')}`);
        console.log(`  Estado: ${order.status}`);
        console.log(`  Items: ${order.items?.length || 0} productos`);
        console.log(`  Fecha: ${order.createdAt}`);
        console.log('');
      });
      console.log(`Total: ${orders.length} órdenes\n`);
    }

    // Ver carritos
    console.log('🛍️ CARRITOS ACTIVOS:');
    console.log('====================');
    const carts = await Cart.find({});
    if (carts.length === 0) {
      console.log('No hay carritos activos\n');
    } else {
      carts.forEach(cart => {
        console.log(`- Usuario ID: ${cart.userId}`);
        console.log(`  Items en carrito: ${cart.items?.length || 0}`);
        console.log(`  Última actualización: ${cart.updatedAt}`);
        console.log('');
      });
      console.log(`Total: ${carts.length} carritos\n`);
    }

    console.log('✅ Todos los datos están en MongoDB Atlas');
    console.log('🌐 Puedes verlos también en: https://cloud.mongodb.com/');
    
    await mongoose.connection.close();
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

verDatos();
