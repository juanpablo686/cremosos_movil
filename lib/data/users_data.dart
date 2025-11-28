// data/users_data.dart - Datos mock de usuarios y órdenes

import '../models/user.dart';
import '../models/cart.dart';
import '../models/product.dart';

/// Usuarios de prueba
final List<User> mockUsers = [
  User(
    id: 'user-001',
    email: 'juan.perez@email.com',
    name: 'Juan Pérez',
    phone: '+57 300 123 4567',
    role: UserRole.customer,
    createdAt: DateTime(2023, 6, 15),
    avatar:
        'https://ui-avatars.com/api/?name=Juan+Perez&background=7c3aed&color=fff&size=150',
    addresses: [
      Address(
        id: 'addr-001',
        label: 'Casa',
        street: 'Calle 45 #12-34',
        city: 'Bogotá',
        state: 'Cundinamarca',
        postalCode: '110111',
        country: 'Colombia',
        type: AddressType.home,
        isDefault: true,
        recipientName: 'Juan Pérez',
        recipientPhone: '+57 300 123 4567',
      ),
      Address(
        id: 'addr-002',
        label: 'Oficina',
        street: 'Carrera 7 #85-21',
        city: 'Bogotá',
        state: 'Cundinamarca',
        postalCode: '110221',
        country: 'Colombia',
        type: AddressType.work,
        isDefault: false,
        recipientName: 'Juan Pérez',
        recipientPhone: '+57 300 123 4567',
        additionalInfo: 'Torre B, Piso 4, Oficina 405',
      ),
    ],
    preferences: UserPreferences(
      newsletter: true,
      pushNotifications: true,
      emailNotifications: true,
      smsNotifications: false,
      theme: 'light',
      language: 'es',
    ),
    paymentMethods: [
      PaymentMethod(
        id: 'pm-001',
        type: 'credit_card',
        last4: '4242',
        brand: 'Visa',
        expiryMonth: 12,
        expiryYear: 2025,
        isDefault: true,
        holderName: 'Juan Pérez',
      ),
    ],
  ),
  User(
    id: 'user-002',
    email: 'maria.garcia@email.com',
    name: 'María García',
    phone: '+57 310 987 6543',
    role: UserRole.customer,
    createdAt: DateTime(2023, 8, 22),
    avatar:
        'https://ui-avatars.com/api/?name=Maria+Garcia&background=ec4899&color=fff&size=150',
    addresses: [
      Address(
        id: 'addr-003',
        label: 'Casa',
        street: 'Avenida 15 #89-23',
        city: 'Medellín',
        state: 'Antioquia',
        postalCode: '050001',
        country: 'Colombia',
        type: AddressType.home,
        isDefault: true,
        recipientName: 'María García',
        recipientPhone: '+57 310 987 6543',
      ),
    ],
    preferences: UserPreferences(
      newsletter: true,
      pushNotifications: true,
      emailNotifications: true,
      smsNotifications: true,
      theme: 'dark',
      language: 'es',
    ),
    paymentMethods: [
      PaymentMethod(
        id: 'pm-002',
        type: 'debit_card',
        last4: '8888',
        brand: 'Mastercard',
        expiryMonth: 8,
        expiryYear: 2026,
        isDefault: true,
        holderName: 'María García',
      ),
    ],
  ),
  User(
    id: 'user-003',
    email: 'carlos.rodriguez@email.com',
    name: 'Carlos Rodríguez',
    phone: '+57 320 456 7890',
    role: UserRole.customer,
    createdAt: DateTime(2023, 10, 5),
    avatar:
        'https://ui-avatars.com/api/?name=Carlos+Lopez&background=3b82f6&color=fff&size=150',
    addresses: [
      Address(
        id: 'addr-004',
        label: 'Apartamento',
        street: 'Calle 100 #18-45',
        city: 'Cali',
        state: 'Valle del Cauca',
        postalCode: '760001',
        country: 'Colombia',
        type: AddressType.home,
        isDefault: true,
        recipientName: 'Carlos Rodríguez',
        recipientPhone: '+57 320 456 7890',
        additionalInfo: 'Apartamento 302, Edificio Palmeras',
      ),
    ],
    preferences: UserPreferences(
      newsletter: false,
      pushNotifications: true,
      emailNotifications: false,
      smsNotifications: false,
      theme: 'light',
      language: 'es',
    ),
    paymentMethods: [
      PaymentMethod(
        id: 'pm-003',
        type: 'pse',
        last4: '0123',
        brand: 'Bancolombia',
        isDefault: true,
        holderName: 'Carlos Rodríguez',
      ),
    ],
  ),
  User(
    id: 'user-004',
    email: 'ana.martinez@email.com',
    name: 'Ana Martínez',
    phone: '+57 315 222 3333',
    role: UserRole.customer,
    createdAt: DateTime(2024, 1, 10),
    avatar:
        'https://ui-avatars.com/api/?name=Ana+Martinez&background=10b981&color=fff&size=150',
    addresses: [
      Address(
        id: 'addr-005',
        label: 'Casa',
        street: 'Transversal 50 #20-10',
        city: 'Barranquilla',
        state: 'Atlántico',
        postalCode: '080001',
        country: 'Colombia',
        type: AddressType.home,
        isDefault: true,
        recipientName: 'Ana Martínez',
        recipientPhone: '+57 315 222 3333',
      ),
    ],
    preferences: UserPreferences(
      newsletter: true,
      pushNotifications: false,
      emailNotifications: true,
      smsNotifications: false,
      theme: 'light',
      language: 'es',
    ),
    paymentMethods: [
      PaymentMethod(
        id: 'pm-004',
        type: 'credit_card',
        last4: '5555',
        brand: 'American Express',
        expiryMonth: 6,
        expiryYear: 2027,
        isDefault: true,
        holderName: 'Ana Martínez',
      ),
    ],
  ),
  User(
    id: 'user-005',
    email: 'pedro.lopez@email.com',
    name: 'Pedro López',
    phone: '+57 318 444 5555',
    role: UserRole.customer,
    createdAt: DateTime(2024, 3, 15),
    avatar:
        'https://ui-avatars.com/api/?name=Admin&background=f59e0b&color=000&size=150',
    addresses: [
      Address(
        id: 'addr-006',
        label: 'Residencia',
        street: 'Diagonal 30 #40-50',
        city: 'Cartagena',
        state: 'Bolívar',
        postalCode: '130001',
        country: 'Colombia',
        type: AddressType.home,
        isDefault: true,
        recipientName: 'Pedro López',
        recipientPhone: '+57 318 444 5555',
      ),
    ],
    preferences: UserPreferences(
      newsletter: true,
      pushNotifications: true,
      emailNotifications: true,
      smsNotifications: true,
      theme: 'dark',
      language: 'es',
    ),
    paymentMethods: [],
  ),
  User(
    id: 'user-admin',
    email: 'admin@cremosos.com',
    name: 'Administrador',
    phone: '+57 300 000 0000',
    role: UserRole.admin,
    createdAt: DateTime(2023, 1, 1),
    avatar:
        'https://ui-avatars.com/api/?name=Laura+Rodriguez&background=8b5cf6&color=fff&size=150',
    addresses: [
      Address(
        id: 'addr-admin',
        label: 'Sede Principal',
        street: 'Carrera 50 #100-25',
        city: 'Bogotá',
        state: 'Cundinamarca',
        postalCode: '110111',
        country: 'Colombia',
        type: AddressType.work,
        isDefault: true,
        recipientName: 'Cremosos Admin',
        recipientPhone: '+57 300 000 0000',
      ),
    ],
    preferences: UserPreferences(
      newsletter: true,
      pushNotifications: true,
      emailNotifications: true,
      smsNotifications: true,
      theme: 'light',
      language: 'es',
    ),
    paymentMethods: [],
  ),
];

