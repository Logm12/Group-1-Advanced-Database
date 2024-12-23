<?php
    include "connect.php";
    include 'Includes/functions/functions.php';
    include "Includes/templates/header.php";
    include "Includes/templates/navbar.php";
?>

<!-- HOME SECTION -->
<section class="home-section" id="home">
    <div class="container">
        <div class="row">
            <div class="col-md-12 home-left-section">
                <div style="padding: 100px 0px; color: black;">
                    <h1>High-quality fertilizers</h1>
                    <h2>Helping Plants Grow Best</h2>
                    <hr>
                    <p>We provide the best fertilizers for your plants.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- OUR PRODUCTS SECTION -->
<section class="our_products" id="products">
    <div class="container">
        <h2 style="text-align: center; margin-bottom: 30px">Our Products</h2>
        <div class="row">
            <?php
                // Fetch products from the database
                $stmt_products = $con->prepare("SELECT ProductID, Name, Description, Price, StockQuantity FROM Products");
                $stmt_products->execute();
                $rows_products = $stmt_products->fetchAll();

                // Loop through each product
                foreach($rows_products as $product) {
                    ?>
                    <div class="col-md-4 col-lg-3 product-column">
                        <div class="thumbnail" style="cursor:pointer">
                            <div class="product-image">
                                <div class="image-preview">
                                    <!-- Placeholder for product image -->
                                    <div style="background-color: #f0f0f0; height: 200px;"></div>
                                </div>
                            </div>
                            <div class="caption">
                                <h5><?php echo htmlspecialchars($product['Name']); ?></h5>
                                <p><?php echo htmlspecialchars($product['Description']); ?></p>
                                <span class="product_price"><?php echo "$" . number_format($product['Price'], 2); ?></span><br>
                                <span class="product_stock">Stock: <?php echo $product['StockQuantity']; ?></span>
                                <button class="bttn_style_2 order_button" data-product-id="<?php echo $product['ProductID']; ?>">Order Now!</button>
                            </div>
                        </div>
                    </div>
                    <?php
                }
            ?>
        </div>
    </div>
</section>

<!-- OUR ROUTES SECTION -->
<section class="our_routes" id="routes">
    <div class="container">
        <h2 style="text-align: center; margin-bottom: 30px">Delivery Routes</h2>

        <!-- Add New Route Form -->
        <div style="text-align: center; margin-bottom: 20px;">
            <form id="addRouteForm" style="display: inline-block; max-width: 600px;">
                <input type="text" name="Name" placeholder="Route Name" required>
                <input type="text" name="StartLocation" placeholder="Start Location" required>
                <input type="text" name="EndLocation" placeholder="End Location" required>
                <input type="number" step="0.01" name="TotalDistance" placeholder="Total Distance (km)" required>
                <input type="number" step="0.01" name="EstimatedTime" placeholder="Estimated Time (hours)" required>
                <button type="submit" class="btn btn-success">Add New Route</button>
            </form>
        </div>

        <div class="row" id="routesContainer">
            <?php
                // Fetch routes from the database
                $stmt_routes = $con->prepare("SELECT r.RouteID, r.Name, r.TotalDistance, r.EstimatedTime, r.StartLocation, r.EndLocation 
                                            FROM Routes r");
                $stmt_routes->execute();
                $rows_routes = $stmt_routes->fetchAll();

                // Check if there are routes
                if (empty($rows_routes)) {
                    echo "<p style='text-align: center; color: red;'>No routes found. Add a new route to get started.</p>";
                } else {
                    // Loop through each route and display it
                    foreach($rows_routes as $route) {
                        ?>
                        <div class="col-md-4 col-lg-3 route-column" data-route-id="<?php echo $route['RouteID']; ?>">
                            <div class="thumbnail">
                                <div class="route-details">
                                    <h5 contenteditable="true" class="editable-route" data-field="Name"><?php echo htmlspecialchars($route['Name']); ?></h5>
                                    <p><strong>Start Location:</strong> <span contenteditable="true" class="editable-route" data-field="StartLocation"><?php echo htmlspecialchars($route['StartLocation']); ?></span></p>
                                    <p><strong>End Location:</strong> <span contenteditable="true" class="editable-route" data-field="EndLocation"><?php echo htmlspecialchars($route['EndLocation']); ?></span></p>
                                    <p><strong>Distance:</strong> <span contenteditable="true" class="editable-route" data-field="TotalDistance"><?php echo number_format($route['TotalDistance'], 2); ?></span> km</p>
                                    <p><strong>Estimated Time:</strong> <span contenteditable="true" class="editable-route" data-field="EstimatedTime"><?php echo number_format($route['EstimatedTime'], 2); ?></span> hours</p>
                                    <div class="route-actions">
                                        <button class="btn btn-danger btn-sm delete-route" data-route-id="<?php echo $route['RouteID']; ?>">Delete</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <?php
                    }
                }
            ?>
        </div>
    </div>
</section>

<script>
    // Add New Route
    document.getElementById('addRouteForm').addEventListener('submit', function (e) {
        e.preventDefault();
        const formData = new FormData(this);
        fetch('ajax_routes.php?action=add', {
            method: 'POST',
            body: formData
        })
        .then(response => response.text())
        .then(data => {
            document.getElementById('routesContainer').innerHTML = data;
            this.reset();
        });
    });

    // Inline Edit Route
    document.addEventListener('blur', function (e) {
        if (e.target.classList.contains('editable-route')) {
            const routeID = e.target.closest('.route-column').dataset.routeId;
            const field = e.target.dataset.field;
            const value = e.target.textContent.trim();

            fetch('ajax_routes.php?action=edit', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ RouteID: routeID, field: field, value: value })
            });
        }
    }, true);

    // Delete Route
    document.addEventListener('click', function (e) {
        if (e.target.classList.contains('delete-route')) {
            if (confirm('Are you sure you want to delete this route?')) {
                const routeID = e.target.dataset.routeId;

                fetch('ajax_routes.php?action=delete', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ RouteID: routeID })
                })
                .then(response => response.text())
                .then(data => {
                    document.getElementById('routesContainer').innerHTML = data;
                });
            }
        }
    });
</script>
