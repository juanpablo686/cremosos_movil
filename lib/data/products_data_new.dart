// data/products_data_new.dart - Datos mock completos de productos (20+ productos)

import '../models/product.dart';

/// PRODUCTOS COMPLETOS CON VARIANTES - 20 productos
final List<Product> allProductsComplete = [
  // ========== ARROZ CON LECHE (10 productos) ==========
  Product(
    id: 'acl-001',
    name: 'Arroz con Leche Clásico',
    description:
        'Delicioso arroz con leche preparado con receta tradicional, leche entera y canela. Cremoso y reconfortante. Ideal para cualquier ocasión.',
    price: 4500,
    image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400',
    category: ProductCategory.arrozConLeche,
    stock: 45,
    featured: true,
    rating: 4.8,
    reviewCount: 124,
    ingredients: ['Arroz', 'Leche entera', 'Azúcar', 'Canela', 'Vainilla'],
    allergens: ['Lácteos'],
    variants: [
      ProductVariant(
        id: 'acl-001-small',
        name: 'Pequeño (250ml)',
        type: VariantType.size,
        priceModifier: 0,
        stock: 20,
      ),
      ProductVariant(
        id: 'acl-001-medium',
        name: 'Mediano (500ml)',
        type: VariantType.size,
        priceModifier: 1500,
        stock: 15,
      ),
      ProductVariant(
        id: 'acl-001-large',
        name: 'Grande (1L)',
        type: VariantType.size,
        priceModifier: 3000,
        stock: 10,
      ),
    ],
    images: [
      'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400',
      'https://images.unsplash.com/photo-1563379091339-03b47878d44e?w=400',
    ],
  ),
  Product(
    id: 'acl-002',
    name: 'Arroz con Leche de Coco',
    description:
        'Versión tropical con leche de coco, ralladura de limón y un toque de cardamomo. Exótico y refrescante.',
    price: 5200,
    image: 'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?w=400',
    category: ProductCategory.arrozConLeche,
    stock: 32,
    rating: 4.7,
    reviewCount: 89,
    ingredients: [
      'Arroz',
      'Leche de coco',
      'Azúcar de caña',
      'Cardamomo',
      'Ralladura de limón'
    ],
    allergens: [],
    variants: [
      ProductVariant(
        id: 'acl-002-small',
        name: 'Pequeño',
        type: VariantType.size,
        priceModifier: 0,
        stock: 16,
      ),
      ProductVariant(
        id: 'acl-002-large',
        name: 'Grande',
        type: VariantType.size,
        priceModifier: 2500,
        stock: 16,
      ),
    ],
  ),
  Product(
    id: 'acl-003',
    name: 'Arroz con Leche Premium',
    description:
        'Preparado con leche de búfala, azafrán y almendras. Una experiencia gourmet única.',
    price: 7800,
    image: 'https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=400',
    category: ProductCategory.arrozConLeche,
    stock: 18,
    onSale: true,
    salePrice: 6500,
    rating: 4.9,
    reviewCount: 67,
    ingredients: [
      'Arroz bomba',
      'Leche de búfala',
      'Azafrán',
      'Almendras',
      'Miel de abeja'
    ],
    allergens: ['Lácteos', 'Frutos secos'],
    variants: [
      ProductVariant(
        id: 'acl-003-regular',
        name: 'Regular',
        type: VariantType.size,
        priceModifier: 0,
        stock: 18,
      ),
    ],
  ),
  Product(
    id: 'acl-004',
    name: 'Arroz con Leche Vegano',
    description:
        'Versión plant-based con leche de almendras y endulzado con jarabe de agave. Igual de cremoso.',
    price: 5800,
    image: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400',
    category: ProductCategory.arrozConLeche,
    stock: 28,
    rating: 4.6,
    reviewCount: 156,
    ingredients: [
      'Arroz integral',
      'Leche de almendras',
      'Jarabe de agave',
      'Canela Ceylon',
      'Extracto de vainilla'
    ],
    allergens: ['Frutos secos'],
  ),
  Product(
    id: 'acl-005',
    name: 'Arroz con Leche de Chocolate',
    description:
        'Innovadora mezcla con cacao premium y chips de chocolate. Para los amantes del chocolate.',
    price: 6200,
    image: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
    category: ProductCategory.arrozConLeche,
    stock: 39,
    featured: true,
    rating: 4.8,
    reviewCount: 203,
    ingredients: [
      'Arroz',
      'Leche entera',
      'Cacao premium',
      'Chips de chocolate',
      'Azúcar morena'
    ],
    allergens: ['Lácteos'],
    variants: [
      ProductVariant(
        id: 'acl-005-dark',
        name: 'Chocolate Oscuro',
        type: VariantType.flavor,
        priceModifier: 500,
        stock: 20,
      ),
      ProductVariant(
        id: 'acl-005-milk',
        name: 'Chocolate con Leche',
        type: VariantType.flavor,
        priceModifier: 0,
        stock: 19,
      ),
    ],
  ),
  Product(
    id: 'acl-006',
    name: 'Arroz con Leche de Jengibre',
    description:
        'Fusión tropical con leche de coco, ralladura de limón y un toque de jengibre fresco.',
    price: 5500,
    image: 'https://images.unsplash.com/photo-1610450949065-1f2841536c88?w=400',
    category: ProductCategory.arrozConLeche,
    stock: 32,
    rating: 4.5,
    reviewCount: 89,
    ingredients: [
      'Arroz jazmín',
      'Leche de coco',
      'Ralladura de limón',
      'Jengibre',
      'Azúcar de caña'
    ],
    allergens: [],
  ),
  Product(
    id: 'acl-007',
    name: 'Arroz con Leche Estacional',
    description:
        'Receta especial de temporada con especias navideñas: cardamomo, clavo y naranja.',
    price: 6800,
    image: 'https://images.unsplash.com/photo-1553979459-d2229ba7433a?w=400',
    category: ProductCategory.arrozConLeche,
    stock: 18,
    featured: true,
    rating: 4.9,
    reviewCount: 156,
    ingredients: [
      'Arroz bomba',
      'Leche entera',
      'Cardamomo',
      'Clavo',
      'Ralladura de naranja',
      'Miel'
    ],
    allergens: ['Lácteos'],
  ),
  Product(
    id: 'acl-008',
    name: 'Arroz con Leche de Café',
    description: 'Fusión moderna con infusión de café colombiano premium.',
    price: 5500,
    image: 'https://images.unsplash.com/photo-1514481538271-cf9f99627ab4?w=400',
    category: ProductCategory.arrozConLeche,
    stock: 30,
    rating: 4.5,
    reviewCount: 78,
    ingredients: ['Arroz', 'Leche', 'Café colombiano', 'Azúcar'],
    allergens: ['Lácteos'],
  ),
  Product(
    id: 'acl-009',
    name: 'Arroz con Leche de Matcha',
    description: 'Innovadora combinación con té matcha japonés.',
    price: 6500,
    image: 'https://images.unsplash.com/photo-1536599018102-9f803c140fc1?w=400',
    category: ProductCategory.arrozConLeche,
    stock: 19,
    rating: 4.7,
    reviewCount: 54,
    ingredients: ['Arroz', 'Leche', 'Té matcha', 'Azúcar'],
    allergens: ['Lácteos'],
  ),
  Product(
    id: 'acl-010',
    name: 'Arroz con Leche de Caramelo',
    description: 'Con salsa de caramelo casera y sal marina.',
    price: 5900,
    image: 'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=400',
    category: ProductCategory.arrozConLeche,
    stock: 27,
    onSale: true,
    salePrice: 4900,
    rating: 4.9,
    reviewCount: 143,
    ingredients: ['Arroz', 'Leche', 'Caramelo', 'Sal marina'],
    allergens: ['Lácteos'],
  ),

  // ========== FRESAS CON CREMA (10 productos) ==========
  Product(
    id: 'fcc-001',
    name: 'Fresas con Crema Tradicional',
    description:
        'Fresas frescas con crema batida casera. El clásico que nunca falla.',
    price: 5500,
    image: 'https://images.unsplash.com/photo-1464219789935-c2d9d9aba644?w=400',
    category: ProductCategory.fresasConCrema,
    stock: 38,
    featured: true,
    rating: 4.9,
    reviewCount: 267,
    ingredients: ['Fresas frescas', 'Crema batida', 'Azúcar', 'Vainilla'],
    allergens: ['Lácteos'],
    variants: [
      ProductVariant(
        id: 'fcc-001-small',
        name: 'Pequeño',
        type: VariantType.size,
        priceModifier: 0,
        stock: 15,
      ),
      ProductVariant(
        id: 'fcc-001-medium',
        name: 'Mediano',
        type: VariantType.size,
        priceModifier: 1800,
        stock: 13,
      ),
      ProductVariant(
        id: 'fcc-001-large',
        name: 'Grande',
        type: VariantType.size,
        priceModifier: 3500,
        stock: 10,
      ),
    ],
  ),
  Product(
    id: 'fcc-002',
    name: 'Fresas con Crema de Chocolate',
    description: 'Fresas con crema batida y chips de chocolate belga.',
    price: 6200,
    image: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
    category: ProductCategory.fresasConCrema,
    stock: 29,
    rating: 4.8,
    reviewCount: 189,
    ingredients: ['Fresas', 'Crema batida', 'Chocolate belga', 'Cacao'],
    allergens: ['Lácteos'],
  ),
  Product(
    id: 'fcc-003',
    name: 'Fresas con Crema Premium',
    description: 'Con fresas orgánicas, crema chantilly y almendras tostadas.',
    price: 7500,
    image: 'https://images.unsplash.com/photo-1587049352846-4a222e784e38?w=400',
    category: ProductCategory.fresasConCrema,
    stock: 22,
    onSale: true,
    salePrice: 6800,
    rating: 5.0,
    reviewCount: 98,
    ingredients: ['Fresas orgánicas', 'Crema chantilly', 'Almendras', 'Miel'],
    allergens: ['Lácteos', 'Frutos secos'],
    variants: [
      ProductVariant(
        id: 'fcc-003-regular',
        name: 'Regular',
        type: VariantType.size,
        priceModifier: 0,
        stock: 22,
      ),
    ],
  ),
  Product(
    id: 'fcc-004',
    name: 'Fresas con Crema de Almendras',
    description: 'Con láminas de almendras tostadas y miel de abeja.',
    price: 6400,
    image: 'https://images.unsplash.com/photo-1557142046-c704a3adf364?w=400',
    category: ProductCategory.fresasConCrema,
    stock: 25,
    rating: 4.7,
    reviewCount: 134,
    ingredients: ['Fresas', 'Crema', 'Almendras', 'Miel de abeja'],
    allergens: ['Lácteos', 'Frutos secos'],
  ),
  Product(
    id: 'fcc-005',
    name: 'Fresas con Crema Light',
    description: 'Versión baja en calorías con yogurt griego y stevia.',
    price: 5800,
    image: 'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=400',
    category: ProductCategory.fresasConCrema,
    stock: 34,
    rating: 4.4,
    reviewCount: 176,
    ingredients: ['Fresas', 'Yogurt griego', 'Stevia', 'Vainilla'],
    allergens: ['Lácteos'],
  ),
  Product(
    id: 'fcc-006',
    name: 'Fresas con Crema de Coco',
    description: 'Versión vegana con crema de coco batida.',
    price: 6000,
    image: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=400',
    category: ProductCategory.fresasConCrema,
    stock: 28,
    rating: 4.6,
    reviewCount: 112,
    ingredients: ['Fresas', 'Crema de coco', 'Azúcar de caña'],
    allergens: [],
  ),
  Product(
    id: 'fcc-007',
    name: 'Fresas con Crema de Pistachos',
    description: 'Con crema de pistachos y agua de rosas.',
    price: 7200,
    image: 'https://images.unsplash.com/photo-1547514701-42782101795e?w=400',
    category: ProductCategory.fresasConCrema,
    stock: 19,
    featured: true,
    rating: 4.9,
    reviewCount: 87,
    ingredients: ['Fresas', 'Crema', 'Pistachos', 'Agua de rosas'],
    allergens: ['Lácteos', 'Frutos secos'],
  ),
  Product(
    id: 'fcc-008',
    name: 'Fresas con Crema de Limón',
    description: 'Refrescante versión con ralladura de limón.',
    price: 5600,
    image: 'https://images.unsplash.com/photo-1481391319762-47dff72954d9?w=400',
    category: ProductCategory.fresasConCrema,
    stock: 31,
    rating: 4.5,
    reviewCount: 145,
    ingredients: ['Fresas', 'Crema', 'Limón', 'Azúcar'],
    allergens: ['Lácteos'],
  ),
  Product(
    id: 'fcc-009',
    name: 'Fresas con Crema de Frambuesa',
    description: 'Con coulis de frambuesa y fresas maceradas.',
    price: 6800,
    image: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400',
    category: ProductCategory.fresasConCrema,
    stock: 23,
    rating: 4.8,
    reviewCount: 101,
    ingredients: ['Fresas', 'Frambuesas', 'Crema', 'Azúcar'],
    allergens: ['Lácteos'],
  ),
  Product(
    id: 'fcc-010',
    name: 'Fresas con Crema de Caramelo',
    description: 'Con salsa de caramelo salado y nueces pecanas.',
    price: 6500,
    image: 'https://images.unsplash.com/photo-1517686748534-27cfd7f97430?w=400',
    category: ProductCategory.fresasConCrema,
    stock: 26,
    onSale: true,
    salePrice: 5500,
    rating: 4.7,
    reviewCount: 168,
    ingredients: ['Fresas', 'Crema', 'Caramelo', 'Nueces pecanas'],
    allergens: ['Lácteos', 'Frutos secos'],
  ),
];

