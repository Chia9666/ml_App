<?php
include '../connection.php';

// header('Content-Type: application/json'); // Set the content type to JSON

# get email from flutter
$email = $_POST['email'];

$sqlQuery = "SELECT * FROM users WHERE email = '$email'" ;

$result = $connect->query($sqlQuery);

# Validate whether can connect or not?
if ($result == false){
    echo json_encode(['error' => 'Query failed: ' . $connect->error]);
    exit();
}

# Connection established successfully
# Validate whether email has been used or not

if ($result->num_rows > 0) { // Email has been used
    echo json_encode(["emailFound" => true]);
} else { // Email has not been found
    echo json_encode(["emailFound" => false, "message" => "Email not found"]);
}
?>
