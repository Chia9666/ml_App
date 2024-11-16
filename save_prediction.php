<?php
include '../connection.php';


$user_id = $_POST['user_id']; // ID of the user using the model
$image_name = $_POST['image_name'];
$prediction_label = $_POST['prediction_label'];
$confidence = $_POST['confidence'];

$query = "INSERT INTO prediction_history (user_id, image_name, prediction_label, confidence) VALUES (?, ?, ?, ?)";

$stmt = $connect->prepare($query);
$stmt->bind_param("issd", $user_id, $image_name, $prediction_label, $confidence);

$result = $stmt->execute();

if($result) {
    echo json_encode(['success' => true, 'message' => 'Prediction Results Saved']);
} else {
    echo json_encode(['success' => false, 'error' => 'Prediction Results Failed to Save']);
}

$stmt->close();
$connect->close();
?>