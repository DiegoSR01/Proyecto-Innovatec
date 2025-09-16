-- ========================================
-- LIMPIEZA Y REINSERCION DE ROLES
-- ========================================
-- Este script define la jerarquia correcta de roles:
-- 1 = asistente (nivel básico)
-- 2 = productor (crea eventos)
-- 3 = organizador (gestiona todo)

-- ⚠️ IMPORTANTE: Ejecutar SOLO si ya se eliminaron los usuarios
-- O usar master_cleanup_fixed.sql para limpieza completa

SET FOREIGN_KEY_CHECKS = 0; -- Desactivar verificaciones FK temporalmente

-- Eliminar todos los roles existentes
DELETE FROM `roles`;

-- Reiniciar el auto increment
ALTER TABLE `roles` AUTO_INCREMENT = 1;

SET FOREIGN_KEY_CHECKS = 1; -- Reactivar verificaciones FK

-- ========================================
-- INSERCION DE ROLES CON JERARQUIA
-- ========================================

INSERT INTO `roles` (`nombre`, `descripcion`, `permisos`, `created_at`, `updated_at`) VALUES
-- 1. Asistente (nivel básico)
('asistente', 'Usuario que asiste a eventos', '[\"view_events\",\"register_events\",\"rate_events\",\"add_favorites\",\"view_profile\"]', NOW(), NOW()),

-- 2. Productor (crea y gestiona sus eventos)
('productor', 'Usuario que crea y gestiona sus propios eventos', '[\"view_events\",\"register_events\",\"rate_events\",\"add_favorites\",\"view_profile\",\"create_events\",\"edit_own_events\",\"manage_own_events\",\"view_own_analytics\",\"upload_images\"]', NOW(), NOW()),

-- 3. Organizador (administra plataforma y todos los eventos)
('organizador', 'Administrador que gestiona la plataforma y todos los eventos', '[\"*\"]', NOW(), NOW());

-- Verificar los roles insertados
SELECT 
    id,
    nombre,
    descripcion,
    permisos,
    created_at,
    updated_at
FROM roles 
ORDER BY id;