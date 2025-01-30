<?php
include '../config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST');

$data = json_decode(file_get_contents('php://input'), true);

if (isset($data['contact_id'])) {
    $contact_id = mysqli_real_escape_string($conn, $data['contact_id']);
    
    $sql = "DELETE FROM favorites WHERE contact_id = $contact_id";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(array("message" => "Removed from favorites successfully"));
    } else {
        echo json_encode(array("message" => "Error: " . mysqli_error($conn)));
    }
} else {
    echo json_encode(array("message" => "Missing contact_id"));
}

mysqli_close($conn);
?> 