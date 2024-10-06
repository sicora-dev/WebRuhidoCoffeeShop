<?php
    require_once 'db_conn.php';
    if(!isset($_GET['productId'])){
        header('Location: shop.php');
    }

    $query = 'SELECT * FROM producto WHERE id_producto = ?';
    $stmt = $db->prepare($query);
    $stmt->bind_param('s', $_GET['productId']);
    $stmt->execute();
    $result = $stmt->get_result();
    $prod = $result->fetch_assoc();
    
    
?>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><?php echo htmlspecialchars($prod['nombre_producto']); ?></title>
        <link rel="stylesheet" href="stylesRuhido.css?v=<?php echo time(); ?>">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap">
        
    </head>
    <body>
        <?php
            include 'menunav.php';
        ?>
        <div class="superProduct">
            <div class="cajaProducto">
                <div class="fotoProducto">
                    <img src="<?php echo $prod['url_imagen'] ?>" alt="imagen producto">
                </div>
                <form action="producto.php" class="opcionesProducto">
                    <div class="nombreProducto"><?php echo $prod['nombre_producto'] ?></div>
                    <div class="cantidadProducto"> 
                        <label for="cantidadDeProducto">CANTIDAD</label>
                        <input type="number" id="cantidadDeProducto" min="1" max="20" value="1" onKeyDown="return false">
                    </div>
                    <div class="precioProducto">
                    <div class="datoPrecio">
                        <div>Precio Unidad €</div>
                        <div id="precioUnidad"><?php echo $prod['precio_venta']; ?></div>
                        <div>Precio Total €</div>
                        <div id="precioTotal"></div>
                    </div>
                    </div>
                    <input type="button" class="agregarAlCarrito" value="AGREGAR AL CARRITO">
                </form>
                <div class="descripcionProducto">
                    <div class="descripcionProductoIn"><?php echo $prod['descripcion'] ?></div>
                </div>
            </div>
        </div>

        <?php
            include 'carrito.php';
        ?>
        <?php
            include 'footer.php';
        ?>
        <script>
            const precioUnidad = <?php echo $prod['precio_venta'] ?>;
            document.addEventListener('DOMContentLoaded', function(e){
                const btnAddCart = document.getElementsByClassName('agregarAlCarrito')[0];
                const cantidadInput = document.getElementById('cantidadDeProducto');
                cantidadInput.addEventListener('input', actualizarPrecioTotal);
                btnAddCart.onclick = function(e){
                    const inputCantidadDeProducto =document.getElementById('cantidadDeProducto');
                    const cantidad = parseInt(inputCantidadDeProducto.value);
                    agregarAlCarrito("<?php echo $prod['nombre_producto'] ?>", cantidad, precioUnidad)
                };
                actualizarPrecioTotal();
            });

            function actualizarPrecioTotal() {
                const cantidadInput = document.getElementById('cantidadDeProducto');
                const cantidad = parseInt(cantidadInput.value, 10);
                const precioTotal = precioUnidad * cantidad;
                precioTotalElement.textContent = precioTotal.toFixed(2);
            }
        </script>
    </body>
</html>