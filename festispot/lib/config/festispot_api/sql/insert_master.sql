-- ========================================
-- SCRIPT MAESTRO DE LIMPIEZA COMPLETA
-- ========================================
-- Este script maneja correctamente las restricciones de clave foránea
-- eliminando datos en el orden correcto para evitar errores FK

-- IMPORTANTE: Este script ELIMINA todos los datos existentes
-- Solo ejecutar en entorno de desarrollo/testing

-- ========================================
-- 1. DESHABILITAR FOREIGN KEY CHECKS (método robusto)
-- ========================================
SET SESSION foreign_key_checks = 0;
SET @OLD_FOREIGN_KEY_CHECKS = @@foreign_key_checks;
SET foreign_key_checks = 0;

-- ========================================
-- 2. LIMPIAR TABLAS CON DEPENDENCIAS (orden específico)
-- ========================================

-- Primero eliminar todas las tablas que referencian otras
DELETE FROM `analytics_evento`;
DELETE FROM `imagenes_evento`;
DELETE FROM `asistencias`;
DELETE FROM `favoritos`;
DELETE FROM `reviews`;
DELETE FROM `notificaciones`;
DELETE FROM `configuraciones_usuario`;
DELETE FROM `suscripciones_organizador`;

-- Eliminar eventos (referencian categorias, ubicaciones, users)
DELETE FROM `events`;

-- Eliminar TODOS los usuarios (referencian roles)
DELETE FROM `users`;

-- Eliminar ubicaciones
DELETE FROM `ubicaciones`;

-- Eliminar categorías
DELETE FROM `categorias`;

-- Finalmente eliminar roles
DELETE FROM `roles`;

-- ========================================
-- 3. REINICIAR AUTO INCREMENT
-- ========================================

ALTER TABLE `analytics_evento` AUTO_INCREMENT = 1;
ALTER TABLE `imagenes_evento` AUTO_INCREMENT = 1;
ALTER TABLE `asistencias` AUTO_INCREMENT = 1;
ALTER TABLE `favoritos` AUTO_INCREMENT = 1;
ALTER TABLE `reviews` AUTO_INCREMENT = 1;
ALTER TABLE `notificaciones` AUTO_INCREMENT = 1;
ALTER TABLE `configuraciones_usuario` AUTO_INCREMENT = 1;
ALTER TABLE `suscripciones_organizador` AUTO_INCREMENT = 1;
ALTER TABLE `events` AUTO_INCREMENT = 1;
ALTER TABLE `users` AUTO_INCREMENT = 1;
ALTER TABLE `categorias` AUTO_INCREMENT = 1;
ALTER TABLE `ubicaciones` AUTO_INCREMENT = 1;
ALTER TABLE `roles` AUTO_INCREMENT = 1;

-- ========================================
-- 4. INSERTAR ROLES PRIMERO (son la base de todo)
-- ========================================

INSERT INTO `roles` (`nombre`, `descripcion`, `permisos`, `created_at`, `updated_at`) VALUES
-- 1. Asistente (nivel básico)
('asistente', 'Usuario que asiste a eventos', '[\"view_events\",\"register_events\",\"rate_events\",\"add_favorites\",\"view_profile\"]', NOW(), NOW()),

-- 2. Productor (crea y gestiona sus eventos)
('productor', 'Usuario que crea y gestiona sus propios eventos', '[\"view_events\",\"register_events\",\"rate_events\",\"add_favorites\",\"view_profile\",\"create_events\",\"edit_own_events\",\"manage_own_events\",\"view_own_analytics\",\"upload_images\"]', NOW(), NOW()),

-- 3. Organizador (administra plataforma y todos los eventos)
('organizador', 'Administrador que gestiona la plataforma y todos los eventos', '[\"*\"]', NOW(), NOW());

-- ========================================
-- 5. INSERTAR CATEGORIAS 
-- ========================================

INSERT INTO `categorias` (`nombre`, `descripcion`, `icono`, `color`, `activo`, `created_at`, `updated_at`) VALUES
-- 1. Música
('Música', 'Conciertos, festivales musicales y eventos sonoros', 'music', '#FF6B6B', 1, NOW(), NOW()),

-- 2. Arte
('Arte', 'Exposiciones, galerías de arte, eventos artísticos y culturales', 'palette', '#4ECDC4', 1, NOW(), NOW()),

-- 3. Gastronomía
('Gastronomía', 'Festivales culinarios, catas y eventos gastronómicos', 'restaurant', '#45B7D1', 1, NOW(), NOW()),

-- 4. Deportes
('Deportes', 'Eventos deportivos, competencias y actividades físicas', 'sports', '#96CEB4', 1, NOW(), NOW()),

