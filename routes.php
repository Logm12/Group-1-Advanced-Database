<?php
    $pageTitle = 'Routes';
    include "connect.php";
    include "Includes/templates/header.php";
    include "Includes/templates/navbar.php";

    // Fetch routes, vehicles, and drivers
    try {
        $stmt_routes = $con->prepare("SELECT r.RouteID, r.Name, r.StartLocation, r.EndLocation, r.TotalDistance, r.EstimatedTime, v.LicensePlate, d.Name as DriverName
                                FROM Routes r
                                LEFT JOIN RoutePlans rp ON r.RouteID = rp.RouteID
                                LEFT JOIN Vehicles v ON rp.VehicleID = v.VehicleID
                                LEFT JOIN Drivers d ON rp.DriverID = d.DriverID");
        $stmt_routes->execute();
        $rows_routes = $stmt_routes->fetchAll();
    } catch (Exception $e) {
        echo "Error fetching routes: " . $e->getMessage();
        exit;
    }
?>

<!-- ROUTES MANAGEMENT SECTION -->
<section class="routes-section" id="routes">
    <div class="container">
        <h2 style="text-align: center; margin-bottom: 30px;">Manage Routes</h2>

        <!-- Button to Add New Route -->
        <div style="text-align: center;">
            <a href="add_route.php" class="btn btn-primary">Add New Route</a>
        </div>

        <!-- Route List Table -->
        <table class="table">
            <thead>
                <tr>
                    <th>Route Name</th>
                    <th>Start Location</th>
                    <th>End Location</th>
                    <th>Distance (km)</th>
                    <th>Estimated Time (hrs)</th>
                    <th>Vehicle</th>
                    <th>Driver</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php
                    if (empty($rows_routes)) {
                        echo "<tr><td colspan='8' style='text-align: center;'>No routes available.</td></tr>";
                    } else {
                        foreach ($rows_routes as $route) {
                            echo "<tr>";
                            echo "<td>" . htmlspecialchars($route['Name']) . "</td>";
                            echo "<td>" . htmlspecialchars($route['StartLocation']) . "</td>";
                            echo "<td>" . htmlspecialchars($route['EndLocation']) . "</td>";
                            echo "<td>" . number_format($route['TotalDistance'], 2) . "</td>";
                            echo "<td>" . number_format($route['EstimatedTime'], 2) . "</td>";
                            echo "<td>" . htmlspecialchars($route['LicensePlate']) . "</td>";
                            echo "<td>" . htmlspecialchars($route['DriverName']) . "</td>";
                            echo "<td>
                                    <a href='edit_route.php?id=" . $route['RouteID'] . "' class='btn btn-warning'>Edit</a>
                                    <a href='delete_route.php?id=" . $route['RouteID'] . "' class='btn btn-danger' onclick='return confirm(\"Are you sure you want to delete this route?\")'>Delete</a>
                                  </td>";
                            echo "</tr>";
                        }
                    }
                ?>
            </tbody>
        </table>
    </div>
</section>

<!-- FOOTER -->
<?php include "Includes/templates/footer.php"; ?>
