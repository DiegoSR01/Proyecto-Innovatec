-- Insercion de usuarios de prueba para FestiSpot
-- Reemplaza los usuarios hardcodeados que antes estaban en el codigo Flutter

-- NOTA: Usar INSERT IGNORE para evitar duplicados si ya existen usuarios
-- 1. Usuario Asistente de prueba
INSERT IGNORE INTO `users` (
    `nombre`, 
    `apellido`, 
    `email`, 
    `telefono`, 
    `fecha_nacimiento`, 
    `genero`, 
    `rol_id`, 
    `estado`, 
    `fecha_registro`, 
    `password`
) VALUES (
    'Usuario', 
    'Asistente', 
    'asistente@festispot.com', 
    '+52 555 123 4567', 
    '1995-05-15', 
    'prefiero_no_decir', 
    1, -- rol_id = 1 para asistente (ver tabla roles)
    'activo',
    NOW(), 
    '$2y$10$A2ohSR9Z7aleXOMl/ckoLePqWGolc.TauyVIt0XHqFtVuAVBojKaq' -- password: "asistente123"
);

-- 2. Usuario Productor de prueba
INSERT IGNORE INTO `users` (
    `nombre`, 
    `apellido`, 
    `email`, 
    `telefono`, 
    `fecha_nacimiento`, 
    `genero`, 
    `rol_id`, 
    `estado`, 
    `fecha_registro`, 
    `password`
) VALUES (
    'Usuario', 
    'Productor', 
    'productor@festispot.com', 
    '+52 555 987 6543', 
    '1988-12-03', 
    'masculino', 
    2, -- rol_id = 2 para organizador/productor (ver tabla roles)
    'activo',
    NOW(), 
    '$2y$10$A2ohSR9Z7aleXOMl/ckoLePqWGolc.TauyVIt0XHqFtVuAVBojKaq' -- password: "productor123"
);

-- 3. Usuario Admin de prueba (opcional)
INSERT IGNORE INTO `users` (
    `nombre`, 
    `apellido`, 
    `email`, 
    `telefono`, 
    `fecha_nacimiento`, 
    `genero`, 
    `rol_id`, 
    `estado`, 
    `fecha_registro`, 
    `password`
) VALUES (
    'Admin', 
    'Sistema', 
    'admin@festispot.com', 
    '+52 555 000 0000', 
    '1985-01-01', 
    'otro', 
    3, -- rol_id = 3 para admin (ver tabla roles)
    'activo',
    NOW(), 
    '$2y$10$A2ohSR9Z7aleXOMl/ckoLePqWGolc.TauyVIt0XHqFtVuAVBojKaq' -- password: "admin123"
);

-- Obtener el ID del usuario productor para usar en los eventos
SET @productor_id = (SELECT id FROM users WHERE email = 'productor@festispot.com' LIMIT 1);

-- Si no existe el usuario productor, usar el primer usuario con rol de organizador
SET @productor_id = IFNULL(@productor_id, (SELECT id FROM users WHERE rol_id = 2 LIMIT 1));

-- Si aún no hay ningún organizador, usar el primer usuario disponible
SET @productor_id = IFNULL(@productor_id, (SELECT id FROM users ORDER BY id LIMIT 1));

-- ========================================
-- INSERCION DE EVENTOS DE PRUEBA
-- ========================================
-- Estos eventos reemplazan los datos estaticos del carrusel en Flutter

-- Evento 1: Cata de vinos
INSERT INTO `events` (
    `organizador_id`, 
    `titulo`, 
    `descripcion`, 
    `descripcion_corta`,
    `categoria_id`,
    `category`,
    `fecha_inicio`, 
    `fecha_fin`,
    `start_time`, 
    `end_time`,
    `event_type`,
    `venue_name`,
    `full_address`,
    `city`,
    `state`,
    `country`,
    `capacidad_total`,
    `edad_minima`,
    `banner_image`,
    `estado`,
    `created_at`,
    `updated_at`
) VALUES (
    @productor_id, -- organizador_id (usuario productor)
    'Cata de vinos',
    'Disfruta de una cata de vinos con expertos en la materia. Aprende sobre diferentes variedades y tecnicas de degustacion.',
    'Cata de vinos con expertos y degustacion de variedades selectas',
    12, -- categoria_id (Gastronómico)
    'Gastronómico',
    '2025-10-15 18:30:00',
    '2025-10-15 22:00:00',
    '18:30:00',
    '22:00:00',
    'Presencial',
    'Bodega del Valle',
    'Carretera a Valle de Guadalupe Km 85',
    'Ensenada',
    'Baja California',
    'Mexico',
    500,
    18,
    'cata.jpeg',
    'publicado',
    NOW(),
    NOW()
);

