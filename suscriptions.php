<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ruhido Suscripciones</title>
    <link rel="stylesheet" href="stylesRuhido.css?v=<?php echo time(); ?>">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap">
</head>

<body>
    <?php
    include 'menunav.php';
    ?>
    <div class="textSusAmbos">
        <div class="textSus">No te quedes sin café en casa o en la oficina </div>
        <div class="textSus">Suscríbete a nuestros planes desde 30€/mes -></div>
    </div>

    <div class="superSus">
        <div class="contenedorSus">
            <a href="producto.php?productId=96">
                <div class="susBasic">BASIC</div>
            </a>
            <a href="producto.php?productId=97">
                <div class="susPro">PRO</div>
            </a>
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