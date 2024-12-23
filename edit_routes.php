<?php
    include "connect.php";
    include "Includes/templates/header.php";
    include "Includes/templates/navbar.php";

    // Fetch route details for editing
    if (isset($_GET['id'])) {
        $route_id = $_GET['id'];

        try {
            $stmt = $con->prepare("SELECT * FROM Routes WHERE RouteID = ?");
            $stmt->execute([$route_id]);
            $route = $stmt->fetch();
        } catch (Exception $e) {
            echo "Error fetching route details: " . $e->getMessage();
            exit;
        }

        // If form is submitted, update the route
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $name = $_POST['name'];
            $start_location = $_POST['start_location'];
            $end_location = $_POST['end_location'];
            $total_distance = $_POST['total_distance'];
            $estimated_time = $_POST['estimated_time'];

            try {
                $stmt = $con->prepare("UPDATE Routes SET Name = ?, StartLocation = ?, EndLocation = ?, TotalDistance = ?, EstimatedTime = ? WHERE RouteID = ?");
                $stmt->execute([$name, $start_location, $end_location, $total_distance, $estimated_time, $route_id]);

                header("Location: routes.php"); // Redirect to routes page after update
                exit;
            } catch (Exception $e) {
                echo "Error updating route: " . $e->getMessage();
            }
        }
    }
?>

<!-- EDIT ROUTE FORM -->
<section class="edit-route-section">
    <div class="container">
        <h2 style="text-align: center;">Edit Route</h2>

        <form method="POST">
            <div class="form-group">
                <label for="name">Route Name:</label>
                <input type="text" class="form-control" id="name" name="name" value="<?php echo htmlspecialchars($route['Name']); ?>" required>
            </div>

            <div class="form-group">
                <label for="start_location">Start Location:</label>
                <input type="text" class="form-control" id="start_location" name="start_location" value="<?php echo htmlspecialchars($route['StartLocation']); ?>" required>
            </div>

            <div class="form-group">
                <label for="end_location">End Location:</label>
                <input type="text" class="form-control" id="end_location" name="end_location" value="<?php echo htmlspecialchars($route['EndLocation']); ?>" required>
            </div>

            <div class="form-group">
                <label for="total_distance">Total Distance (km):</label>
                <input type="number" class="form-control" id="total_distance" name="total_distance" value="<?php echo htmlspecialchars($route['TotalDistance']); ?>" required>
            </div>

            <div class="form-group">
                <label for="estimated_time">Estimated Time (hrs):</label>
                <input type="number" class="form-control" id="estimated_time" name="estimated_time" value="<?php echo htmlspecialchars($route['EstimatedTime']); ?>" required>
            </div>

            <button type="submit" class="btn btn-warning">Update Route</button>
        </form>
    </div>
</section>

<!-- FOOTER -->
<?php include "Includes/templates/footer.php"; ?>
