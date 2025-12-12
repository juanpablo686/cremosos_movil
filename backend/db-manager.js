const fs = require('fs').promises;
const path = require('path');

class DatabaseManager {
  constructor() {
    this.dataDir = path.join(__dirname, 'data');
    this.files = {
      products: path.join(this.dataDir, 'products.json'),
      users: path.join(this.dataDir, 'users.json'),
      orders: path.join(this.dataDir, 'orders.json'),
      sales: path.join(this.dataDir, 'sales.json'),
      cart: path.join(this.dataDir, 'cart.json'),
      roles: path.join(this.dataDir, 'roles.json'),
      suppliers: path.join(this.dataDir, 'suppliers.json'),
      purchases: path.join(this.dataDir, 'purchases.json')
    };
  }

  // Inicializar archivos si no existen
  async initialize() {
    try {
      // Verificar que el directorio existe
      await fs.mkdir(this.dataDir, { recursive: true });
      
      // Inicializar cada archivo con datos vacíos si no existe
      for (const [key, filepath] of Object.entries(this.files)) {
        try {
          await fs.access(filepath);
        } catch {
          // El archivo no existe, crearlo con array vacío
          await fs.writeFile(filepath, JSON.stringify([], null, 2));
          console.log(`📄 Creado archivo: ${key}.json`);
        }
      }
      
      console.log('✅ Base de datos JSON inicializada correctamente');
      return true;
    } catch (error) {
      console.error('❌ Error inicializando base de datos:', error.message);
      return false;
    }
  }

  // Leer datos de un archivo
  async read(collection) {
    try {
      const filepath = this.files[collection];
      if (!filepath) {
        throw new Error(`Colección desconocida: ${collection}`);
      }
      
      const data = await fs.readFile(filepath, 'utf-8');
      return JSON.parse(data);
    } catch (error) {
      console.error(`Error leyendo ${collection}:`, error.message);
      return [];
    }
  }

  // Escribir datos a un archivo
  async write(collection, data) {
    try {
      const filepath = this.files[collection];
      if (!filepath) {
        throw new Error(`Colección desconocida: ${collection}`);
      }
      
      await fs.writeFile(filepath, JSON.stringify(data, null, 2));
      return true;
    } catch (error) {
      console.error(`Error escribiendo ${collection}:`, error.message);
      return false;
    }
  }

  // Agregar un registro
  async insert(collection, record) {
    const data = await this.read(collection);
    data.push(record);
    await this.write(collection, data);
    return record;
  }

  // Actualizar un registro
  async update(collection, id, updates) {
    const data = await this.read(collection);
    const index = data.findIndex(item => item.id === id);
    
    if (index === -1) {
      throw new Error(`Registro con id ${id} no encontrado`);
    }
    
    data[index] = { ...data[index], ...updates, updatedAt: new Date().toISOString() };
    await this.write(collection, data);
    return data[index];
  }

  // Eliminar un registro
  async delete(collection, id) {
    const data = await this.read(collection);
    const filtered = data.filter(item => item.id !== id);
    
    if (data.length === filtered.length) {
      throw new Error(`Registro con id ${id} no encontrado`);
    }
    
    await this.write(collection, filtered);
    return true;
  }

  // Buscar por ID
  async findById(collection, id) {
    const data = await this.read(collection);
    return data.find(item => item.id === id);
  }

  // Buscar con filtro
  async find(collection, filterFn) {
    const data = await this.read(collection);
    return filterFn ? data.filter(filterFn) : data;
  }

  // Contar registros
  async count(collection, filterFn) {
    const data = await this.read(collection);
    return filterFn ? data.filter(filterFn).length : data.length;
  }

  // Reemplazar toda la colección (útil para migraciones)
  async replaceAll(collection, newData) {
    await this.write(collection, newData);
    return newData;
  }
}

// Exportar instancia única (singleton)
const db = new DatabaseManager();
module.exports = db;
