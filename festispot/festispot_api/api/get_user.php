<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Manejar preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Solo permitir método GET
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['error' => 'Método no permitido']);
    exit();
}

require_once '../config/database.php';

try {
    $pdo = getConnection();
    
    // Verificar que se proporcione el ID del usuario
    if (!isset($_GET['id']) || empty($_GET['id'])) {
        http_response_code(400);
        echo json_encode(['error' => 'ID de usuario requerido']);
        exit();
    }
    
    $userId = intval($_GET['id']);
    
    // Obtener el usuario por ID (excluyendo la contraseña)
    $stmt = $pdo->prepare("
        SELECT id, nombre, apellido, email, telefono, fecha_nacimiento, 
               genero, avatar_url, rol_id, estado, fecha_registro, 
               ultimo_acceso, email_verificado, created_at, updated_at
        FROM usuarios 
        WHERE id = ? AND estado = 'activo'
    ");
    $stmt->execute([$userId]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$user) {
        http_response_code(404);
        echo json_encode(['error' => 'Usuario no encontrado']);
        exit();
    }
    
    // Convertir campos booleanos
    $user['email_verificado'] = (bool)$user['email_verificado'];
    
    // Actualizar último acceso
    $updateAccess = $pdo->prepare("UPDATE usuarios SET ultimo_acceso = CURRENT_TIMESTAMP WHERE id = ?");
    $updateAccess->execute([$userId]);
    
    // Respuesta exitosa
    http_response_code(200);
    echo json_encode([
        'success' => true,
        'user' => $user
    ]);
    
} catch (PDOException $e) {
    error_log("Error de base de datos en get_user.php: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(['error' => 'Error interno del servidor']);
    
} catch (Exception $e) {
    error_log("Error en get_user.php: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}
?>