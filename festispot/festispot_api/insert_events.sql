-- ========================================
-- LIMPIEZA Y REINSERCION DE EVENTOS
-- ========================================
-- Este script elimina eventos existentes y crea 20 eventos diversos
-- usando las categorias limpias y usuarios de prueba

-- ⚠️ IMPORTANTE: Ejecutar SOLO después de tener roles, categorías y usuarios
-- O usar master_cleanup_fixed.sql para limpieza completa

-- Eliminar todos los eventos existentes
DELETE FROM `events`;

-- Reiniciar el auto increment
ALTER TABLE `events` AUTO_INCREMENT = 1;

-- ========================================
-- OBTENER IDS DE USUARIOS PARA ASIGNAR EVENTOS
-- ========================================

-- Obtener el ID del usuario productor para usar en los eventos
SET @productor_id = (SELECT id FROM users WHERE email = 'productor@festispot.com' LIMIT 1);

-- Si no existe el usuario productor, usar el primer usuario con rol de productor
SET @productor_id = IFNULL(@productor_id, (SELECT id FROM users WHERE rol_id = 2 LIMIT 1));

-- Si aún no hay ningún productor, usar el primer usuario disponible
SET @productor_id = IFNULL(@productor_id, (SELECT id FROM users ORDER BY id LIMIT 1));

-- ========================================
-- INSERCION DE 20 EVENTOS DIVERSOS
-- ========================================

-- Evento 1: Festival de Jazz Internacional
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Festival de Jazz Internacional', 
    'Tres días de música jazz con artistas nacionales e internacionales. Workshops, jam sessions y conciertos en múltiples escenarios.',
    'Festival de jazz con artistas internacionales y workshops',
    1, 'Música', '2025-10-15 19:00:00', '2025-10-17 23:00:00', '19:00:00', '23:00:00', 'Presencial',
    'Parque Lincoln', 'Polanco, Ciudad de México', 'Ciudad de México', 'Ciudad de México', 'México',
    2000, 0, 'jazz_festival.jpg', 'publicado', NOW(), NOW()
);

-- Evento 2: Exposición de Arte Contemporáneo
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Exposición de Arte Contemporáneo "Nuevas Miradas"', 
    'Muestra colectiva de 30 artistas emergentes mexicanos. Pintura, escultura, instalaciones y arte digital.',
    'Exposición de arte contemporáneo con artistas emergentes',
    2, 'Arte', '2025-10-20 10:00:00', '2025-12-20 18:00:00', '10:00:00', '18:00:00', 'Presencial',
    'Museo de Arte Moderno', 'Paseo de la Reforma y Gandhi, Bosque de Chapultepec', 'Ciudad de México', 'Ciudad de México', 'México',
    300, 0, 'arte_contemporaneo.jpg', 'publicado', NOW(), NOW()
);

-- Evento 3: Festival Gastronómico Internacional
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Festival Gastronómico Internacional', 
    'Degustación de platillos de 15 países, talleres de cocina, competencias culinarias y cenas temáticas.',
    'Festival gastronómico internacional con talleres y degustaciones',
    3, 'Gastronomía', '2025-10-25 12:00:00', '2025-10-27 22:00:00', '12:00:00', '22:00:00', 'Presencial',
    'Centro de Convenciones WTC', 'Montecito 38, Nápoles', 'Ciudad de México', 'Ciudad de México', 'México',
    1500, 18, 'festival_gastronomico.jpg', 'publicado', NOW(), NOW()
);

-- Evento 4: Maratón de la Ciudad
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Maratón de la Ciudad de México 2025', 
    'Carrera de 42km por los principales monumentos de la ciudad. Incluye categorías de 10km y 21km.',
    'Maratón con recorrido por monumentos históricos',
    4, 'Deportes', '2025-11-01 07:00:00', '2025-11-01 13:00:00', '07:00:00', '13:00:00', 'Presencial',
    'Zócalo Capitalino', 'Plaza de la Constitución s/n, Centro Histórico', 'Ciudad de México', 'Ciudad de México', 'México',
    5000, 16, 'maraton_cdmx.jpg', 'publicado', NOW(), NOW()
);

-- Evento 5: Conferencia de Inteligencia Artificial
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'AI Summit México 2025', 
    'Conferencia sobre inteligencia artificial con expertos internacionales. Talleres prácticos y networking.',
    'Conferencia de IA con expertos y talleres prácticos',
    5, 'Tecnología', '2025-11-05 09:00:00', '2025-11-06 18:00:00', '09:00:00', '18:00:00', 'Híbrido',
    'Centro Banamex', 'Av. Conscripto 311, Lomas de Sotelo', 'Ciudad de México', 'Ciudad de México', 'México',
    800, 18, 'ai_summit.jpg', 'publicado', NOW(), NOW()
);

-- Evento 6: Festival de Día de Muertos
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Festival de Día de Muertos', 
    'Celebración tradicional mexicana con ofrendas, música, teatro, talleres de catrinas y comida típica.',
    'Celebración tradicional del Día de Muertos',
    6, 'Cultura', '2025-11-01 16:00:00', '2025-11-02 23:00:00', '16:00:00', '23:00:00', 'Presencial',
    'Parque México', 'Parque México, Condesa', 'Ciudad de México', 'Ciudad de México', 'México',
    3000, 0, 'dia_muertos.jpg', 'publicado', NOW(), NOW()
);

