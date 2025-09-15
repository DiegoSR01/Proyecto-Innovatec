<?php
require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    $where_clause = "";
    $params = [];
    
    // Filtros opcionales
    if (isset($_GET['evento_id'])) {
        $where_clause .= " WHERE a.evento_id = :evento_id";
        $params[':evento_id'] = $_GET['evento_id'];
    }
    
    if (isset($_GET['fecha'])) {
        $where_clause .= ($where_clause ? " AND" : " WHERE") . " a.fecha = :fecha";
        $params[':fecha'] = $_GET['fecha'];
    }
    
    if (isset($_GET['fecha_inicio']) && isset($_GET['fecha_fin'])) {
        $where_clause .= ($where_clause ? " AND" : " WHERE") . " a.fecha BETWEEN :fecha_inicio AND :fecha_fin";
        $params[':fecha_inicio'] = $_GET['fecha_inicio'];
        $params[':fecha_fin'] = $_GET['fecha_fin'];
    }
    
    $query = "SELECT a.*, e.titulo as evento_titulo
              FROM analytics_evento a 
              LEFT JOIN events e ON a.evento_id = e.id" . 
              $where_clause . " ORDER BY a.fecha DESC";
    
    $stmt = $db->prepare($query);
    $stmt->execute($params);
    
    $analytics = $stmt->fetchAll(PDO::FETCH_ASSOC);
    jsonResponse(['success' => true, 'data' => $analytics]);
} catch(PDOException $exception) {
    jsonResponse(['error' => 'Error al obtener analytics: ' . $exception->getMessage()], 500);
}
?>