/// Credenciales de prueba (email: password)
/// IMPORTANTE: En producción NUNCA almacenar contraseñas en texto plano
final Map<String, String> mockCredentials = {
  'juan.perez@email.com': 'password123',
  'maria.garcia@email.com': 'password123',
  'carlos.rodriguez@email.com': 'password123',
  'ana.martinez@email.com': 'password123',
  'pedro.lopez@email.com': 'password123',
  'admin@cremosos.com': 'admin123',
  // Usuario demo para pruebas rápidas
  'demo@cremosos.com': 'demo',
};

/// Órdenes de ejemplo
final List<Order> mockOrders = [
  Order(
    id: 'order-001',
    userId: 'user-001',
    items: [
      CartItem(
        productId: 'acl-001',
        quantity: 2,
        selectedToppings: ['top-003', 'top-009'],
      ),
      CartItem(
        productId: 'fcc-001',
        quantity: 1,
        selectedToppings: ['top-001', 'top-006'],
      ),
    ],
    subtotal: 17700,
    tax: 1593,
    shipping: 5000,
    discount: 0,
    total: 24293,
    status: OrderStatus.delivered,
    createdAt: DateTime(2024, 10, 15, 10, 30),
    deliveredAt: DateTime(2024, 10, 16, 14, 20),
    shippingAddress: Address(
      id: 'addr-001',
      label: 'Casa',
      street: 'Calle 45 #12-34',
      city: 'Bogotá',
      state: 'Cundinamarca',
      postalCode: '110111',
      country: 'Colombia',
      type: AddressType.home,
      isDefault: true,
      recipientName: 'Juan Pérez',
      recipientPhone: '+57 300 123 4567',
    ),
    paymentMethod: PaymentMethod(
      id: 'pm-001',
      type: 'credit_card',
      last4: '4242',
      brand: 'Visa',
      expiryMonth: 12,
      expiryYear: 2025,
      isDefault: true,
      holderName: 'Juan Pérez',
    ),
  ),
  Order(
    id: 'order-002',
    userId: 'user-001',
    items: [CartItem(productId: 'acl-003', quantity: 1, selectedToppings: [])],
    subtotal: 6500,
    tax: 585,
    shipping: 5000,
    discount: 650,
    total: 11435,
    status: OrderStatus.shipped,
    createdAt: DateTime(2024, 11, 20, 15, 45),
    shippingAddress: Address(
      id: 'addr-002',
      label: 'Oficina',
      street: 'Carrera 7 #85-21',
      city: 'Bogotá',
      state: 'Cundinamarca',
      postalCode: '110221',
      country: 'Colombia',
      type: AddressType.work,
      isDefault: false,
      recipientName: 'Juan Pérez',
      recipientPhone: '+57 300 123 4567',
      additionalInfo: 'Torre B, Piso 4, Oficina 405',
    ),
    paymentMethod: PaymentMethod(
      id: 'pm-001',
      type: 'credit_card',
      last4: '4242',
      brand: 'Visa',
      expiryMonth: 12,
      expiryYear: 2025,
      isDefault: true,
      holderName: 'Juan Pérez',
    ),
  ),
  Order(
    id: 'order-003',
    userId: 'user-002',
    items: [
      CartItem(
        productId: 'fcc-003',
        quantity: 2,
        selectedToppings: ['top-002', 'top-010'],
      ),
    ],
    subtotal: 13600,
    tax: 1224,
    shipping: 5000,
    discount: 0,
    total: 19824,
    status: OrderStatus.delivered,
    createdAt: DateTime(2024, 11, 10, 9, 15),
    deliveredAt: DateTime(2024, 11, 12, 16, 30),
    shippingAddress: Address(
      id: 'addr-003',
      label: 'Casa',
      street: 'Avenida 15 #89-23',
      city: 'Medellín',
      state: 'Antioquia',
      postalCode: '050001',
      country: 'Colombia',
      type: AddressType.home,
      isDefault: true,
      recipientName: 'María García',
      recipientPhone: '+57 310 987 6543',
    ),
    paymentMethod: PaymentMethod(
      id: 'pm-002',
      type: 'debit_card',
      last4: '8888',
      brand: 'Mastercard',
      expiryMonth: 8,
      expiryYear: 2026,
      isDefault: true,
      holderName: 'María García',
    ),
  ),
];

