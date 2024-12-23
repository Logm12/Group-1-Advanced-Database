<?php
    include "connect.php";
    include "Includes/templates/header.php";
    include "Includes/templates/navbar.php";

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        // Get form data
        $name = $_POST['name'];
        $start_location = $_POST['start_location'];
        $end_location = $_POST['end_location'];
        $total_distance = $_POST['total_distance'];
        $estimated_time = $_POST['estimated_time'];

        // Insert new route into the database
        try {
            $stmt = $con->prepare("INSERT INTO Routes (Name, StartLocation, EndLocation, TotalDistance, EstimatedTime) 
                                   VALUES (?, ?, ?, ?, ?)");
            $stmt->execute([$name, $start_location, $end_location, $total_distance, $estimated_time]);

            header("Location: routes.php"); // Redirect to routes page after adding
            exit;
        } catch (Exception $e) {
            echo "Error adding route: " . $e->getMessage();
        }
    }
?>

<!-- ADD ROUTE FORM -->
<section class="add-route-section">
    <div class="container">
        <h2 style="text-align: center;">Add New Route</h2>

        <form method="POST">
            <div class="form-group">
                <label for="name">Route Name:</label>
                <input type="text" class="form-control" id="name" name="name" required>
            </div>

            <div class="form-group">
                <label for="start_location">Start Location:</label>
                <input type="text" class="form-control" id="start_location" name="start_location" required>
            </div>

            <div class="form-group">
                <label for="end_location">End Location:</label>
                <input type="text" class="form-control" id="end_location" name="end_location" required>
            </div>

            <div class="form-group">
                <label for="total_distance">Total Distance (km):</label>
                <input type="number" class="form-control" id="total_distance" name="total_distance" required>
            </div>

            <div class="form-group">
                <label for="estimated_time">Estimated Time (hrs):</label>
                <input type="number" class="form-control" id="estimated_time" name="estimated_time" required>
            </div>

            <button type="submit" class="btn btn-success">Add Route</button>
        </form>
    </div>
</section>

<!-- FOOTER -->
<?php include "Includes/templates/footer.php"; ?>
