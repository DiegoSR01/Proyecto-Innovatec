<?php
require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    $where_clause = "";
    $params = [];
    
    // Filtros opcionales
    if (isset($_GET['organizador_id'])) {
        $where_clause .= " WHERE s.organizador_id = :organizador_id";
        $params[':organizador_id'] = $_GET['organizador_id'];
    }
    
    if (isset($_GET['estado'])) {
        $where_clause .= ($where_clause ? " AND" : " WHERE") . " s.estado = :estado";
        $params[':estado'] = $_GET['estado'];
    }
    
    $query = "SELECT s.*, p.nombre as plan_nombre, u.nombre as organizador_nombre, u.apellido as organizador_apellido
              FROM suscripciones_organizador s 
              LEFT JOIN planes_suscripcion p ON s.plan_id = p.id 
              LEFT JOIN users u ON s.organizador_id = u.id" . 
              $where_clause . " ORDER BY s.fecha_inicio DESC";
    
    $stmt = $db->prepare($query);
    $stmt->execute($params);
    
    $suscripciones = $stmt->fetchAll(PDO::FETCH_ASSOC);
    jsonResponse(['success' => true, 'data' => $suscripciones]);
} catch(PDOException $exception) {
    jsonResponse(['error' => 'Error al obtener suscripciones: ' . $exception->getMessage()], 500);
}
?>