/// Reseñas de productos
final List<Review> mockReviews = [
  Review(
    id: 'rev-001',
    productId: 'acl-001',
    userId: 'user-001',
    userName: 'Juan Pérez',
    userAvatar:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
    rating: 5,
    comment:
        '¡Excelente! El sabor es increíble, muy cremoso y la canela está perfecta. Lo recomiendo 100%.',
    createdAt: DateTime(2024, 10, 17),
    helpful: 24,
    verified: true,
  ),
  Review(
    id: 'rev-002',
    productId: 'acl-001',
    userId: 'user-002',
    userName: 'María García',
    userAvatar:
        'https://ui-avatars.com/api/?name=Maria+Garcia&background=ec4899&color=fff&size=150',
    rating: 4,
    comment:
        'Muy bueno, aunque me gustaría que tuviera un poco más de azúcar. El tamaño perfecto.',
    createdAt: DateTime(2024, 10, 20),
    helpful: 12,
    verified: true,
  ),
  Review(
    id: 'rev-003',
    productId: 'fcc-001',
    userId: 'user-003',
    userName: 'Carlos Rodríguez',
    userAvatar:
        'https://ui-avatars.com/api/?name=Carlos+Lopez&background=3b82f6&color=fff&size=150',
    rating: 5,
    comment:
        'Las fresas están súper frescas y la crema es deliciosa. Mi familia lo ama.',
    createdAt: DateTime(2024, 11, 5),
    helpful: 18,
    verified: true,
  ),
  Review(
    id: 'rev-004',
    productId: 'acl-003',
    userId: 'user-001',
    userName: 'Juan Pérez',
    userAvatar:
        'https://ui-avatars.com/api/?name=Juan+Perez&background=7c3aed&color=fff&size=150',
    rating: 5,
    comment:
        'La versión premium realmente vale la pena. El azafrán le da un toque único.',
    createdAt: DateTime(2024, 11, 21),
    helpful: 9,
    verified: true,
  ),
  Review(
    id: 'rev-005',
    productId: 'acl-005',
    userId: 'user-004',
    userName: 'Ana Martínez',
    userAvatar:
        'https://ui-avatars.com/api/?name=Ana+Martinez&background=10b981&color=fff&size=150',
    rating: 5,
    comment:
        'Para los amantes del chocolate, esto es el paraíso. Muy recomendado.',
    createdAt: DateTime(2024, 11, 18),
    helpful: 15,
    verified: true,
  ),
  Review(
    id: 'rev-006',
    productId: 'fcc-003',
    userId: 'user-005',
    userName: 'Pedro López',
    userAvatar:
        'https://ui-avatars.com/api/?name=Pedro+Lopez&background=f59e0b&color=000&size=150',
    rating: 5,
    comment:
        'Simplemente perfecto. Las almendras tostadas son el complemento ideal.',
    createdAt: DateTime(2024, 11, 8),
    helpful: 11,
    verified: false,
  ),
];

