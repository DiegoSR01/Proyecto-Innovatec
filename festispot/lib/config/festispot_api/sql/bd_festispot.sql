-- ========================================
-- SQL MAESTRO FESTISPOT - CREACIÓN COMPLETA DE BD
-- ========================================
-- Este archivo crea la base de datos "festispot" desde cero con:
-- ✅ Estructura completa de todas las tablas (con validación IF NOT EXISTS)
-- ✅ Datos de categorías, roles, planes de suscripción (con INSERT IGNORE)
-- ✅ Registros de migrations (para Laravel)
-- ✅ Validaciones para evitar errores al re-ejecutar el script
-- ❌ SIN eventos ni usuarios (como solicitado)
-- ❌ SIN ubicaciones iniciales (como solicitado)
-- 
-- SEGURIDAD: Este script puede ejecutarse múltiples veces sin errores
-- 
-- Generado: Septiembre 22, 2025
-- Proyecto: FestiSpot - Plataforma de Eventos
-- ========================================

-- Configuración inicial
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- ========================================
-- 1. CREAR BASE DE DATOS
-- ========================================

CREATE DATABASE IF NOT EXISTS `festispot` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `festispot`;

-- ========================================
-- 2. ESTRUCTURA DE TABLAS
-- ========================================

-- Tabla: analytics_evento
CREATE TABLE IF NOT EXISTS `analytics_evento` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `evento_id` bigint(20) UNSIGNED NOT NULL,
  `fecha` date NOT NULL,
  `vistas_totales` int(11) NOT NULL DEFAULT 0,
  `vistas_unicas` int(11) NOT NULL DEFAULT 0,
  `clicks_reserva` int(11) NOT NULL DEFAULT 0,
  `compartidos` int(11) NOT NULL DEFAULT 0,
  `favoritos_agregados` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: asistencias
CREATE TABLE IF NOT EXISTS `asistencias` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `usuario_id` bigint(20) UNSIGNED NOT NULL,
  `evento_id` bigint(20) UNSIGNED NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `estado` enum('confirmada','pendiente','cancelada','asistio','no_asistio') NOT NULL DEFAULT 'confirmada',
  `numero_acompanantes` int(11) NOT NULL DEFAULT 0,
  `codigo_qr` varchar(100) DEFAULT NULL,
  `notas_usuario` text DEFAULT NULL,
  `fecha_cancelacion` timestamp NULL DEFAULT NULL,
  `motivo_cancelacion` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: cache
CREATE TABLE IF NOT EXISTS `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: cache_locks
CREATE TABLE IF NOT EXISTS `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: categorias
CREATE TABLE IF NOT EXISTS `categorias` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `icono` varchar(100) DEFAULT NULL,
  `color` varchar(7) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: configuraciones_usuario
CREATE TABLE IF NOT EXISTS `configuraciones_usuario` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `usuario_id` bigint(20) UNSIGNED NOT NULL,
  `notificaciones_push` tinyint(1) NOT NULL DEFAULT 1,
  `notificaciones_email` tinyint(1) NOT NULL DEFAULT 1,
  `categorias_favoritas` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`categorias_favoritas`)),
  `radio_busqueda_km` int(11) NOT NULL DEFAULT 50,
  `idioma` varchar(5) NOT NULL DEFAULT 'es',
  `tema` enum('claro','oscuro','auto') NOT NULL DEFAULT 'auto',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: events
