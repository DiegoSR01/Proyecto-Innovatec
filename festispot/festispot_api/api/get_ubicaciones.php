<?php
require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    $query = "SELECT * FROM ubicaciones ORDER BY nombre";
    $stmt = $db->prepare($query);
    $stmt->execute();
    
    $ubicaciones = $stmt->fetchAll(PDO::FETCH_ASSOC);
    jsonResponse(['success' => true, 'data' => $ubicaciones]);
} catch(PDOException $exception) {
    jsonResponse(['error' => 'Error al obtener ubicaciones: ' . $exception->getMessage()], 500);
}
?>