/// TOPPINGS
final List<Topping> toppingsData = [
  Topping(
    id: 'top-001',
    name: 'Fresas Frescas',
    price: 800,
    category: ToppingCategory.frutas,
    image: 'https://images.unsplash.com/photo-1464219789935-c2d9d9aba644?w=200',
  ),
  Topping(
    id: 'top-002',
    name: 'Arándanos',
    price: 1000,
    category: ToppingCategory.frutas,
    image: 'https://images.unsplash.com/photo-1498557850523-fd3d118b962e?w=200',
  ),
  Topping(
    id: 'top-003',
    name: 'Mango',
    price: 900,
    category: ToppingCategory.frutas,
    image: 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=200',
  ),
  Topping(
    id: 'top-004',
    name: 'Kiwi',
    price: 850,
    category: ToppingCategory.frutas,
    image: 'https://images.unsplash.com/photo-1585059895524-72359e9e91d6?w=200',
  ),
  Topping(
    id: 'top-005',
    name: 'Plátano Caramelizado',
    price: 700,
    category: ToppingCategory.frutas,
    image: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=200',
  ),
  Topping(
    id: 'top-006',
    name: 'Chocolate en Virutas',
    price: 600,
    category: ToppingCategory.dulces,
    image: 'https://images.unsplash.com/photo-1511381939415-e44015466834?w=200',
  ),
  Topping(
    id: 'top-007',
    name: 'Chispas de Colores',
    price: 400,
    category: ToppingCategory.dulces,
    image: 'https://images.unsplash.com/photo-1563379091339-03b47878d44e?w=200',
  ),
  Topping(
    id: 'top-008',
    name: 'Gomitas',
    price: 500,
    category: ToppingCategory.dulces,
    image: 'https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?w=200',
  ),
  Topping(
    id: 'top-009',
    name: 'Almendras Fileteadas',
    price: 900,
    category: ToppingCategory.frutosSeco,
    image: 'https://images.unsplash.com/photo-1508736793122-f516e3ba5569?w=200',
  ),
  Topping(
    id: 'top-010',
    name: 'Nueces Pecanas',
    price: 1100,
    category: ToppingCategory.frutosSeco,
    image: 'https://images.unsplash.com/photo-1595790220469-594a92e04b1a?w=200',
  ),
  Topping(
    id: 'top-011',
    name: 'Pistachos',
    price: 1200,
    category: ToppingCategory.frutosSeco,
    image: 'https://images.unsplash.com/photo-1599599810694-b5d1b3d0f724?w=200',
  ),
  Topping(
    id: 'top-012',
    name: 'Coco Rallado',
    price: 600,
    category: ToppingCategory.frutosSeco,
    image: 'https://images.unsplash.com/photo-1471943311424-646960669fbc?w=200',
  ),
  Topping(
    id: 'top-013',
    name: 'Salsa de Caramelo',
    price: 700,
    category: ToppingCategory.salsas,
    image: 'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=200',
  ),
  Topping(
    id: 'top-014',
    name: 'Salsa de Chocolate',
    price: 700,
    category: ToppingCategory.salsas,
    image: 'https://images.unsplash.com/photo-1511381939415-e44015466834?w=200',
  ),
  Topping(
    id: 'top-015',
    name: 'Salsa de Frambuesa',
    price: 800,
    category: ToppingCategory.salsas,
    image: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=200',
  ),
];

/// Funciones de utilidad
Product? getProductById(String id) {
  try {
    return allProductsComplete.firstWhere((product) => product.id == id);
  } catch (e) {
    return null;
  }
}

List<Product> getProductsByCategory(ProductCategory category) {
  return allProductsComplete
      .where((product) => product.category == category)
      .toList();
}

List<Product> getFeaturedProducts() {
  return allProductsComplete
      .where((product) => product.featured == true)
      .toList();
}

List<Product> getProductsOnSale() {
  return allProductsComplete
      .where((product) => product.onSale == true)
      .toList();
}

List<Product> searchProducts(String query) {
  final searchTerm = query.toLowerCase();
  return allProductsComplete
      .where((product) =>
          product.name.toLowerCase().contains(searchTerm) ||
          product.description.toLowerCase().contains(searchTerm) ||
          product.ingredients.any(
              (ingredient) => ingredient.toLowerCase().contains(searchTerm)))
      .toList();
}

// Alias para compatibilidad
final List<Product> allProducts = allProductsComplete;
final List<Topping> availableToppings = toppingsData;