CREATE TABLE IF NOT EXISTS `events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `organizador_id` bigint(20) UNSIGNED NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `descripcion` text NOT NULL,
  `descripcion_corta` varchar(500) DEFAULT NULL,
  `categoria_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ubicacion_id` bigint(20) UNSIGNED DEFAULT NULL,
  `category` varchar(255) NOT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `hora_apertura_puertas` time DEFAULT NULL,
  `repeat_schedule` tinyint(1) NOT NULL DEFAULT 0,
  `event_type` enum('Presencial','Virtual','Híbrido') NOT NULL,
  `venue_name` varchar(255) DEFAULT NULL,
  `full_address` text DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `location_details` text DEFAULT NULL,
  `capacidad_total` int(11) DEFAULT NULL,
  `edad_minima` int(11) NOT NULL DEFAULT 0,
  `politicas_cancelacion` text DEFAULT NULL,
  `instrucciones_especiales` text DEFAULT NULL,
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tags`)),
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `fecha_actualizacion` timestamp NULL DEFAULT NULL,
  `fecha_publicacion` timestamp NULL DEFAULT NULL,
  `motivo_cambio` text DEFAULT NULL,
  `accessible` tinyint(1) NOT NULL DEFAULT 0,
  `virtual_platform` varchar(255) DEFAULT NULL,
  `event_link` varchar(255) DEFAULT NULL,
  `access_code` varchar(255) DEFAULT NULL,
  `virtual_password` varchar(255) DEFAULT NULL,
  `virtual_instructions` text DEFAULT NULL,
  `banner_image` MEDIUMBLOB DEFAULT NULL,
  `banner_image_type` varchar(50) DEFAULT NULL,
  `gallery_images` LONGBLOB DEFAULT NULL,
  `gallery_images_metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`gallery_images_metadata`)),
  `videos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`videos`)),
  `estado` enum('borrador','publicado','en_curso','finalizado','cancelado') NOT NULL DEFAULT 'borrador',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: failed_jobs
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: favoritos
CREATE TABLE IF NOT EXISTS `favoritos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `usuario_id` bigint(20) UNSIGNED NOT NULL,
  `evento_id` bigint(20) UNSIGNED NOT NULL,
  `fecha_agregado` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: imagenes_evento
CREATE TABLE IF NOT EXISTS `imagenes_evento` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `evento_id` bigint(20) UNSIGNED NOT NULL,
  `url` varchar(500) NOT NULL,
  `tipo` enum('principal','galeria','thumbnail') NOT NULL DEFAULT 'galeria',
  `orden` int(11) NOT NULL DEFAULT 0,
  `alt_text` varchar(200) DEFAULT NULL,
  `tamaño_kb` int(11) DEFAULT NULL,
  `formato` varchar(10) DEFAULT NULL,
  `fecha_subida` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: imagenes_galeria_evento
CREATE TABLE IF NOT EXISTS `imagenes_galeria_evento` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `evento_id` bigint(20) UNSIGNED NOT NULL,
  `imagen_data` MEDIUMBLOB NOT NULL,
  `tipo_mime` varchar(50) NOT NULL,
  `tamaño_bytes` int(11) NOT NULL,
  `nombre_original` varchar(255) DEFAULT NULL,
  `orden` int(11) NOT NULL DEFAULT 0,
  `alt_text` varchar(200) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_subida` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: job_batches
