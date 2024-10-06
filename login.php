<?php
session_start();
require_once 'db_conn.php';
$login_error = '';
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['email']) && isset($_POST['contrasena'])) {

        $query = 'CALL LoginCliente(?,?, @out)';
        $stmt = $db->prepare($query);
        $stmt->bind_param('ss', $_POST['email'], $_POST['contrasena']);

        if (!$stmt->execute()) {
            die('Error en la consulta: ' . $stmt->error);
        }

        $stmt->close();
        $result = $db->query('SELECT @out as _resultado')->fetch_object();
        $proc_result = $result->_resultado;



        switch ($proc_result) {
            case -1:
                $login_error = 'El correo electrónico no puede estar vacío.';
                break;
            case -2:
                $login_error = 'El correo electrónico no existe.';
                break;
            case -3:
                $login_error = 'El formato del correo electrónico es incorrecto.';
                break;
            case -4:
                $login_error = 'La contraseña no puede estar vacía.';
                break;
            case -5:
                $login_error = 'Usuario o contraseña incorrectos :(';
                break;
            case 0:


                $query = 'SELECT * FROM cliente WHERE mail_cliente = ?';
                $stmt = $db->prepare($query);
                $stmt->bind_param('s', $_POST['email']);
                $stmt->execute();
                $result = $stmt->get_result();

                if ($result && $result->num_rows > 0) {
                    $row = $result->fetch_assoc();

                    $_SESSION['mail_cliente'] = $row['mail_cliente'];
                    $_SESSION['nombre_cliente'] = $row['nombre_cliente'];
                    $_SESSION['direccion_cliente'] = $row['direccion_cliente'];
                    $_SESSION['codigo_postal_cliente'] = $row['codigo_postal_cliente'];
                    $_SESSION['telefono_cliente'] = $row['telefono_cliente'];
                } else {
                    // Maneja el error aquí
                    die('Error en la consulta: ' . $db->error);
                }

                $_SESSION['login_error'] = $login_error;
                header('Location: shop.php');
                die();


            default:
                $login_error = '';
        }
        $_SESSION['login_error'] = $login_error;
        header('Location: account.php');
        die();

    } else {
        $login_error = 'Faltan datos';
        $_SESSION['login_error'] = $login_error;
        header('Location: account.php');
        die();

    }

}
?>