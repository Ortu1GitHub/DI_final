let currentPage = 1;
const recordsPerPage = 5; // Puedes ajustar este valor según tus necesidades

document.addEventListener('DOMContentLoaded', function() {
    cargarPacientes(currentPage);

    document.getElementById('insertar').addEventListener('click', insertarPacienteHandler);
    document.getElementById('actualizar').addEventListener('click', actualizarPacienteHandler);
    document.getElementById('buscar').addEventListener('click', buscarPacientesHandler);
    document.getElementById('limpiar').addEventListener('click', function(event) {
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

async function cargarPacientes(page) {
    if (page < 1) {
        console.error('El número de página no puede ser menor que 1');
        return;
    }
    try {
        const data = await sendRequest(`ws_pacientes.php?limit=${recordsPerPage}&page=${page}`);
        console.log('Datos recibidos:', data);
        if (data.pacientes && Array.isArray(data.pacientes)) {
            currentPage = page;
            actualizarListaPacientes(data.pacientes);
            actualizarPaginacion(data.total);
        } else {
            throw new Error('La respuesta no contiene pacientes');
        }
    } catch (error) {
        console.error('Error al cargar los pacientes:', error);
    }
}

async function obtenerTotalRegistros() {
    try {
        const data = await sendRequest('ws_pacientes.php?total=true');
        return data.total;
       
    } catch (error) {
        console.log(data.total);
        console.error('Error al obtener el total de registros:', error);
    }
}

function actualizarPaginacion(totalRecords) {
    const totalPages = Math.ceil(totalRecords / recordsPerPage);
    document.querySelector('[data-action="anterior"]').parentElement.classList.toggle('disabled', currentPage === 1);
    document.querySelector('[data-action="siguiente"]').parentElement.classList.toggle('disabled', currentPage === totalPages);

    const pageInfo = document.getElementById('page-info');
    pageInfo.textContent = `Página ${currentPage} de ${totalPages}`;
    console.log(currentPage);
    console.log(totalPages);
}


function cambiarPagina(page) {
    if (page < 1) page = 1;
    cargarPacientes(page);
    console.log(cargarPacientes(page));
}


function actualizarListaPacientes(pacientes) {
    if (!Array.isArray(pacientes)) {
        console.error('Error: La respuesta no es un array');
        return;
    }
    const tbody = document.getElementById('pacienteTableBody');
    tbody.innerHTML = '';
    pacientes.forEach(paciente => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${paciente.sip}</td>
            <td>${paciente.dni}</td>
            <td>${paciente.nombre}</td>
            <td>${paciente.apellido1}</td>
            
            <td>
                <button class="btn btn-sm btn-primary" onclick="editarPaciente('${paciente.sip}')">
                    <i class="bi bi-pencil-square"></i> Editar
                </button>
                <button class="btn btn-sm btn-danger" onclick="eliminarPaciente('${paciente.sip}')">
                    <i class="bi bi-trash"></i> Eliminar
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}





function buscarPacientesHandler(event) {
    event.preventDefault();

    // Obtener los valores de los campos de entrada, si existen
    const sip = document.getElementById('sip') ? document.getElementById('sip').value.trim() : '';
    const dni = document.getElementById('dni') ? document.getElementById('dni').value.trim() : '';
    const nombre = document.getElementById('nombre') ? document.getElementById('nombre').value.trim() : '';
    const apellido1 = document.getElementById('apellido') ? document.getElementById('apellido').value.trim() : '';
    const telefono = document.getElementById('telefono') ? document.getElementById('telefono').value.trim() : '';

    const params = new URLSearchParams();

    if (sip) params.append('sip', sip);
    if (dni) params.append('dni', dni);
    if (nombre) params.append('nombre', nombre);
    if (apellido1) params.append('apellido1', apellido1);
    if (telefono) params.append('telefono', telefono);

    if (!params.toString()) {
        alert('Por favor, ingrese al menos un criterio de búsqueda.');
        return;
    }

    fetch(`ws_pacientes.php?${params.toString()}`)
        .then(response => response.json())
        .then(data => {
            const tbody = document.getElementById('pacienteTableBody');
            tbody.innerHTML = '';
            data.forEach(paciente => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${paciente.sip}</td>
                    <td>${paciente.dni}</td>
                    <td>${paciente.nombre}</td>
                    <td>${paciente.apellido1}</td>
                    <td>
                        <button class="btn btn-sm btn-primary" onclick="editarPaciente('${paciente.sip}')">
                            <i class="bi bi-pencil-square"></i> Editar
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="eliminarPaciente('${paciente.sip}', event)">
                            <i class="bi bi-trash"></i> Eliminar
                        </button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(error => {
            console.error('Error al buscar los pacientes:', error);
            alert('Error al buscar los pacientes. Por favor, inténtelo de nuevo.');
        });
}





function editarPaciente(sip) {
    fetch(`ws_pacientes.php?sip=${sip}`)
        .then(response => response.json())
        .then(data => {
            const paciente = data[0];
            document.getElementById('sip').value = paciente.sip;
            document.getElementById('dni').value = paciente.dni;
            document.getElementById('nombre').value = paciente.nombre;
            document.getElementById('apellido').value = paciente.apellido1;
            document.getElementById('telefono').value = paciente.telefono;

            // Convert fecha_nacimiento to 'yyyy-MM-ddThh:mm'
            let fechaNacimiento = new Date(paciente.fecha_nacimiento);
            let formattedDate = fechaNacimiento.toISOString().slice(0, 16);
            document.getElementById('fecha').value = formattedDate;
        })
        .catch(error => {
            console.error('Error al obtener el paciente:', error);
        });
}

function obtenerDatosFormulario() {
    const sip = document.getElementById('sip').value.trim();
    const dni = document.getElementById('dni').value.trim();
    const nombre = document.getElementById('nombre').value.trim();
    const apellido = document.getElementById('apellido').value.trim();

    const telefono = document.getElementById('telefono').value.trim();
  
    const fecha = document.getElementById('fecha').value;
    const fecha_nacimiento = fecha.replace('T', ' ') + ':00';
    return {
        sip,
        dni,
        nombre,
        apellido,
        telefono,
        fecha_nacimiento
    };
}

function limpiarFormulario() {
    document.getElementById('sip').value = '';
    document.getElementById('dni').value = '';
    document.getElementById('nombre').value = '';
    document.getElementById('apellido').value = '';
    document.getElementById('telefono').value = '';
    document.getElementById('fecha').value = '';
}

function insertarPacienteHandler(event) {
    event.preventDefault();
    const datos = obtenerDatosFormulario();
    if (!datos.sip || !datos.dni || !datos.nombre || !datos.apellido || !datos.telefono || !datos.fecha_nacimiento) {
        alert('Por favor, complete todos los campos requeridos.');
        return;
    }
    insertarPaciente(datos);
    cargarPacientes(1); // Actualizar la tabla
}

function actualizarPacienteHandler(event) {
    event.preventDefault();
    const datos = obtenerDatosFormulario();
    if (!datos.sip || !datos.dni || !datos.nombre || !datos.apellido || !datos.telefono || !datos.fecha_nacimiento) {
        alert('Por favor, complete todos los campos requeridos.');
        return;
    }
    actualizarPaciente(datos);
    cargarPacientes(1); // Actualizar la tabla
}

async function insertarPaciente(paciente) {
    try {
        const response = await sendRequest('ws_pacientes.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(paciente)
        });
        if (response.error) {
            alert(response.error);
        } else {
            alert('Paciente insertado correctamente.');
            limpiarFormulario();
        }
    } catch (error) {
        console.error('Error al insertar el paciente:', error);
        alert('Error al insertar el paciente. Por favor, inténtelo de nuevo.');
    }
}


async function actualizarPaciente(paciente) {
    try {
        await sendRequest('ws_pacientes.php', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(paciente)
        });
        alert('Paciente actualizado correctamente.');
        limpiarFormulario();
    } catch (error) {
        alert('Error al actualizar el paciente.');
        console.error('Error al actualizar el paciente:', error);
    }
}

async function eliminarPaciente(sip) {
    try {
        await sendRequest(`ws_pacientes.php?sip=${sip}`, { method: 'DELETE' });
        alert('Paciente eliminado correctamente.');
        cargarPacientes(currentPage); // Actualizar la tabla
    } catch (error) {
        alert('Error al eliminar el paciente.');
        console.error('Error al eliminar el paciente:', error);
    }
}

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
