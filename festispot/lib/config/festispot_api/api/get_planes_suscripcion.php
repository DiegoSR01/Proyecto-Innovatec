<?php
require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    $query = "SELECT * FROM planes_suscripcion WHERE activo = 1 ORDER BY precio_mensual ASC";
    $stmt = $db->prepare($query);
    $stmt->execute();
    
    $planes = $stmt->fetchAll(PDO::FETCH_ASSOC);
    jsonResponse(['success' => true, 'data' => $planes]);
} catch(PDOException $exception) {
    jsonResponse(['error' => 'Error al obtener planes de suscripción: ' . $exception->getMessage()], 500);
}
?>
