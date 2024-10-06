<?php
require_once 'db_conn.php';
session_start();
?>


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
    <?php
    include 'menunav.php';
    ?>


    <div class="containerAccount">
        <div class="form-section" id="login-section">
            <div>HE OLVIDADO MI CONTRASEÑA</div>

            <form action="resetmail.php" method="GET">
                <input type="email" name="email" placeholder="Introduce tu correo electrónico" required>
                <button type="submit">Enviar</button>
                <?php
                if (isset($_GET['error'])) {
                    if ($_GET['error'] == 1) {
                        echo '<div class="error">No existe este correo electrónico</div>';
                    } else if ($_GET['error'] == 2) {
                        echo '<div class="error">Introduce un correo electrónico</div>';
                    } else if ($_GET['error'] == 3) {
                        echo '<div class="error">Internal error</div>';
                    } else if ($_GET['error'] == 0) {
                        echo '<div class="error">Se ha enviado un correo con instrucciones para restablecer tu contraseña</div>';
                    }
                }

                ?>
            </form>
        </div>

    </div>

    <?php
    include 'carrito.php';
    ?>
    <?php
    include 'footer.php';
    ?>

</body>

</html>