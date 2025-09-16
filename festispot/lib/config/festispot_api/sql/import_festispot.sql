-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-09-2025 a las 07:03:58
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
(1, 'Música', 'Conciertos, festivales musicales y eventos sonoros', 'music', '#FF6B6B', 1, '2025-09-16 03:04:52', '2025-09-16 03:04:52'),
(2, 'Arte', 'Exposiciones, galerías de arte, eventos artísticos y culturales', 'palette', '#4ECDC4', 1, '2025-09-16 03:04:52', '2025-09-16 03:04:52'),
(3, 'Gastronomía', 'Festivales culinarios, catas y eventos gastronómicos', 'restaurant', '#45B7D1', 1, '2025-09-16 03:04:52', '2025-09-16 03:04:52'),
(4, 'Deportes', 'Eventos deportivos, competencias y actividades físicas', 'sports', '#96CEB4', 1, '2025-09-16 03:04:52', '2025-09-16 03:04:52'),
(5, 'Tecnología', 'Conferencias tech, workshops y eventos tecnológicos', 'computer', '#FFEAA7', 1, '2025-09-16 03:04:52', '2025-09-16 03:04:52'),
(6, 'Cultura', 'Eventos culturales, tradiciones y patrimonio', 'theater', '#DDA0DD', 1, '2025-09-16 03:04:52', '2025-09-16 03:04:52'),
(7, 'Educativo', 'Talleres, cursos, seminarios y eventos educativos', 'school', '#FFA07A', 1, '2025-09-16 03:04:52', '2025-09-16 03:04:52'),
(8, 'Entretenimiento', 'Shows, espectáculos y eventos de entretenimiento general', 'celebration', '#98D8E8', 1, '2025-09-16 03:04:52', '2025-09-16 03:04:52'),
(9, 'Negocios', 'Conferencias empresariales, networking y eventos corporativos', 'business', '#F7DC6F', 1, '2025-09-16 03:04:52', '2025-09-16 03:04:52'),
(10, 'Salud y Bienestar', 'Eventos de yoga, meditación, fitness y bienestar', 'spa', '#ABEBC6', 1, '2025-09-16 03:04:52', '2025-09-16 03:04:52'),
(11, 'Familia', 'Eventos familiares, actividades para niños y padres', 'family', '#F8C471', 1, '2025-09-16 03:04:52', '2025-09-16 03:04:52'),
(12, 'Religioso', 'Eventos religiosos, ceremonias y celebraciones espirituales', 'church', '#D2B4DE', 1, '2025-09-16 03:04:52', '2025-09-16 03:04:52');

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

--
-- Volcado de datos para la tabla `configuraciones_usuario`
--