-- 5. Tecnología
('Tecnología', 'Conferencias tech, workshops y eventos tecnológicos', 'computer', '#FFEAA7', 1, NOW(), NOW()),

-- 6. Cultura
('Cultura', 'Eventos culturales, tradiciones y patrimonio', 'theater', '#DDA0DD', 1, NOW(), NOW()),

-- 7. Educativo
('Educativo', 'Talleres, cursos, seminarios y eventos educativos', 'school', '#FFA07A', 1, NOW(), NOW()),

-- 8. Entretenimiento
('Entretenimiento', 'Shows, espectáculos y eventos de entretenimiento general', 'celebration', '#98D8E8', 1, NOW(), NOW()),

-- 9. Negocios
('Negocios', 'Conferencias empresariales, networking y eventos corporativos', 'business', '#F7DC6F', 1, NOW(), NOW()),

-- 10. Salud y Bienestar
('Salud y Bienestar', 'Eventos de yoga, meditación, fitness y bienestar', 'spa', '#ABEBC6', 1, NOW(), NOW()),

-- 11. Familia
('Familia', 'Eventos familiares, actividades para niños y padres', 'family', '#F8C471', 1, NOW(), NOW()),

-- 12. Religioso
('Religioso', 'Eventos religiosos, ceremonias y celebraciones espirituales', 'church', '#D2B4DE', 1, NOW(), NOW());

-- ========================================
-- 6. INSERTAR USUARIOS DE PRUEBA
-- ========================================

INSERT INTO `users` (
    `nombre`, `apellido`, `email`, `telefono`, `fecha_nacimiento`, `genero`, 
    `rol_id`, `estado`, `fecha_registro`, `password`
) VALUES 
-- Usuario Asistente (rol_id = 1)
('Usuario', 'Asistente', 'asistente@festispot.com', '+52 555 123 4567', 
 '1995-05-15', 'prefiero_no_decir', 1, 'activo', NOW(), 
 '$2y$10$A2ohSR9Z7aleXOMl/ckoLePqWGolc.TauyVIt0XHqFtVuAVBojKaq'), -- password: "asistente123"

-- Usuario Productor (rol_id = 2) 
('Usuario', 'Productor', 'productor@festispot.com', '+52 555 987 6543', 
 '1988-12-03', 'masculino', 2, 'activo', NOW(), 
 '$2y$10$A2ohSR9Z7aleXOMl/ckoLePqWGolc.TauyVIt0XHqFtVuAVBojKaq'), -- password: "productor123"

-- Usuario Organizador (rol_id = 3)
('Admin', 'Organizador', 'organizador@festispot.com', '+52 555 000 0000', 
 '1985-01-01', 'otro', 3, 'activo', NOW(), 
 '$2y$10$A2ohSR9Z7aleXOMl/ckoLePqWGolc.TauyVIt0XHqFtVuAVBojKaq'); -- password: "organizador123"

-- ========================================
-- 7. REHABILITAR FOREIGN KEY CHECKS
-- ========================================
SET foreign_key_checks = @OLD_FOREIGN_KEY_CHECKS;
SET SESSION foreign_key_checks = 1;

-- ========================================
-- 8. RESULTADO Y VERIFICACION
-- ========================================

-- Verificar roles
SELECT 'ROLES CREADOS:' as Info;
SELECT id, nombre, descripcion FROM roles ORDER BY id;

-- Verificar categorías
SELECT 'CATEGORIAS CREADAS:' as Info;
SELECT id, nombre, descripcion, icono, color FROM categorias ORDER BY id;

-- Verificar usuarios
SELECT 'USUARIOS CREADOS:' as Info;
SELECT 
    u.id,
    u.nombre,
    u.apellido, 
    u.email,
    r.nombre as rol,
    u.estado
FROM users u 
JOIN roles r ON u.rol_id = r.id 
ORDER BY u.id;

-- ========================================
-- INSTRUCCIONES DE USO
-- ========================================

/*
CREDENCIALES DE USUARIOS DE PRUEBA:

1. ASISTENTE:
   Email: asistente@festispot.com
   Password: asistente123
   Rol: Asistente (ID: 1)

2. PRODUCTOR:
   Email: productor@festispot.com  
   Password: productor123
   Rol: Productor (ID: 2)

3. ORGANIZADOR:
   Email: organizador@festispot.com
   Password: organizador123
   Rol: Organizador (ID: 3)

SIGUIENTE PASO:
Para agregar eventos, ejecutar: insert_events.sql
(ya incluye la obtención automática del productor_id)
*/