-- Evento 2: Concierto de musica clasica
INSERT INTO `events` (
    `organizador_id`, 
    `titulo`, 
    `descripcion`, 
    `descripcion_corta`,
    `categoria_id`,
    `category`,
    `fecha_inicio`, 
    `fecha_fin`,
    `start_time`, 
    `end_time`,
    `event_type`,
    `venue_name`,
    `full_address`,
    `city`,
    `state`,
    `country`,
    `capacidad_total`,
    `edad_minima`,
    `banner_image`,
    `estado`,
    `created_at`,
    `updated_at`
) VALUES (
    @productor_id, -- organizador_id (usuario productor)
    'Concierto de musica clasica',
    'Asiste a un concierto de musica clasica con una orquesta reconocida. Una experiencia cultural unica.',
    'Concierto de musica clasica con orquesta sinfonica',
    1, -- categoria_id (Música)
    'Música',
    '2025-10-15 20:00:00',
    '2025-10-15 23:00:00',
    '20:00:00',
    '23:00:00',
    'Presencial',
    'Auditorio Nacional',
    'Paseo de la Reforma 50, Bosque de Chapultepec',
    'Ciudad de Mexico',
    'Ciudad de Mexico',
    'Mexico',
    500,
    0,
    'conc_ejem.jpg',
    'publicado',
    NOW(),
    NOW()
);

-- Evento 3: Feria del alfenique
INSERT INTO `events` (
    `organizador_id`, 
    `titulo`, 
    `descripcion`, 
    `descripcion_corta`,
    `categoria_id`,
    `category`,
    `fecha_inicio`, 
    `fecha_fin`,
    `start_time`, 
    `end_time`,
    `event_type`,
    `venue_name`,
    `full_address`,
    `city`,
    `state`,
    `country`,
    `capacidad_total`,
    `edad_minima`,
    `banner_image`,
    `estado`,
    `created_at`,
    `updated_at`
) VALUES (
    @productor_id, -- organizador_id (usuario productor)
    'Feria del alfenique',
    'Disfruta de un dia lleno de tradicion en la Feria del Alfenique. Prueba dulces tipicos y disfruta de actividades culturales.',
    'Feria tradicional del alfenique con dulces tipicos y cultura',
    6, -- categoria_id (Cultura)
    'Cultura',
    '2025-10-20 10:40:00',
    '2025-10-20 18:00:00',
    '10:40:00',
    '18:00:00',
    'Presencial',
    'Plaza Mayor',
    'Centro Historico, Plaza Principal',
    'Toluca',
    'Estado de Mexico',
    'Mexico',
    1000,
    0,
    'feria_ejem.jpeg',
    'publicado',
    NOW(),
    NOW()
);

-- Evento 4: Feria de agricultura
INSERT INTO `events` (
    `organizador_id`, 
    `titulo`, 
    `descripcion`, 
    `descripcion_corta`,
    `categoria_id`,
    `category`,
    `fecha_inicio`, 
    `fecha_fin`,
    `start_time`, 
    `end_time`,
    `event_type`,
    `venue_name`,
    `full_address`,
    `city`,
    `state`,
    `country`,
    `capacidad_total`,
    `edad_minima`,
    `banner_image`,
    `estado`,
    `created_at`,
    `updated_at`
) VALUES (
    @productor_id, -- organizador_id (usuario productor)
    'Feria de agricultura',
    'Visita la Feria de Agricultura para conocer mas sobre practicas sostenibles y productos locales. Ideal para los amantes de la naturaleza.',
    'Feria de agricultura sostenible y productos locales',
    11, -- categoria_id (Educativo)
    'Educativo',
    '2025-10-25 09:00:00',
    '2025-10-25 17:00:00',
    '09:00:00',
    '17:00:00',
    'Presencial',
    'Parque Ecologico',
    'Av. Ecologica 123, Zona Verde',
    'Guadalajara',
    'Jalisco',
    'Mexico',
    800,
    0,
    'feria_agri.jpeg',
    'publicado',
    NOW(),
    NOW()
);

