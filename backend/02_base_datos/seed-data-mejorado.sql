-- ============================================
-- SEED DATA MEJORADO - CREMOSOS DB
-- 100+ productos, 10 proveedores, datos completos
-- ============================================

USE CremososDB;
GO

PRINT '🌱 Iniciando seed de datos mejorado...';
PRINT '';

-- ============================================
-- 1. ROLES
-- ============================================
PRINT '👔 Creando roles...';

IF NOT EXISTS (SELECT 1 FROM Roles WHERE name = 'admin')
INSERT INTO Roles (id, name, description, permissions) 
VALUES ('role1', 'admin', 'Administrador total', '{"all": true}');

IF NOT EXISTS (SELECT 1 FROM Roles WHERE name = 'customer')
INSERT INTO Roles (id, name, description, permissions) 
VALUES ('role2', 'customer', 'Cliente', '{"buy": true, "view_products": true}');

IF NOT EXISTS (SELECT 1 FROM Roles WHERE name = 'employee')
INSERT INTO Roles (id, name, description, permissions) 
VALUES ('role3', 'employee', 'Empleado', '{"pos": true, "view_products": true, "manage_sales": true}');

PRINT '   ✅ 3 roles creados';
PRINT '';

-- ============================================
-- 2. USUARIOS
-- ============================================
PRINT '👥 Creando usuarios...';

IF NOT EXISTS (SELECT 1 FROM Users WHERE email = 'admin@cremosos.com')
INSERT INTO Users (id, email, password, name, phone, role, street, city, state, zipCode)
VALUES ('user1', 'admin@cremosos.com', '123456', 'Juan Admin', '3001234567', 'admin', 'Calle 123', 'Bogotá', 'Cundinamarca', '110111');

IF NOT EXISTS (SELECT 1 FROM Users WHERE email = 'maria.garcia@email.com')
INSERT INTO Users (id, email, password, name, phone, role, street, city, state, zipCode)
VALUES ('user2', 'maria.garcia@email.com', '123456', 'María García', '3109876543', 'customer', 'Carrera 45 #67-89', 'Medellín', 'Antioquia', '050021');

IF NOT EXISTS (SELECT 1 FROM Users WHERE email = 'carlos.lopez@email.com')
INSERT INTO Users (id, email, password, name, phone, role, street, city, state, zipCode)
VALUES ('user3', 'carlos.lopez@email.com', '123456', 'Carlos López', '3158887766', 'customer', 'Avenida 30 #15-20', 'Cali', 'Valle del Cauca', '760042');

IF NOT EXISTS (SELECT 1 FROM Users WHERE email = 'ana.martinez@email.com')
INSERT INTO Users (id, email, password, name, phone, role, street, city, state, zipCode)
VALUES ('user4', 'ana.martinez@email.com', '123456', 'Ana Martínez', '3201112233', 'customer', 'Calle 50 #20-30', 'Barranquilla', 'Atlántico', '080001');

IF NOT EXISTS (SELECT 1 FROM Users WHERE email = 'pedro.sanchez@email.com')
INSERT INTO Users (id, email, password, name, phone, role, street, city, state, zipCode)
VALUES ('user5', 'pedro.sanchez@email.com', '123456', 'Pedro Sánchez', '3124445566', 'customer', 'Carrera 15 #40-50', 'Cartagena', 'Bolívar', '130001');

IF NOT EXISTS (SELECT 1 FROM Users WHERE email = 'empleado@cremosos.com')
INSERT INTO Users (id, email, password, name, phone, role, street, city, state, zipCode)
VALUES ('user6', 'empleado@cremosos.com', '123456', 'Luis Empleado', '3156667788', 'employee', 'Calle 80 #10-20', 'Bogotá', 'Cundinamarca', '110221');

PRINT '   ✅ 6 usuarios creados';
PRINT '';

-- ============================================
-- 3. CATEGORÍAS
-- ============================================
PRINT '📂 Creando categorías...';

