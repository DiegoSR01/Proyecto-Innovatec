<?php
require_once '../config/database.php';

// Crear conexión con manejo de errores
$db = createDatabaseConnection();

$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'GET':
        if (isset($_GET['id'])) {
            getUser($db, $_GET['id']);
        } else {
            getAllUsers($db);
        }
        break;
    case 'POST':
        createUser($db);
        break;
    case 'PUT':
        updateUser($db);
        break;
    case 'DELETE':
        if (isset($_GET['id'])) {
            deleteUser($db, $_GET['id']);
        } else {
            jsonResponse(['error' => 'ID requerido para eliminar'], 400);
        }
        break;
    default:
        jsonResponse(['error' => 'Método no permitido'], 405);
        break;
}

// Obtener todos los usuarios
function getAllUsers($db) {
    try {
        $query = "SELECT u.*, r.nombre as rol_nombre 
                  FROM users u 
                  LEFT JOIN roles r ON u.rol_id = r.id 
                  ORDER BY u.id DESC";
        $stmt = $db->prepare($query);
        $stmt->execute();
        
        $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
        jsonResponse(['success' => true, 'data' => $users]);
    } catch(PDOException $exception) {
        jsonResponse(['error' => 'Error al obtener usuarios: ' . $exception->getMessage()], 500);
    }
}

// Obtener un usuario por ID
function getUser($db, $id) {
    try {
        $query = "SELECT u.*, r.nombre as rol_nombre 
                  FROM users u 
                  LEFT JOIN roles r ON u.rol_id = r.id 
                  WHERE u.id = :id";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":id", $id);
        $stmt->execute();
        
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($user) {
            jsonResponse(['success' => true, 'data' => $user]);
        } else {
            jsonResponse(['error' => 'Usuario no encontrado'], 404);
        }
    } catch(PDOException $exception) {
        jsonResponse(['error' => 'Error al obtener usuario: ' . $exception->getMessage()], 500);
    }
}

// Crear nuevo usuario
function createUser($db) {
    $data = json_decode(file_get_contents("php://input"), true);
    
    // Validar campos requeridos
    $required_fields = ['nombre', 'apellido', 'email'];
    $errors = validateRequired($data, $required_fields);
    
    if (!empty($errors)) {
        jsonResponse(['error' => 'Datos faltantes', 'details' => $errors], 400);
    }
    
    // Validar email único
    try {
        $check_query = "SELECT id FROM users WHERE email = :email";
        $check_stmt = $db->prepare($check_query);
        $check_stmt->bindParam(":email", $data['email']);
        $check_stmt->execute();
        
        if ($check_stmt->rowCount() > 0) {
            jsonResponse(['error' => 'El email ya está registrado'], 400);
        }
    } catch(PDOException $exception) {
        jsonResponse(['error' => 'Error al validar email: ' . $exception->getMessage()], 500);
    }
    
    try {
        $query = "INSERT INTO users (nombre, apellido, email, telefono, fecha_nacimiento, genero, avatar_url, rol_id, estado, fecha_registro, email_verificado, password) 
                  VALUES (:nombre, :apellido, :email, :telefono, :fecha_nacimiento, :genero, :avatar_url, :rol_id, :estado, NOW(), :email_verificado, :password)";
        
        $stmt = $db->prepare($query);
        
        // Asignar valores con valores por defecto
        $stmt->bindParam(":nombre", $data['nombre']);
        $stmt->bindParam(":apellido", $data['apellido']);
        $stmt->bindParam(":email", $data['email']);
        $stmt->bindParam(":telefono", $data['telefono'] ?? null);
        $stmt->bindParam(":fecha_nacimiento", $data['fecha_nacimiento'] ?? null);
        $stmt->bindParam(":genero", $data['genero'] ?? null);
        $stmt->bindParam(":avatar_url", $data['avatar_url'] ?? null);
        
        $rol_id = $data['rol_id'] ?? 1; // Rol asistente por defecto
        $stmt->bindParam(":rol_id", $rol_id);
        
        $estado = $data['estado'] ?? 'activo';
        $stmt->bindParam(":estado", $estado);
        
        $email_verificado = $data['email_verificado'] ?? 0;
        $stmt->bindParam(":email_verificado", $email_verificado);
        
        // Hash de la contraseña si se proporciona
        $password_hash = isset($data['password']) ? password_hash($data['password'], PASSWORD_DEFAULT) : null;
        $stmt->bindParam(":password", $password_hash);
        
        if ($stmt->execute()) {
            $user_id = $db->lastInsertId();
            jsonResponse(['success' => true, 'message' => 'Usuario creado exitosamente', 'user_id' => $user_id], 201);
        } else {
            jsonResponse(['error' => 'Error al crear usuario'], 500);
        }
    } catch(PDOException $exception) {
        jsonResponse(['error' => 'Error al crear usuario: ' . $exception->getMessage()], 500);
    }
}

