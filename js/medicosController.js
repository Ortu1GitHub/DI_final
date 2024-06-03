let currentPage = 1;
const recordsPerPage = 2;

document.addEventListener('DOMContentLoaded', function() {
    cargarMedicos(currentPage);
    cargarEspecialidades();
    cargarHorarios();
    cargarUsuarios();

    document.getElementById('insertar').addEventListener('click', insertarMedicoHandler);
    document.getElementById('actualizar').addEventListener('click', actualizarMedicoHandler);
    document.getElementById('buscar').addEventListener('click', buscarMedicosHandler);
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

async function cargarMedicos(page) {
    if (page < 1) {
        console.error('El número de página no puede ser menor que 1');
        return;
    }
    try {
        const data = await sendRequest(`ws_medicos.php?limit=${recordsPerPage}&page=${page}`);
        console.log('Datos recibidos:', data);
        if (Array.isArray(data.medicos)) {
            currentPage = page;
            actualizarListaMedicos(data.medicos);
            actualizarPaginacion(data.total);
        } else {
            throw new Error('La respuesta no es un array');
        }
    } catch (error) {
        console.error('Error al cargar los médicos:', error);
    }
}

async function obtenerTotalRegistros() {
    const data = await sendRequest('ws_medicos.php');
    return data.total;
}


function actualizarListaMedicos(medicos) {
    const tbody = document.getElementById('medicoTableBody');
    tbody.innerHTML = '';
    medicos.forEach(medico => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${medico.numero_colegiado}</td>
            <td>${medico.dni}</td>
            <td>${medico.nombre}</td>
            <td>${medico.apellido1}</td>
            <td>
                <button class="btn btn-sm btn-primary" onclick="editarMedico('${medico.numero_colegiado}')">
                    <i class="bi bi-pencil-square"></i> Editar
                </button>
                <button class="btn btn-sm btn-danger" onclick="eliminarMedico('${medico.numero_colegiado}', event)">
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
    cargarMedicos(page);
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

function buscarMedicosHandler(event) {
    event.preventDefault();
    const filtro = document.getElementById('search').value.trim();
    if (!filtro) {
        alert('Por favor, ingrese un criterio de búsqueda.');
        return;
    }

    fetch(`ws_medicos.php?filtro=${encodeURIComponent(filtro)}`)
        .then(response => response.json())
        .then(data => {
            const tbody = document.getElementById('medicoTableBody');
            tbody.innerHTML = '';
            data.forEach(medico => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${medico.numero_colegiado}</td>
                    <td>${medico.dni}</td>
                    <td>${medico.nombre}</td>
                    <td>${medico.apellido1}</td>
                    <td>
                        <button class="btn btn-sm btn-primary" onclick="editarMedico('${medico.numero_colegiado}')">
                            <i class="bi bi-pencil-square"></i> Editar
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="eliminarMedico('${medico.numero_colegiado}', event)">
                            <i class="bi bi-trash"></i> Eliminar
                        </button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(error => console.error('Error al buscar médicos:', error));
}

async function cargarEspecialidades() {
    try {
        const data = await sendRequest('ws_medicos.php?especialidades=true');
        actualizarOpciones('especialidad_id', data, 'especialidades');
    } catch (error) {
        console.error('Error al cargar las especialidades:', error);
    }
}

async function cargarUsuarios() {
    try {
        const data = await sendRequest('ws_medicos.php?usuarios=true');
        actualizarOpciones('usuario_id', data, 'usuarios');
    } catch (error) {
        console.error('Error al cargar los usuarios:', error);
    }
}

async function cargarHorarios() {
    try {
        const data = await sendRequest('ws_medicos.php?horarios=true');
        actualizarOpciones('horario_id', data, 'horarios');
    } catch (error) {
        console.error('Error al cargar los horarios:', error);
    }
}

function actualizarOpciones(selectId, opciones, tipo) {
    const select = document.getElementById(selectId);
    select.innerHTML = '';
    opciones.forEach(opcion => {
        const option = document.createElement('option');
        option.value = opcion.id;
        if (tipo === 'horarios') {
            option.textContent = `${opcion.hora_inicio} - ${opcion.hora_fin}`;
        } else if (tipo === 'usuarios') {
            option.textContent = opcion.name;
        } else {
            option.textContent = opcion.nombre || opcion.descripcion;
        }
        select.appendChild(option);
    });
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

async function eliminarMedico(numero_colegiado) {
    try {
        await sendRequest(`ws_medicos.php?numero_colegiado=${numero_colegiado}`, { method: 'DELETE' });
        location.reload();
    } catch (error) {
        console.error('Error al eliminar el médico:', error);
    }
}

function buscarMedicosHandler(event) {
    event.preventDefault();
    const filtro = document.getElementById('search').value.trim();
    if (!filtro) {
        alert('Por favor, ingrese un criterio de búsqueda.');
        return;
    }

    fetch(`ws_medicos.php?filtro=${encodeURIComponent(filtro)}`)
        .then(response => response.json())
        .then(data => {
            const tbody = document.getElementById('medicoTableBody');
            tbody.innerHTML = '';
            data.forEach(medico => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td>${medico.numero_colegiado}</td>
                    <td>${medico.dni}</td>
                    <td>${medico.nombre}</td>
                    <td>${medico.apellido1}</td>
                    <td>
                        <button class="btn btn-sm btn-primary" onclick="editarMedico('${medico.numero_colegiado}')">
                            <i class="bi bi-pencil-square"></i> Editar
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="eliminarMedico('${medico.numero_colegiado}', event)">
                            <i class="bi bi-trash"></i> Eliminar
                        </button>
                    </td>
                `;
                tbody.appendChild(tr);
            });
        })
        .catch(error => {
            console.error('Error al buscar los médicos:', error);
            alert('Error al buscar los médicos. Por favor, inténtelo de nuevo.');
        });
}

function editarMedico(numero_colegiado) {
    fetch(`ws_medicos.php?numero_colegiado=${numero_colegiado}`)
        .then(response => response.json())
        .then(data => {
            const medico = data[0];
            document.getElementById('numero_colegiado').value = medico.numero_colegiado;
            document.getElementById('dni').value = medico.dni;
            document.getElementById('nombre').value = medico.nombre;
            document.getElementById('apellido').value = medico.apellido1;
            document.getElementById('apellido2').value = medico.apellido2;
            document.getElementById('telefono').value = medico.telefono;
            document.getElementById('especialidad_id').value = medico.especialidad_id;
            document.getElementById('horario_id').value = medico.horario_id;
            document.getElementById('usuario_id').value = medico.user_id;

            // Actualizar el valor del user_id en el formulario
            document.getElementById('usuario_id').value = medico.user_id;
        })
        .catch(error => {
            console.error('Error al obtener el médico:', error);
        });
}


function obtenerDatosFormulario() {
    const numero_colegiado = document.getElementById('numero_colegiado').value.trim();
    const dni = document.getElementById('dni').value.trim();
    const nombre = document.getElementById('nombre').value.trim();
    const apellido1 = document.getElementById('apellido').value.trim();
    const apellido2 = document.getElementById('apellido2').value.trim();
    const telefono = document.getElementById('telefono').value.trim();
    const especialidad_id = document.getElementById('especialidad_id').value;
    const horario_id = document.getElementById('horario_id').value;
    const usuario_id = document.getElementById('usuario_id').value;

    return {
        numero_colegiado,
        dni,
        nombre,
        apellido1,
        apellido2,
        telefono,
        especialidad_id,
        horario_id,
        usuario_id
    };
}


function limpiarFormulario() {
    document.getElementById('numero_colegiado').value = '';
    document.getElementById('dni').value = '';
    document.getElementById('nombre').value = '';
    document.getElementById('apellido').value = '';
    document.getElementById('apellido2').value = '';
    document.getElementById('telefono').value = '';
    document.getElementById('especialidad_id').value = '';
    document.getElementById('horario_id').value = '';
    document.getElementById('usuario_id').value = '';
}

async function insertarMedicoHandler(event) {
    event.preventDefault();
    const datos = obtenerDatosFormulario();
    if (!datos.numero_colegiado || !datos.dni || !datos.nombre || !datos.apellido1 || !datos.telefono) {
        alert('Por favor, complete todos los campos requeridos.');
        return;
    }
    insertarMedico(datos);
    location.reload();
}



async function insertarMedico(medico) {
    try {
        const response = await sendRequest('ws_medicos.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(medico)
        });
        if (response.error) {
            alert(response.error);
        } else {
            alert('Medico insertado correctamente.');
            limpiarFormulario();
         
        }
    } catch (error) {
        console.error('Error al insertar el medico:', error);
        alert('Error al insertar el medico. Por favor, inténtelo de nuevo.');
    }
}


function actualizarMedicoHandler(event) {
    event.preventDefault();
    const datos = obtenerDatosFormulario();
    if (!datos.numero_colegiado || !datos.dni || !datos.nombre || !datos.apellido1 || !datos.telefono) {
        alert('Por favor, complete todos los campos requeridos.');
        return;
    }
    actualizarMedico(datos);
    location.reload();
}



async function actualizarMedico(medico) {
    try {
        await sendRequest('ws_medicos.php', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(medico)
        });
   
        limpiarFormulario();
        alert('Médico actualizado correctamente.');
   

       
    } catch (error) {
        alert('Error al actualizar el médico. Por favor, inténtelo de nuevo.');
        console.error('Error al actualizar el médico:', error);
    }
}
