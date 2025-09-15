<?php
require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    $where_clause = "";
    $params = [];
    
    // Filtros opcionales
    if (isset($_GET['usuario_id'])) {
        $where_clause .= " WHERE f.usuario_id = :usuario_id";
        $params[':usuario_id'] = $_GET['usuario_id'];
    }
    
    if (isset($_GET['evento_id'])) {
        $where_clause .= ($where_clause ? " AND" : " WHERE") . " f.evento_id = :evento_id";
        $params[':evento_id'] = $_GET['evento_id'];
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
} catch(PDOException $exception) {
    jsonResponse(['error' => 'Error al obtener favoritos: ' . $exception->getMessage()], 500);
}
?>
