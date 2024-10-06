<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ruhido Academy</title>
        <link rel="stylesheet" href="stylesRuhido.css?v=<?php echo time(); ?>">
        <script src="scriptGeneral.js?v=<?php echo time(); ?>"></script>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap">
    </head>
    <body>
        <?php
            include 'menunav.php';
        ?>

        <div class="textAcademy">Ruhido Academy es el proyecto formativo sobre café de especialidad de RUHIDO. </div>        
        <div class="superAcademy">
            <div class="backCourses">
                <a href="producto.php?productId=87">
                    <div class="superDivEspresso">
                        <div class="imageCursoEspresso"></div>
                        <div class="descripCurso">CURSO ESPRESSO</div>
                    </div>
                </a>
                <a href="producto.php?productId=88">
                    <div class="superDivFiltro">
                        <div class="imageCursoFiltro"></div>
                        <div class="descripCurso">CURSO FILTRO</div>
                    </div>
                </a>
                <a href="producto.php?productId=89">
                    <div class="superDivCata">
                        <div class="imageCursoCata"></div>
                        <div class="descripCurso">CURSO CATA</div>
                    </div>
                </a>
            </div>
        </div>
        <?php
            include 'carrito.php';
        ?>

        <?php
            include 'footer.php';
        ?>
        <script src="carrito.js?v=<?php echo time(); ?>" ></script>
    </body>
</html>