<?php
require_once '../config/database.php';

// Crear conexión con manejo de errores
$db = createDatabaseConnection();

$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        
        if (isset($data['action'])) {
            switch($data['action']) {
                case 'login':
                    login($db, $data);
                    break;
                case 'register':
                    register($db, $data);
                    break;
                case 'verify_email':
                    verifyEmail($db, $data);
                    break;
                case 'reset_password':
                    resetPassword($db, $data);
                    break;
                default:
                    jsonResponse(['error' => 'Acción no válida'], 400);
            }
        } else {
            jsonResponse(['error' => 'Acción requerida'], 400);
        }
        break;
    default:
        jsonResponse(['error' => 'Método no permitido'], 405);
        break;
}

// Login de usuario
function login($db, $data) {
    $required_fields = ['email', 'password'];
    $errors = validateRequired($data, $required_fields);
    
    if (!empty($errors)) {
        jsonResponse(['error' => 'Datos faltantes', 'details' => $errors], 400);
    }
    
    try {
        $query = "SELECT u.*, r.nombre as rol_nombre 
                  FROM users u 
                  LEFT JOIN roles r ON u.rol_id = r.id 
                  WHERE u.email = :email AND u.estado = 'activo'";
        $stmt = $db->prepare($query);
        $stmt->bindValue(":email", $data['email']);
        $stmt->execute();
        
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($user && password_verify($data['password'], $user['password'])) {
            // Actualizar último acceso
            $update_query = "UPDATE users SET ultimo_acceso = NOW() WHERE id = :id";
            $update_stmt = $db->prepare($update_query);
            $update_stmt->bindValue(":id", $user['id']);
            $update_stmt->execute();
            
            // Remover password del response
            unset($user['password']);
            
            jsonResponse([
                'success' => true, 
                'message' => 'Login exitoso',
                'user' => $user
            ]);
        } else {
            jsonResponse(['error' => 'Credenciales inválidas'], 401);
        }
    } catch(PDOException $exception) {
        jsonResponse(['error' => 'Error al procesar login: ' . $exception->getMessage()], 500);
    }
}

// Registro de usuario
function register($db, $data) {
    $required_fields = ['nombre', 'apellido', 'email', 'password'];
    $errors = validateRequired($data, $required_fields);
    
    if (!empty($errors)) {
        jsonResponse(['error' => 'Datos faltantes', 'details' => $errors], 400);
    }
    
    // Validar email único
    try {
        $check_query = "SELECT id FROM users WHERE email = :email";
        $check_stmt = $db->prepare($check_query);
        $check_stmt->bindValue(":email", $data['email']);
        $check_stmt->execute();
        
        if ($check_stmt->rowCount() > 0) {
            jsonResponse(['error' => 'El email ya está registrado'], 400);
        }
    } catch(PDOException $exception) {
        jsonResponse(['error' => 'Error al validar email: ' . $exception->getMessage()], 500);
    }
    
    try {
        $token_verificacion = bin2hex(random_bytes(32));
        $password_hash = password_hash($data['password'], PASSWORD_DEFAULT);
        
        $query = "INSERT INTO users (nombre, apellido, email, telefono, fecha_nacimiento, genero, rol_id, estado, fecha_registro, token_verificacion, email_verificado, password) 
                  VALUES (:nombre, :apellido, :email, :telefono, :fecha_nacimiento, :genero, :rol_id, :estado, NOW(), :token_verificacion, 0, :password)";
        
        $stmt = $db->prepare($query);
        
        $stmt->bindValue(":nombre", $data['nombre']);
        $stmt->bindValue(":apellido", $data['apellido']);
        $stmt->bindValue(":email", $data['email']);
        $stmt->bindValue(":telefono", $data['telefono'] ?? null);
        $stmt->bindValue(":fecha_nacimiento", $data['fecha_nacimiento'] ?? null);
        $stmt->bindValue(":genero", $data['genero'] ?? null);
        
        $rol_id = $data['rol_id'] ?? 1; // Rol asistente por defecto
        $stmt->bindValue(":rol_id", $rol_id);
        
        $estado = 'activo';
        $stmt->bindValue(":estado", $estado);
        $stmt->bindValue(":token_verificacion", $token_verificacion);
        $stmt->bindValue(":password", $password_hash);
        
        if ($stmt->execute()) {
            $user_id = $db->lastInsertId();
            
            // Crear configuración por defecto para el usuario
            $config_query = "INSERT INTO configuraciones_usuario (usuario_id, created_at, updated_at) VALUES (:user_id, NOW(), NOW())";
            $config_stmt = $db->prepare($config_query);
            $config_stmt->bindValue(":user_id", $user_id);
            $config_stmt->execute();
            
            jsonResponse([
                'success' => true, 
                'message' => 'Usuario registrado exitosamente',
                'user_id' => $user_id,
                'verification_token' => $token_verificacion
            ], 201);
        } else {
            jsonResponse(['error' => 'Error al registrar usuario'], 500);
        }
    } catch(PDOException $exception) {
        jsonResponse(['error' => 'Error al registrar usuario: ' . $exception->getMessage()], 500);
    }
}

