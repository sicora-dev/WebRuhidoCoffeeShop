<?php
    $servername = "localhost";
    $username = "your_username";
    $password = "your_password";
    $dbname = "ruhido_db";

    $db = new mysqli($servername, $username, $password, $dbname);
    if ($db->connect_errno) {
        die("Connection failed: " . $conn->connect_error);
    }