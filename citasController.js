let currentPage = 1;
const recordsPerPage = 5;

document.addEventListener('DOMContentLoaded', function () {
    cargarCitas(currentPage);
    cargarMedicos();
    cargarPacientes();


    document.getElementById('insertar').addEventListener('click', insertarCitaHandler);
    document.getElementById('actualizar').addEventListener('click', actualizarCitaHandler);
    document.getElementById('buscar').addEventListener('click', buscarCitasHandler);
    document.getElementById('limpiar').addEventListener('click', function (event) {
        event.preventDefault();
        limpiarFormulario();
    });

    document.querySelector('[data-action="primera"]').addEventListener('click', () => cambiarPagina(1));
    document.querySelector('[data-action="anterior"]').addEventListener('click', () => cambiarPagina(currentPage - 1));
    document.querySelector('[data-action="siguiente"]').addEventListener('click', () => cambiarPagina(currentPage + 1));
    document.querySelector('[data-action="ultima"]').addEventListener('click', async () => {
        const totalRecords = await obtenerTotalRegistros();
        const totalPages = Math.ceil(totalRecords / recordsPerPage);
        cambiarPagina(totalPages);
    });
});

async function sendRequest(url, options) {
    const response = await fetch(url, options);
    const responseText = await response.text();
    console.log('Respuesta del servidor:', responseText);
    try {
        return JSON.parse(responseText);
    } catch (error) {
        console.error('Error al parsear la respuesta del servidor como JSON:', error);
        throw new Error('La respuesta del servidor no es un JSON válido');
    }
}

async function cargarCitas(page) {
    if (page < 1) {
        console.error('El número de página no puede ser menor que 1');
        return;
    }
    try {
        const data = await sendRequest(`ws_citas.php?limit=${recordsPerPage}&page=${page}`);
        console.log('Datos recibidos:', data);
        if (data.citas && Array.isArray(data.citas)) {
            currentPage = page;
            actualizarListaCitas(data.citas);
            actualizarPaginacion(data.total);
        } else {
            throw new Error('La respuesta no contiene citas');
        }
    } catch (error) {
        console.error('Error al cargar las citas:', error);
    }
}

async function obtenerTotalRegistros() {
    try {
        const data = await sendRequest('ws_citas.php?total=true');
        return data.total;
    } catch (error) {
        console.error('Error al obtener el total de registros:', error);
    }
}

function actualizarListaCitas(citas) {
    const tbody = document.getElementById('citasTableBody');
    tbody.innerHTML = '';
    citas.forEach(cita => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
        <td>${cita.id}</td>
        <td>${cita.paciente}</td>
        <td>${cita.fecha}</td>
        <td>${cita.medico}</td>
        <td>
            <button class="btn btn-sm btn-primary" onclick="editarCita(${cita.id})">
                <i class="bi bi-pencil-square"></i> Editar
            </button>
            <button class="btn btn-sm btn-danger" onclick="eliminarCita(${cita.id}, event)">
                <i class="bi bi-trash"></i> Eliminar
            </button>
        </td>
        `;
        tbody.appendChild(tr);
    });
}

function actualizarPaginacion(totalRecords) {
    const totalPages = Math.ceil(totalRecords / recordsPerPage);
    document.querySelector('[data-action="anterior"]').parentElement.classList.toggle('disabled', currentPage === 1);
    document.querySelector('[data-action="siguiente"]').parentElement.classList.toggle('disabled', currentPage === totalPages);

    const pageInfo = document.getElementById('page-info');
    pageInfo.textContent = `Página ${currentPage} de ${totalPages}`;
}

function cambiarPagina(page) {
    if (page < 1) page = 1;
    cargarCitas(page);
}

function cargarMedicos() {
    fetch('ws_citas.php?medicos=true')
        .then(response => response.json())
        .then(data => {
            const select = document.getElementById('medico_id');
            select.innerHTML = ''; // Limpiar opciones anteriores
            data.forEach(medico => {
                const option = document.createElement('option');
                option.value = medico.id;
                option.textContent = medico.nombre + " " + medico.apellido1;
                select.appendChild(option);
            });
        })
        .catch(error => {
            console.error('Error al cargar los médicos:', error);
        });
}

function cargarPacientes() {
    fetch('ws_citas.php?pacientes=true')
        .then(response => response.json())
        .then(data => {
            const select = document.getElementById('paciente_id');
            select.innerHTML = ''; // Limpiar opciones anteriores
            data.forEach(paciente => {
                const option = document.createElement('option');
                option.value = paciente.id;
                option.textContent = paciente.nombre + " " + paciente.apellido1;
                select.appendChild(option);
            });
        })
        .catch(error => {
            console.error('Error al cargar los pacientes:', error);
        });
}


function listarCitas() {
    fetch('ws_citas.php')
        .then(response => response.json())
        .then(data => {
            const tbody = document.getElementById('citasTableBody');
            tbody.innerHTML = ''; // Limpiar la tabla
            data.forEach(cita => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${cita.id}</td>
                    <td>${cita.paciente}</td>
                    <td>${cita.fecha}</td>
                    <td>${cita.medico}</td>
                    <td>
                        <button class="btn btn-sm btn-primary" onclick="editarCita(${cita.id})">
                            <i class="bi bi-pencil-square"></i> Editar
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="eliminarCita(${cita.id}, event)">
                            <i class="bi bi-trash"></i> Eliminar
                        </button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(error => {
            console.error('Error al listar las citas:', error);
        });
}


function editarCita(id) {
    fetch(`ws_citas.php?id=${id}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok ' + response.statusText);
            }
            return response.json();
        })
        .then(data => {
            if (data.error) {
                throw new Error(data.error);
            }
            const cita = data[0];
            document.getElementById('id').value = cita.id;
            document.getElementById('paciente_id').value = cita.paciente_id;
            document.getElementById('fecha').value = cita.fecha.replace(' ', 'T');
            document.getElementById('medico_id').value = cita.medico_id;
        })
        .catch(error => {
            console.error('Error al obtener la cita:', error);
            alert('Error al obtener la cita: ' + error.message);
        });
}

