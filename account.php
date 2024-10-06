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
            <div>INICIAR SESIÓN</div>
            <form action="login.php" method="post">
                <input type="email" name="email" placeholder="email" required>
                <input type="password" name="contrasena" placeholder="contraseña" required>
                <?php
                if (!isset($_SESSION['login_error'])) {
                    $_SESSION['login_error'] = '';
                }
                echo $_SESSION['login_error']; ?>
                <button type="submit">LOG IN</button>
                <a href="forgotpass.php">He olvidado mi contraseña</a>
            </form>
            
        </div>
        <div class="separatorAccount"></div>
        <div class="form-section" id="register-section">
            <div>REGISTRARSE</div>
            <form action="register.php" method="post">
                <input type="email" name="email" placeholder="email" required onfocus="changeColor(this)"
                    onblur="changeColorBack(this)">
                <input type="text" name="nombre" placeholder="nombre" required onfocus="changeColor(this)"
                    onblur="changeColorBack(this)">
                <input type="text" name="apellido" placeholder="apellido" required onfocus="changeColor(this)"
                    onblur="changeColorBack(this)">
                <input type="password" name="contrasena" placeholder="contraseña" required onfocus="changeColor(this)"
                    onblur="changeColorBack(this)">
                <input type="text" name="ciudad" placeholder="ciudad" required onfocus="changeColor(this)"
                    onblur="changeColorBack(this)">
                <input type="text" name="direccion" placeholder="dirección">
                <input type="text" name="codigo_postal" placeholder="código postal" required onfocus="changeColor(this)"
                    onblur="changeColorBack(this)">
                <input type="text" name="telefono" placeholder="numero de telefono">
                <?php
                if (!isset($_SESSION['register_error'])) {
                    $_SESSION['register_error'] = '';
                }
                echo $_SESSION['register_error']; ?>
                <button type="submit">SIGN UP</button>
            </form>
        </div>
    </div>
    <script>
        function changeColor(input) {
            if (input.value == '') {
                input.placeholder = input.placeholder.replace(" (obligatorio)", '');
                input.classList.remove('placeholderRojo');

            }
        }

        function changeColorBack(input) {
            if (input.value == '') {
                input.placeholder = input.placeholder + " (obligatorio)";
                input.classList.add('placeholderRojo');

            }
        }
    </script>
    <?php
    include 'carrito.php';
    ?>
    <?php
    include 'footer.php';
    ?>

</body>

</html>