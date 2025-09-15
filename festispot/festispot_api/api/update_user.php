<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: PUT, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Manejar preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Solo permitir métodos PUT y POST
if ($_SERVER['REQUEST_METHOD'] !== 'PUT' && $_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Método no permitido']);
    exit();
}

require_once '../config/database.php';

try {
    $pdo = getConnection();
    
    // Obtener datos del cuerpo de la petición
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!$input) {
        http_response_code(400);
        echo json_encode(['error' => 'Datos JSON inválidos']);
        exit();
    }
    
    // Validar que se proporcione el ID del usuario
    if (!isset($input['id']) || empty($input['id'])) {
        http_response_code(400);
        echo json_encode(['error' => 'ID de usuario requerido']);
        exit();
    }
    
    $userId = intval($input['id']);
    
    // Verificar que el usuario existe
    $checkUser = $pdo->prepare("SELECT id FROM usuarios WHERE id = ?");
    $checkUser->execute([$userId]);
    
    if (!$checkUser->fetch()) {
        http_response_code(404);
        echo json_encode(['error' => 'Usuario no encontrado']);
        exit();
    }
    
    // Construir la consulta de actualización dinámicamente
    $updateFields = [];
    $updateValues = [];
    
    // Campos que se pueden actualizar
    $allowedFields = [
        'nombre', 'apellido', 'email', 'telefono', 
        'fecha_nacimiento', 'genero', 'avatar_url'
    ];
    
    foreach ($allowedFields as $field) {
        if (isset($input[$field])) {
            $updateFields[] = "$field = ?";
            $updateValues[] = $input[$field];
        }
    }
    
    // Si se proporciona password, hashearlo
    if (isset($input['password']) && !empty($input['password'])) {
        $updateFields[] = "password = ?";
        $updateValues[] = password_hash($input['password'], PASSWORD_DEFAULT);
    }
    
    // Verificar que hay campos para actualizar
    if (empty($updateFields)) {
        http_response_code(400);
        echo json_encode(['error' => 'No hay campos para actualizar']);
        exit();
    }
    
    // Agregar campo de fecha de actualización
    $updateFields[] = "updated_at = CURRENT_TIMESTAMP";
    
    // Agregar el ID al final para la cláusula WHERE
    $updateValues[] = $userId;
    
    // Construir y ejecutar la consulta
    $sql = "UPDATE usuarios SET " . implode(', ', $updateFields) . " WHERE id = ?";
    $stmt = $pdo->prepare($sql);
    
    if (!$stmt->execute($updateValues)) {
        throw new Exception('Error al actualizar usuario');
    }
    
    // Verificar si se actualizó algún registro
    if ($stmt->rowCount() === 0) {
        http_response_code(400);
        echo json_encode(['error' => 'No se realizaron cambios o usuario no encontrado']);
        exit();
    }
    
    // Obtener el usuario actualizado
    $getUserStmt = $pdo->prepare("
        SELECT id, nombre, apellido, email, telefono, fecha_nacimiento, 
               genero, avatar_url, rol_id, estado, fecha_registro, 
               ultimo_acceso, email_verificado, created_at, updated_at
        FROM usuarios 
        WHERE id = ?
    ");
    $getUserStmt->execute([$userId]);
    $updatedUser = $getUserStmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$updatedUser) {
        throw new Exception('Error al obtener usuario actualizado');
    }
    
    // Convertir campos booleanos
    $updatedUser['email_verificado'] = (bool)$updatedUser['email_verificado'];
    
    // Respuesta exitosa
    http_response_code(200);
    echo json_encode([
        'success' => true,
        'message' => 'Usuario actualizado correctamente',
        'user' => $updatedUser
    ]);
    
} catch (PDOException $e) {
    error_log("Error de base de datos en update_user.php: " . $e->getMessage());
    
    // Verificar si es un error de duplicado de email
    if ($e->getCode() == 23000 && strpos($e->getMessage(), 'email') !== false) {
        http_response_code(409);
        echo json_encode(['error' => 'El email ya está en uso por otro usuario']);
    } else {
        http_response_code(500);
        echo json_encode(['error' => 'Error interno del servidor']);
    }
    
} catch (Exception $e) {
    error_log("Error en update_user.php: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}
?>