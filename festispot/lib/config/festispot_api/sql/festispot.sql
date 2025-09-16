-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-09-2025 a las 22:04:03
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `festispot`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `analytics_evento`
--

CREATE TABLE `analytics_evento` (
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asistencias`
--

CREATE TABLE `asistencias` (
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `icono` varchar(100) DEFAULT NULL,
  `color` varchar(7) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`, `descripcion`, `icono`, `color`, `activo`, `created_at`, `updated_at`) VALUES
(1, 'Música', 'Conciertos, festivales musicales', 'music', '#FF6B6B', 1, '2025-09-05 01:37:55', '2025-09-05 01:37:55'),
(2, 'Arte', 'Exposiciones, galerías', 'palette', '#4ECDC4', 1, '2025-09-05 01:37:55', '2025-09-05 01:37:55'),
(3, 'Gastronomía', 'Festivales culinarios, catas', 'restaurant', '#45B7D1', 1, '2025-09-05 01:37:55', '2025-09-05 01:37:55'),
(4, 'Deportes', 'Eventos deportivos', 'sports', '#96CEB4', 1, '2025-09-05 01:37:55', '2025-09-05 01:37:55'),
(5, 'Tecnología', 'Conferencias tech, workshops', 'computer', '#FFEAA7', 1, '2025-09-05 01:37:55', '2025-09-05 01:37:55'),
(6, 'Cultura', 'Eventos culturales', 'theater', '#DDA0DD', 1, '2025-09-05 01:37:55', '2025-09-05 01:37:55'),
(7, 'Música', 'Eventos musicales y conciertos', NULL, NULL, 1, '2025-09-05 01:49:33', '2025-09-05 01:49:33'),
(8, 'Tecnología', 'Conferencias y eventos tecnológicos', NULL, NULL, 1, '2025-09-05 01:49:33', '2025-09-05 01:49:33'),
(9, 'Arte', 'Exposiciones y eventos artísticos', NULL, NULL, 1, '2025-09-05 01:49:33', '2025-09-05 01:49:33'),
(10, 'Deportes', 'Eventos deportivos y competencias', NULL, NULL, 1, '2025-09-05 01:49:33', '2025-09-05 01:49:33'),
(11, 'Educativo', 'Talleres y eventos educativos', NULL, NULL, 1, '2025-09-05 01:49:33', '2025-09-05 01:49:33'),
(12, 'Gastronómico', 'Eventos culinarios y gastronómicos', NULL, NULL, 1, '2025-09-05 01:49:33', '2025-09-05 01:49:33');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuraciones_usuario`
--

CREATE TABLE `configuraciones_usuario` (
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `events`
--

CREATE TABLE `events` (
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
  `banner_image` varchar(255) DEFAULT NULL,
  `gallery_images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`gallery_images`)),
  `videos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`videos`)),
  `estado` enum('borrador','publicado','en_curso','finalizado','cancelado') NOT NULL DEFAULT 'borrador',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `events`
--

INSERT INTO `events` (`id`, `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `ubicacion_id`, `category`, `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `hora_apertura_puertas`, `repeat_schedule`, `event_type`, `venue_name`, `full_address`, `city`, `state`, `country`, `postal_code`, `location_details`, `capacidad_total`, `edad_minima`, `politicas_cancelacion`, `instrucciones_especiales`, `tags`, `fecha_creacion`, `fecha_actualizacion`, `fecha_publicacion`, `motivo_cambio`, `accessible`, `virtual_platform`, `event_link`, `access_code`, `virtual_password`, `virtual_instructions`, `banner_image`, `gallery_images`, `videos`, `estado`, `created_at`, `updated_at`) VALUES
(3, 1, 'Juanpa es gay', 'wqeewqe', NULL, NULL, NULL, 'Educativo', '2025-09-17 10:30:00', '2025-09-19 16:00:00', '10:30:00', '16:00:00', NULL, 0, 'Presencial', 'eqweqw', 'ewqeqw', 'ewqeqw', 'Nuevo León', NULL, '32132', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'borrador', '2025-09-05 01:50:46', '2025-09-05 01:50:46'),
(4, 1, 'buenas', 'dsadsadas', NULL, NULL, NULL, 'Deportivo', '2025-09-11 11:30:00', '2025-09-18 17:30:00', '11:30:00', '17:30:00', NULL, 0, 'Presencial', 'dsa', 'dsadsa', 'dasdsa', 'Jalisco', NULL, '23123', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'wallpaper.jpeg', NULL, NULL, 'borrador', '2025-09-05 02:00:48', '2025-09-05 02:00:48');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `favoritos`
--

CREATE TABLE `favoritos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `usuario_id` bigint(20) UNSIGNED NOT NULL,
  `evento_id` bigint(20) UNSIGNED NOT NULL,
  `fecha_agregado` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `imagenes_evento`