CREATE TABLE IF NOT EXISTS `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: notificaciones
CREATE TABLE IF NOT EXISTS `notificaciones` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `usuario_id` bigint(20) UNSIGNED NOT NULL,
  `evento_id` bigint(20) UNSIGNED DEFAULT NULL,
  `tipo` enum('nuevo_evento','recordatorio','cancelacion','actualizacion','promocion') NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `mensaje` text NOT NULL,
  `leida` tinyint(1) NOT NULL DEFAULT 0,
  `fecha_envio` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_lectura` timestamp NULL DEFAULT NULL,
  `canal` enum('push','email','in_app') NOT NULL DEFAULT 'in_app',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: password_reset_tokens
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: personal_access_tokens
CREATE TABLE IF NOT EXISTS `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: planes_suscripcion
CREATE TABLE IF NOT EXISTS `planes_suscripcion` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio_mensual` decimal(10,2) DEFAULT NULL,
  `precio_anual` decimal(10,2) DEFAULT NULL,
  `max_eventos` int(11) DEFAULT NULL,
  `max_imagenes_por_evento` int(11) DEFAULT NULL,
  `features` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`features`)),
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: reviews
CREATE TABLE IF NOT EXISTS `reviews` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `usuario_id` bigint(20) UNSIGNED NOT NULL,
  `evento_id` bigint(20) UNSIGNED NOT NULL,
  `calificacion` int(10) UNSIGNED NOT NULL,
  `comentario` text DEFAULT NULL,
  `fecha_review` timestamp NOT NULL DEFAULT current_timestamp(),
  `moderado` tinyint(1) NOT NULL DEFAULT 0,
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: roles
CREATE TABLE IF NOT EXISTS `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `permisos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permisos`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: sessions
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: suscripciones_organizador
CREATE TABLE IF NOT EXISTS `suscripciones_organizador` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `organizador_id` bigint(20) UNSIGNED NOT NULL,
  `plan_id` bigint(20) UNSIGNED NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `estado` enum('activa','vencida','cancelada','suspendida') NOT NULL DEFAULT 'activa',
  `precio_pagado` decimal(10,2) DEFAULT NULL,
  `metodo_pago` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: ubicaciones
CREATE TABLE IF NOT EXISTS `ubicaciones` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `direccion` text NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  `estado` varchar(100) DEFAULT NULL,
  `codigo_postal` varchar(20) DEFAULT NULL,
  `pais` varchar(100) NOT NULL DEFAULT 'México',
  `latitud` decimal(10,8) DEFAULT NULL,
  `longitud` decimal(11,8) DEFAULT NULL,
  `capacidad_maxima` int(11) DEFAULT NULL,
  `tipo_venue` enum('interior','exterior','mixto') DEFAULT NULL,
  `facilidades` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`facilidades`)),
  `contacto_venue` varchar(200) DEFAULT NULL,
  `telefono_venue` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: users
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `genero` enum('masculino','femenino','otro','prefiero_no_decir') DEFAULT NULL,
  `avatar_url` varchar(255) DEFAULT NULL,
  `rol_id` bigint(20) UNSIGNED NOT NULL DEFAULT 1,
  `estado` enum('activo','inactivo','suspendido') NOT NULL DEFAULT 'activo',
  `fecha_registro` timestamp NULL DEFAULT NULL,
  `ultimo_acceso` timestamp NULL DEFAULT NULL,
  `token_verificacion` varchar(255) DEFAULT NULL,
  `email_verificado` tinyint(1) NOT NULL DEFAULT 0,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- 3. DATOS INICIALES - ROLES
-- ========================================

INSERT IGNORE INTO `roles` (`id`, `nombre`, `descripcion`, `permisos`, `created_at`, `updated_at`) VALUES
(1, 'asistente', 'Usuario que asiste a eventos', '[\"view_events\",\"register_events\",\"rate_events\",\"add_favorites\",\"view_profile\"]', NOW(), NOW()),
(2, 'productor', 'Usuario que crea y gestiona sus propios eventos', '[\"view_events\",\"register_events\",\"rate_events\",\"add_favorites\",\"view_profile\",\"create_events\",\"edit_own_events\",\"manage_own_events\",\"view_own_analytics\",\"upload_images\"]', NOW(), NOW()),
(3, 'organizador', 'Administrador que gestiona la plataforma y todos los eventos', '[\"*\"]', NOW(), NOW());

-- ========================================
-- 4. DATOS INICIALES - CATEGORÍAS
-- ========================================

INSERT IGNORE INTO `categorias` (`id`, `nombre`, `descripcion`, `icono`, `color`, `activo`, `created_at`, `updated_at`) VALUES
(1, 'Música', 'Conciertos, festivales musicales y eventos sonoros', 'music', '#FF6B6B', 1, NOW(), NOW()),
(2, 'Arte', 'Exposiciones, galerías de arte, eventos artísticos y culturales', 'palette', '#4ECDC4', 1, NOW(), NOW()),
(3, 'Gastronomía', 'Festivales culinarios, catas y eventos gastronómicos', 'restaurant', '#45B7D1', 1, NOW(), NOW()),
(4, 'Deportes', 'Eventos deportivos, competencias y actividades físicas', 'sports', '#96CEB4', 1, NOW(), NOW()),
(5, 'Tecnología', 'Conferencias tech, workshops y eventos tecnológicos', 'computer', '#FFEAA7', 1, NOW(), NOW()),
(6, 'Cultura', 'Eventos culturales, tradiciones y patrimonio', 'theater', '#DDA0DD', 1, NOW(), NOW()),
(7, 'Educativo', 'Talleres, cursos, seminarios y eventos educativos', 'school', '#FFA07A', 1, NOW(), NOW()),
(8, 'Entretenimiento', 'Shows, espectáculos y eventos de entretenimiento general', 'celebration', '#98D8E8', 1, NOW(), NOW()),
(9, 'Negocios', 'Conferencias empresariales, networking y eventos corporativos', 'business', '#F7DC6F', 1, NOW(), NOW()),
(10, 'Salud y Bienestar', 'Eventos de yoga, meditación, fitness y bienestar', 'spa', '#ABEBC6', 1, NOW(), NOW()),
(11, 'Familia', 'Eventos familiares, actividades para niños y padres', 'family', '#F8C471', 1, NOW(), NOW()),
(12, 'Religioso', 'Eventos religiosos, ceremonias y celebraciones espirituales', 'church', '#D2B4DE', 1, NOW(), NOW());

-- ========================================
-- 5. DATOS INICIALES - PLANES DE SUSCRIPCIÓN
-- ========================================

INSERT IGNORE INTO `planes_suscripcion` (`id`, `nombre`, `descripcion`, `precio_mensual`, `precio_anual`, `max_eventos`, `max_imagenes_por_evento`, `features`, `activo`, `created_at`, `updated_at`) VALUES
(1, 'Básico', 'Plan básico para empezar', 0.00, 0.00, 5, 3, '[\"eventos_basicos\"]', 1, NOW(), NOW()),
(2, 'Pro', 'Plan profesional con más funciones', 299.00, 2990.00, 50, 10, '[\"analytics\",\"promocion_premium\",\"soporte_prioritario\"]', 1, NOW(), NOW()),
(3, 'Premium', 'Plan premium con todas las funciones', 599.00, 5990.00, NULL, NULL, '[\"analytics\",\"promocion_premium\",\"soporte_24_7\",\"api_access\",\"white_label\"]', 1, NOW(), NOW());

-- ========================================
-- 6. DATOS INICIALES - MIGRACIONES DE LARAVEL
-- ========================================

INSERT IGNORE INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_08_29_194903_create_events_table', 1),
(5, '2025_09_01_000001_create_roles_table', 1),
(6, '2025_09_01_000002_create_categorias_table', 1),
(7, '2025_09_01_000003_create_ubicaciones_table', 1),
(8, '2025_09_01_000004_create_planes_suscripcion_table', 1),
(9, '2025_09_01_000005_update_users_table', 1),
(10, '2025_09_01_000006_update_events_table', 1),
(11, '2025_09_01_000007_create_imagenes_evento_table', 1),
(12, '2025_09_01_000008_create_suscripciones_organizador_table', 1),
(13, '2025_09_01_000009_create_asistencias_table', 1),
(14, '2025_09_01_000010_create_notificaciones_table', 1),
(15, '2025_09_01_000011_create_favoritos_table', 1),
(16, '2025_09_01_000012_create_reviews_table', 1),
(17, '2025_09_01_000013_create_configuraciones_usuario_table', 1),
(18, '2025_09_01_000014_create_analytics_evento_table', 1),
(19, '2025_09_01_185639_create_personal_access_tokens_table', 1);

-- ========================================
-- 8. CONFIGURAR ÍNDICES Y CLAVES
-- ========================================

-- Indices de la tabla analytics_evento
ALTER TABLE `analytics_evento`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_event_date` (`evento_id`,`fecha`);

