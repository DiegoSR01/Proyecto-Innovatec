<?php
require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    $where_clause = "";
    $params = [];
    
    // Filtros opcionales
    if (isset($_GET['evento_id'])) {
        $where_clause .= " WHERE i.evento_id = :evento_id";
        $params[':evento_id'] = $_GET['evento_id'];
    }
    
    if (isset($_GET['tipo'])) {
        $where_clause .= ($where_clause ? " AND" : " WHERE") . " i.tipo = :tipo";
        $params[':tipo'] = $_GET['tipo'];
    }
    
    $query = "SELECT i.*, e.titulo as evento_titulo
              FROM imagenes_evento i 
              LEFT JOIN events e ON i.evento_id = e.id" . 
              $where_clause . " ORDER BY i.orden ASC, i.fecha_subida DESC";
    
    $stmt = $db->prepare($query);
    $stmt->execute($params);
    
    $imagenes = $stmt->fetchAll(PDO::FETCH_ASSOC);
    jsonResponse(['success' => true, 'data' => $imagenes]);
} catch(PDOException $exception) {
    jsonResponse(['error' => 'Error al obtener imágenes: ' . $exception->getMessage()], 500);
}
?>
