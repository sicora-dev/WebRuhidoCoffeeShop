<?php
    $db = new mysqli("localhost", "?", "?", "?", 3306);
    if ($db->connect_errno) {
        die();
    }