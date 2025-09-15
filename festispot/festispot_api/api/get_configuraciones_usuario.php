<?php
require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    $where_clause = "";
    $params = [];
    
    // Filtros opcionales
    if (isset($_GET['usuario_id'])) {
        $where_clause .= " WHERE c.usuario_id = :usuario_id";
        $params[':usuario_id'] = $_GET['usuario_id'];
    }
    
    $query = "SELECT c.*, u.nombre as usuario_nombre, u.apellido as usuario_apellido
              FROM configuraciones_usuario c 
              LEFT JOIN users u ON c.usuario_id = u.id" . 
              $where_clause . " ORDER BY c.updated_at DESC";
    
    $stmt = $db->prepare($query);
    $stmt->execute($params);
    
    $configuraciones = $stmt->fetchAll(PDO::FETCH_ASSOC);
    jsonResponse(['success' => true, 'data' => $configuraciones]);
} catch(PDOException $exception) {
    jsonResponse(['error' => 'Error al obtener configuraciones: ' . $exception->getMessage()], 500);
}
?>
