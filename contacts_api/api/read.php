<?php
include '../config.php';

header('Content-Type: application/json');

$sql = "SELECT * FROM contacts ORDER BY name";
$result = mysqli_query($conn, $sql);

if ($result) {
    $contacts = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $contacts[] = array(
            'id' => $row['id'],
            'name' => $row['name'],
            'phone' => $row['phone'],
            'email' => $row['email']
        );
    }
    echo json_encode($contacts);
} else {
    echo json_encode(array('message' => 'Error: ' . mysqli_error($conn)));
}

mysqli_close($conn);
?> 