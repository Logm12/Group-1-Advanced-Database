<?php
ob_start();
session_start();

$pageTitle = 'Users';

if (isset($_SESSION['username']) && isset($_SESSION['password'])) {
    include 'connect.php';
    include 'Includes/functions/functions.php'; 
    include 'Includes/templates/header.php';
    include 'Includes/templates/navbar.php';

    $do = isset($_GET['do']) ? $_GET['do'] : 'Manage';
    ?>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <script type="text/javascript">
        var vertical_menu = document.getElementById("vertical-menu");
        var current = vertical_menu.getElementsByClassName("active_link");

        if (current.length > 0) {
            current[0].classList.remove("active_link");   
        }
        
        vertical_menu.getElementsByClassName('users_link')[0].className += " active_link";
    </script>

    <?php
if ($do == "Manage") {
    // Fetch users from the database
    $stmt = $con->prepare("SELECT Users.UserID, Users.Username, Users.Email, Users.CreatedAtDate, Users.CreatedAtTime, Users.UpdatedAtDate, Users.UpdatedAtTime, Roles.RoleName 
    FROM Users 
    JOIN Roles ON Users.RoleID = Roles.RoleID");
    $stmt->execute();
    $users = $stmt->fetchAll();

    ?>
    <div class="card mt-4">
        <div class="card-header d-flex justify-content-between align-items-center">
            <span><?php echo $pageTitle; ?></span>
            <a href="users.php?do=Add" class="btn btn-primary btn-sm">Add User</a>
        </div>
        <div class="card-body">
            <table class="table table-bordered users-table">
                <thead>
                    <tr>
                        <th scope="col">Username</th>
                        <th scope="col">E-mail</th>
                        <th scope="col">Role</th>
                        <th scope="col">Created At</th>
                        <th scope="col">Updated At</th>
                        <th scope="col">Manage</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    if (!empty($users)) {
                        foreach ($users as $user) {
                            echo "<tr>";
                            echo "<td>" . $user['Username'] . "</td>";
                            echo "<td>" . $user['Email'] . "</td>";
                            echo "<td>" . $user['RoleName'] . "</td>";
                            echo "<td>" . $user['CreatedAtDate'] . " " . $user['CreatedAtTime'] . "</td>";
                            echo "<td>" . $user['UpdatedAtDate'] . " " . $user['UpdatedAtTime'] . "</td>";
                            echo "<td>";
                            echo "<a href='users.php?do=Edit&user_id=" . $user['UserID'] . "' class='btn btn-success btn-sm rounded-0' style='color: white;'>";
                            echo "<i class='fa fa-edit'></i>";
                            echo "</a> ";
                            echo "<a href='users.php?do=Delete&user_id=" . $user['UserID'] . "' class='btn btn-danger btn-sm rounded-0' style='color: white;' onclick='return confirm(\"Are you sure you want to delete this user?\");'>";
                            echo "<i class='fa fa-trash'></i>";
                            echo "</a>";
                            echo "</td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='6' class='text-center'>No users found</td></tr>";
                    }
                    ?>
                </tbody>
            </table>
        </div>
    </div>
    <?php
} elseif ($do == 'Add') {
    ?>
    <div class="card">
        <div class="card-header">
            Add User
        </div>
        <div class="card-body">
            <form method="POST" action="users.php?do=Add">
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" name="Username" id="username" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="email">E-mail:</label>
                    <input type="email" name="Email" id="email" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="role">Role:</label>
                    <select name="role" id="role" class="form-control">
                        <option value="">Select Role</option>
                        <?php
                        $roles_stmt = $con->prepare("SELECT RoleID, RoleName FROM Roles");
                        $roles_stmt->execute();
                        $roles = $roles_stmt->fetchAll();
                        foreach ($roles as $role) {
                            echo "<option value='{$role['RoleID']}'>{$role['RoleName']}</option>";
                        }
                        ?>
                    </select>
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" name="Password" id="password" class="form-control" required>
                </div>
                <button type="submit" name="add_user_sbmt" class="btn btn-primary">Add User</button>
            </form>
        </div>
    </div>
    <?php

    if (isset($_POST['add_user_sbmt']) && $_SERVER['REQUEST_METHOD'] == 'POST') {
        $user_name = test_input($_POST['Username']);
        $user_email = test_input($_POST['Email']);
        $role_id = test_input($_POST['role']);
        $user_password = sha1(test_input($_POST['Password']));

        $stmt = $con->prepare("INSERT INTO Users (Username, Email, Password, RoleID, CreatedAtDate, CreatedAtTime) VALUES (?, ?, ?, ?, CURDATE(), CURTIME())");
        $stmt->execute(array($user_name, $user_email, $user_password, $role_id));

        echo "<script>
            swal('Add User', 'User has been added successfully', 'success')
            .then(() => {
                window.location.replace('users.php');
            });
        </script>";
        exit();
    }
} elseif ($do == 'Edit') {
    $user_id = (isset($_GET['user_id']) && is_numeric($_GET['user_id'])) ? intval($_GET['user_id']) : 0;

    if ($user_id) {
        $stmt = $con->prepare("SELECT Users.UserID, Users.Username, Users.Email, Users.RoleID, Roles.RoleName 
        FROM Users 
        JOIN Roles ON Users.RoleID = Roles.RoleID WHERE Users.UserID = ?");
        $stmt->execute(array($user_id));
        $user = $stmt->fetch();

        if ($user) {
            ?>
            <div class="card">
                <div class="card-header">
                    Edit User
                </div>
                <div class="card-body">
                    <form method="POST" action="users.php?do=Edit&user_id=<?php echo $user['UserID']; ?>">
                        <div class="form-group">
                            <label for="username">Username:</label>
                            <input type="text" name="Username" id="username" class="form-control" value="<?php echo $user['Username']; ?>" required>
                        </div>
                        <div class="form-group">
                            <label for="email">E-mail:</label>
                            <input type="email" name="Email" id="email" class="form-control" value="<?php echo $user['Email']; ?>" required>
                        </div>
                        <div class="form-group">
                            <label for="role">Role:</label>
                            <select name="role" id="role" class="form-control">
                                <option value="">Select Role</option>
                                <?php
                                $roles_stmt = $con->prepare("SELECT RoleID, RoleName FROM Roles");
                                $roles_stmt->execute();
                                $roles = $roles_stmt->fetchAll();
                                foreach ($roles as $role) {
                                    $selected = ($role['RoleID'] == $user['RoleID']) ? 'selected' : '';
                                    echo "<option value='{$role['RoleID']}' $selected>{$role['RoleName']}</option>";
                                }
                                ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="password">Password (leave blank to keep unchanged):</label>
                            <input type="password" name="user_password" id="password" class="form-control">
                        </div>
                        <button type="submit" name="edit_user_sbmt" class="btn btn-primary">Save</button>
                    </form>
                </div>
            </div>
            <?php
        } else {
            echo "User not found.";
        }
    } else {
        header('Location: users.php');
        exit();
    }

    if (isset($_POST['edit_user_sbmt']) && $_SERVER['REQUEST_METHOD'] == 'POST') {
        $user_name = test_input($_POST['Username']);
        $user_email = test_input($_POST['Email']);
        $role_id = test_input($_POST['role']);
        $user_password = $_POST['user_password'] ?? '';

        if (empty($user_password)) {
            $stmt = $con->prepare("UPDATE Users SET Username = ?, Email = ?, RoleID = ?, UpdatedAtDate = CURDATE(), UpdatedAtTime = CURTIME() WHERE UserID = ?");
            $stmt->execute(array($user_name, $user_email, $role_id, $user_id));
        } else {
            $user_password = sha1($user_password);
            $stmt = $con->prepare("UPDATE Users SET Username = ?, Email = ?, Password = ?, RoleID = ?, UpdatedAtDate = CURDATE(), UpdatedAtTime = CURTIME() WHERE UserID = ?");
            $stmt->execute(array($user_name, $user_email, $user_password, $role_id, $user_id));
        }

        echo "<script>
            swal('Edit User', 'User has been updated successfully', 'success')
            .then(() => {
                window.location.replace('users.php');
            });
        </script>";
        exit();
    }

} elseif ($do == 'Delete') {
    $user_id = (isset($_GET['user_id']) && is_numeric($_GET['user_id'])) ? intval($_GET['user_id']) : 0;

    if ($user_id) {
        $stmt = $con->prepare("DELETE FROM Users WHERE UserID = ?");
        $stmt->execute(array($user_id));

        echo "<script>
            swal('Delete User', 'User has been deleted successfully', 'success')
            .then(() => {
                window.location.replace('users.php');
            });
        </script>";
        exit();
    } else {
        header('Location: users.php');
        exit();
    }
}

    include 'Includes/templates/footer.php';
} else {
    header('Location: index.php');
    exit();
}
