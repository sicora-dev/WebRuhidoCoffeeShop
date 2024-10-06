<?php
require_once 'db_conn.php';
if (!isset($_GET['email']) || !isset($_GET['token'])) {
    header('Location: forgotpass.php?error=3');
}
$error = '';
if($_GET['error']=== 1){
    $error = 'Las contraseña deben coincidir';
}
if (isset($_GET['token'])) {
    $token = $_GET['token'];


    $query = 'SELECT * FROM cliente WHERE token = ?';
    $stmt = $db->prepare($query);
    $stmt->bind_param('s', $token);
    $stmt->execute();
    $result = $stmt->get_result();


    if ($result->num_rows === 1) {
        $row = $result->fetch_assoc();
        if ($_GET['email'] === $row['mail_cliente']) { ?>

            <!DOCTYPE html>
            <html lang="es">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Ruhido Your Account</title>
                <link rel="stylesheet" href="stylesRuhido.css?v=<?php echo time(); ?>">
                <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap">

            </head>

            <body>
                <div class="containerAccount">
                    <div class="form-section" id="login-section">
                        <div>CREE UNA NUEVA CONTRASEÑA</div>

                        <form action="resetpass.php" method="POST">
                            <input type="password" name="password1" placeholder="Introduce tu nueva contraseña">
                            <input type="password" name="password2" placeholder="Repite tu nueva contraseña">
                            <?php echo '<div class="error">' . $error . '</div>'; ?>
                            <input type="text" hidden="true" name="email" value=<?php echo '"'.$_GET['email'] . '"' ?>>
                            <input type="text" hidden="true" name="token" value=<?php echo '"'.$_GET['token'] . '"' ?>>
                            
                            <button type="submit">Restablecer contraseña</button>
                            
                            
                        </form>
                    </div>

                </div>

                <?php
                include 'footer.php';
                ?>

            </body>

            </html>


            <?php

        }
    } else {
        echo 'Enlace de recuperación no válido.';
    }
} else {
    echo 'Falta el token en la URL.';
}


$email = $_GET['email'];
if ($_GET['error'] == 1) {
    $error = 'Las contraseñas no coinciden';
} else {
    $error = '';
}

?>