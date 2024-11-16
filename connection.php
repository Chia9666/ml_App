<?php

    # change the $db_user, $db_password to your own set up
    $serverHost = "localhost";
    $user = "root";
    $password = "";
    $database = "mldb";

    # establish connection to mysql
    $connect = new mysqli($serverHost, $user, $password, $database);
    # check connection
    if ($connect->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>