git <?php
    # change the $db_user, $db_password to your own setup in xampp 2nd acc test
    $serverHost = "localhost";
    $user = "root";
    $password = "root";
    $database = "mldb";

    # establish connection to mysql
    $connect = new mysqli($serverHost, $user, $password, $database);
    # check connection
    if ($connect->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>