IF NOT EXISTS (SELECT 1 FROM Categories WHERE name = 'arroz_con_leche')
INSERT INTO Categories (name, description, icon) VALUES ('arroz_con_leche', 'Arroz con leche casero', 'rice_bowl');

IF NOT EXISTS (SELECT 1 FROM Categories WHERE name = 'fresas_con_crema')
INSERT INTO Categories (name, description, icon) VALUES ('fresas_con_crema', 'Fresas frescas con crema', 'cake');

IF NOT EXISTS (SELECT 1 FROM Categories WHERE name = 'postres_especiales')
INSERT INTO Categories (name, description, icon) VALUES ('postres_especiales', 'Postres únicos y especiales', 'icecream');

IF NOT EXISTS (SELECT 1 FROM Categories WHERE name = 'bebidas_cremosas')
INSERT INTO Categories (name, description, icon) VALUES ('bebidas_cremosas', 'Bebidas cremosas y smoothies', 'local_cafe');

IF NOT EXISTS (SELECT 1 FROM Categories WHERE name = 'bebidas')
INSERT INTO Categories (name, description, icon) VALUES ('bebidas', 'Bebidas frías y calientes', 'coffee');

IF NOT EXISTS (SELECT 1 FROM Categories WHERE name = 'postres')
INSERT INTO Categories (name, description, icon) VALUES ('postres', 'Postres variados', 'cookie');

PRINT '   ✅ 6 categorías creadas';
PRINT '';

-- ============================================
-- 4. PROVEEDORES (10 proveedores)
-- ============================================
PRINT '🚚 Creando proveedores...';

IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE id = 'sup1')
INSERT INTO Suppliers (id, name, contact_name, email, phone, address, city, country)
VALUES ('sup1', 'Lácteos del Valle', 'Pedro Ramírez', 'pedro@lacteos.com', '3001111111', 'Calle 50 #30-20', 'Cali', 'Colombia');

IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE id = 'sup2')
INSERT INTO Suppliers (id, name, contact_name, email, phone, address, city, country)
VALUES ('sup2', 'Frutas Frescas SAS', 'Ana López', 'ana@frutas.com', '3002222222', 'Carrera 15 #25-10', 'Medellín', 'Colombia');

IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE id = 'sup3')
INSERT INTO Suppliers (id, name, contact_name, email, phone, address, city, country)
VALUES ('sup3', 'Dulces y Más', 'Carlos Méndez', 'carlos@dulces.com', '3003333333', 'Avenida 68 #45-30', 'Bogotá', 'Colombia');

IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE id = 'sup4')
INSERT INTO Suppliers (id, name, contact_name, email, phone, address, city, country)
VALUES ('sup4', 'Distribuidora La Crema', 'Laura González', 'laura@lacrema.com', '3004444444', 'Calle 100 #15-25', 'Bogotá', 'Colombia');

IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE id = 'sup5')
INSERT INTO Suppliers (id, name, contact_name, email, phone, address, city, country)
VALUES ('sup5', 'Azúcar y Sabor', 'Miguel Torres', 'miguel@azucar.com', '3005555555', 'Carrera 7 #80-90', 'Barranquilla', 'Colombia');

IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE id = 'sup6')
INSERT INTO Suppliers (id, name, contact_name, email, phone, address, city, country)
VALUES ('sup6', 'Productos Premium SAS', 'Diana Rojas', 'diana@premium.com', '3006666666', 'Avenida 30 #50-60', 'Cali', 'Colombia');

IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE id = 'sup7')
INSERT INTO Suppliers (id, name, contact_name, email, phone, address, city, country)
VALUES ('sup7', 'Ingredientes Naturales', 'Roberto Silva', 'roberto@naturales.com', '3007777777', 'Calle 45 #20-30', 'Cartagena', 'Colombia');

IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE id = 'sup8')
INSERT INTO Suppliers (id, name, contact_name, email, phone, address, city, country)
VALUES ('sup8', 'Sabores Colombianos', 'Patricia Vargas', 'patricia@sabores.com', '3008888888', 'Carrera 50 #40-50', 'Medellín', 'Colombia');

IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE id = 'sup9')
INSERT INTO Suppliers (id, name, contact_name, email, phone, address, city, country)
VALUES ('sup9', 'Insumos Gourmet', 'Fernando Ruiz', 'fernando@gourmet.com', '3009999999', 'Avenida 15 #25-35', 'Bucaramanga', 'Colombia');

IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE id = 'sup10')
INSERT INTO Suppliers (id, name, contact_name, email, phone, address, city, country)
VALUES ('sup10', 'Todo Postres', 'Camila Ort', 'camila@todopostres.com', '3001010101', 'Calle 80 #60-70', 'Pereira', 'Colombia');

PRINT '   ✅ 10 proveedores creados';
PRINT '';

-- ============================================
-- 5. PRODUCTOS (100 productos - 25 por categoría x 4 categorías principales)
-- ============================================
PRINT '📦 Creando 100 productos...';
PRINT '   (Esto puede tomar un momento...)';
PRINT '';

-- Arroz con Leche (25 productos)
INSERT INTO Products (id, name, description, price, category, image, stock, rating, is_featured, on_sale, sale_price) VALUES
('prod_arroz_001', 'Arroz con Leche Clásico', 'Delicioso arroz con leche tradicional', 8000, 'arroz_con_leche', 'https://images.unsplash.com/photo-1562440499-64c9a111f713?w=400', 50, 4.8, 1, 0, NULL),
('prod_arroz_002', 'Arroz con Leche de Coco', 'Con leche de coco y canela', 9500, 'arroz_con_leche', 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400', 35, 4.7, 1, 0, NULL),
('prod_arroz_003', 'Arroz con Leche y Canela', 'Extra canela y pasas', 8500, 'arroz_con_leche', 'https://images.unsplash.com/photo-1563379091339-03b47878d44e?w=400', 40, 4.6, 0, 1, 7225),
('prod_arroz_004', 'Arroz con Leche Premium', 'Ingredientes premium seleccionados', 12000, 'arroz_con_leche', 'https://images.unsplash.com/photo-1587536849024-daaa4a417b16?w=400', 20, 4.9, 1, 0, NULL),
('prod_arroz_005', 'Arroz con Leche y Pasas', 'Con pasas y nuez moscada', 9000, 'arroz_con_leche', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400', 45, 4.5, 0, 0, NULL),
('prod_arroz_006', 'Arroz Doble Cremoso', 'Extra cremoso y suave', 10000, 'arroz_con_leche', 'https://images.unsplash.com/photo-1514517521153-1be72277b32f?w=400', 30, 4.8, 0, 0, NULL),
('prod_arroz_007', 'Arroz de Almendras', 'Con leche de almendras', 11000, 'arroz_con_leche', 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400', 25, 4.7, 0, 0, NULL),
('prod_arroz_008', 'Arroz Especiado', 'Con especias selectas', 9500, 'arroz_con_leche', 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400', 38, 4.6, 0, 0, NULL),
('prod_arroz_009', 'Arroz con Frutas', 'Con frutas tropicales', 11500, 'arroz_con_leche', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400', 28, 4.8, 0, 0, NULL),
('prod_arroz_010', 'Arroz Caramelizado', 'Con caramelo casero', 10500, 'arroz_con_leche', 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400', 32, 4.9, 0, 1, 8925),
('prod_arroz_011', 'Arroz de Vainilla', 'Vainilla natural de Madagascar', 9000, 'arroz_con_leche', 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400', 42, 4.5, 0, 0, NULL),
('prod_arroz_012', 'Arroz Light', 'Bajo en calorías', 7500, 'arroz_con_leche', 'https://images.unsplash.com/photo-1610450949065-1f2841536c88?w=400', 36, 4.4, 0, 0, NULL),
('prod_arroz_013', 'Arroz Gourmet', 'Edición especial gourmet', 15000, 'arroz_con_leche', 'https://images.unsplash.com/photo-1553979459-d2229ba7433a?w=400', 15, 5.0, 1, 0, NULL),
('prod_arroz_014', 'Arroz Tradicional', 'Receta de la abuela', 8000, 'arroz_con_leche', 'https://images.unsplash.com/photo-1514481538271-cf9f99627ab4?w=400', 55, 4.7, 0, 0, NULL),
('prod_arroz_015', 'Arroz XL', 'Porción extra grande', 18000, 'arroz_con_leche', 'https://images.unsplash.com/photo-1536599018102-9f803c140fc1?w=400', 12, 4.9, 0, 1, 15300),
('prod_arroz_016', 'Arroz Mini', 'Porción individual', 5000, 'arroz_con_leche', 'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=400', 65, 4.3, 0, 0, NULL),
('prod_arroz_017', 'Arroz con Chocolate', 'Toque de chocolate belga', 11500, 'arroz_con_leche', 'https://images.unsplash.com/photo-1563379091339-03b47878d44e?w=400', 22, 4.8, 0, 0, NULL),
('prod_arroz_018', 'Arroz de Soya', 'Con leche de soya', 9500, 'arroz_con_leche', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400', 29, 4.5, 0, 0, NULL),
('prod_arroz_019', 'Arroz sin Azúcar', 'Endulzado con stevia', 8500, 'arroz_con_leche', 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400', 34, 4.6, 0, 0, NULL),
('prod_arroz_020', 'Arroz de Avena', 'Con leche de avena', 10500, 'arroz_con_leche', 'https://images.unsplash.com/photo-1511381939415-e44015466834?w=400', 26, 4.7, 0, 0, NULL),
('prod_arroz_021', 'Arroz Navideño', 'Edición especial navidad', 13000, 'arroz_con_leche', 'https://images.unsplash.com/photo-1562440499-64c9a111f713?w=400', 18, 4.8, 0, 0, NULL),
('prod_arroz_022', 'Arroz con Miel', 'Endulzado con miel de abeja', 10000, 'arroz_con_leche', 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400', 31, 4.7, 0, 0, NULL),
('prod_arroz_023', 'Arroz Integral', 'Con arroz integral', 9500, 'arroz_con_leche', 'https://images.unsplash.com/photo-1563379091339-03b47878d44e?w=400', 27, 4.6, 0, 0, NULL),
('prod_arroz_024', 'Arroz Vegano', '100% vegano', 10000, 'arroz_con_leche', 'https://images.unsplash.com/photo-1587536849024-daaa4a417b16?w=400', 24, 4.7, 0, 0, NULL),
('prod_arroz_025', 'Arroz Deluxe', 'Ingredientes importados', 20000, 'arroz_con_leche', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400', 10, 5.0, 1, 1, 17000);

PRINT '   ✅ 25 productos de Arroz con Leche';

-- Fresas con Crema (25 productos)
INSERT INTO Products (id, name, description, price, category, image, stock, rating, is_featured, on_sale, sale_price) VALUES
('prod_fresas_001', 'Fresas con Crema Clásica', 'Fresas frescas con crema tradicional', 12000, 'fresas_con_crema', 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400', 40, 4.9, 1, 0, NULL),
('prod_fresas_002', 'Fresas con Crema Batida', 'Crema batida artesanal', 13500, 'fresas_con_crema', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400', 35, 4.8, 1, 0, NULL),
('prod_fresas_003', 'Fresas Premium', 'Fresas importadas selectas', 16000, 'fresas_con_crema', 'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=400', 25, 5.0, 1, 0, NULL),
('prod_fresas_004', 'Fresas con Crema de Coco', 'Crema de coco natural', 14500, 'fresas_con_crema', 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400', 28, 4.7, 0, 0, NULL),
('prod_fresas_005', 'Fresas con Chocolate', 'Bañadas en chocolate belga', 17000, 'fresas_con_crema', 'https://images.unsplash.com/photo-1516714435131-44d6b64dc6a2?w=400', 20, 4.9, 1, 1, 14450),
('prod_fresas_006', 'Fresas con Miel', 'Miel de abejas pura', 14000, 'fresas_con_crema', 'https://images.unsplash.com/photo-1559181567-c3190ca9959b?w=400', 32, 4.6, 0, 0, NULL),
('prod_fresas_007', 'Fresas Gigantes', 'Fresas extra grandes', 19000, 'fresas_con_crema', 'https://images.unsplash.com/photo-1543362906-acfc16c67564?w=400', 15, 5.0, 1, 0, NULL),
('prod_fresas_008', 'Fresas con Granola', 'Con granola casera', 15500, 'fresas_con_crema', 'https://images.unsplash.com/photo-1495147466023-ac5c588e2e94?w=400', 27, 4.7, 0, 0, NULL),
('prod_fresas_009', 'Fresas con Nueces', 'Nueces caramelizadas', 16500, 'fresas_con_crema', 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400', 22, 4.8, 0, 0, NULL),
('prod_fresas_010', 'Fresas Light', 'Crema light baja en grasa', 11500, 'fresas_con_crema', 'https://images.unsplash.com/photo-1603569283847-aa295f0d016a?w=400', 45, 4.4, 0, 1, 9775),
('prod_fresas_011', 'Fresas Orgánicas', '100% orgánicas certificadas', 18000, 'fresas_con_crema', 'https://images.unsplash.com/photo-1587049352846-4a222e784004?w=400', 18, 4.9, 1, 0, NULL),
('prod_fresas_012', 'Fresas con Arándanos', 'Mix de fresas y arándanos', 17500, 'fresas_con_crema', 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400', 20, 4.8, 0, 0, NULL),
('prod_fresas_013', 'Fresas Especiales', 'Edición especial del chef', 15000, 'fresas_con_crema', 'https://images.unsplash.com/photo-1514517521153-1be72277b32f?w=400', 24, 4.7, 0, 0, NULL),
('prod_fresas_014', 'Fresas con Yogurt', 'Yogurt griego natural', 13500, 'fresas_con_crema', 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400', 30, 4.6, 0, 0, NULL),
('prod_fresas_015', 'Fresas XXL', 'Porción extra extra grande', 22000, 'fresas_con_crema', 'https://images.unsplash.com/photo-1562440499-64c9a111f713?w=400', 10, 5.0, 1, 1, 18700),
('prod_fresas_016', 'Fresas Mini', 'Porción mini', 8500, 'fresas_con_crema', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400', 55, 4.3, 0, 0, NULL),
('prod_fresas_017', 'Fresas con Almendras', 'Almendras laminadas', 16000, 'fresas_con_crema', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400', 26, 4.8, 0, 0, NULL),
('prod_fresas_018', 'Fresas sin Azúcar', 'Endulzadas naturalmente', 12500, 'fresas_con_crema', 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400', 34, 4.5, 0, 0, NULL),
('prod_fresas_019', 'Fresas Gourmet', 'Selección gourmet', 20000, 'fresas_con_crema', 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400', 12, 5.0, 1, 0, NULL),
('prod_fresas_020', 'Fresas Tradicionales', 'Receta familiar', 12000, 'fresas_con_crema', 'https://images.unsplash.com/photo-1464219789935-c2d9d9aba644?w=400', 42, 4.6, 0, 0, NULL),
('prod_fresas_021', 'Fresas con Kiwi', 'Mix de fresas y kiwi', 14500, 'fresas_con_crema', 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400', 23, 4.7, 0, 0, NULL),
('prod_fresas_022', 'Fresas con Mango', 'Toque tropical', 15000, 'fresas_con_crema', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400', 21, 4.8, 0, 0, NULL),
('prod_fresas_023', 'Fresas Navideñas', 'Especial navidad', 16500, 'fresas_con_crema', 'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=400', 17, 4.9, 0, 0, NULL),
('prod_fresas_024', 'Fresas Veganas', 'Crema vegana', 13000, 'fresas_con_crema', 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400', 29, 4.6, 0, 0, NULL),
('prod_fresas_025', 'Fresas Deluxe', 'La mejor selección', 25000, 'fresas_con_crema', 'https://images.unsplash.com/photo-1516714435131-44d6b64dc6a2?w=400', 8, 5.0, 1, 1, 21250);

PRINT '   ✅ 25 productos de Fresas con Crema';

-- Postres Especiales (25 productos)
INSERT INTO Products (id, name, description, price, category, image, stock, rating, is_featured, on_sale, sale_price) VALUES
('prod_postres_001', 'Brownie con Helado', 'Brownie caliente con helado', 15000, 'postres_especiales', 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400', 30, 4.9, 1, 0, NULL),
('prod_postres_002', 'Tres Leches Clásico', 'Pastel tres leches tradicional', 12000, 'postres_especiales', 'https://images.unsplash.com/photo-1464219789935-c2d9d9aba644?w=400', 35, 4.8, 1, 0, NULL),
('prod_postres_003', 'Tiramisú Premium', 'Tiramisú italiano auténtico', 16000, 'postres_especiales', 'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?w=400', 22, 5.0, 1, 0, NULL),
('prod_postres_004', 'Cheesecake Frutos Rojos', 'Cheesecake con salsa de frutos', 17000, 'postres_especiales', 'https://images.unsplash.com/photo-1607920591413-4ec007e70023?w=400', 20, 4.9, 1, 0, NULL),
('prod_postres_005', 'Pudín de Caramelo', 'Pudín casero con caramelo', 10000, 'postres_especiales', 'https://images.unsplash.com/photo-1533134242-ed4c976b38e5?w=400', 40, 4.6, 0, 1, 8500),
('prod_postres_006', 'Mousse de Chocolate', 'Mousse belga premium', 13000, 'postres_especiales', 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400', 28, 4.8, 0, 0, NULL),
('prod_postres_007', 'Flan Napolitano', 'Flan tradicional napolitano', 9000, 'postres_especiales', 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400', 45, 4.5, 0, 0, NULL),
('prod_postres_008', 'Torta de Zanahoria', 'Con frosting de queso crema', 12500, 'postres_especiales', 'https://images.unsplash.com/photo-1587049352846-4a222e784004?w=400', 25, 4.7, 0, 0, NULL),
('prod_postres_009', 'Crème Brûlée', 'Crème brûlée francesa', 14000, 'postres_especiales', 'https://images.unsplash.com/photo-1470124182917-cc6e71b22ecc?w=400', 18, 4.9, 1, 0, NULL),
('prod_postres_010', 'Pie de Limón', 'Pie de limón merengado', 11000, 'postres_especiales', 'https://images.unsplash.com/photo-1535920527002-b35e96722eb9?w=400', 32, 4.6, 0, 1, 9350),
('prod_postres_011', 'Profiteroles', 'Profiteroles con chocolate', 15000, 'postres_especiales', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400', 16, 4.8, 0, 0, NULL),
('prod_postres_012', 'Panna Cotta', 'Panna cotta italiana', 12000, 'postres_especiales', 'https://images.unsplash.com/photo-1563379091339-03b47878d44e?w=400', 27, 4.7, 0, 0, NULL),
('prod_postres_013', 'Brownie Vegano', 'Brownie 100% vegano', 14000, 'postres_especiales', 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400', 21, 4.6, 0, 0, NULL),
('prod_postres_014', 'Cheesecake NY', 'New York style cheesecake', 18000, 'postres_especiales', 'https://images.unsplash.com/photo-1524351199678-941a58a3df50?w=400', 15, 5.0, 1, 0, NULL),
('prod_postres_015', 'Red Velvet', 'Torta red velvet premium', 16000, 'postres_especiales', 'https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=400', 19, 4.9, 1, 1, 13600),
('prod_postres_016', 'Postre de Oreo', 'Con galletas Oreo', 13000, 'postres_especiales', 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400', 29, 4.7, 0, 0, NULL),
('prod_postres_017', 'Tarta de Manzana', 'Tarta de manzana casera', 12000, 'postres_especiales', 'https://images.unsplash.com/photo-1535920527002-b35e96722eb9?w=400', 26, 4.6, 0, 0, NULL),
('prod_postres_018', 'Postre de Maracuyá', 'Mousse de maracuyá', 11500, 'postres_especiales', 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400', 33, 4.7, 0, 0, NULL),
('prod_postres_019', 'Pastel Imposible', 'Flan y chocolate en uno', 15000, 'postres_especiales', 'https://images.unsplash.com/photo-1571115177098-24ec42ed204d?w=400', 20, 4.8, 0, 0, NULL),
('prod_postres_020', 'Carlota de Limón', 'Carlota de limón refrescante', 10000, 'postres_especiales', 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=400', 36, 4.5, 0, 0, NULL),
('prod_postres_021', 'Volcán de Chocolate', 'Volcán de chocolate fundido', 17000, 'postres_especiales', 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400', 17, 4.9, 1, 0, NULL),
('prod_postres_022', 'Milhojas', 'Milhojas con crema pastelera', 14500, 'postres_especiales', 'https://images.unsplash.com/photo-1464219789935-c2d9d9aba644?w=400', 23, 4.7, 0, 0, NULL),
('prod_postres_023', 'Éclair de Chocolate', 'Éclair francés premium', 13500, 'postres_especiales', 'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?w=400', 22, 4.8, 0, 0, NULL),
('prod_postres_024', 'Marquesa de Chocolate', 'Marquesa con galletas María', 12500, 'postres_especiales', 'https://images.unsplash.com/photo-1607920591413-4ec007e70023?w=400', 28, 4.7, 0, 0, NULL),
('prod_postres_025', 'Postre Signature', 'Creación exclusiva del chef', 25000, 'postres_especiales', 'https://images.unsplash.com/photo-1533134242-ed4c976b38e5?w=400', 10, 5.0, 1, 1, 21250);

PRINT '   ✅ 25 productos de Postres Especiales';

-- Bebidas Cremosas (25 productos)
INSERT INTO Products (id, name, description, price, category, image, stock, rating, is_featured, on_sale, sale_price) VALUES
('prod_bebidas_001', 'Milkshake de Chocolate', 'Milkshake cremoso de chocolate', 9500, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400', 60, 4.7, 1, 0, NULL),
('prod_bebidas_002', 'Smoothie de Fresa', 'Smoothie natural de fresa', 10500, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=400', 55, 4.8, 1, 0, NULL),
('prod_bebidas_003', 'Frappé de Vainilla', 'Frappé helado de vainilla', 9000, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400', 50, 4.6, 0, 0, NULL),
('prod_bebidas_004', 'Batido de Mango', 'Batido tropical de mango', 10000, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1546173159-315724a31696?w=400', 48, 4.7, 0, 0, NULL),
('prod_bebidas_005', 'Milkshake de Oreo', 'Con galletas Oreo trituradas', 11000, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1579954115545-a95591f28bfc?w=400', 42, 4.9, 1, 1, 9350),
('prod_bebidas_006', 'Smoothie Verde', 'Smoothie detox verde', 11500, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1610970881699-44a5587cabec?w=400', 38, 4.5, 0, 0, NULL),
('prod_bebidas_007', 'Frappé Mocha', 'Café y chocolate combinados', 9500, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400', 52, 4.8, 1, 0, NULL),
('prod_bebidas_008', 'Batido de Banano', 'Batido cremoso de banano', 8500, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1546173159-315724a31696?w=400', 62, 4.4, 0, 0, NULL),
('prod_bebidas_009', 'Milkshake de Fresa', 'Milkshake con fresas naturales', 10000, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400', 56, 4.7, 0, 0, NULL),
('prod_bebidas_010', 'Smoothie de Arándanos', 'Rico en antioxidantes', 12000, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1610970881699-44a5587cabec?w=400', 32, 4.8, 0, 1, 10200),
('prod_bebidas_011', 'Frappé de Caramelo', 'Con salsa de caramelo', 10500, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400', 40, 4.6, 0, 0, NULL),
('prod_bebidas_012', 'Batido Proteico', 'Con proteína whey', 13000, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1546173159-315724a31696?w=400', 28, 4.7, 0, 0, NULL),
('prod_bebidas_013', 'Milkshake Dulce de Leche', 'Con dulce de leche argentino', 10500, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1579954115545-a95591f28bfc?w=400', 44, 4.8, 0, 0, NULL),
('prod_bebidas_014', 'Smoothie Tropical', 'Mix de frutas tropicales', 11000, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=400', 36, 4.7, 0, 0, NULL),
('prod_bebidas_015', 'Frappé de Cookies', 'Con galletas de chocolate', 11500, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400', 30, 4.9, 1, 1, 9775),
('prod_bebidas_016', 'Batido Energizante', 'Con guaraná y cafeína', 12000, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1546173159-315724a31696?w=400', 34, 4.6, 0, 0, NULL),
('prod_bebidas_017', 'Milkshake XXL', 'Porción extra grande', 16000, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400', 20, 5.0, 1, 0, NULL),
('prod_bebidas_018', 'Smoothie Detox', 'Limpieza y energía', 13000, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1610970881699-44a5587cabec?w=400', 26, 4.7, 0, 0, NULL),
('prod_bebidas_019', 'Frappé Light', 'Bajo en calorías', 8500, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400', 53, 4.5, 0, 0, NULL),
('prod_bebidas_020', 'Batido de Aguacate', 'Cremoso y nutritivo', 10500, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1546173159-315724a31696?w=400', 35, 4.6, 0, 0, NULL),
('prod_bebidas_021', 'Milkshake de Nutella', 'Con Nutella original', 12500, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1579954115545-a95591f28bfc?w=400', 31, 4.9, 1, 0, NULL),
('prod_bebidas_022', 'Smoothie de Papaya', 'Papaya fresca y cremosa', 9500, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=400', 41, 4.6, 0, 0, NULL),
('prod_bebidas_023', 'Frappé de Menta', 'Refrescante de menta', 9500, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400', 37, 4.7, 0, 0, NULL),
('prod_bebidas_024', 'Batido de Coco', 'Con leche de coco fresca', 11000, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1546173159-315724a31696?w=400', 33, 4.7, 0, 0, NULL),
('prod_bebidas_025', 'Milkshake Premium', 'Edición especial premium', 18000, 'bebidas_cremosas', 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400', 15, 5.0, 1, 1, 15300);

PRINT '   ✅ 25 productos de Bebidas Cremosas';
PRINT '';
PRINT '   ✅✅✅ TOTAL: 100 PRODUCTOS CREADOS ✅✅✅';
PRINT '';

-- ============================================
-- RESUMEN
-- ============================================
DECLARE @totalUsers INT, @totalCategories INT, @totalProducts INT, @totalSuppliers INT;

SELECT @totalUsers = COUNT(*) FROM Users;
SELECT @totalCategories = COUNT(*) FROM Categories;
SELECT @totalProducts = COUNT(*) FROM Products;
SELECT @totalSuppliers = COUNT(*) FROM Suppliers;

PRINT '✅ Seed completado exitosamente';
PRINT '📊 Datos insertados:';
PRINT '   - ' + CAST(@totalUsers AS NVARCHAR) + ' usuarios';
PRINT '   - ' + CAST(@totalCategories AS NVARCHAR) + ' categorías';
PRINT '   - ' + CAST(@totalProducts AS NVARCHAR) + ' productos';
PRINT '   - ' + CAST(@totalSuppliers AS NVARCHAR) + ' proveedores';
PRINT '';
PRINT '🎉 BASE DE DATOS LISTA CON 100 PRODUCTOS!';
PRINT '';
PRINT '💡 Puedes ver los datos en SQL Server Management Studio:';
PRINT '   Servidor: JUANPABLO\SQLEXPRESS';
PRINT '   Base de datos: CremososDB';
PRINT '';
