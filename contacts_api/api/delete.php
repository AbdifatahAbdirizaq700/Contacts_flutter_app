<?php
include '../config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST');

// Get posted data
$data = json_decode(file_get_contents('php://input'), true);

if (isset($data['id'])) {
    $id = mysqli_real_escape_string($conn, $data['id']);

    $sql = "DELETE FROM contacts WHERE id=$id";

    if (mysqli_query($conn, $sql)) {
        echo json_encode(array('message' => 'Contact deleted successfully'));
    } else {
        echo json_encode(array('message' => 'Error: ' . mysqli_error($conn)));
    }
} else {
    echo json_encode(array('message' => 'Missing contact ID'));
}

mysqli_close($conn);
?> 