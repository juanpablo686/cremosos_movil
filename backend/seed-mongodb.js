require('dotenv').config();
const mongoose = require('mongoose');
const User = require('./models/User');
const Product = require('./models/Product');
const bcrypt = require('bcryptjs');

const seedDatabase = async () => {
  try {
    console.log('🌱 Iniciando población de base de datos...');
    
    // Conectar a MongoDB
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✅ Conectado a MongoDB');

    // Limpiar colecciones existentes
    await User.deleteMany({});
    await Product.deleteMany({});
    console.log('🧹 Colecciones limpiadas');

    // Crear usuarios
    const hashedPassword = await bcrypt.hash('123456', 10);
    
    const users = await User.insertMany([
      {
        email: 'admin@cremosos.com',
        password: hashedPassword,
        name: 'Juan Admin',
        phone: '3001234567',
        role: 'admin',
        address: {
          street: 'Calle 123',
          city: 'Cali',
          state: 'Valle del Cauca',
          zipCode: '760001',
          country: 'Colombia'
        }
      },
      {
        email: 'cliente@cremosos.com',
        password: hashedPassword,
        name: 'María Cliente',
        phone: '3109876543',
        role: 'customer',
        address: {
          street: 'Carrera 50 #30-20',
          city: 'Cali',
          state: 'Valle del Cauca',
          zipCode: '760002',
          country: 'Colombia'
        }
      }
    ]);
    console.log(`👥 ${users.length} usuarios creados`);

    // Crear productos
    const products = [];
    
    // Arroz con leche - Tamaño Grande ($9,000)
    const arrozGrande = [
      { name: 'Arroz con Leche Tradicional - Grande', sabor: 'Tradicional', image: 'arroz_tradicional.jpg', price: 9000, tamaño: 'Grande' },
      { name: 'Arroz con Leche de Arequipe - Grande', sabor: 'Arequipe', image: 'arroz_arequipe.jpg', price: 9000, tamaño: 'Grande' },
      { name: 'Arroz con Leche de Maracuyá - Grande', sabor: 'Maracuyá', image: 'arroz_maracuya.jpg', price: 9000, tamaño: 'Grande' },
      { name: 'Arroz con Leche de Chocolate - Grande', sabor: 'Chocolate', image: 'arroz_chocolate.jpg', price: 9000, tamaño: 'Grande' }
    ];

    // Arroz con leche - Tamaño Pequeño ($6,000)
    const arrozPequeno = [
      { name: 'Arroz con Leche Tradicional - Pequeño', sabor: 'Tradicional', image: 'arroz_tradicional.jpg', price: 6000, tamaño: 'Pequeño' },
      { name: 'Arroz con Leche de Arequipe - Pequeño', sabor: 'Arequipe', image: 'arroz_arequipe.jpg', price: 6000, tamaño: 'Pequeño' },
      { name: 'Arroz con Leche de Maracuyá - Pequeño', sabor: 'Maracuyá', image: 'arroz_maracuya.jpg', price: 6000, tamaño: 'Pequeño' },
      { name: 'Arroz con Leche de Chocolate - Pequeño', sabor: 'Chocolate', image: 'arroz_chocolate.jpg', price: 6000, tamaño: 'Pequeño' }
    ];

    // Fresas con crema
    const fresasProducts = [
      { 
        name: 'Fresas con Crema - 2 Toppings', 
        price: 9000, 
        toppingsIncluidos: 2,
        toppingsDisponibles: ['Chocolate', 'Arequipe'],
        image: 'fresas_con_crema.jpg'
      },
      { 
        name: 'Fresas con Crema - 3 Toppings', 
        price: 11000, 
        toppingsIncluidos: 3,
        toppingsDisponibles: ['Chocolate', 'Chispas de Chocolate', 'Arequipe'],
        image: 'fresas_con_crema.jpg'
      },
      { 
        name: 'Fresas con Crema - 4 Toppings', 
        price: 16000, 
        toppingsIncluidos: 4,
        toppingsDisponibles: ['Chocolate', 'Frutos Secos', 'Arequipe', 'Fresa'],
        image: 'fresas_con_crema.jpg'
      }
    ];

    // Agregar productos de arroz con leche
    [...arrozGrande, ...arrozPequeno].forEach(item => {
      products.push({
        name: item.name,
        description: `Delicioso arroz con leche sabor ${item.sabor} - Tamaño ${item.tamaño}`,
        price: item.price,
        imageUrl: `http://localhost:3000/images/${item.image}`,
        category: 'arroz_con_leche',
        stock: 50,
        rating: 4.5,
        reviewsCount: 80,
        isAvailable: true,
        isFeatured: item.sabor === 'Tradicional' && item.tamaño === 'Grande',
        sabor: item.sabor,
        tamaño: item.tamaño
      });
    });

    // Agregar productos de fresas
    fresasProducts.forEach(item => {
      products.push({
        name: item.name,
        description: `Fresas frescas con crema y ${item.toppingsIncluidos} toppings a elegir. Precio: $${item.price.toLocaleString()}`,
        price: item.price,
        imageUrl: `http://localhost:3000/images/${item.image}`,
        category: 'fresas_con_crema',
        stock: 50,
        rating: 4.8,
        reviewsCount: 120,
        isAvailable: true,
        isFeatured: item.toppingsIncluidos === 3,
        toppingsIncluidos: item.toppingsIncluidos,
        toppingsDisponibles: item.toppingsDisponibles
      });
    });

    const insertedProducts = await Product.insertMany(products);
    console.log(`🍰 ${insertedProducts.length} productos creados`);

    console.log('\n✅ Base de datos poblada exitosamente!');
    console.log('\n📝 Usuarios de prueba:');
    console.log('   Admin: admin@cremosos.com / 123456');
    console.log('   Cliente: cliente@cremosos.com / 123456');
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
};

seedDatabase();
