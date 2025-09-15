<?php
// Configuración de la base de datos
class Database {
    private $host = "localhost";
    private $db_name = "festispot";
    private $username = "root";
    private $password = "";
    public $conn;

    // Obtener la conexión de base de datos
    public function getConnection() {
        $this->conn = null;

        try {
            $this->conn = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->db_name, $this->username, $this->password);
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $this->conn->exec("set names utf8");
        } catch(PDOException $exception) {
            // En lugar de hacer echo directamente, lanzar la excepción para manejo controlado
            throw new Exception("Error de conexión a la base de datos: " . $exception->getMessage());
        }

        return $this->conn;
    }
    
    // Función para verificar si la conexión está disponible
    public function isConnected() {
        try {
            $this->getConnection();
            return $this->conn !== null;
        } catch(Exception $e) {
            return false;
        }
    }
}

// Función para responder con JSON
function jsonResponse($data, $status_code = 200) {
    http_response_code($status_code);
    header('Content-Type: application/json');
    echo json_encode($data);
    exit;
}

// Función para manejar errores de conexión de manera consistente
function handleConnectionError($exception_message) {
    jsonResponse([
        'success' => false,
        'error' => 'Error de conexión a la base de datos',
        'details' => $exception_message,
        'code' => 'DB_CONNECTION_ERROR'
    ], 500);
}

// Función para crear conexión con manejo de errores
function createDatabaseConnection() {
    try {
        $database = new Database();
        $conn = $database->getConnection();
        if ($conn === null) {
            throw new Exception("No se pudo establecer conexión con la base de datos");
        }
        return $conn;
    } catch(Exception $e) {
        handleConnectionError($e->getMessage());
        return null; // Este return nunca se ejecutará debido a exit() en handleConnectionError
    }
}

// Función para validar datos requeridos
function validateRequired($data, $required_fields) {
    $errors = [];
    foreach ($required_fields as $field) {
        if (!isset($data[$field]) || empty($data[$field])) {
            $errors[] = "El campo $field es requerido";
        }
    }
    return $errors;
}

// Configuración CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Manejar preflight requests
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}
?>
