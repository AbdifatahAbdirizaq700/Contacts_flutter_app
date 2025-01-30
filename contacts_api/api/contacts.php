<?php
include 'config.php';

// Get all contacts
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT * FROM contacts ORDER BY name";
    $result = mysqli_query($conn, $sql);
    $contacts = array();
    
    while($row = mysqli_fetch_assoc($result)) {
        $contacts[] = $row;
    }
    
    echo json_encode($contacts);
}

// Add new contact
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $name = $data['name'];
    $phone = $data['phone'];
    $email = $data['email'];
    
    $sql = "INSERT INTO contacts (name, phone, email) VALUES ('$name', '$phone', '$email')";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(array("message" => "Contact added successfully"));
    } else {
        echo json_encode(array("message" => "Error: " . mysqli_error($conn)));
    }
}

// Delete contact
if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $id = $_GET['id'];
    $sql = "DELETE FROM contacts WHERE id=$id";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(array("message" => "Contact deleted successfully"));
    } else {
        echo json_encode(array("message" => "Error: " . mysqli_error($conn)));
    }
}
?> 