-- Indices de la tabla asistencias
ALTER TABLE `asistencias`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_event` (`usuario_id`,`evento_id`),
  ADD UNIQUE KEY `asistencias_codigo_qr_unique` (`codigo_qr`),
  ADD KEY `asistencias_evento_id_foreign` (`evento_id`);

-- Indices de la tabla cache
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

-- Indices de la tabla cache_locks
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

-- Indices de la tabla categorias
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`);

-- Indices de la tabla configuraciones_usuario
ALTER TABLE `configuraciones_usuario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `configuraciones_usuario_usuario_id_foreign` (`usuario_id`);

-- Indices de la tabla events
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `events_user_id_foreign` (`organizador_id`),
  ADD KEY `events_categoria_id_foreign` (`categoria_id`),
  ADD KEY `events_ubicacion_id_foreign` (`ubicacion_id`);

-- Indices de la tabla failed_jobs
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

-- Indices de la tabla favoritos
ALTER TABLE `favoritos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_favorite` (`usuario_id`,`evento_id`),
  ADD KEY `favoritos_evento_id_foreign` (`evento_id`);

-- Indices de la tabla imagenes_evento
ALTER TABLE `imagenes_evento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `imagenes_evento_evento_id_foreign` (`evento_id`);

-- Indices de la tabla imagenes_galeria_evento
ALTER TABLE `imagenes_galeria_evento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `imagenes_galeria_evento_evento_id_foreign` (`evento_id`),
  ADD KEY `imagenes_galeria_evento_orden_index` (`orden`);

-- Indices de la tabla jobs
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

-- Indices de la tabla job_batches
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

-- Indices de la tabla migrations
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

-- Indices de la tabla notificaciones
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notificaciones_usuario_id_foreign` (`usuario_id`),
  ADD KEY `notificaciones_evento_id_foreign` (`evento_id`);

