<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ruhido About</title>
        <link rel="stylesheet" href="stylesRuhido.css?v=<?php echo time(); ?>">
        <script src="scriptShopRuhido.js?v=<?php echo time(); ?>"></script>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap">
    </head>
    <body>
        <?php
            include 'menunav.php';
        ?>
        <div class="superUs">
            <a href="mailto: hey@ruhido-coffeehouses.com" >
                <div class="emailUs">email us! hey@ruhido-coffeehouses.com</div>
            </a>
            <div class="separatorLocales"></div>
            <div class="containerAbout">
                <div class="imgUs"></div>
                <div class="textUs">RUHIDO Coffee Houses es una cadena de cafeterías de especialidad, con sede en Madrid, pero en expansión por todo el territorio nacional. <br> <br>
                    Con el objetivo de difundir la cultura del café, pone mimo en cada bebida que prepara en sus locales, con un cuidado diseño que infunde al disfrute de cada taza. </div>
                <a href="locations.php" class="usLocations">LOCATIONS</a>
            </div>
        </div>
        <?php
            include 'footer.php';
        ?>
    </body>
</html>