<?php
require_once 'db_conn.php';

?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ruhido Shop</title>
    <link rel="stylesheet" href="stylesRuhido.css?v=<?php echo time(); ?>">
    <script src="scriptShopRuhido.js?v=<?php echo time(); ?>"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap">
</head>

<body>
    <?php
    include 'menunav.php';
    ?>
    <div class="nextHeader">
        <div class="imgShop"></div>

        <div id="cointainerRetail" class="cointainerRetail">
            <a href="productos.php?cat=retail">
                <div class="titleCafes">CAFÉS</div>
            </a>

        </div>
    </div>
    <div class="separator">
        <div>Llévate la experiencia RUHIDO Coffee a casa o a cualquier lugar del mundo.</div>
    </div>
    <div class="superMerch">
        <a href="productos.php?cat=merchandising">
            <div class="titleMerch">MERCHANDISING</div>
        </a>
        <a href="productos.php?cat=merchandising" class="imgMerch">
        </a>
    </div>
    <div class="separator3"></div>

    <div class="superEquip">

        <div id="cointainerEquipment" class="cointainerEquipment">
            <a href="productos.php?cat=house_equipment">
                <div class="titleEquip">EQUIPMENT</div>
            </a>
        </div>
    </div>
    <br>
    <?php
    include 'carrito.php';
    ?>

    <?php
    include 'footer.php';
    ?>
    <script>
        const productos5 =
            <?php
            // $query = 'SELECT * FROM producto LIMIT 10,5';
            $query = 'SELECT * FROM producto WHERE id_producto IN (15, 25, 35, 45)';
            $stmt = $db->prepare($query);
            $stmt->execute();
            $result = $stmt->get_result();
            $productos = $result->fetch_all(MYSQLI_ASSOC);

            // $productos = [];
            // while($prod = $result->fetch_assoc()){
            //     array_push($productos, $prod);
            // }
            
            echo json_encode($productos);
            ?>
            ;
const productos6 = 
<?php
// $query = 'SELECT * FROM producto LIMIT 10,5';
$query = 'SELECT * FROM producto WHERE id_producto IN (90, 91, 92, 93)';
$stmt = $db->prepare($query);
$stmt->execute();
$result = $stmt->get_result();
$productos = $result->fetch_all(MYSQLI_ASSOC);

// $productos = [];
// while($prod = $result->fetch_assoc()){
//     array_push($productos, $prod);
// }

echo json_encode($productos);
?>
            ;
            console.log(productos5);
            document.addEventListener('DOMContentLoaded', function(event){
                for(let p of productos5){
                    printCafesShop(p.id_producto, p.nombre_producto, p.descripcion, p.precio_venta, p.url_imagen);
                }

                for(let p of productos6){
                    printEquipShop(p.id_producto, p.nombre_producto, p.descripcion, p.precio_venta, p.url_imagen);
                }
                

            });
        </script>
    </body>
</html>