<?php
include 'conexion.php';

$pdo = new Conexion();

header('Content-Type: application/json');

function listarMedicos($limit, $offset) {
    global $pdo;
    $sql = "SELECT id, numero_colegiado, dni, nombre, apellido1,  telefono FROM medicos LIMIT :limit OFFSET :offset";
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':limit', $limit, PDO::PARAM_INT);
    $stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function contarMedicos() {
    global $pdo;
    $sql = "SELECT COUNT(*) AS total FROM medicos";
    $stmt = $pdo->prepare($sql);
    $stmt->execute();
    return $stmt->fetch(PDO::FETCH_ASSOC)['total'];
}


function buscarMedicosPorFiltro($filtros) {
    global $pdo;
    
    // Base de la consulta que siempre incluirá el número de colegiado
    $sql = "SELECT id, numero_colegiado, dni, nombre, apellido1 FROM medicos WHERE 1=1";
    
    // Array para los parámetros de la consulta
    $params = [];
    
    // Añadir condiciones dinámicamente basadas en los filtros proporcionados
    if (!empty($filtros['numero_colegiado'])) {
        $sql .= " AND numero_colegiado LIKE :numero_colegiado";
        $params[':numero_colegiado'] = "%" . $filtros['numero_colegiado'] . "%";
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


    function insertarMedico($datos) {
        global $pdo;
        try {
          
            $sql = "SELECT COUNT(*) FROM medicos WHERE numero_colegiado = :numero_colegiado OR dni = :dni";
            $stmt = $pdo->prepare($sql);
            $stmt->bindParam(':numero_colegiado', $datos['numero_colegiado'], PDO::PARAM_STR);
            $stmt->bindParam(':dni', $datos['dni'], PDO::PARAM_STR);
            $stmt->execute();
            $count = $stmt->fetchColumn();
    
            if ($count > 0) {
                http_response_code(400);
                echo json_encode(['error' => 'El numero del colegiado o dni ya existe.']);
                exit();
            }
            $sql = "INSERT INTO medicos (numero_colegiado, dni, nombre, apellido1, telefono) VALUES (:numero_colegiado, :dni, :nombre, :apellido1, :telefono)";
            $stmt = $pdo->prepare($sql);
            $stmt->bindParam(':numero_colegiado', $datos['numero_colegiado'], PDO::PARAM_STR);
            $stmt->bindParam(':dni', $datos['dni'], PDO::PARAM_STR);
            $stmt->bindParam(':nombre', $datos['nombre'], PDO::PARAM_STR);
            $stmt->bindParam(':apellido1', $datos['apellido1'], PDO::PARAM_STR); 
            $stmt->bindParam(':telefono', $datos['telefono'], PDO::PARAM_STR);
          
            return $stmt->execute();

            return ['success' => true];
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
            exit();
        }
    }


function actualizarMedico($numero_colegiado, $datos) {
    global $pdo;
    $sql = "UPDATE medicos SET dni = :dni, nombre = :nombre, apellido1 = :apellido1, telefono = :telefono WHERE numero_colegiado = :numero_colegiado";
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':dni', $datos['dni'], PDO::PARAM_STR);
    $stmt->bindParam(':nombre', $datos['nombre'], PDO::PARAM_STR);
    $stmt->bindParam(':apellido1', $datos['apellido1'], PDO::PARAM_STR);
    $stmt->bindParam(':telefono', $datos['telefono'], PDO::PARAM_STR);
    $stmt->bindParam(':numero_colegiado', $numero_colegiado, PDO::PARAM_STR);
    return $stmt->execute();
}


function eliminarMedico($numero_colegiado) {
    global $pdo;
    $sql = "DELETE FROM medicos WHERE numero_colegiado = :numero_colegiado";
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':numero_colegiado', $numero_colegiado, PDO::PARAM_STR);
    return $stmt->execute();
}

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $limit = isset($_GET['limit']) ? intval($_GET['limit']) : 5;
    $page = isset($_GET['page']) ? intval($_GET['page']) : 1;
    $offset = ($page - 1) * $limit;

    if (isset($_GET['filtro'])) {
        $filtro = $_GET['filtro'];
        echo json_encode(buscarMedicosPorFiltro($filtro));
    } elseif (isset($_GET['numero_colegiado'])) {
        $numero_colegiado = $_GET['numero_colegiado'];
        $stmt = $pdo->prepare("SELECT id, numero_colegiado, dni, nombre, apellido1, telefono FROM medicos WHERE numero_colegiado = :numero_colegiado");
        $stmt->bindParam(':numero_colegiado', $numero_colegiado, PDO::PARAM_STR);
        $stmt->execute();
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    } else {
        $medicos = listarMedicos($limit, $offset);
        $total = contarMedicos();
        echo json_encode(['medicos' => $medicos, 'total' => $total, 'limit' => $limit, 'page' => $page]);
    }
} elseif ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    echo json_encode(insertarMedico($input));

} elseif ($_SERVER['REQUEST_METHOD'] == 'PUT') {
    $input = json_decode(file_get_contents('php://input'), true);
    $numero_colegiado = $input['numero_colegiado'];
    unset($input['numero_colegiado']);
    echo json_encode(actualizarMedico($numero_colegiado, $input));
} elseif ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $numero_colegiado = $_GET['numero_colegiado'];
    echo json_encode(eliminarMedico($numero_colegiado));
}

?>
