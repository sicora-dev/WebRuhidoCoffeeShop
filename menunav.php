
<?php
    if(!isset($_SESSION)){
        session_start();
    }
    
?>
<header>
    <nav>
        <ul class="mainMenu">
            <li><a href="index.php" class="hola"><img src="images/RUHIDO negro.png" alt=""></a></li>
            <li class="subMenuShop"><a href="shop.php" class="">SHOP</a>
                <ul class="submenu">
                    <li><a href="productos.php?cat=retail">CAFÉS</a></li>
                    <li><a href="productos.php?cat=merchandising">MERCHANDISING</a></li>
                    <li><a href="productos.php?cat=house_equipment">EQUIPAMIENTO PARA CASA</a></li>
                    <li><a href="suscriptions.php">SUSCRIPCIONES</a></li>
                </ul>
            </li>
            <li><a href="locations.php">LOCATIONS</a></li>
            <li><a href="us.php">US</a></li>
            <li><a href="suscriptions.php">SUSCRIPCIONES</a></li>
            <li><a href="academy.php">ACADEMY</a></li>
            <?php if(!isset($_SESSION['mail_cliente'])){ ?>
            <li><a href="account.php">ACCOUNT</a></li>
            <?php }else{ ?>
            <li><a href="profile.php"><?php echo $_SESSION["nombre_cliente"]?></a></li>
            
            <?php } ?>
            
            
        </ul>
        
    </nav>
</header>


