<?php
include 'conexion.php';

$pdo = new Conexion();

header('Content-Type: application/json');

function listarPacientes() {
    global $pdo;
    try {
        $sql = "SELECT sip, dni, nombre, apellido1, apellido2, telefono, fecha_nacimiento FROM pacientes";
        $stmt = $pdo->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
        exit();
    }
}

function listarPacientesPaginados($page = 1, $limit = 10) {
    global $pdo;

    $offset = ($page - 1) * $limit;

    $sql = "SELECT sip, dni, nombre, apellido1, apellido2, telefono, fecha_nacimiento FROM pacientes LIMIT :offset, :limit";
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':limit', $limit, PDO::PARAM_INT);
    $stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
    $stmt->execute();

    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function obtenerTotalPacientes() {
    global $pdo;

    $sql = "SELECT COUNT(*) as total FROM pacientes";
    $stmt = $pdo->prepare($sql);
    $stmt->execute();

    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    return $result['total'];
}


function buscarPacientesPorFiltro($filtro) {
    global $pdo;
    try {
        $stmt = $pdo->prepare("SELECT sip, dni, nombre, apellido1, apellido2, telefono, fecha_nacimiento FROM pacientes WHERE nombre LIKE :filtro OR dni LIKE :filtro");
        $likeFiltro = "%$filtro%";
        $stmt->bindParam(':filtro', $likeFiltro, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
        exit();
    }
}

function insertarPaciente($datos) {
    global $pdo;
    try {
      
        $sql = "SELECT COUNT(*) FROM pacientes WHERE sip = :sip OR dni = :dni";
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':sip', $datos['sip'], PDO::PARAM_STR);
        $stmt->bindParam(':dni', $datos['dni'], PDO::PARAM_STR);
        $stmt->execute();
        $count = $stmt->fetchColumn();

        if ($count > 0) {
            http_response_code(400);
            echo json_encode(['error' => 'El sip o dni ya existe.']);
            exit();
        }

        $sql = "INSERT INTO pacientes (sip, dni, nombre, apellido1, apellido2, telefono, fecha_nacimiento) VALUES (:sip, :dni, :nombre, :apellido1, :apellido2, :telefono, :fecha_nacimiento)";
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':sip', $datos['sip'], PDO::PARAM_STR);
        $stmt->bindParam(':dni', $datos['dni'], PDO::PARAM_STR);
        $stmt->bindParam(':nombre', $datos['nombre'], PDO::PARAM_STR);
        $stmt->bindParam(':apellido1', $datos['apellido'], PDO::PARAM_STR);
        $stmt->bindParam(':apellido2', $datos['apellido2'], PDO::PARAM_STR);
        $stmt->bindParam(':telefono', $datos['telefono'], PDO::PARAM_STR);
        $stmt->bindParam(':fecha_nacimiento', $datos['fecha_nacimiento'], PDO::PARAM_STR);
        $stmt->execute();
        return ['success' => true];
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
        exit();
    }
}



function actualizarPaciente($sip, $datos) {
    global $pdo;
    try {
        $sql = "UPDATE pacientes SET dni = :dni, nombre = :nombre, apellido1 = :apellido1, apellido2 = :apellido2, telefono = :telefono, fecha_nacimiento = :fecha_nacimiento WHERE sip = :sip";
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':dni', $datos['dni'], PDO::PARAM_STR);
        $stmt->bindParam(':nombre', $datos['nombre'], PDO::PARAM_STR);
        $stmt->bindParam(':apellido1', $datos['apellido'], PDO::PARAM_STR);
        $stmt->bindParam(':apellido2', $datos['apellido2'], PDO::PARAM_STR);
        $stmt->bindParam(':telefono', $datos['telefono'], PDO::PARAM_STR);
        $stmt->bindParam(':fecha_nacimiento', $datos['fecha_nacimiento'], PDO::PARAM_STR);
        $stmt->bindParam(':sip', $sip, PDO::PARAM_STR);
        $stmt->execute();
        return ['success' => true];
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
        exit();
    }
}

function eliminarPaciente($sip) {
    global $pdo;
    try {
        $sql = "DELETE FROM pacientes WHERE sip = :sip";
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':sip', $sip, PDO::PARAM_STR);
        $stmt->execute();
        return ['success' => true];
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
        exit();
    }
}

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    if (isset($_GET['filtro'])) {
        $filtro = $_GET['filtro'];
        echo json_encode(buscarPacientesPorFiltro($filtro));
    } elseif (isset($_GET['sip'])) {
        $sip = $_GET['sip'];
        $stmt = $pdo->prepare("SELECT sip, dni, nombre, apellido1, apellido2, telefono, fecha_nacimiento FROM pacientes WHERE sip = :sip");
        $stmt->bindParam(':sip', $sip, PDO::PARAM_STR);
        $stmt->execute();
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    } elseif (isset($_GET['limit'], $_GET['page'])) {
        $page = (int)$_GET['page'];
        $limit = (int)$_GET['limit'];
        $pacientes = listarPacientesPaginados($page, $limit);
        $total = obtenerTotalPacientes();
        echo json_encode(['pacientes' => $pacientes, 'total' => $total]);
    } else {
        echo json_encode(listarPacientes());
    }
} elseif ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    echo json_encode(insertarPaciente($input));
} elseif ($_SERVER['REQUEST_METHOD'] == 'PUT') {
    $input = json_decode(file_get_contents('php://input'), true);
    $sip = $input['sip'];
    unset($input['sip']);
    echo json_encode(actualizarPaciente($sip, $input));
} elseif ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $sip = $_GET['sip'];
    echo json_encode(eliminarPaciente($sip));
}

?>