-- Evento 5: Festival de Jazz
INSERT INTO `events` (
    `organizador_id`, 
    `titulo`, 
    `descripcion`, 
    `descripcion_corta`,
    `categoria_id`,
    `category`,
    `fecha_inicio`, 
    `fecha_fin`,
    `start_time`, 
    `end_time`,
    `event_type`,
    `venue_name`,
    `full_address`,
    `city`,
    `state`,
    `country`,
    `capacidad_total`,
    `edad_minima`,
    `banner_image`,
    `estado`,
    `created_at`,
    `updated_at`
) VALUES (
    @productor_id, -- organizador_id (usuario productor)
    'Festival de Jazz',
    'Disfruta de un fin de semana lleno de musica en el Festival de Jazz. Conciertos en vivo y talleres para todos los amantes del jazz.',
    'Festival de jazz con conciertos en vivo y talleres',
    1, -- categoria_id (Música)
    'Música',
    '2025-11-01 19:00:00',
    '2025-11-03 23:00:00',
    '19:00:00',
    '23:00:00',
    'Presencial',
    'Centro Cultural',
    'Av. Cultural 456, Centro',
    'Monterrey',
    'Nuevo Leon',
    'Mexico',
    1200,
    0,
    'festival_jazz.jpeg',
    'publicado',
    NOW(),
    NOW()
);

-- Evento 6: Concierto de rock
INSERT INTO `events` (
    `organizador_id`, 
    `titulo`, 
    `descripcion`, 
    `descripcion_corta`,
    `categoria_id`,
    `category`,
    `fecha_inicio`, 
    `fecha_fin`,
    `start_time`, 
    `end_time`,
    `event_type`,
    `venue_name`,
    `full_address`,
    `city`,
    `state`,
    `country`,
    `capacidad_total`,
    `edad_minima`,
    `banner_image`,
    `estado`,
    `created_at`,
    `updated_at`
) VALUES (
    @productor_id, -- organizador_id (usuario productor)
    'Concierto de rock',
    'Asiste al concierto de rock del ano con bandas locales e internacionales. Una noche llena de energia y buena musica.',
    'Concierto de rock con bandas locales e internacionales',
    1, -- categoria_id (Música)
    'Música',
    '2025-11-05 21:00:00',
    '2025-11-06 02:00:00',
    '21:00:00',
    '02:00:00',
    'Presencial',
    'Estadio Municipal',
    'Av. Deportiva 789, Zona Norte',
    'Puebla',
    'Puebla',
    'Mexico',
    15000,
    16,
    'rock_ejem.jpg',
    'publicado',
    NOW(),
    NOW()
);

-- Evento 7: Startup Pitch & Networking Mexico
INSERT INTO `events` (
    `organizador_id`, 
    `titulo`, 
    `descripcion`, 
    `descripcion_corta`,
    `categoria_id`,
    `category`,
    `fecha_inicio`, 
    `fecha_fin`,
    `start_time`, 
    `end_time`,
    `event_type`,
    `venue_name`,
    `full_address`,
    `city`,
    `state`,
    `country`,
    `capacidad_total`,
    `edad_minima`,
    `banner_image`,
    `estado`,
    `created_at`,
    `updated_at`
) VALUES (
    @productor_id, -- organizador_id (usuario productor)
    'Startup Pitch & Networking Mexico',
    'Evento de networking para startups y emprendedores. Presentaciones, oportunidades de inversion y mucho mas.',
    'Networking para startups con presentaciones e inversion',
    5, -- categoria_id (Tecnología)
    'Tecnología',
    '2025-11-10 10:00:00',
    '2025-11-10 18:00:00',
    '10:00:00',
    '18:00:00',
    'Presencial',
    'Centro de Convenciones',
    'Av. Convenciones 321, Zona Empresarial',
    'Ciudad de Mexico',
    'Ciudad de Mexico',
    'Mexico',
    300,
    18,
    'network.jpg',
    'publicado',
    NOW(),
    NOW()
);

