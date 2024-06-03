<?php
include 'conexion.php';

$pdo = new Conexion();

header('Content-Type: application/json');

function listarMedicos($limit, $offset) {
    global $pdo;
    $sql = "SELECT id, numero_colegiado, dni, nombre, apellido1, apellido2, telefono, especialidad_id, horario_id, user_id FROM medicos LIMIT :limit OFFSET :offset";
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


function buscarMedicosPorFiltro($filtro) {
    global $pdo;
    $stmt = $pdo->prepare("SELECT id, numero_colegiado, dni, nombre, apellido1, apellido2, telefono, especialidad_id, horario_id, user_id FROM medicos WHERE nombre LIKE :filtro OR dni LIKE :filtro");
    $likeFiltro = "%$filtro%";
    $stmt->bindParam(':filtro', $likeFiltro, PDO::PARAM_STR);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function obtenerEspecialidades() {
    global $pdo;
    $sql = "SELECT id, nombre FROM especialidades";
    $stmt = $pdo->prepare($sql);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function obtenerHorarios() {
    global $pdo;
    $sql = "SELECT id, hora_inicio, hora_fin FROM horarios";
    $stmt = $pdo->prepare($sql);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function obtenerUsuarios() {
    global $pdo;
    $sql = "SELECT id, name FROM users";
    $stmt = $pdo->prepare($sql);
    $stmt->execute();
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
            $sql = "INSERT INTO medicos (numero_colegiado, dni, nombre, apellido1, apellido2, telefono, especialidad_id, horario_id, user_id) VALUES (:numero_colegiado, :dni, :nombre, :apellido1, :apellido2, :telefono, :especialidad_id, :horario_id, :user_id)";
            $stmt = $pdo->prepare($sql);
            $stmt->bindParam(':numero_colegiado', $datos['numero_colegiado'], PDO::PARAM_STR);
            $stmt->bindParam(':dni', $datos['dni'], PDO::PARAM_STR);
            $stmt->bindParam(':nombre', $datos['nombre'], PDO::PARAM_STR);
            $stmt->bindParam(':apellido1', $datos['apellido1'], PDO::PARAM_STR);
            $stmt->bindParam(':apellido2', $datos['apellido2'], PDO::PARAM_STR);
            $stmt->bindParam(':telefono', $datos['telefono'], PDO::PARAM_STR);
            $stmt->bindParam(':especialidad_id', $datos['especialidad_id'], PDO::PARAM_INT);
            $stmt->bindParam(':horario_id', $datos['horario_id'], PDO::PARAM_INT);
            $stmt->bindParam(':user_id', $datos['usuario_id'], PDO::PARAM_INT);
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
    $sql = "UPDATE medicos SET dni = :dni, nombre = :nombre, apellido1 = :apellido1, apellido2 = :apellido2, telefono = :telefono, especialidad_id = :especialidad_id, horario_id = :horario_id, user_id = :user_id WHERE numero_colegiado = :numero_colegiado";
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':dni', $datos['dni'], PDO::PARAM_STR);
    $stmt->bindParam(':nombre', $datos['nombre'], PDO::PARAM_STR);
    $stmt->bindParam(':apellido1', $datos['apellido1'], PDO::PARAM_STR);
    $stmt->bindParam(':apellido2', $datos['apellido2'], PDO::PARAM_STR);
    $stmt->bindParam(':telefono', $datos['telefono'], PDO::PARAM_STR);
    $stmt->bindParam(':especialidad_id', $datos['especialidad_id'], PDO::PARAM_INT);
    $stmt->bindParam(':horario_id', $datos['horario_id'], PDO::PARAM_INT);
    $stmt->bindParam(':user_id', $datos['usuario_id'], PDO::PARAM_INT);
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
    $limit = isset($_GET['limit']) ? intval($_GET['limit']) : 2;
    $page = isset($_GET['page']) ? intval($_GET['page']) : 1;
    $offset = ($page - 1) * $limit;

    if (isset($_GET['filtro'])) {
        $filtro = $_GET['filtro'];
        echo json_encode(buscarMedicosPorFiltro($filtro));
    } elseif (isset($_GET['numero_colegiado'])) {
        $numero_colegiado = $_GET['numero_colegiado'];
        $stmt = $pdo->prepare("SELECT id, numero_colegiado, dni, nombre, apellido1, apellido2, telefono, especialidad_id, horario_id, user_id FROM medicos WHERE numero_colegiado = :numero_colegiado");
        $stmt->bindParam(':numero_colegiado', $numero_colegiado, PDO::PARAM_STR);
        $stmt->execute();
        echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    } elseif (isset($_GET['especialidades'])) {
        echo json_encode(obtenerEspecialidades());
    } elseif (isset($_GET['horarios'])) {
        echo json_encode(obtenerHorarios());
    } elseif (isset($_GET['usuarios'])) {
        echo json_encode(obtenerUsuarios());
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
