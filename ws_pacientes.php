<?php
include 'conexion.php';

$pdo = new Conexion();

header('Content-Type: application/json');

function listarPacientes() {
    global $pdo;
    try {
        $sql = "SELECT sip, dni, nombre, apellido1, telefono, fecha_nacimiento FROM pacientes";
        $stmt = $pdo->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
        exit();
    }
}

function listarPacientesPaginados($page = 1, $limit = 5) {
    global $pdo;

    $offset = ($page - 1) * $limit;

    $sql = "SELECT sip, dni, nombre, apellido1, telefono, fecha_nacimiento FROM pacientes LIMIT :offset, :limit";
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

function buscarPacientesPorFiltro($filtros) {
    global $pdo;
    
    // Base de la consulta
    $sql = "SELECT sip, dni, nombre, apellido1, telefono, fecha_nacimiento FROM pacientes WHERE 1=1";
    
    // Array para los parámetros de la consulta
    $params = [];
    
    // Añadir condiciones dinámicamente basadas en los filtros proporcionados
    if (!empty($filtros['sip'])) {
        $sql .= " AND sip LIKE :sip";
        $params[':sip'] = "%" . $filtros['sip'] . "%";
    }

    if (!empty($filtros['dni'])) {
        $sql .= " AND dni LIKE :dni";
        $params[':dni'] = "%" . $filtros['dni'] . "%";
    }
    
    if (!empty($filtros['nombre'])) {
        $sql .= " AND nombre LIKE :nombre";
        $params[':nombre'] = "%" . $filtros['nombre'] . "%";
    }
    
    if (!empty($filtros['apellido'])) {
        $sql .= " AND apellido1 LIKE :apellido";
        $params[':apellido'] = "%" . $filtros['apellido'] . "%";
    }

    if (!empty($filtros['telefono'])) {
        $sql .= " AND telefono LIKE :telefono";
        $params[':telefono'] = "%" . $filtros['telefono'] . "%";
    }

    if (!empty($filtros['fecha_nacimiento'])) {
        // Si la fecha viene en formato de string, podrías necesitar convertirla al formato correcto que espera la base de datos
        // Aquí asumiré que la fecha ya está en el formato correcto
        $sql .= " AND fecha_nacimiento = :fecha_nacimiento";
        $params[':fecha_nacimiento'] = $filtros['fecha_nacimiento'];
    }

    try {
        // Preparar la consulta
        $stmt = $pdo->prepare($sql);
        
        // Vincular los parámetros
        foreach ($params as $key => &$value) {
            $stmt->bindParam($key, $value, PDO::PARAM_STR);
        }
        
        // Ejecutar la consulta
        $stmt->execute();
        
        // Retornar los resultados
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
        exit();
    }
}



function buscarMedicosPorFiltro($filtros) {
    global $pdo;
    
    // Base de la consulta que siempre incluirá el número de colegiado
    $sql = "SELECT id, numero_colegiado, dni, nombre, apellido1 FROM medicos WHERE 1=1";
    
    // Array para los parámetros de la consulta
    $params = [];
    
    // Añadir condiciones dinámicamente basadas en los filtros proporcionados
    if (!empty($filtros['sip'])) {
        $sql .= " AND sip LIKE :sip";
        $params[':sip'] = "%" . $filtros['sip'] . "%";
    }

    if (!empty($filtros['dni'])) {
        $sql .= " AND dni LIKE :dni";
        $params[':dni'] = "%" . $filtros['dni'] . "%";
    }
    
    if (!empty($filtros['nombre'])) {
        $sql .= " AND nombre LIKE :nombre";
        $params[':nombre'] = "%" . $filtros['nombre'] . "%";
    }
    
    if (!empty($filtros['apellido1'])) {
        $sql .= " AND apellido1 LIKE :apellido1";
        $params[':apellido1'] = "%" . $filtros['apellido1'] . "%";
    }

    if (!empty($filtros['telefono'])) {
        $sql .= " AND telefono LIKE :telefono";
        $params[':telefono'] = "%" . $filtros['telefono'] . "%";
    }

    // Preparar la consulta
    $stmt = $pdo->prepare($sql);
    
    // Vincular los parámetros
    foreach ($params as $key => &$value) {
        $stmt->bindParam($key, $value, PDO::PARAM_STR);
    }
    
    // Ejecutar la consulta
    $stmt->execute();
    
    // Retornar los resultados
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
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

        $sql = "INSERT INTO pacientes (sip, dni, nombre, apellido1, telefono, fecha_nacimiento) VALUES (:sip, :dni, :nombre, :apellido1, :telefono, :fecha_nacimiento)";
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':sip', $datos['sip'], PDO::PARAM_STR);
        $stmt->bindParam(':dni', $datos['dni'], PDO::PARAM_STR);
        $stmt->bindParam(':nombre', $datos['nombre'], PDO::PARAM_STR);
        $stmt->bindParam(':apellido1', $datos['apellido'], PDO::PARAM_STR);
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
        $sql = "UPDATE pacientes SET dni = :dni, nombre = :nombre, apellido1 = :apellido1, telefono = :telefono, fecha_nacimiento = :fecha_nacimiento WHERE sip = :sip";
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':dni', $datos['dni'], PDO::PARAM_STR);
        $stmt->bindParam(':nombre', $datos['nombre'], PDO::PARAM_STR);
        $stmt->bindParam(':apellido1', $datos['apellido'], PDO::PARAM_STR);
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
        $stmt = $pdo->prepare("SELECT sip, dni, nombre, apellido1, telefono, fecha_nacimiento FROM pacientes WHERE sip = :sip");
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