/// Funciones de utilidad

User? getUserById(String id) {
  try {
    return mockUsers.firstWhere((user) => user.id == id);
  } catch (e) {
    return null;
  }
}

User? getUserByEmail(String email) {
  try {
    return mockUsers.firstWhere((user) => user.email == email);
  } catch (e) {
    return null;
  }
}

AuthResponse simulateLogin(String email, String password) {
  // Simular validación de credenciales
  if (!mockCredentials.containsKey(email)) {
    throw Exception('Usuario no encontrado');
  }

  if (mockCredentials[email] != password) {
    throw Exception('Contraseña incorrecta');
  }

  final user = getUserByEmail(email);
  if (user == null) {
    throw Exception('Error al cargar usuario');
  }

  if (!user.isActive) {
    throw Exception('Usuario inactivo');
  }

  // Generar token simulado
  final token =
      'mock_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';

  return AuthResponse(
    user: user,
    token: token,
    refreshToken:
        'mock_refresh_${user.id}_${DateTime.now().millisecondsSinceEpoch}',
    expiresIn: 604800, // 7 días en segundos
  );
}

List<Order> getUserOrders(String userId) {
  return mockOrders.where((order) => order.userId == userId).toList();
}

List<Review> getProductReviews(String productId) {
  return mockReviews.where((review) => review.productId == productId).toList();
}