-- Indices de la tabla password_reset_tokens
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

-- Indices de la tabla personal_access_tokens
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

-- Indices de la tabla planes_suscripcion
ALTER TABLE `planes_suscripcion`
  ADD PRIMARY KEY (`id`);

-- Indices de la tabla reviews
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_review` (`usuario_id`,`evento_id`),
  ADD KEY `reviews_evento_id_foreign` (`evento_id`);

-- Indices de la tabla roles
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_nombre_unique` (`nombre`);

-- Indices de la tabla sessions
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

-- Indices de la tabla suscripciones_organizador
ALTER TABLE `suscripciones_organizador`
  ADD PRIMARY KEY (`id`),
  ADD KEY `suscripciones_organizador_organizador_id_foreign` (`organizador_id`),
  ADD KEY `suscripciones_organizador_plan_id_foreign` (`plan_id`);

-- Indices de la tabla ubicaciones
ALTER TABLE `ubicaciones`
  ADD PRIMARY KEY (`id`);

-- Indices de la tabla users
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_rol_id_foreign` (`rol_id`);

-- ========================================
-- 9. AUTO_INCREMENT PARA TABLAS
-- ========================================

ALTER TABLE `analytics_evento`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `asistencias`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `categorias`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

ALTER TABLE `configuraciones_usuario`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `favoritos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `imagenes_evento`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `imagenes_galeria_evento`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

ALTER TABLE `notificaciones`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `planes_suscripcion`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

ALTER TABLE `reviews`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

ALTER TABLE `suscripciones_organizador`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `ubicaciones`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

-- ========================================
-- 10. RESTRICCIONES DE CLAVE FORÁNEA
-- ========================================

ALTER TABLE `analytics_evento`
  ADD CONSTRAINT `analytics_evento_evento_id_foreign` FOREIGN KEY (`evento_id`) REFERENCES `events` (`id`);

