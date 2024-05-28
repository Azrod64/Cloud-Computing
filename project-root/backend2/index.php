<?php

header('Access-Control-Allow-Origin: http://localhost:8080');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

// Database connection

$connect = mysqli_connect(
    'db2', 
    'php_docker2', 
    'password2', 
    'php_docker2'

);

if (!$connect) {
    echo json_encode(['error' => 'Database connection failed']);
    exit();
}



/// Handle POST request for authentication or signup

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $data = json_decode(file_get_contents('php://input'), true);



    if (!isset($data['username']) || !isset($data['password'])) {

        echo json_encode(['error' => 'Invalid data']);

        exit();

    }



    $username = mysqli_real_escape_string($connect, $data['username']);

    $password = mysqli_real_escape_string($connect, $data['password']);



    // Handle signup

    if (isset($data['action']) && $data['action'] === 'signup') {

        $query = "INSERT INTO docker_table_users (user, password) VALUES ('$username', '$password')";



        if (mysqli_query($connect, $query)) {

            echo json_encode(['success' => true]);

        } else {

            echo json_encode(['error' => 'Failed to create account']);

        }



        mysqli_close($connect);

        exit();

    }



    // Handle login

    $query = "SELECT * FROM docker_table_users WHERE user='$username' AND password='$password'";

    $response = mysqli_query($connect, $query);



    if (mysqli_num_rows($response) > 0) {

        $user = mysqli_fetch_assoc($response);

        echo json_encode(['success' => true, 'user' => $user]);

    } else {

        echo json_encode(['error' => 'Invalid username or password']);

    }



    mysqli_close($connect);

    exit();

}



// Handle GET request to fetch all users

elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {

    $query = "SELECT * FROM docker_table_users";

    $response = mysqli_query($connect, $query);



    $data = [];



    if ($response) {

        while ($row = mysqli_fetch_assoc($response)) {

            $data[] = $row;

        }

        echo json_encode($data);

    } else {

        echo json_encode(['error' => 'Query failed']);

    }



    mysqli_close($connect);

    exit();

}



// Handle invalid request methods

else {

    echo json_encode(['error' => 'Invalid request method']);

    mysqli_close($connect);

    exit();

}

?>