INSERT INTO `configuraciones_usuario` (`id`, `usuario_id`, `notificaciones_push`, `notificaciones_email`, `categorias_favoritas`, `radio_busqueda_km`, `idioma`, `tema`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, NULL, 50, 'es', 'auto', '2025-09-16 03:20:13', '2025-09-16 03:20:13'),
(2, 2, 1, 1, NULL, 50, 'es', 'auto', '2025-09-16 03:22:36', '2025-09-16 03:22:36'),
(3, 3, 1, 1, NULL, 50, 'es', 'auto', '2025-09-16 03:23:41', '2025-09-16 03:23:41');

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
(1, 2, 'Festival de Jazz Internacional', 'Tres días de música jazz con artistas nacionales e internacionales. Workshops, jam sessions y conciertos en múltiples escenarios.', 'Festival de jazz con artistas internacionales y workshops', 1, NULL, 'Música', '2025-10-15 19:00:00', '2025-10-17 23:00:00', '19:00:00', '23:00:00', NULL, 0, 'Presencial', 'Parque Lincoln', 'Polanco, Ciudad de México', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 2000, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'jazz_festival.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(2, 2, 'Exposición de Arte Contemporáneo \"Nuevas Miradas\"', 'Muestra colectiva de 30 artistas emergentes mexicanos. Pintura, escultura, instalaciones y arte digital.', 'Exposición de arte contemporáneo con artistas emergentes', 2, NULL, 'Arte', '2025-10-20 10:00:00', '2025-12-20 18:00:00', '10:00:00', '18:00:00', NULL, 0, 'Presencial', 'Museo de Arte Moderno', 'Paseo de la Reforma y Gandhi, Bosque de Chapultepec', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 300, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'arte_contemporaneo.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(3, 2, 'Festival Gastronómico Internacional', 'Degustación de platillos de 15 países, talleres de cocina, competencias culinarias y cenas temáticas.', 'Festival gastronómico internacional con talleres y degustaciones', 3, NULL, 'Gastronomía', '2025-10-25 12:00:00', '2025-10-27 22:00:00', '12:00:00', '22:00:00', NULL, 0, 'Presencial', 'Centro de Convenciones WTC', 'Montecito 38, Nápoles', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 1500, 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'festival_gastronomico.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(4, 2, 'Maratón de la Ciudad de México 2025', 'Carrera de 42km por los principales monumentos de la ciudad. Incluye categorías de 10km y 21km.', 'Maratón con recorrido por monumentos históricos', 4, NULL, 'Deportes', '2025-11-01 07:00:00', '2025-11-01 13:00:00', '07:00:00', '13:00:00', NULL, 0, 'Presencial', 'Zócalo Capitalino', 'Plaza de la Constitución s/n, Centro Histórico', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 5000, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'maraton_cdmx.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(5, 2, 'AI Summit México 2025', 'Conferencia sobre inteligencia artificial con expertos internacionales. Talleres prácticos y networking.', 'Conferencia de IA con expertos y talleres prácticos', 5, NULL, 'Tecnología', '2025-11-05 09:00:00', '2025-11-06 18:00:00', '09:00:00', '18:00:00', NULL, 0, 'Híbrido', 'Centro Banamex', 'Av. Conscripto 311, Lomas de Sotelo', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 800, 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'ai_summit.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(6, 2, 'Festival de Día de Muertos', 'Celebración tradicional mexicana con ofrendas, música, teatro, talleres de catrinas y comida típica.', 'Celebración tradicional del Día de Muertos', 6, NULL, 'Cultura', '2025-11-01 16:00:00', '2025-11-02 23:00:00', '16:00:00', '23:00:00', NULL, 0, 'Presencial', 'Parque México', 'Parque México, Condesa', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 3000, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'dia_muertos.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(7, 2, 'CodeKids: Programación para el Futuro', 'Taller intensivo de programación para niños de 8-14 años usando Scratch y Python. Incluye certificado.', 'Taller de programación para niños con Scratch y Python', 7, NULL, 'Educativo', '2025-11-10 10:00:00', '2025-11-12 16:00:00', '10:00:00', '16:00:00', NULL, 0, 'Presencial', 'TecMilenio Campus Santa Fe', 'Av. Santa Fe 1130, Santa Fe', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 40, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'codekids.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(8, 2, 'Noche de Stand-Up Comedy', 'Show de comedia con los mejores comediantes mexicanos. Dos horas de risas garantizadas.', 'Show de comedia stand-up con comediantes mexicanos', 8, NULL, 'Entretenimiento', '2025-11-15 21:00:00', '2025-11-15 23:30:00', '21:00:00', '23:30:00', NULL, 0, 'Presencial', 'Teatro Metropolitan', 'Independencia 90, Centro Histórico', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 600, 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'stand_up.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(9, 2, 'Cumbre de Emprendimiento México 2025', 'Evento para emprendedores con pitch competitions, mentorías, networking y conferencias magistrales.', 'Cumbre de emprendimiento con pitch y networking', 9, NULL, 'Negocios', '2025-11-20 09:00:00', '2025-11-21 19:00:00', '09:00:00', '19:00:00', NULL, 0, 'Presencial', 'Hotel Presidente InterContinental', 'Campos Elíseos 218, Polanco', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 500, 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'emprendimiento.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(10, 2, 'Retiro de Yoga y Meditación en Tepoztlán', 'Fin de semana de conexión interior con sesiones de yoga, meditación, temazcal y alimentación consciente.', 'Retiro de yoga y meditación en ambiente natural', 10, NULL, 'Salud y Bienestar', '2025-11-25 16:00:00', '2025-11-27 14:00:00', '16:00:00', '14:00:00', NULL, 0, 'Presencial', 'Casa Alaya Tepoztlán', 'Camino a Amatlán s/n, Tepoztlán', 'Tepoztlán', 'Morelos', 'México', NULL, NULL, 30, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'yoga_retreat.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(11, 2, 'Festival Familiar de Navidad', 'Celebración navideña para toda la familia con Santa Claus, obras de teatro, talleres y área de juegos.', 'Festival navideño familiar con actividades para niños', 11, NULL, 'Familia', '2025-12-15 10:00:00', '2025-12-15 20:00:00', '10:00:00', '20:00:00', NULL, 0, 'Presencial', 'Parque Bicentenario', 'Ejército Nacional Mexicano 843, Granada', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 2000, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'navidad_familiar.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(12, 2, 'Concierto de Música Sacra Navideña', 'Concierto de villancicos y música sacra interpretado por el Coro de la Catedral con orquesta sinfónica.', 'Concierto de música sacra navideña con coro y orquesta', 12, NULL, 'Religioso', '2025-12-20 19:00:00', '2025-12-20 21:00:00', '19:00:00', '21:00:00', NULL, 0, 'Presencial', 'Catedral Metropolitana', 'Plaza de la Constitución s/n, Centro Histórico', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 800, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'musica_sacra.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(13, 2, 'Festival de Rock Alternativo Underground', 'Noche de rock alternativo con bandas emergentes nacionales. Mosh pit, merchandising y sorpresas.', 'Festival de rock alternativo con bandas emergentes', 1, NULL, 'Música', '2025-12-22 20:00:00', '2025-12-23 02:00:00', '20:00:00', '02:00:00', NULL, 0, 'Presencial', 'Foro Sol', 'Viaducto Río de la Piedad s/n, Granjas México', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 8000, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'rock_underground.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(14, 2, 'Exposición \"Ciudad en Blanco y Negro\"', 'Muestra fotográfica de la vida urbana mexicana. 50 fotografías de 20 artistas documentando la ciudad.', 'Exposición de fotografía urbana en blanco y negro', 2, NULL, 'Arte', '2025-12-01 11:00:00', '2026-01-31 19:00:00', '11:00:00', '19:00:00', NULL, 0, 'Presencial', 'Galería José María Velasco', 'Peralvillo 55, Morelos', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 150, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'foto_urbana.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(15, 2, 'Notte Italiana - Cena Temática', 'Cena de cinco tiempos con auténtica cocina italiana, vinos de importación y música en vivo.', 'Cena temática italiana con música en vivo', 3, NULL, 'Gastronomía', '2025-12-05 19:00:00', '2025-12-05 23:00:00', '19:00:00', '23:00:00', NULL, 0, 'Presencial', 'Restaurante Osteria Santo', 'Orizaba 87, Roma Norte', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 60, 21, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'cena_italiana.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(16, 2, 'Torneo de Ajedrez Ciudad de México', 'Torneo oficial de ajedrez con categorías para todas las edades. Premios en efectivo y trofeos.', 'Torneo de ajedrez con categorías para todas las edades', 4, NULL, 'Deportes', '2025-12-07 09:00:00', '2025-12-08 18:00:00', '09:00:00', '18:00:00', NULL, 0, 'Presencial', 'Casa de la Cultura Jesús Reyes Heroles', 'Av. Universidad 1000, Del Valle', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 200, 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'torneo_ajedrez.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(17, 2, 'BlockChain Hackathon México 2025', '48 horas de desarrollo intensivo en blockchain. Mentores expertos, premios de $100,000 MXN.', 'Hackathon de blockchain con premios y mentores', 5, NULL, 'Tecnología', '2025-12-10 18:00:00', '2025-12-12 18:00:00', '18:00:00', '18:00:00', NULL, 0, 'Presencial', 'Hub Ciudad de México', 'Alejandro Dumas 215, Polanco', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 120, 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'blockchain_hack.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(18, 2, 'Festival de Danza Folclórica Mexicana', 'Encuentro de grupos de danza de todo México. Concursos, talleres y presentaciones culturales.', 'Festival de danza folclórica con grupos de todo México', 6, NULL, 'Cultura', '2025-12-12 17:00:00', '2025-12-14 21:00:00', '17:00:00', '21:00:00', NULL, 0, 'Presencial', 'Teatro de la Ciudad Esperanza Iris', 'Donceles 36, Centro Histórico', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 1000, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'danza_folklorica.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(19, 2, 'Seminario de Marketing Digital 2025', 'Curso intensivo sobre tendencias en marketing digital, redes sociales, SEO y publicidad online.', 'Seminario intensivo de marketing digital y redes sociales', 7, NULL, 'Educativo', '2025-12-16 09:00:00', '2025-12-17 17:00:00', '09:00:00', '17:00:00', NULL, 0, 'Virtual', 'Plataforma Zoom', 'Evento en línea', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 500, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'marketing_digital.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14'),
(20, 2, 'Circo Contemporáneo \"Elementos\"', 'Espectáculo de circo contemporáneo que combina acrobacias, danza y tecnología. Una experiencia única.', 'Circo contemporáneo con acrobacias, danza y tecnología', 8, NULL, 'Entretenimiento', '2025-12-18 20:00:00', '2025-12-20 22:00:00', '20:00:00', '22:00:00', NULL, 0, 'Presencial', 'Centro Nacional de las Artes', 'Av. Río Churubusco 79, Country Club', 'Ciudad de México', 'Ciudad de México', 'México', NULL, NULL, 800, 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 'circo_contemporaneo.jpg', NULL, NULL, 'publicado', '2025-09-16 03:25:14', '2025-09-16 03:25:14');

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

--
-- Volcado de datos para la tabla `favoritos`
--

INSERT INTO `favoritos` (`id`, `usuario_id`, `evento_id`, `fecha_agregado`, `created_at`, `updated_at`) VALUES
(1, 2, 13, '2025-09-16 04:16:21', NULL, NULL),
(2, 1, 12, '2025-09-16 05:00:19', NULL, NULL);

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
(1, 'asistente', 'Usuario que asiste a eventos', '[\"view_events\",\"register_events\",\"rate_events\",\"add_favorites\",\"view_profile\"]', '2025-09-16 03:04:52', '2025-09-16 03:04:52'),
(2, 'productor', 'Usuario que crea y gestiona sus propios eventos', '[\"view_events\",\"register_events\",\"rate_events\",\"add_favorites\",\"view_profile\",\"create_events\",\"edit_own_events\",\"manage_own_events\",\"view_own_analytics\",\"upload_images\"]', '2025-09-16 03:04:52', '2025-09-16 03:04:52'),
(3, 'organizador', 'Administrador que gestiona la plataforma y todos los eventos', '[\"*\"]', '2025-09-16 03:04:52', '2025-09-16 03:04:52');

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
(1, 'Asistente', 'Festispot', 'asistente@festispot.com', '1234567890', '2000-01-01', 'otro', NULL, 1, 'activo', '2025-09-16 03:20:13', '2025-09-16 05:00:10', '1a7cda0f68ee5264356d75e4a40534894f5833bf4398f39351df6cd21d538702', 0, NULL, '$2y$10$nKJ6TGSJrRhpnfDGwjMyy.goCaBUJK.Pg19XMMzaLXiXMzhAyeNa.', NULL, NULL, NULL),
(2, 'Productor', 'Festispot', 'productor@festispot.com', '1234567890', '2000-01-01', 'otro', NULL, 2, 'activo', '2025-09-16 03:22:36', '2025-09-16 05:01:03', 'c5fe64b0d185d1136edb2d44a4dcd221bbd5db5981da90a9f476d363ec233dde', 0, NULL, '$2y$10$HRFcz863lUbcWluPIj8hW.eG.5fFmUjnzFdZ.oqUJ/FyNlmKwPDXy', NULL, NULL, NULL),
(3, 'Organizador', 'Festispot', 'organizador@festispot.com', '1234567890', '2000-01-01', 'otro', NULL, 2, 'activo', '2025-09-16 03:23:41', '2025-09-16 03:23:59', '922f9fa921b253246196d94f1d2bd32da5fc5a7571dc90b44f2f7207c03ac5ab', 0, NULL, '$2y$10$HAMpzBx4/onyWhaT2wZtSO23KHTp95hQcfgaco3SQuaOCorr2s2CK', NULL, NULL, NULL);

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `events`
--
ALTER TABLE `events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `favoritos`
--
ALTER TABLE `favoritos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
