<?php
require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    $where_clause = "";
    $params = [];
    
    // Filtros opcionales
    if (isset($_GET['estado'])) {
        $where_clause .= " WHERE estado = :estado";
        $params[':estado'] = $_GET['estado'];
    }
    
    if (isset($_GET['categoria_id'])) {
        $where_clause .= ($where_clause ? " AND" : " WHERE") . " categoria_id = :categoria_id";
        $params[':categoria_id'] = $_GET['categoria_id'];
    }
    
    if (isset($_GET['organizador_id'])) {
        $where_clause .= ($where_clause ? " AND" : " WHERE") . " organizador_id = :organizador_id";
        $params[':organizador_id'] = $_GET['organizador_id'];
    }
    
    $query = "SELECT e.*, c.nombre as categoria_nombre, u.nombre as organizador_nombre, u.apellido as organizador_apellido
              FROM events e 
              LEFT JOIN categorias c ON e.categoria_id = c.id 
              LEFT JOIN users u ON e.organizador_id = u.id" . 
              $where_clause . " ORDER BY e.fecha_inicio DESC";
    
    $stmt = $db->prepare($query);
    $stmt->execute($params);
    
    $events = $stmt->fetchAll(PDO::FETCH_ASSOC);
    jsonResponse(['success' => true, 'data' => $events]);
} catch(PDOException $exception) {
    jsonResponse(['error' => 'Error al obtener eventos: ' . $exception->getMessage()], 500);
}
?>
