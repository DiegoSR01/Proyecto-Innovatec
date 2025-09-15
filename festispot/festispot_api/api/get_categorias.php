<?php
require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    $query = "SELECT * FROM categorias WHERE activo = 1 ORDER BY nombre";
    $stmt = $db->prepare($query);
    $stmt->execute();
    
    $categorias = $stmt->fetchAll(PDO::FETCH_ASSOC);
    jsonResponse(['success' => true, 'data' => $categorias]);
} catch(PDOException $exception) {
    jsonResponse(['error' => 'Error al obtener categorías: ' . $exception->getMessage()], 500);
}
?>