// Actualizar usuario
function updateUser($db) {
    $data = json_decode(file_get_contents("php://input"), true);
    
    if (!isset($data['id'])) {
        jsonResponse(['error' => 'ID de usuario requerido'], 400);
    }
    
    try {
        // Verificar si el usuario existe
        $check_query = "SELECT id FROM users WHERE id = :id";
        $check_stmt = $db->prepare($check_query);
        $check_stmt->bindParam(":id", $data['id']);
        $check_stmt->execute();
        
        if ($check_stmt->rowCount() == 0) {
            jsonResponse(['error' => 'Usuario no encontrado'], 404);
        }
        
        // Construir query dinámicamente
        $fields = [];
        $params = [':id' => $data['id']];
        
        if (isset($data['nombre'])) {
            $fields[] = "nombre = :nombre";
            $params[':nombre'] = $data['nombre'];
        }
        if (isset($data['apellido'])) {
            $fields[] = "apellido = :apellido";
            $params[':apellido'] = $data['apellido'];
        }
        if (isset($data['email'])) {
            // Validar email único (excluyendo el usuario actual)
            $email_check = "SELECT id FROM users WHERE email = :email AND id != :current_id";
            $email_stmt = $db->prepare($email_check);
            $email_stmt->bindParam(":email", $data['email']);
            $email_stmt->bindParam(":current_id", $data['id']);
            $email_stmt->execute();
            
            if ($email_stmt->rowCount() > 0) {
                jsonResponse(['error' => 'El email ya está en uso'], 400);
            }
            
            $fields[] = "email = :email";
            $params[':email'] = $data['email'];
        }
        if (isset($data['telefono'])) {
            $fields[] = "telefono = :telefono";
            $params[':telefono'] = $data['telefono'];
        }
        if (isset($data['fecha_nacimiento'])) {
            $fields[] = "fecha_nacimiento = :fecha_nacimiento";
            $params[':fecha_nacimiento'] = $data['fecha_nacimiento'];
        }
        if (isset($data['genero'])) {
            $fields[] = "genero = :genero";
            $params[':genero'] = $data['genero'];
        }
        if (isset($data['avatar_url'])) {
            $fields[] = "avatar_url = :avatar_url";
            $params[':avatar_url'] = $data['avatar_url'];
        }
        if (isset($data['rol_id'])) {
            $fields[] = "rol_id = :rol_id";
            $params[':rol_id'] = $data['rol_id'];
        }
        if (isset($data['estado'])) {
            $fields[] = "estado = :estado";
            $params[':estado'] = $data['estado'];
        }
        if (isset($data['password'])) {
            $fields[] = "password = :password";
            $params[':password'] = password_hash($data['password'], PASSWORD_DEFAULT);
        }
        
        if (empty($fields)) {
            jsonResponse(['error' => 'No hay datos para actualizar'], 400);
        }
        
        $fields[] = "updated_at = NOW()";
        
        $query = "UPDATE users SET " . implode(', ', $fields) . " WHERE id = :id";
        $stmt = $db->prepare($query);
        
        if ($stmt->execute($params)) {
            jsonResponse(['success' => true, 'message' => 'Usuario actualizado exitosamente']);
        } else {
            jsonResponse(['error' => 'Error al actualizar usuario'], 500);
        }
    } catch(PDOException $exception) {
        jsonResponse(['error' => 'Error al actualizar usuario: ' . $exception->getMessage()], 500);
    }
}

// Eliminar usuario
function deleteUser($db, $id) {
    try {
        // Verificar si el usuario existe
        $check_query = "SELECT id FROM users WHERE id = :id";
        $check_stmt = $db->prepare($check_query);
        $check_stmt->bindParam(":id", $id);
        $check_stmt->execute();
        
        if ($check_stmt->rowCount() == 0) {
            jsonResponse(['error' => 'Usuario no encontrado'], 404);
        }
        
        // Eliminar usuario (esto también eliminará registros relacionados por CASCADE si está configurado)
        $query = "DELETE FROM users WHERE id = :id";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":id", $id);
        
        if ($stmt->execute()) {
            jsonResponse(['success' => true, 'message' => 'Usuario eliminado exitosamente']);
        } else {
            jsonResponse(['error' => 'Error al eliminar usuario'], 500);
        }
    } catch(PDOException $exception) {
        jsonResponse(['error' => 'Error al eliminar usuario: ' . $exception->getMessage()], 500);
    }
}
?>
