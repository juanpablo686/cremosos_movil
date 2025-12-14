// Configuración de Toppings Disponibles
// EXPLICAR EN EXPOSICIÓN: Define los toppings (ingredientes adicionales)
// que los clientes pueden agregar a sus productos de fresas con crema

// Lista de toppings disponibles en el sistema
// EXPLICAR: Esta lista se puede actualizar dinámicamente desde el backend
// Por ahora está hardcodeada con valores por defecto
final List<Topping> availableToppings = [
  // Topping 1: Fresas Frescas
  Topping(
    id: 'topping-001', // ID único del topping
    name: 'Fresas Frescas', // Nombre visible al cliente
    price: 2000, // Precio adicional en pesos
    image:
        'https://images.unsplash.com/photo-1543528176-61b239494933?w=200', // Imagen del topping
  ),
  // Topping 2: Arándanos
  Topping(
    id: 'topping-002',
    name: 'Arándanos',
    price: 2500,
    image: 'https://images.unsplash.com/photo-1498557850523-fd3d118b962e?w=200',
  ),
  // Topping 3: Granola Crujiente
  Topping(
    id: 'topping-003',
    name: 'Granola Crujiente',
    price: 1500,
    image: 'https://images.unsplash.com/photo-1526318472351-c75fcf070305?w=200',
  ),
  // Topping 4: Miel de Abeja
  Topping(
    id: 'topping-004',
    name: 'Miel de Abeja',
    price: 1000,
    image: 'https://images.unsplash.com/photo-1587049352846-4a222e784234?w=200',
  ),
  // Topping 5: Chocolate en Polvo
  Topping(
    id: 'topping-005',
    name: 'Chocolate en Polvo',
    price: 1000,
    image: 'https://images.unsplash.com/photo-1511381939415-e44015466834?w=200',
  ),
  // Topping 6: Coco Rallado
  Topping(
    id: 'topping-006',
    name: 'Coco Rallado',
    price: 1500,
    image: 'https://images.unsplash.com/photo-1471943311424-646960669fbc?w=200',
  ),
  // Topping 7: Chispas de Chocolate
  Topping(
    id: 'topping-007',
    name: 'Chispas de Chocolate',
    price: 1500,
    image: 'https://images.unsplash.com/photo-1481391319762-47dff72954d9?w=200',
  ),
  // Topping 8: Crema Batida
  Topping(
    id: 'topping-008',
    name: 'Crema Batida',
    price: 2000,
    image: 'https://images.unsplash.com/photo-1558326567-98ae2405596b?w=200',
  ),
];

class Topping {
  final String id;
  final String name;
  final double price;
  final String image;

  Topping({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });
}
