<?php
include '../config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST');

$data = json_decode(file_get_contents('php://input'), true);

if (isset($data['contact_id'])) {
    $contact_id = mysqli_real_escape_string($conn, $data['contact_id']);
    
    // Check if already favorite
    $check_sql = "SELECT id FROM favorites WHERE contact_id = $contact_id";
    $result = mysqli_query($conn, $check_sql);
    
    if (mysqli_num_rows($result) > 0) {
        echo json_encode(array("message" => "Contact already in favorites"));
        exit;
    }
    
    $sql = "INSERT INTO favorites (contact_id) VALUES ($contact_id)";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(array("message" => "Added to favorites successfully"));
    } else {
        echo json_encode(array("message" => "Error: " . mysqli_error($conn)));
    }
} else {
    echo json_encode(array("message" => "Missing contact_id"));
}

mysqli_close($conn);
?> 