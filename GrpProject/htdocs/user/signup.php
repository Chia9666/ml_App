<?php
include '../connection.php';

// Capture the POST data
$username = $_POST['username'];
$email = $_POST['email'];

// hash user's password
$password = md5($_POST['password']);

// Create unique token for user
$token = bin2hex(random_bytes(16));

// Prepare SQL statement to insert user
$sqlQuery = "INSERT INTO users (username, email, password, token) VALUES (?, ?, ?, ?)";
$stmt = $connect->prepare($sqlQuery);

// Check if statement preparation was successful
if ($stmt) {
    // Bind parameters
    $stmt->bind_param("ssss", $username, $email, $password, $token);

    // Execute the statement
    $result = $stmt->execute();

    // Check execution result
    if ($result) {
        echo json_encode(['message' => 'Registration Successful']);
    } else {
        echo json_encode([
            'message' => 'Registration Unsuccessful', 
            'error' => $stmt->error // Return the actual error message
        ]);
    }
} else {
    // Statement preparation failed
    echo json_encode([
        'message' => 'Failed to prepare SQL statement', 
        'error' => $connect->error // Return the actual preparation error message
    ]);
}

// Close the statement and connection
$stmt->close();
$connect->close();
?>
