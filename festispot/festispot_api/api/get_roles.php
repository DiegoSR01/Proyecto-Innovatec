<?php
require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

try {
    $query = "SELECT * FROM roles ORDER BY id";
    $stmt = $db->prepare($query);
    $stmt->execute();
    
    $roles = $stmt->fetchAll(PDO::FETCH_ASSOC);
    jsonResponse(['success' => true, 'data' => $roles]);
} catch(PDOException $exception) {
    jsonResponse(['error' => 'Error al obtener roles: ' . $exception->getMessage()], 500);
}
?>
