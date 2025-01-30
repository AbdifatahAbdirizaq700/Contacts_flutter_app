<?php
include '../config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST');

// Get posted data
$data = json_decode(file_get_contents('php://input'), true);

if (isset($data['id']) && isset($data['name']) && isset($data['phone']) && isset($data['email'])) {
    $id = mysqli_real_escape_string($conn, $data['id']);
    $name = mysqli_real_escape_string($conn, $data['name']);
    $phone = mysqli_real_escape_string($conn, $data['phone']);
    $email = mysqli_real_escape_string($conn, $data['email']);

    $sql = "UPDATE contacts SET name='$name', phone='$phone', email='$email' WHERE id=$id";

    if (mysqli_query($conn, $sql)) {
        echo json_encode(array('message' => 'Contact updated successfully'));
    } else {
        echo json_encode(array('message' => 'Error: ' . mysqli_error($conn)));
    }
} else {
    echo json_encode(array('message' => 'Missing required fields'));
}

mysqli_close($conn);
?> 