// Verificar email
function verifyEmail($db, $data) {
    if (!isset($data['token'])) {
        jsonResponse(['error' => 'Token de verificación requerido'], 400);
    }
    
    try {
        $query = "UPDATE users SET email_verificado = 1, token_verificacion = NULL, updated_at = NOW() 
                  WHERE token_verificacion = :token AND email_verificado = 0";
        $stmt = $db->prepare($query);
        $stmt->bindValue(":token", $data['token']);
        
        if ($stmt->execute() && $stmt->rowCount() > 0) {
            jsonResponse(['success' => true, 'message' => 'Email verificado exitosamente']);
        } else {
            jsonResponse(['error' => 'Token inválido o email ya verificado'], 400);
        }
    } catch(PDOException $exception) {
        jsonResponse(['error' => 'Error al verificar email: ' . $exception->getMessage()], 500);
    }
}

// Reset de contraseña
function resetPassword($db, $data) {
    if (isset($data['email'])) {
        // Solicitar reset
        try {
            $check_query = "SELECT id FROM users WHERE email = :email AND estado = 'activo'";
            $check_stmt = $db->prepare($check_query);
            $check_stmt->bindValue(":email", $data['email']);
            $check_stmt->execute();
            
            if ($check_stmt->rowCount() > 0) {
                $reset_token = bin2hex(random_bytes(32));
                
                $insert_query = "INSERT INTO password_reset_tokens (email, token, created_at) VALUES (:email, :token, NOW())
                                ON DUPLICATE KEY UPDATE token = :token2, created_at = NOW()";
                $insert_stmt = $db->prepare($insert_query);
                $insert_stmt->bindValue(":email", $data['email']);
                $insert_stmt->bindValue(":token", $reset_token);
                $insert_stmt->bindValue(":token2", $reset_token);
                $insert_stmt->execute();
                
                jsonResponse([
                    'success' => true, 
                    'message' => 'Token de reset generado',
                    'reset_token' => $reset_token
                ]);
            } else {
                jsonResponse(['error' => 'Email no encontrado'], 404);
            }
        } catch(PDOException $exception) {
            jsonResponse(['error' => 'Error al procesar reset: ' . $exception->getMessage()], 500);
        }
    } elseif (isset($data['token']) && isset($data['new_password'])) {
        // Cambiar contraseña
        try {
            $token_query = "SELECT email FROM password_reset_tokens WHERE token = :token AND created_at > DATE_SUB(NOW(), INTERVAL 1 HOUR)";
            $token_stmt = $db->prepare($token_query);
            $token_stmt->bindValue(":token", $data['token']);
            $token_stmt->execute();
            
            $token_data = $token_stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($token_data) {
                $password_hash = password_hash($data['new_password'], PASSWORD_DEFAULT);
                
                $update_query = "UPDATE users SET password = :password, updated_at = NOW() WHERE email = :email";
                $update_stmt = $db->prepare($update_query);
                $update_stmt->bindValue(":password", $password_hash);
                $update_stmt->bindValue(":email", $token_data['email']);
                $update_stmt->execute();
                
                // Eliminar token usado
                $delete_query = "DELETE FROM password_reset_tokens WHERE token = :token";
                $delete_stmt = $db->prepare($delete_query);
                $delete_stmt->bindValue(":token", $data['token']);
                $delete_stmt->execute();
                
                jsonResponse(['success' => true, 'message' => 'Contraseña actualizada exitosamente']);
            } else {
                jsonResponse(['error' => 'Token inválido o expirado'], 400);
            }
        } catch(PDOException $exception) {
            jsonResponse(['error' => 'Error al cambiar contraseña: ' . $exception->getMessage()], 500);
        }
    } else {
        jsonResponse(['error' => 'Datos insuficientes para reset de contraseña'], 400);
    }
}
?>
