<?php
include "connect.php";

$action = $_GET['action'];

switch ($action) {
    case 'add':
        // Add new route
        $name = $_POST['Name'];
        $startLocation = $_POST['StartLocation'];
        $endLocation = $_POST['EndLocation'];
        $totalDistance = $_POST['TotalDistance'];
        $estimatedTime = $_POST['EstimatedTime'];

        $stmt = $con->prepare("INSERT INTO Routes (Name, StartLocation, EndLocation, TotalDistance, EstimatedTime) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$name, $startLocation, $endLocation, $totalDistance, $estimatedTime]);

        break;

    case 'edit':
        // Edit route details
        $data = json_decode(file_get_contents('php://input'), true);
        $routeID = $data['RouteID'];
        $field = $data['field'];
        $value = $data['value'];

        $stmt = $con->prepare("UPDATE Routes SET $field = ? WHERE RouteID = ?");
        $stmt->execute([$value, $routeID]);

        break;

    case 'delete':
        // Delete route
        $data = json_decode(file_get_contents('php://input'), true);
        $routeID = $data['RouteID'];

        $stmt = $con->prepare("DELETE FROM Routes WHERE RouteID = ?");
        $stmt->execute([$routeID]);

        break;

    default:
        break;
}

// Fetch and return updated list of routes
$stmt_routes = $con->prepare("SELECT RouteID, Name, TotalDistance, EstimatedTime, StartLocation, EndLocation FROM Routes");
$stmt_routes->execute();
$rows_routes = $stmt_routes->fetchAll();

if (empty($rows_routes)) {
    echo "<p style='text-align: center; color: red;'>No routes found. Add a new route to get started.</p>";
} else {
    foreach ($rows_routes as $route) {
        echo "<div class='col-md-4 col-lg-3 route-column' data-route-id='{$route['RouteID']}'>
                <div class='thumbnail'>
                    <div class='route-details'>
                        <h5 contenteditable='true' class='editable-route' data-field='Name'>" . htmlspecialchars($route['Name']) . "</h5>
                        <p><strong>Start Location:</strong> <span contenteditable='true' class='editable-route' data-field='StartLocation'>" . htmlspecialchars($route['StartLocation']) . "</span></p>
                        <p><strong>End Location:</strong> <span contenteditable='true' class='editable-route' data-field='EndLocation'>" . htmlspecialchars($route['EndLocation']) . "</span></p>
                        <p><strong>Distance:</strong> <span contenteditable='true' class='editable-route' data-field='TotalDistance'>" . number_format($route['TotalDistance'], 2) . "</span> km</p>
                        <p><strong>Estimated Time:</strong> <span contenteditable='true' class='editable-route' data-field='EstimatedTime'>" . number_format($route['EstimatedTime'], 2) . "</span> hours</p>
                        <div class='route-actions'>
                            <button class='btn btn-danger btn-sm delete-route' data-route-id='{$route['RouteID']}'>Delete</button>
                        </div>
                    </div>
                </div>
            </div>";
    }
}
?>