function insertarCitaHandler(event) {
    event.preventDefault();
    const medicoId = document.getElementById('medico_id').value;
    const pacienteId = document.getElementById('paciente_id').value;
    const fecha = document.getElementById('fecha').value;
    const fecha_nacimiento = fecha.replace('T', ' ') + ':00';
    if (!medicoId || !pacienteId || !fecha) {
        alert('Por favor, complete todos los campos');
        return;
    }

    fetch('ws_citas.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ medico_id: medicoId, paciente_id: pacienteId, fecha: fecha_nacimiento }),
    })
        .then(response => response.json())
        .then(data => {
            console.log(data);
            limpiarFormulario();
            alert('Cita insertada con éxito');
            cargarCitas(1);
        })
        .catch(error => {
            console.error('Error en la solicitud:', error);
            alert('Error al insertar la cita. Por favor, inténtelo de nuevo.');
        });
}

function actualizarCitaHandler(event) {
    event.preventDefault();
    const id = document.getElementById('id').value;
    const medicoId = document.getElementById('medico_id').value;
    const pacienteId = document.getElementById('paciente_id').value;
    const fecha = document.getElementById('fecha').value;

    if (!id || !medicoId || !pacienteId || !fecha) {
        alert('Por favor, complete todos los campos');
        return;
    }

    fetch(`ws_citas.php?id=${id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ id, medico_id: medicoId, paciente_id: pacienteId, fecha: fecha }),
    })
        .then(response => {
            if (!response.ok) {
                throw new Error('Error en la respuesta del servidor');
            }
            return response.json();
        })
        .then(data => {
            console.log('Cita actualizada:', data);
            limpiarFormulario();
            alert('Cita actualizada con éxito');
            cargarCitas(1);
        })
        .catch(error => {
            console.error('Error en la solicitud:', error);
            alert('Error al actualizar la cita. Por favor, inténtelo de nuevo.');
        });
}



function eliminarCita(id, event) {
    event.preventDefault();

    fetch(`ws_citas.php?id=${id}`, {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json',
        },
    })
        .then(response => response.json())
        .then(data => {
            console.log('Cita eliminada:', data);
            alert('Cita eliminada con éxito');
            cargarCitas(currentPage);
        })
        .catch(error => {
            console.error('Error en la solicitud:', error);
            alert('Error al eliminar la cita. Por favor, inténtelo de nuevo.');
        });
}


function limpiarFormulario() {
    document.getElementById('medico_id').value = '';
    document.getElementById('paciente_id').value = '';
    document.getElementById('fecha').value = '';
}


function buscarCitasHandler(event) {
    event.preventDefault();

    const fechaInput = document.getElementById('fecha');
    if (!fechaInput) {
        console.error('El elemento con ID "fecha" no se encontró en el DOM.');
        return;
    }

    const fecha = document.getElementById('fecha').value;
    const fecha_nacimiento = fecha.replace('T', ' ') + ':00';

    if (!fecha) {
        alert('Por favor, seleccione una fecha.');
        return;
    }

    buscarCitasPorFecha(fecha_nacimiento);
}

function buscarCitasPorFecha(fecha) {
    fetch(`ws_citas.php?fecha=${fecha}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Error al buscar las citas: ' + response.statusText);
            }
            return response.json();
        })
        .then(data => {
            const tbody = document.getElementById('citasTableBody');
            tbody.innerHTML = '';

            if (data.length === 0) {
                alert('No se encontraron citas para la fecha seleccionada.');
                return;
            }

            data.forEach(cita => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${cita.id}</td>
                    <td>${cita.paciente}</td>
                    <td>${cita.fecha}</td>
                    <td>${cita.medico}</td>
                    <td>
                        <button class="btn btn-sm btn-primary" onclick="editarCita(${cita.id})">
                            <i class="bi bi-pencil-square"></i> Editar
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="eliminarCita(${cita.id}, event)">
                            <i class="bi bi-trash"></i> Eliminar
                        </button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(error => {
            console.error('Error al buscar las citas:', error);
            alert('Error al buscar las citas. Por favor, inténtelo de nuevo.');
        });
}




