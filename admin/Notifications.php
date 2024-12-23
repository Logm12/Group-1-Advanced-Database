<?php
ob_start();
session_start();

$pageTitle = 'Notifications';

if (isset($_SESSION['username']) && isset($_SESSION['password'])) {
    include 'connect.php';
    include 'Includes/functions/functions.php'; 
    include 'Includes/templates/header.php';
    include 'Includes/templates/navbar.php';

    // Fetch notifications for the logged-in user
    $user_id = 1; // Assuming the logged-in user ID is 1; update dynamically if needed
    try {
        $stmt = $con->prepare(
            "SELECT n.NotificationID, n.NotificationType, n.NotificationMessage, n.CreatedAtDate, n.CreatedAtTime, 
                    ns.StatusName AS NotificationStatus
             FROM Notifications n
             LEFT JOIN NotificationStatuses ns ON n.NotificationStatusID = ns.NotificationStatusID
             WHERE n.UserID = ? 
             ORDER BY n.CreatedAtDate DESC, n.CreatedAtTime DESC"
        );
        $stmt->execute([$user_id]);
        $notifications = $stmt->fetchAll();
    } catch (Exception $e) {
        echo "<div class='alert alert-danger'>Error fetching notifications: " . htmlspecialchars($e->getMessage()) . "</div>";
    }

    ?>

    <div class="container">
        <h2>Notifications</h2>
        <?php if (!empty($notifications)) { ?>
            <ul class="list-group">
                <?php foreach ($notifications as $notification) { ?>
                    <li class="list-group-item">
                        <strong><?php echo htmlspecialchars($notification['NotificationType']); ?>:</strong> 
                        <?php echo htmlspecialchars($notification['NotificationMessage']); ?>
                        <br>
                        <small>On <?php echo htmlspecialchars($notification['CreatedAtDate']); ?> at <?php echo htmlspecialchars($notification['CreatedAtTime']); ?> - Status: <?php echo htmlspecialchars($notification['NotificationStatus']); ?></small>
                    </li>
                <?php } ?>
            </ul>
        <?php } else { ?>
            <div class="alert alert-info">No notifications available.</div>
        <?php } ?>
    </div>

    <?php
    include 'Includes/templates/footer.php';
} else {
    header('Location: index.php');
    exit();
}
?>