-- Evento 7: Taller de Programación para Niños
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'CodeKids: Programación para el Futuro', 
    'Taller intensivo de programación para niños de 8-14 años usando Scratch y Python. Incluye certificado.',
    'Taller de programación para niños con Scratch y Python',
    7, 'Educativo', '2025-11-10 10:00:00', '2025-11-12 16:00:00', '10:00:00', '16:00:00', 'Presencial',
    'TecMilenio Campus Santa Fe', 'Av. Santa Fe 1130, Santa Fe', 'Ciudad de México', 'Ciudad de México', 'México',
    40, 8, 'codekids.jpg', 'publicado', NOW(), NOW()
);

-- Evento 8: Show de Comedia Stand-Up
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Noche de Stand-Up Comedy', 
    'Show de comedia con los mejores comediantes mexicanos. Dos horas de risas garantizadas.',
    'Show de comedia stand-up con comediantes mexicanos',
    8, 'Entretenimiento', '2025-11-15 21:00:00', '2025-11-15 23:30:00', '21:00:00', '23:30:00', 'Presencial',
    'Teatro Metropolitan', 'Independencia 90, Centro Histórico', 'Ciudad de México', 'Ciudad de México', 'México',
    600, 18, 'stand_up.jpg', 'publicado', NOW(), NOW()
);

-- Evento 9: Cumbre de Emprendimiento
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Cumbre de Emprendimiento México 2025', 
    'Evento para emprendedores con pitch competitions, mentorías, networking y conferencias magistrales.',
    'Cumbre de emprendimiento con pitch y networking',
    9, 'Negocios', '2025-11-20 09:00:00', '2025-11-21 19:00:00', '09:00:00', '19:00:00', 'Presencial',
    'Hotel Presidente InterContinental', 'Campos Elíseos 218, Polanco', 'Ciudad de México', 'Ciudad de México', 'México',
    500, 18, 'emprendimiento.jpg', 'publicado', NOW(), NOW()
);

-- Evento 10: Retiro de Yoga y Meditación
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Retiro de Yoga y Meditación en Tepoztlán', 
    'Fin de semana de conexión interior con sesiones de yoga, meditación, temazcal y alimentación consciente.',
    'Retiro de yoga y meditación en ambiente natural',
    10, 'Salud y Bienestar', '2025-11-25 16:00:00', '2025-11-27 14:00:00', '16:00:00', '14:00:00', 'Presencial',
    'Casa Alaya Tepoztlán', 'Camino a Amatlán s/n, Tepoztlán', 'Tepoztlán', 'Morelos', 'México',
    30, 16, 'yoga_retreat.jpg', 'publicado', NOW(), NOW()
);

-- Evento 11: Festival Familiar de Navidad
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Festival Familiar de Navidad', 
    'Celebración navideña para toda la familia con Santa Claus, obras de teatro, talleres y área de juegos.',
    'Festival navideño familiar con actividades para niños',
    11, 'Familia', '2025-12-15 10:00:00', '2025-12-15 20:00:00', '10:00:00', '20:00:00', 'Presencial',
    'Parque Bicentenario', 'Ejército Nacional Mexicano 843, Granada', 'Ciudad de México', 'Ciudad de México', 'México',
    2000, 0, 'navidad_familiar.jpg', 'publicado', NOW(), NOW()
);

-- Evento 12: Concierto de Música Sacra
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Concierto de Música Sacra Navideña', 
    'Concierto de villancicos y música sacra interpretado por el Coro de la Catedral con orquesta sinfónica.',
    'Concierto de música sacra navideña con coro y orquesta',
    12, 'Religioso', '2025-12-20 19:00:00', '2025-12-20 21:00:00', '19:00:00', '21:00:00', 'Presencial',
    'Catedral Metropolitana', 'Plaza de la Constitución s/n, Centro Histórico', 'Ciudad de México', 'Ciudad de México', 'México',
    800, 0, 'musica_sacra.jpg', 'publicado', NOW(), NOW()
);

-- Evento 13: Concierto de Rock Alternativo
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Festival de Rock Alternativo Underground', 
    'Noche de rock alternativo con bandas emergentes nacionales. Mosh pit, merchandising y sorpresas.',
    'Festival de rock alternativo con bandas emergentes',
    1, 'Música', '2025-12-22 20:00:00', '2025-12-23 02:00:00', '20:00:00', '02:00:00', 'Presencial',
    'Foro Sol', 'Viaducto Río de la Piedad s/n, Granjas México', 'Ciudad de México', 'Ciudad de México', 'México',
    8000, 16, 'rock_underground.jpg', 'publicado', NOW(), NOW()
);