-- Evento 8: Exposicion de arte contemporaneo
INSERT INTO `events` (
    `organizador_id`, 
    `titulo`, 
    `descripcion`, 
    `descripcion_corta`,
    `categoria_id`,
    `category`,
    `fecha_inicio`, 
    `fecha_fin`,
    `start_time`, 
    `end_time`,
    `event_type`,
    `venue_name`,
    `full_address`,
    `city`,
    `state`,
    `country`,
    `capacidad_total`,
    `edad_minima`,
    `banner_image`,
    `estado`,
    `created_at`,
    `updated_at`
) VALUES (
    @productor_id, -- organizador_id (usuario productor)
    'Exposicion de arte contemporaneo',
    'Explora la Exposicion de Arte Contemporaneo con obras de artistas emergentes. Una oportunidad para apreciar el arte moderno.',
    'Exposicion de arte contemporaneo con artistas emergentes',
    2, -- categoria_id (Arte)
    'Arte',
    '2025-11-15 11:00:00',
    '2025-12-15 19:00:00',
    '11:00:00',
    '19:00:00',
    'Presencial',
    'Galeria Nacional',
    'Av. Arte 654, Zona Cultural',
    'Guadalajara',
    'Jalisco',
    'Mexico',
    200,
    0,
    'expo_arte.jpg',
    'publicado',
    NOW(),
    NOW()
);

-- Evento 9: Taller de cocina mexicana
INSERT INTO `events` (
    `organizador_id`, 
    `titulo`, 
    `descripcion`, 
    `descripcion_corta`,
    `categoria_id`,
    `category`,
    `fecha_inicio`, 
    `fecha_fin`,
    `start_time`, 
    `end_time`,
    `event_type`,
    `venue_name`,
    `full_address`,
    `city`,
    `state`,
    `country`,
    `capacidad_total`,
    `edad_minima`,
    `banner_image`,
    `estado`,
    `created_at`,
    `updated_at`
) VALUES (
    @productor_id, -- organizador_id (usuario productor)
    'Taller de cocina mexicana',
    'Aprende a cocinar platillos tradicionales mexicanos en este taller practico. Ideal para los amantes de la gastronomia.',
    'Taller practico de cocina tradicional mexicana',
    11, -- categoria_id (Educativo)
    'Educativo',
    '2025-11-20 09:00:00',
    '2025-11-20 14:00:00',
    '09:00:00',
    '14:00:00',
    'Presencial',
    'Escuela de Cocina',
    'Av. Gastronomica 987, Centro Culinario',
    'Oaxaca',
    'Oaxaca',
    'Mexico',
    30,
    12,
    'taller_cocina.jpg',
    'publicado',
    NOW(),
    NOW()
);

-- Evento 10: Festival de cine independiente
INSERT INTO `events` (
    `organizador_id`, 
    `titulo`, 
    `descripcion`, 
    `descripcion_corta`,
    `categoria_id`,
    `category`,
    `fecha_inicio`, 
    `fecha_fin`,
    `start_time`, 
    `end_time`,
    `event_type`,
    `venue_name`,
    `full_address`,
    `city`,
    `state`,
    `country`,
    `capacidad_total`,
    `edad_minima`,
    `banner_image`,
    `estado`,
    `created_at`,
    `updated_at`
) VALUES (
    @productor_id, -- organizador_id (usuario productor)
    'Festival de cine independiente',
    'Disfruta de una seleccion de peliculas independientes en el Festival de Cine. Charlas con directores y actores.',
    'Festival de cine independiente con charlas y proyecciones',
    6, -- categoria_id (Cultura)
    'Cultura',
    '2025-11-25 19:30:00',
    '2025-11-28 23:00:00',
    '19:30:00',
    '23:00:00',
    'Presencial',
    'Cine Club',
    'Av. Cinematografica 147, Zona Artistica',
    'Merida',
    'Yucatan',
    'Mexico',
    150,
    13,
    'festival_cine.jpg',
    'publicado',
    NOW(),
    NOW()
);

-- Verificar los roles existentes
SELECT * FROM roles;

-- Verificar los usuarios insertados
SELECT 
    u.id,
    u.nombre,
    u.apellido,
    u.email,
    r.nombre as rol,
    u.estado,
    u.fecha_registro
FROM users u 
JOIN roles r ON u.rol_id = r.id 
ORDER BY u.id;