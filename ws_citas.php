<?php

include 'conexion.php';

$pdo = new Conexion();

header('Content-Type: application/json');

function listarCitasPaginadas($page = 1, $limit = 10) {
    global $pdo;

    $offset = ($page - 1) * $limit;

    $sql = "SELECT c.id, p.nombre as paciente, c.fecha, m.nombre as medico, c.medico_id, c.paciente_id
            FROM citas c 
            JOIN pacientes p ON c.paciente_id = p.id 
            JOIN medicos m ON c.medico_id = m.id
            ORDER BY c.id ASC
            LIMIT :limit OFFSET :offset";
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':limit', $limit, PDO::PARAM_INT);
    $stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
    $stmt->execute();

    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function obtenerTotalCitas() {
    global $pdo;

    $sql = "SELECT COUNT(*) as total FROM citas";
    $stmt = $pdo->prepare($sql);
    $stmt->execute();

    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    return $result['total'];
}

function listarMedicos() {
    global $pdo;

    $sql = "SELECT id, nombre, apellido1 FROM medicos";
    $stmt = $pdo->prepare($sql);
    $stmt->execute();

    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function listarPacientes() {
    global $pdo;

    $sql = "SELECT id, nombre, apellido1 FROM pacientes";
    $stmt = $pdo->prepare($sql);
    $stmt->execute();

    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function listarEnfermeros() {
    global $pdo;

    $sql = "SELECT id, nombre, apellido1 FROM enfermeros";
    $stmt = $pdo->prepare($sql);
    $stmt->execute();

    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function listarCitas($id = null) {
    global $pdo;

    $sql = "SELECT c.id, p.nombre as paciente, c.fecha, m.nombre as medico, c.medico_id, c.paciente_id, c.enfermero_id
            FROM citas c 
            JOIN pacientes p ON c.paciente_id = p.id 
            JOIN medicos m ON c.medico_id = m.id
            JOIN enfermeros e ON c.enfermero_id = e.id";
    $params = [];

    if ($id) {
        $sql .= " WHERE c.id = :id";
        $params[':id'] = $id;
    }

    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);

    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function insertarCita($medico_id, $paciente_id, $enfermero_id, $fecha) {
    global $pdo;

    $sql = "INSERT INTO citas (medico_id, paciente_id, enfermero_id, fecha, created_at) VALUES (:medico_id, :paciente_id, :enfermero_id, :fecha, NOW())";
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':medico_id', $medico_id, PDO::PARAM_INT);
    $stmt->bindParam(':paciente_id', $paciente_id, PDO::PARAM_INT);
    $stmt->bindParam(':enfermero_id', $enfermero_id, PDO::PARAM_INT);
    $stmt->bindParam(':fecha', $fecha, PDO::PARAM_STR);

    return $stmt->execute();
}

function actualizarCita($id, $medico_id, $paciente_id, $enfermero_id, $fecha) {
    global $pdo;

    $sql = "UPDATE citas SET medico_id = :medico_id, paciente_id = :paciente_id, enfermero_id = :enfermero_id, fecha = :fecha, updated_at = NOW() WHERE id = :id";
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':medico_id', $medico_id, PDO::PARAM_INT);
    $stmt->bindParam(':paciente_id', $paciente_id, PDO::PARAM_INT);
    $stmt->bindParam(':enfermero_id', $enfermero_id, PDO::PARAM_INT);
    $stmt->bindParam(':fecha', $fecha, PDO::PARAM_STR);
    $stmt->bindParam(':id', $id, PDO::PARAM_INT); // Aquí agregué la línea para enlazar el parámetro :id

    return $stmt->execute();
}


function eliminarCita($id) {
    global $pdo;

    $sql = "DELETE FROM citas WHERE id = :id";
    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':id', $id, PDO::PARAM_INT);

    return $stmt->execute();
}


function buscarCitas($filtro) {
    global $pdo;

    $sql = "SELECT c.id, p.nombre AS paciente, c.fecha, m.nombre AS medico, c.medico_id, c.paciente_id
            FROM citas c 
            JOIN pacientes p ON c.paciente_id = p.id 
            JOIN medicos m ON c.medico_id = m.id
            WHERE p.nombre LIKE :filtro
            OR m.nombre LIKE :filtro
            OR DATE(c.fecha) = DATE(:filtro)";
    $stmt = $pdo->prepare($sql);
    $filtro = "%{$filtro}%"; // Agrega comodines para buscar coincidencias parciales
    $stmt->bindParam(':filtro', $filtro, PDO::PARAM_STR);
    $stmt->execute();

    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}




if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['total'])) {
        echo json_encode(['total' => obtenerTotalCitas()]);
    } else if (isset($_GET['limit'], $_GET['page'])) {
        $page = (int)$_GET['page'];
        $limit = (int)$_GET['limit'];
        $citas = listarCitasPaginadas($page, $limit);
        $total = obtenerTotalCitas();
        echo json_encode(['citas' => $citas, 'total' => $total]);
    } else if (isset($_GET['id'])) {
        echo json_encode(listarCitas((int)$_GET['id']));
    } else if (isset($_GET['medicos'])) { // Agregado para obtener la lista de médicos
        echo json_encode(listarMedicos());
    } else if (isset($_GET['pacientes'])) { // Agregado para obtener la lista de pacientes
        echo json_encode(listarPacientes());
    }else if (isset($_GET['enfermeros'])) { // Agregado para obtener la lista de enfermeros
        echo json_encode(listarEnfermeros());
    } else if (isset($_GET['search'])) { // Agregado para buscar citas
        $searchTerm = $_GET['search'];
        $result = buscarCitas($searchTerm);
        echo json_encode($result);
    } 

} else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Insertar nueva cita
    $data = json_decode(file_get_contents("php://input"), true);
    $medico_id = $data['medico_id'];
    $paciente_id = $data['paciente_id'];
    $enfermero_id = $data['enfermero_id'];
    $fecha = $data['fecha'];
    
    // Realiza la inserción en la base de datos
    if (insertarCita($medico_id, $paciente_id, $enfermero_id, $fecha)) {
        echo json_encode(array("message" => "Cita insertada con éxito"));
    } else {
        echo json_encode(array("message" => "Error al insertar la cita"));
    }

} else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    // Editar cita existente
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $_GET['id']; // Suponiendo que la identificación de la cita se pasa en la URL
    $medico_id = $data['medico_id'];
    $paciente_id = $data['paciente_id'];
    $enfermero_id = $data['enfermero_id'];
    $fecha = $data['fecha'];
    
    // Realiza la actualización en la base de datos
    if (actualizarCita($id, $medico_id, $paciente_id, $enfermero_id, $fecha)) {
        echo json_encode(array("message" => "Cita actualizada con éxito"));
    } else {
        echo json_encode(array("message" => "Error al actualizar la cita"));
    }

} else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    // Eliminar cita
    $id = $_GET['id']; // Suponiendo que la identificación de la cita se pasa en la URL
    
    // Realiza la eliminación en la base de datos
    if (eliminarCita($id)) {
        echo json_encode(array("message" => "Cita eliminada con éxito"));
    } else {
        echo json_encode(array("message" => "Error al eliminar la cita"));
    }
}


?>    

