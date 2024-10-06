<?php
    session_start();
    if(!isset($_SESSION['mail_cliente'])){
        header('Location: account.php');
        exit();
    }