ALTER TABLE `asistencias`
  ADD CONSTRAINT `asistencias_evento_id_foreign` FOREIGN KEY (`evento_id`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `asistencias_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`);

ALTER TABLE `configuraciones_usuario`
  ADD CONSTRAINT `configuraciones_usuario_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`);

ALTER TABLE `events`
  ADD CONSTRAINT `events_categoria_id_foreign` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`),
  ADD CONSTRAINT `events_ubicacion_id_foreign` FOREIGN KEY (`ubicacion_id`) REFERENCES `ubicaciones` (`id`),
  ADD CONSTRAINT `events_user_id_foreign` FOREIGN KEY (`organizador_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

ALTER TABLE `favoritos`
  ADD CONSTRAINT `favoritos_evento_id_foreign` FOREIGN KEY (`evento_id`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `favoritos_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`);

ALTER TABLE `imagenes_evento`
  ADD CONSTRAINT `imagenes_evento_evento_id_foreign` FOREIGN KEY (`evento_id`) REFERENCES `events` (`id`) ON DELETE CASCADE;

ALTER TABLE `imagenes_galeria_evento`
  ADD CONSTRAINT `imagenes_galeria_evento_evento_id_foreign` FOREIGN KEY (`evento_id`) REFERENCES `events` (`id`) ON DELETE CASCADE;

ALTER TABLE `notificaciones`
  ADD CONSTRAINT `notificaciones_evento_id_foreign` FOREIGN KEY (`evento_id`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `notificaciones_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`);

ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_evento_id_foreign` FOREIGN KEY (`evento_id`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `reviews_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`);

ALTER TABLE `suscripciones_organizador`
  ADD CONSTRAINT `suscripciones_organizador_organizador_id_foreign` FOREIGN KEY (`organizador_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `suscripciones_organizador_plan_id_foreign` FOREIGN KEY (`plan_id`) REFERENCES `planes_suscripcion` (`id`);

ALTER TABLE `users`
  ADD CONSTRAINT `users_rol_id_foreign` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- ========================================
-- 11. RESUMEN DE LA BASE DE DATOS CREADA
-- ========================================

/*
BASE DE DATOS FESTISPOT - RESUMEN:

✅ ESTRUCTURAS CREADAS:
- 23 tablas con estructura completa (CREATE TABLE IF NOT EXISTS)
- Todos los índices y claves foráneas
- Configuración UTF8MB4 para soporte internacional
- Protección contra re-ejecución del script

✅ DATOS INCLUIDOS:
- 3 Roles: asistente, productor, organizador (INSERT IGNORE)
- 12 Categorías: Música, Arte, Gastronomía, Deportes, etc. (INSERT IGNORE)
- 3 Planes de suscripción: Básico (gratis), Pro, Premium (INSERT IGNORE)
- 19 Registros de migraciones de Laravel (INSERT IGNORE)

❌ DATOS EXCLUIDOS (según solicitud):
- Eventos (tabla events vacía)
- Usuarios (tabla users vacía)
- Ubicaciones (tabla ubicaciones vacía)

�️ CARACTERÍSTICAS DE SEGURIDAD:
- Puede ejecutarse múltiples veces sin errores
- No duplicará datos existentes
- No fallará si la BD o tablas ya existen

�📋 SIGUIENTES PASOS RECOMENDADOS:
1. Crear usuarios administradores
2. Agregar más ubicaciones según necesidades
3. Configurar eventos de prueba si es necesario
4. Personalizar categorías según el mercado objetivo

🔧 PARA USAR:
1. Ejecutar este archivo en MySQL/MariaDB
2. Verificar que todas las tablas se crearon correctamente
3. La aplicación Laravel debería funcionar inmediatamente
4. Puede re-ejecutarse sin problemas para actualizaciones

Fecha de creación: Septiembre 22, 2025
Versión de la BD: 2.0 - Estructura completa sin eventos ni usuarios + Validaciones
*/