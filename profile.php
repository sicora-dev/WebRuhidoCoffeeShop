<?php
    if(!isset($_SESSION)){
        require_once 'check_auth.php';
    }
    
    require_once 'db_conn.php';
?>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Profile</title>
        <link rel="stylesheet" href="stylesRuhido.css?v=<?php echo time(); ?>">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap">
        </head>
        <body>
            <?php
                include 'menunav.php';
            ?>
            <div class="superBackProfile">
                <h1>BIENVENID@ <?php echo $_SESSION['nombre_cliente']?></h1><br>
                <div class="cajaDatosCliente">
                    <div class="nombreCliente">Bienvenid@ <?php echo $_SESSION['nombre_cliente']; ?></div>
                    <div class="direccioncliente">Tu mail: <?php echo $_SESSION['mail_cliente']; ?></div>
                    <div class="direccioncliente">Tu direccion: <?php echo $_SESSION['direccion_cliente']; ?></div>
                    <div class="direccioncliente">Tu código postal: <?php echo $_SESSION['codigo_postal_cliente']; ?></div>
                    <div class="direccioncliente">Tu teléfono: <?php echo $_SESSION['telefono_cliente']; ?></div>
                    <form action="logout.php">
                        <button type="submit">Cerrar sesión</button>
                    </form>
                    
                </div>
                <a href="shop.php">
                    <h1 class="slogan">LET'S SHOP!</h1>
                </a>
            </div>
            <?php
                include 'carrito.php';
            ?>
            <?php
                include 'footer.php';
            ?>
    </body>
</html>
    