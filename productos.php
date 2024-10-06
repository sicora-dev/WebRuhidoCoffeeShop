<?php
    require_once 'db_conn.php';
    if(!isset($_GET['cat'])){
        header('Location: shop.php');
    }
    
    $query = 'SELECT * FROM producto WHERE categoria_producto = ?';
    $stmt = $db->prepare($query);
    $stmt->bind_param('s', $_GET['cat']);
    $stmt->execute();
    $result = $stmt->get_result();
?>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ruhido Cafés</title>
        <link rel="stylesheet" href="stylesRuhido.css?v=<?php echo time(); ?>">
        <script src="scriptGeneral.js?v=<?php echo time(); ?>"></script>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap">
    </head>
    <body>
        <?php
            include 'menunav.php';
        ?>

        <div class="nextHeaderCafes"> 
            <div id="cointainerRetailCafes" class="cointainerRetailCafes">
            <?php
                while($prod = $result->fetch_assoc()){ ?>
                    <a href="producto.php?productId=<?php echo $prod['id_producto']; ?>">
                        <div class="containerProduct">
                            <div class="imgContainer">
                                <img src="<?php echo $prod['url_imagen']?>" alt="imagen del producto">
                            </div>
                            <div class="descriptionProduct">
                                <div class="descElements">
                                    <div class="nameOrRoasted">
                                        <div><?php echo $prod['nombre_producto'] ?></div>
                                    </div>
                                    <div class="descripciones"><?php echo $prod['descripcion'] ?></div>                            
                                    <div><?php echo $prod['precio_venta']?> €</div>
                                </div>
                            </div>
                        </div>
                    </a>
            <?php
                }
            ?>
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