--

CREATE TABLE `imagenes_evento` (
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `job_batches`
--

CREATE TABLE `job_batches` (
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planes_suscripcion`
--

CREATE TABLE `planes_suscripcion` (
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

--
-- Volcado de datos para la tabla `planes_suscripcion`
--

INSERT INTO `planes_suscripcion` (`id`, `nombre`, `descripcion`, `precio_mensual`, `precio_anual`, `max_eventos`, `max_imagenes_por_evento`, `features`, `activo`, `created_at`, `updated_at`) VALUES
(1, 'Básico', 'Plan básico para empezar', 0.00, 0.00, 5, 3, '[\"eventos_basicos\"]', 1, '2025-09-05 01:37:55', '2025-09-05 01:37:55'),
(2, 'Pro', 'Plan profesional con más funciones', 299.00, 2990.00, 50, 10, '[\"analytics\",\"promocion_premium\",\"soporte_prioritario\"]', 1, '2025-09-05 01:37:55', '2025-09-05 01:37:55'),
(3, 'Premium', 'Plan premium con todas las funciones', 599.00, 5990.00, NULL, NULL, '[\"analytics\",\"promocion_premium\",\"soporte_24_7\",\"api_access\",\"white_label\"]', 1, '2025-09-05 01:37:55', '2025-09-05 01:37:55');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reviews`
--

CREATE TABLE `reviews` (
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `permisos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permisos`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `nombre`, `descripcion`, `permisos`, `created_at`, `updated_at`) VALUES
(1, 'asistente', 'Usuario que asiste a eventos', '[\"view_events\",\"register_events\",\"rate_events\"]', '2025-09-05 01:37:55', '2025-09-05 01:37:55'),
(2, 'organizador', 'Usuario que crea y gestiona eventos', '[\"view_events\",\"create_events\",\"edit_events\",\"manage_events\",\"view_analytics\"]', '2025-09-05 01:37:55', '2025-09-05 01:37:55'),
(3, 'admin', 'Administrador del sistema', '[\"*\"]', '2025-09-05 01:37:55', '2025-09-05 01:37:55');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('dFJlKxYwTQTStlHtKC87WPo3rauidAJi9UeCM4QM', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.103.2 Chrome/138.0.7204.100 Electron/37.2.3 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWENOV1o3V3FMNnRsbEFUV0czek5Ld1VjZ2RoUGtRZ1BYeHhaWGhjNiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6OTU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC8/aWQ9NDY3ODdmYjUtMTMyNC00NGZiLTgwODAtNTFjZGQzYTEyOWJmJnZzY29kZUJyb3dzZXJSZXFJZD0xNzU3MDE1ODk3NTYyIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1757015898),
('ESNjk73Rv67xq36bakyObzcmaza21DDfxJBX9rmp', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.103.2 Chrome/138.0.7204.100 Electron/37.2.3 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieE43NTlOSzhkU09vTFRPR2cxVGR4bklCclh4dGNNeVBvZTZhUGY4TiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6OTU6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC8/aWQ9NDY3ODdmYjUtMTMyNC00NGZiLTgwODAtNTFjZGQzYTEyOWJmJnZzY29kZUJyb3dzZXJSZXFJZD0xNzU3MDE0Nzg0Mjk1Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1757014784),
('H7Yr6NqmX1Pmlwcu0TZVGlPQuBfGVoXnMSoFDNNX', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 OPR/120.0.0.0', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiaE5lcVJTR29nZDdScFhMd0ZYQzVkREJ3YnlxS3pNWGhMa3I4d0w0MyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9taXMtZXZlbnRvcyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7fQ==', 1757016049),
('RgQTsVid1YaRmXqsJuywoue0qc6Z4rWu4ugqqc4m', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.103.2 Chrome/138.0.7204.100 Electron/37.2.3 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYlZ5b0JBR1Rwa0F6amhlRUl5VExCWTJtc0hLbUM0MmJWcEF5a013ViI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MTA3OiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvZXZlbnQvY3JlYXRlP2lkPTQ2Nzg3ZmI1LTEzMjQtNDRmYi04MDgwLTUxY2RkM2ExMjliZiZ2c2NvZGVCcm93c2VyUmVxSWQ9MTc1NzAxNDc5NTEzOCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1757014795);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `suscripciones_organizador`
--

CREATE TABLE `suscripciones_organizador` (
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ubicaciones`
--

CREATE TABLE `ubicaciones` (
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

--
-- Volcado de datos para la tabla `ubicaciones`
--

INSERT INTO `ubicaciones` (`id`, `nombre`, `direccion`, `ciudad`, `estado`, `codigo_postal`, `pais`, `latitud`, `longitud`, `capacidad_maxima`, `tipo_venue`, `facilidades`, `contacto_venue`, `telefono_venue`, `created_at`, `updated_at`) VALUES
(1, 'Auditorio Nacional', 'Paseo de la Reforma 50', 'Ciudad de México', 'Ciudad de México', '11560', 'México', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-09-05 01:49:54', '2025-09-05 01:49:54'),
(2, 'Centro de Convenciones', 'Av. Conscripto 311', 'Ciudad de México', 'Ciudad de México', '11200', 'México', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-09-05 01:49:54', '2025-09-05 01:49:54'),
(3, 'Palacio de los Deportes', 'Añil 635', 'Ciudad de México', 'Ciudad de México', '08400', 'México', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-09-05 01:49:54', '2025-09-05 01:49:54');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
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

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `nombre`, `apellido`, `email`, `telefono`, `fecha_nacimiento`, `genero`, `avatar_url`, `rol_id`, `estado`, `fecha_registro`, `ultimo_acceso`, `token_verificacion`, `email_verificado`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Usuario de Prueba', 'Apellido Test', 'test@festispot.com', NULL, NULL, NULL, NULL, 1, 'activo', NULL, NULL, NULL, 0, NULL, '$2y$12$A2ohSR9Z7aleXOMl/ckoLePqWGolc.TauyVIt0XHqFtVuAVBojKaq', NULL, '2025-09-05 01:49:01', '2025-09-05 01:49:01');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `analytics_evento`
--
ALTER TABLE `analytics_evento`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_event_date` (`evento_id`,`fecha`);

--
-- Indices de la tabla `asistencias`
--
ALTER TABLE `asistencias`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_event` (`usuario_id`,`evento_id`),
  ADD UNIQUE KEY `asistencias_codigo_qr_unique` (`codigo_qr`),
  ADD KEY `asistencias_evento_id_foreign` (`evento_id`);

--
-- Indices de la tabla `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indices de la tabla `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `configuraciones_usuario`
--
ALTER TABLE `configuraciones_usuario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `configuraciones_usuario_usuario_id_foreign` (`usuario_id`);

--
-- Indices de la tabla `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `events_user_id_foreign` (`organizador_id`),
  ADD KEY `events_categoria_id_foreign` (`categoria_id`),
  ADD KEY `events_ubicacion_id_foreign` (`ubicacion_id`);

--
-- Indices de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indices de la tabla `favoritos`
--
ALTER TABLE `favoritos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_favorite` (`usuario_id`,`evento_id`),
  ADD KEY `favoritos_evento_id_foreign` (`evento_id`);

--
-- Indices de la tabla `imagenes_evento`
--
ALTER TABLE `imagenes_evento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `imagenes_evento_evento_id_foreign` (`evento_id`);

--
-- Indices de la tabla `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indices de la tabla `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notificaciones_usuario_id_foreign` (`usuario_id`),
  ADD KEY `notificaciones_evento_id_foreign` (`evento_id`);

--
-- Indices de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indices de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indices de la tabla `planes_suscripcion`
--
ALTER TABLE `planes_suscripcion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_review` (`usuario_id`,`evento_id`),
  ADD KEY `reviews_evento_id_foreign` (`evento_id`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_nombre_unique` (`nombre`);

--
-- Indices de la tabla `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indices de la tabla `suscripciones_organizador`
--
ALTER TABLE `suscripciones_organizador`
  ADD PRIMARY KEY (`id`),
  ADD KEY `suscripciones_organizador_organizador_id_foreign` (`organizador_id`),
  ADD KEY `suscripciones_organizador_plan_id_foreign` (`plan_id`);

--
-- Indices de la tabla `ubicaciones`
--
ALTER TABLE `ubicaciones`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_rol_id_foreign` (`rol_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `analytics_evento`
--
ALTER TABLE `analytics_evento`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `asistencias`
--
ALTER TABLE `asistencias`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `configuraciones_usuario`
--
ALTER TABLE `configuraciones_usuario`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `events`
--
ALTER TABLE `events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `favoritos`
--
ALTER TABLE `favoritos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `imagenes_evento`
--
ALTER TABLE `imagenes_evento`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `planes_suscripcion`
--
ALTER TABLE `planes_suscripcion`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `suscripciones_organizador`
--
ALTER TABLE `suscripciones_organizador`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ubicaciones`
--
ALTER TABLE `ubicaciones`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `analytics_evento`
--
ALTER TABLE `analytics_evento`
  ADD CONSTRAINT `analytics_evento_evento_id_foreign` FOREIGN KEY (`evento_id`) REFERENCES `events` (`id`);

--
-- Filtros para la tabla `asistencias`
--
ALTER TABLE `asistencias`
  ADD CONSTRAINT `asistencias_evento_id_foreign` FOREIGN KEY (`evento_id`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `asistencias_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `configuraciones_usuario`
--
ALTER TABLE `configuraciones_usuario`
  ADD CONSTRAINT `configuraciones_usuario_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_categoria_id_foreign` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`),
  ADD CONSTRAINT `events_ubicacion_id_foreign` FOREIGN KEY (`ubicacion_id`) REFERENCES `ubicaciones` (`id`),
  ADD CONSTRAINT `events_user_id_foreign` FOREIGN KEY (`organizador_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `favoritos`
--
ALTER TABLE `favoritos`
  ADD CONSTRAINT `favoritos_evento_id_foreign` FOREIGN KEY (`evento_id`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `favoritos_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `imagenes_evento`
--
ALTER TABLE `imagenes_evento`
  ADD CONSTRAINT `imagenes_evento_evento_id_foreign` FOREIGN KEY (`evento_id`) REFERENCES `events` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `notificaciones_evento_id_foreign` FOREIGN KEY (`evento_id`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `notificaciones_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_evento_id_foreign` FOREIGN KEY (`evento_id`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `reviews_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `suscripciones_organizador`
--
ALTER TABLE `suscripciones_organizador`
  ADD CONSTRAINT `suscripciones_organizador_organizador_id_foreign` FOREIGN KEY (`organizador_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `suscripciones_organizador_plan_id_foreign` FOREIGN KEY (`plan_id`) REFERENCES `planes_suscripcion` (`id`);

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_rol_id_foreign` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