-- Evento 14: Galería de Fotografía Urbana
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Exposición "Ciudad en Blanco y Negro"', 
    'Muestra fotográfica de la vida urbana mexicana. 50 fotografías de 20 artistas documentando la ciudad.',
    'Exposición de fotografía urbana en blanco y negro',
    2, 'Arte', '2025-12-01 11:00:00', '2026-01-31 19:00:00', '11:00:00', '19:00:00', 'Presencial',
    'Galería José María Velasco', 'Peralvillo 55, Morelos', 'Ciudad de México', 'Ciudad de México', 'México',
    150, 0, 'foto_urbana.jpg', 'publicado', NOW(), NOW()
);

-- Evento 15: Cena Temática Italiana
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Notte Italiana - Cena Temática', 
    'Cena de cinco tiempos con auténtica cocina italiana, vinos de importación y música en vivo.',
    'Cena temática italiana con música en vivo',
    3, 'Gastronomía', '2025-12-05 19:00:00', '2025-12-05 23:00:00', '19:00:00', '23:00:00', 'Presencial',
    'Restaurante Osteria Santo', 'Orizaba 87, Roma Norte', 'Ciudad de México', 'Ciudad de México', 'México',
    60, 21, 'cena_italiana.jpg', 'publicado', NOW(), NOW()
);

-- Evento 16: Torneo de Ajedrez
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Torneo de Ajedrez Ciudad de México', 
    'Torneo oficial de ajedrez con categorías para todas las edades. Premios en efectivo y trofeos.',
    'Torneo de ajedrez con categorías para todas las edades',
    4, 'Deportes', '2025-12-07 09:00:00', '2025-12-08 18:00:00', '09:00:00', '18:00:00', 'Presencial',
    'Casa de la Cultura Jesús Reyes Heroles', 'Av. Universidad 1000, Del Valle', 'Ciudad de México', 'Ciudad de México', 'México',
    200, 6, 'torneo_ajedrez.jpg', 'publicado', NOW(), NOW()
);

-- Evento 17: Hackathon de Blockchain
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'BlockChain Hackathon México 2025', 
    '48 horas de desarrollo intensivo en blockchain. Mentores expertos, premios de $100,000 MXN.',
    'Hackathon de blockchain con premios y mentores',
    5, 'Tecnología', '2025-12-10 18:00:00', '2025-12-12 18:00:00', '18:00:00', '18:00:00', 'Presencial',
    'Hub Ciudad de México', 'Alejandro Dumas 215, Polanco', 'Ciudad de México', 'Ciudad de México', 'México',
    120, 18, 'blockchain_hack.jpg', 'publicado', NOW(), NOW()
);

-- Evento 18: Festival de Danza Folclórica
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Festival de Danza Folclórica Mexicana', 
    'Encuentro de grupos de danza de todo México. Concursos, talleres y presentaciones culturales.',
    'Festival de danza folclórica con grupos de todo México',
    6, 'Cultura', '2025-12-12 17:00:00', '2025-12-14 21:00:00', '17:00:00', '21:00:00', 'Presencial',
    'Teatro de la Ciudad Esperanza Iris', 'Donceles 36, Centro Histórico', 'Ciudad de México', 'Ciudad de México', 'México',
    1000, 0, 'danza_folklorica.jpg', 'publicado', NOW(), NOW()
);

-- Evento 19: Seminario de Marketing Digital
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Seminario de Marketing Digital 2025', 
    'Curso intensivo sobre tendencias en marketing digital, redes sociales, SEO y publicidad online.',
    'Seminario intensivo de marketing digital y redes sociales',
    7, 'Educativo', '2025-12-16 09:00:00', '2025-12-17 17:00:00', '09:00:00', '17:00:00', 'Virtual',
    'Plataforma Zoom', 'Evento en línea', 'Ciudad de México', 'Ciudad de México', 'México',
    500, 16, 'marketing_digital.jpg', 'publicado', NOW(), NOW()
);

-- Evento 20: Espectáculo de Circo Contemporáneo
INSERT INTO `events` (
    `organizador_id`, `titulo`, `descripcion`, `descripcion_corta`, `categoria_id`, `category`,
    `fecha_inicio`, `fecha_fin`, `start_time`, `end_time`, `event_type`,
    `venue_name`, `full_address`, `city`, `state`, `country`,
    `capacidad_total`, `edad_minima`, `banner_image`, `estado`, `created_at`, `updated_at`
) VALUES (
    @productor_id, 'Circo Contemporáneo "Elementos"', 
    'Espectáculo de circo contemporáneo que combina acrobacias, danza y tecnología. Una experiencia única.',
    'Circo contemporáneo con acrobacias, danza y tecnología',
    8, 'Entretenimiento', '2025-12-18 20:00:00', '2025-12-20 22:00:00', '20:00:00', '22:00:00', 'Presencial',
    'Centro Nacional de las Artes', 'Av. Río Churubusco 79, Country Club', 'Ciudad de México', 'Ciudad de México', 'México',
    800, 6, 'circo_contemporaneo.jpg', 'publicado', NOW(), NOW()
);

-- Verificar los eventos insertados
SELECT 
    id,
    titulo,
    category,
    fecha_inicio,
    fecha_fin,
    city,
    capacidad_total,
    edad_minima,
    estado
FROM events 
ORDER BY fecha_inicio;