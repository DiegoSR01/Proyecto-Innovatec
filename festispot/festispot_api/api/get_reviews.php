<?php
require_once '../config/database.php';

// Crear conexión con manejo de errores
$db = createDatabaseConnection();

try {
    $where_clause = "";
    $params = [];
    
    // Filtros opcionales
    if (isset($_GET['usuario_id'])) {
        $where_clause .= " WHERE r.usuario_id = :usuario_id";
        $params[':usuario_id'] = $_GET['usuario_id'];
    }
    
    if (isset($_GET['evento_id'])) {
        $where_clause .= ($where_clause ? " AND" : " WHERE") . " r.evento_id = :evento_id";
        $params[':evento_id'] = $_GET['evento_id'];
    }
    
    if (isset($_GET['visible'])) {
        $where_clause .= ($where_clause ? " AND" : " WHERE") . " r.visible = :visible";
        $params[':visible'] = $_GET['visible'];
    }
    
    $query = "SELECT r.*, e.titulo as evento_titulo, u.nombre as usuario_nombre, u.apellido as usuario_apellido
              FROM reviews r 
              LEFT JOIN events e ON r.evento_id = e.id 
              LEFT JOIN users u ON r.usuario_id = u.id" . 
              $where_clause . " ORDER BY r.fecha_review DESC";
    
    $stmt = $db->prepare($query);
    $stmt->execute($params);
    
    $reviews = $stmt->fetchAll(PDO::FETCH_ASSOC);
    jsonResponse(['success' => true, 'data' => $reviews]);
} catch(PDOException $exception) {
    jsonResponse(['error' => 'Error al obtener reviews: ' . $exception->getMessage()], 500);
}
?>
