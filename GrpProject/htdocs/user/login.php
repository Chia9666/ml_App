<?php
include "../connection.php";

// header('Content-Type: application/json');

// Prepare the statement to prevent SQL injection
$usernameEmail = $_POST["usernameEmail"];
$password = md5($_POST['password']);

// Log the received credentials
// error_log("Received Username/Email: $usernameEmail");

// Use prepared statement
$stmt = $connect->prepare("SELECT * FROM users WHERE username = ? OR email = ?");
$stmt->bind_param("ss", $usernameEmail, $usernameEmail);
$stmt->execute();
$result = $stmt->get_result();

// Check for query execution errors
if ($result == false) {
    echo json_encode(['error' => 'Query failed: ' . $connect->error]);
    exit();
}

if ($result->num_rows > 0) {
    //$userRecord = mysqli_fetch_assoc($result)
    $userRecord = $result->fetch_assoc();

    // Log the fetched user record
    //error_log("Fetched User Record: " . json_encode($userRecord));

    // Verify the password
    if ($password == $userRecord['password']) {
        // Generate new token on successful login
        $newToken = bin2hex(random_bytes(32));

        // Update token in database
        $updateStmt = $connect->prepare("UPDATE users SET token = ? WHERE user_id = ?");
        $updateStmt->bind_param("si", $newToken, $userRecord['user_id']);
        $updateStmt->execute();

        // Return success response with new token
        echo json_encode([
            "success" => true,
            "token" => $newToken,
            "user_id" => $userRecord['user_id'],
            "username" => $userRecord['username']
        ]);
    } else {
        // Password doesn't match
        echo json_encode([
            "success" => false,
            "message" => "Invalid password"
        ]);
    }
} else {
    // No user found
    echo json_encode([
        "success" => false,
        "message" => "User not found"
    ]);
}

$stmt->close();
$connect->close();
