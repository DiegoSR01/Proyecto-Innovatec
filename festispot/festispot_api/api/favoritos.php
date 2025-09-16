<?php
require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

// Obtener método HTTP
$method = $_SERVER['REQUEST_METHOD'];

try {
    switch ($method) {
        case 'GET':
            // Obtener favoritos de un usuario
            $where_clause = "";
            $params = [];
            
            // Filtros opcionales - soportar tanto user_id como usuario_id para compatibilidad
            if (isset($_GET['user_id']) || isset($_GET['usuario_id'])) {
                $user_id = $_GET['user_id'] ?? $_GET['usuario_id'];
                $where_clause .= " WHERE f.usuario_id = :usuario_id";
                $params[':usuario_id'] = $user_id;
            }
            
            if (isset($_GET['event_id']) || isset($_GET['evento_id'])) {
                $event_id = $_GET['event_id'] ?? $_GET['evento_id'];
                $where_clause .= ($where_clause ? " AND" : " WHERE") . " f.evento_id = :evento_id";
                $params[':evento_id'] = $event_id;
            }
            
            $query = "SELECT f.*, e.titulo as evento_titulo, u.nombre as usuario_nombre, u.apellido as usuario_apellido
                      FROM favoritos f 
                      LEFT JOIN events e ON f.evento_id = e.id 
                      LEFT JOIN users u ON f.usuario_id = u.id" . 
                      $where_clause . " ORDER BY f.fecha_agregado DESC";
            
            $stmt = $db->prepare($query);
            $stmt->execute($params);
            
            $favoritos = $stmt->fetchAll(PDO::FETCH_ASSOC);
            jsonResponse(['success' => true, 'data' => $favoritos]);
            break;

        case 'POST':
            // Agregar/quitar favorito (toggle)
            $input = json_decode(file_get_contents('php://input'), true);
            
            if (!$input) {
                jsonResponse(['error' => 'Datos JSON inválidos'], 400);
            }
            
            $action = $input['action'] ?? '';
            $user_id = $input['user_id'] ?? $input['usuario_id'] ?? null;
            $event_id = $input['event_id'] ?? $input['evento_id'] ?? null;
            
            if (!$user_id || !$event_id) {
                jsonResponse(['error' => 'user_id y event_id son requeridos'], 400);
            }
            
            if ($action === 'toggle') {
                // Verificar si ya existe el favorito
                $checkQuery = "SELECT id FROM favoritos WHERE usuario_id = :usuario_id AND evento_id = :evento_id";
                $checkStmt = $db->prepare($checkQuery);
                $checkStmt->bindParam(':usuario_id', $user_id);
                $checkStmt->bindParam(':evento_id', $event_id);
                $checkStmt->execute();
                
                if ($checkStmt->fetch()) {
                    // Si existe, eliminarlo
                    $deleteQuery = "DELETE FROM favoritos WHERE usuario_id = :usuario_id AND evento_id = :evento_id";
                    $deleteStmt = $db->prepare($deleteQuery);
                    $deleteStmt->bindParam(':usuario_id', $user_id);
                    $deleteStmt->bindParam(':evento_id', $event_id);
                    
                    if ($deleteStmt->execute()) {
                        jsonResponse(['success' => true, 'action' => 'removed', 'message' => 'Favorito eliminado']);
                    } else {
                        jsonResponse(['error' => 'Error al eliminar favorito'], 500);
                    }
                } else {
                    // Si no existe, agregarlo
                    $insertQuery = "INSERT INTO favoritos (usuario_id, evento_id, fecha_agregado) VALUES (:usuario_id, :evento_id, NOW())";
                    $insertStmt = $db->prepare($insertQuery);
                    $insertStmt->bindParam(':usuario_id', $user_id);
                    $insertStmt->bindParam(':evento_id', $event_id);
                    
                    if ($insertStmt->execute()) {
                        jsonResponse(['success' => true, 'action' => 'added', 'message' => 'Favorito agregado']);
                    } else {
                        jsonResponse(['error' => 'Error al agregar favorito'], 500);
                    }
                }
            } else {
                jsonResponse(['error' => 'Acción no válida. Use action: "toggle"'], 400);
            }
            break;

        case 'DELETE':
            // Eliminar todos los favoritos de un usuario
            $user_id = $_GET['user_id'] ?? $_GET['usuario_id'] ?? null;
            
            if (!$user_id) {
                jsonResponse(['error' => 'user_id es requerido'], 400);
            }
            
            $deleteQuery = "DELETE FROM favoritos WHERE usuario_id = :usuario_id";
            $deleteStmt = $db->prepare($deleteQuery);
            $deleteStmt->bindParam(':usuario_id', $user_id);
            
            if ($deleteStmt->execute()) {
                jsonResponse(['success' => true, 'message' => 'Todos los favoritos eliminados']);
            } else {
                jsonResponse(['error' => 'Error al eliminar favoritos'], 500);
            }
            break;

        default:
            jsonResponse(['error' => 'Método HTTP no soportado'], 405);
            break;
    }
} catch(PDOException $exception) {
    jsonResponse(['error' => 'Error de base de datos: ' . $exception->getMessage()], 500);
} catch(Exception $exception) {
    jsonResponse(['error' => 'Error del servidor: ' . $exception->getMessage()], 500);
}
?>