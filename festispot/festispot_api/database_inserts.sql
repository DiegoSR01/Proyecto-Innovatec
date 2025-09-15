-- Inserción de usuarios de prueba para FestiSpot
-- Estos usuarios corresponden a los que están hardcodeados actualmente

-- 1. Usuario Asistente de prueba
INSERT INTO `users` (
    `nombre`, 
    `apellido`, 
    `email`, 
    `telefono`, 
    `fecha_nacimiento`, 
    `genero`, 
    `role_id`, 
    `activo`, 
    `fecha_registro`, 
    `password`
) VALUES (
    'Usuario', 
    'Asistente', 
    'asistente@festispot.com', 
    '+52 555 123 4567', 
    '1995-05-15', 
    'prefiero_no_decir', 
    1, -- role_id = 1 para asistente (ver tabla roles)
    1, -- activo = 1
    NOW(), 
    '$2y$10$0123456789abcdefghijkOm5wJ2xkVw3zCHQ/TH.uLFGD4gS.HQtG' -- password: "asistente123"
);

-- 2. Usuario Productor de prueba
INSERT INTO `users` (
    `nombre`, 
    `apellido`, 
    `email`, 
    `telefono`, 
    `fecha_nacimiento`, 
    `genero`, 
    `role_id`, 
    `activo`, 
    `fecha_registro`, 
    `password`
) VALUES (
    'Usuario', 
    'Productor', 
    'productor@festispot.com', 
    '+52 555 987 6543', 
    '1988-12-03', 
    'masculino', 
    2, -- role_id = 2 para organizador/productor (ver tabla roles)
    1, -- activo = 1
    NOW(), 
    '$2y$10$0123456789abcdefghijkOm5wJ2xkVw3zCHQ/TH.uLFGD4gS.HQtG' -- password: "productor123"
);

-- 3. Usuario Admin de prueba (opcional)
INSERT INTO `users` (
    `nombre`, 
    `apellido`, 
    `email`, 
    `telefono`, 
    `fecha_nacimiento`, 
    `genero`, 
    `role_id`, 
    `activo`, 
    `fecha_registro`, 
    `password`
) VALUES (
    'Admin', 
    'Sistema', 
    'admin@festispot.com', 
    '+52 555 000 0000', 
    '1985-01-01', 
    'otro', 
    3, -- role_id = 3 para admin (ver tabla roles)
    1, -- activo = 1
    NOW(), 
    '$2y$10$0123456789abcdefghijkOm5wJ2xkVw3zCHQ/TH.uLFGD4gS.HQtG' -- password: "admin123"
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
    u.activo,
    u.fecha_registro
FROM users u 
JOIN roles r ON u.role_id = r.id 
ORDER BY u.id;
