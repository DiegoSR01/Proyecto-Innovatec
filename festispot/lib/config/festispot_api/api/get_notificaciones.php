<?php
require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    $where_clause = "";
    $params = [];
    
    // Filtros opcionales
    if (isset($_GET['usuario_id'])) {
        $where_clause .= " WHERE n.usuario_id = :usuario_id";
        $params[':usuario_id'] = $_GET['usuario_id'];
    }
    
    if (isset($_GET['tipo'])) {
        $where_clause .= ($where_clause ? " AND" : " WHERE") . " n.tipo = :tipo";
        $params[':tipo'] = $_GET['tipo'];
    }
    
    if (isset($_GET['leida'])) {
        $where_clause .= ($where_clause ? " AND" : " WHERE") . " n.leida = :leida";
        $params[':leida'] = $_GET['leida'];
    }
    
    $query = "SELECT n.*, e.titulo as evento_titulo, u.nombre as usuario_nombre, u.apellido as usuario_apellido
              FROM notificaciones n 
              LEFT JOIN events e ON n.evento_id = e.id 
              LEFT JOIN users u ON n.usuario_id = u.id" . 
              $where_clause . " ORDER BY n.fecha_envio DESC";
    
    $stmt = $db->prepare($query);
    $stmt->execute($params);
    
    $notificaciones = $stmt->fetchAll(PDO::FETCH_ASSOC);
    jsonResponse(['success' => true, 'data' => $notificaciones]);
} catch(PDOException $exception) {
    jsonResponse(['error' => 'Error al obtener notificaciones: ' . $exception->getMessage()], 500);
}
?>
