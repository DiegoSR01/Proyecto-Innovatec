-- ========================================
-- LIMPIEZA Y REINSERCION DE CATEGORIAS
-- ========================================
-- Este script limpia las categorias duplicadas y las reinserta correctamente

-- ⚠️ IMPORTANTE: Ejecutar SOLO si ya se eliminaron los eventos
-- O usar master_cleanup_fixed.sql para limpieza completa

SET FOREIGN_KEY_CHECKS = 0; -- Desactivar verificaciones FK temporalmente

-- Eliminar todas las categorias existentes para evitar duplicados
DELETE FROM `categorias`;

-- Reiniciar el auto increment
ALTER TABLE `categorias` AUTO_INCREMENT = 1;

SET FOREIGN_KEY_CHECKS = 1; -- Reactivar verificaciones FK

-- ========================================
-- INSERCION DE CATEGORIAS LIMPIAS
-- ========================================
-- Categorias bien definidas sin duplicados, con iconos y colores

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

-- Verificar las categorias insertadas
SELECT 
    id,
    nombre,
    descripcion,
    icono,
    color,
    activo
FROM categorias 
ORDER BY id;