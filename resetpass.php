<?php
session_start();
require_once "db_conn.php";

$pass1 = $_POST['password1'];
$pass2 = $_POST['password2'];
$email = $_POST['email'];
$token = $_POST['token'];

if ($pass1 != $pass2) {
    header('Location: newpass.php?email=' . $email . "&token=" . $token . "&error=1");
} else {
    $query = 'UPDATE cliente SET contrasena_cliente = ? WHERE mail_cliente = ?';
    $stmt = $db->prepare($query);
    $stmt->bind_param('ss', $pass1, $email);
    $stmt->execute();

    $_SESSION['login_error'] = "Contraseña cambiada con exito";
    header("Location: account.php");
    $token = uniqid();

    $query = 'UPDATE cliente SET token = ? WHERE mail_cliente = ?';
    $stmt = $db->prepare($query);
    $stmt->bind_param('ss', $token, $email);
    $stmt->execute();

}