<?php
header('Access-Control-Allow-Origin: http://localhost:8080');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

$connect = mysqli_connect(
    'db', 
    'php_docker', 
    'password', 
    'php_docker'
);

if (!$connect) {
    echo json_encode(['error' => 'Database connection failed']);
    exit();
}

$table_name = "docker_table_posts";

// Handle POST request to add a new tweet
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!isset($data['author']) || !isset($data['content'])) {
        echo json_encode(['error' => 'Invalid data']);
        exit();
    }

    $author = mysqli_real_escape_string($connect, $data['author']);
    $content = mysqli_real_escape_string($connect, $data['content']);
    $date_created = date('Y-m-d H:i:s');

    $query = "INSERT INTO $table_name (name, content, date_created) VALUES ('$author', '$content', '$date_created')";

    if (mysqli_query($connect, $query)) {
        echo json_encode(['success' => 'Tweet added']);
    } else {
        echo json_encode(['error' => 'Failed to add tweet']);
    }

    mysqli_close($connect);
    exit();
}

// Handle GET request to fetch tweets
$query = "SELECT * FROM $table_name";

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