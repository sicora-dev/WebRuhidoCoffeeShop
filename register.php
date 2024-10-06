<?php
require_once 'db_conn.php';
session_start();

$register_error = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (
        isset($_POST['email']) && isset($_POST['nombre']) && isset($_POST['apellido'])
        && isset($_POST['contrasena']) && isset($_POST['ciudad']) && isset($_POST['codigo_postal'])
    ) {

        $query = 'CALL RegistrarCliente(?, ?, ?, ?, ?, ?, ?, ?, @out)';
        $stmt = $db->prepare($query);

        //$pass_hash = password_hash($_POST['passw'], PASSWORD_DEFAULT);

        $stmt->bind_param('ssssssss', $_POST['email'], $_POST['nombre'], $_POST['apellido'], $_POST['contrasena'], $_POST['direccion'], $_POST['ciudad'], $_POST['telefono'], $_POST['codigo_postal']);
        $stmt->execute();

        $select = $db->query('SELECT @out');
        $result = $select->fetch_assoc();
        $proc_result = $result['@out'];


        switch ($proc_result) {
            case -1:
                $register_error = 'Nombre vacío o nulo';
                break;
            case -2:
                $register_error = 'Apellido vacío o nulo';
                break;
            case -3:
                $register_error = 'Usuario ya existe';
                break;
            case -4:
                $register_error = 'Email vacío o nulo';
                break;
            case -5:
                $register_error = 'Email no tiene forma de email';
                break;
            case -6:
                $register_error = 'Código postal no tiene el tamaño correcto';
                break;
            case -7:
                $register_error = 'Contraseña vacía o nula';
                break;
            case -8:
                $register_error = 'Teléfono vacío';
                break;
            case -9:
                $register_error = 'Dirección del cliente vacía';
                break;
            case -10:
                $register_error = 'Ciudad vacía o nula';
                break;
            case 0:
                $register_error = 'Usuario registrado correctamente';
                break;
            default:
                if ($register_error == 1062) {
                    $register_error = 'Usuario ya existe';
                } else if ($register_error == 1048) {
                    $register_error = 'Faltan datos';
                } else if ($register_error == 1366) {
                    $register_error = 'Tipo de dato incorrecto';
                } else if ($register_error == 1064) {
                    $register_error = 'Error en la consulta';
                } else if ($register_error == 0) {
                    $register_error = 'Error desconocido';
                }
                break;
        }
    } else {
        $login_error = 'Faltan datos';
    }
}

$_SESSION['register_error'] = $register_error;
header('Location: account.php');
die();
?>