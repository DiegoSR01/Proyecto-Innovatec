<?php
require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    $where_clause = "";
    $params = [];
    
    // Filtros opcionales
    if (isset($_GET['usuario_id'])) {
        $where_clause .= " WHERE a.usuario_id = :usuario_id";
        $params[':usuario_id'] = $_GET['usuario_id'];
    }
    
    if (isset($_GET['evento_id'])) {
        $where_clause .= ($where_clause ? " AND" : " WHERE") . " a.evento_id = :evento_id";
        $params[':evento_id'] = $_GET['evento_id'];
    }
    
    if (isset($_GET['estado'])) {
        $where_clause .= ($where_clause ? " AND" : " WHERE") . " a.estado = :estado";
        $params[':estado'] = $_GET['estado'];
    }
    
    $query = "SELECT a.*, e.titulo as evento_titulo, u.nombre as usuario_nombre, u.apellido as usuario_apellido
              FROM asistencias a 
              LEFT JOIN events e ON a.evento_id = e.id 
              LEFT JOIN users u ON a.usuario_id = u.id" . 
              $where_clause . " ORDER BY a.fecha_registro DESC";
    
    $stmt = $db->prepare($query);
    $stmt->execute($params);
    
    $asistencias = $stmt->fetchAll(PDO::FETCH_ASSOC);
    jsonResponse(['success' => true, 'data' => $asistencias]);
} catch(PDOException $exception) {
    jsonResponse(['error' => 'Error al obtener asistencias: ' . $exception->getMessage()], 500);
}
?>
