DROP DATABASE Group1;
CREATE DATABASE Group1;
Use Group1;
CREATE TABLE Customers (
  CustomerID INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(100),
  PhoneNumber VARCHAR(15),
  Address VARCHAR(255),
  Email VARCHAR(100),
  DateOfBirth DATE,
  Gender VARCHAR(10),
  JoinDate DATE ,
  LoyaltyPoints INT DEFAULT 0
);
LOAD DATA INFILE 'E:\\Data\\Order_Management\\Customer(1).csv'
INTO TABLE Customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Status VARCHAR(50),
    PaymentMethod VARCHAR(50),
    DeliveryDate DATE,
    ShippingAddress VARCHAR(255),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
LOAD DATA INFILE 'E:\\Data\\Order_Management\\Orders(1).csv'
INTO TABLE Orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(150),
    Description TEXT,
    Price DECIMAL(10, 2),
    StockQuantity INT,
    ReorderLevel INT,
    LastRestockDate DATE
);
LOAD DATA INFILE 'E:\\Data\\Order_Management\\Products.csv'
INTO TABLE Products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    Discount DECIMAL(5, 2) DEFAULT 0,
    Tax DECIMAL(5, 2) DEFAULT 0,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

LOAD DATA INFILE 'E:\\Data\\Order_Management\\OrderDetails.csv'
INTO TABLE OrderDetails
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- 2. Inventory Tracking
CREATE TABLE Warehouses (
    WarehouseID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(150),
    Location VARCHAR(255)
);

LOAD DATA INFILE 'E:\\Data\\Inventory_tracking\\Warehouses.csv'
INTO TABLE Warehouses
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE InventoryItems (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    WarehouseID INT,
    ProductID INT,
    Quantity INT,
    LastUpdated TIME,
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
LOAD DATA INFILE 'E:\\Data\\Inventory_tracking\\Inventory_items.csv'
INTO TABLE InventoryItems
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- 3. Route Planning and Optimization
CREATE TABLE Vehicles (
    VehicleID INT AUTO_INCREMENT PRIMARY KEY,
    LicensePlate VARCHAR(50),
    Capacity INT,
    Type VARCHAR(50),
    Status VARCHAR(50)
);

LOAD DATA INFILE 'E:\\Data\\Route Planning and Optimization\\Vehicle1.csv'
INTO TABLE Vehicles
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE Drivers (
    DriverID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Location VARCHAR(255)
);

LOAD DATA INFILE 'E:\\Data\\Route Planning and Optimization\\Drivers.csv'
INTO TABLE Drivers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE RouteTypes (
  RouteTypeID INT AUTO_INCREMENT PRIMARY KEY,
  Type VARCHAR(50) NOT NULL
);

LOAD DATA INFILE 'E:\\Data\\Route Planning and Optimization\\Route_type.csv'
INTO TABLE RouteTypes
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE Routes (
    RouteID INT AUTO_INCREMENT PRIMARY KEY,
    RouteTypeID INT,
    Name VARCHAR(150),
    TotalDistance DECIMAL(10, 2),
    EstimatedTime DECIMAL(5, 2),
    StartLocation VARCHAR(255),
    EndLocation VARCHAR(400),
    FOREIGN KEY (RouteTypeID) REFERENCES RouteTypes(RouteTypeID)
);
LOAD DATA INFILE 'E:\\Data\\Route Planning and Optimization\\Routes.csv'
INTO TABLE Routes
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
CREATE TABLE RoutePlans (
    RoutePlanID INT AUTO_INCREMENT PRIMARY KEY,
    RouteID INT,
    VehicleID INT,
    DriverID INT,
    StartTime TIME,
    EndTime TIME,
    FOREIGN KEY (RouteID) REFERENCES Routes(RouteID),
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID),
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID)
);

LOAD DATA INFILE 'E:\\Data\\Route Planning and Optimization\\Route_plans.csv'
INTO TABLE RoutePlans
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- 4. Customer Management
CREATE TABLE ActionTypes (
    ActionTypeID INT AUTO_INCREMENT PRIMARY KEY,
    ActionName VARCHAR(255) NOT NULL
);
LOAD DATA INFILE 'E:\\Data\\Customer_management\\Action_Types.csv'
INTO TABLE ActionTypes
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE CustomerBehavior (
    BehaviorID INT AUTO_INCREMENT PRIMARY KEY, 
    CustomerID INT,
    ActionTypeID INT,
    ActionDate DATE,
    Time TIME,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ActionTypeID) REFERENCES ActionTypes(ActionTypeID)
);

LOAD DATA INFILE 'E:\\Data\\Customer_management\\Customer_Behavior.csv'
INTO TABLE CustomerBehavior
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE InteractionTypes (
  InteractionTypeID INT AUTO_INCREMENT PRIMARY KEY,
  InteractionTypeName VARCHAR(100) NOT NULL 
);
LOAD DATA INFILE 'E:\\Data\\Customer_management\\InteractionTypes.csv'
INTO TABLE InteractionTypes
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- Customer Interactions
CREATE TABLE CustomerInteractions (
  InteractionID INT AUTO_INCREMENT PRIMARY KEY,
  CustomerID INT,
  InteractionTypeID INT,
  InteractionDate DATE,
  Time TIME,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  FOREIGN KEY (InteractionTypeID) REFERENCES InteractionTypes(InteractionTypeID)
);
LOAD DATA INFILE 'E:\\Data\\Customer_management\\Customer_Interactions.csv'
INTO TABLE CustomerInteractions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE CustomerSegments (
  SegmentID INT AUTO_INCREMENT PRIMARY KEY,
  SegmentName VARCHAR(100) NOT NULL
);
LOAD DATA INFILE 'E:\\Data\\Customer_management\\Customer_segment.csv'
INTO TABLE CustomerSegments
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE CustomerSegmentMappings (
  MappingID INT AUTO_INCREMENT PRIMARY KEY,
  CustomerID INT,
  SegmentID INT,
  AssignedDate DATE,
  Time TIME,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  FOREIGN KEY (SegmentID) REFERENCES CustomerSegments(SegmentID)
);
LOAD DATA INFILE 'E:\\Data\\Customer_management\\Customer_segment_mapping.csv'
INTO TABLE CustomerSegmentMappings
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- 6. User Access Control
CREATE TABLE Roles (
    RoleID INT AUTO_INCREMENT PRIMARY KEY,
    RoleName VARCHAR(255) NOT NULL,
    Description TEXT
);
LOAD DATA INFILE 'E:\\Data\\User Access Control\\Roles.csv'
INTO TABLE Roles
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(255) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    RoleID INT NOT NULL,
    CreatedAtDate DATE,
	CreatedAtTime TIME,
    UpdatedAtDate DATE,
    UpdatedAtTime TIME,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);
LOAD DATA INFILE 'E:\\Data\\User Access Control\\Users.csv'
INTO TABLE Users
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE Permissions (
    PermissionID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT
);
LOAD DATA INFILE 'E:\\Data\\User Access Control\\Permissions.csv'
INTO TABLE Permissions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE RolePermissions (
    RolePermissionID INT AUTO_INCREMENT PRIMARY KEY,
    RoleID INT NOT NULL,
    PermissionID INT NOT NULL,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    FOREIGN KEY (PermissionID) REFERENCES Permissions(PermissionID)
);
LOAD DATA INFILE 'E:\\Data\\User Access Control\\RolePermissions.csv'
INTO TABLE RolePermissions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 5. Reporting and Analytics
CREATE TABLE Reports (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    Name VARCHAR(255) NOT NULL,
    GeneratedBY INT, 
    Type ENUM('Sales', 'Inventory', 'Customer') NOT NULL,
    GeneratedAtDate DATE,
    Time TIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

LOAD DATA INFILE 'E:\\Data\\Reporting and Analytics\\Reports.csv'
INTO TABLE Reports
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE ReportData (
    ReportDataID INT AUTO_INCREMENT PRIMARY KEY,
    ReportID INT NOT NULL,
    DataKey VARCHAR(255) NOT NULL,
    FOREIGN KEY (ReportID) REFERENCES Reports(ReportID)
);

LOAD DATA INFILE 'E:\\Data\\Reporting and Analytics\\Report_data.csv'
INTO TABLE ReportData
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 7. Multi-location Support
CREATE TABLE Locations (
    LocationID INT AUTO_INCREMENT PRIMARY KEY,
    LocationName VARCHAR(255) NOT NULL,
    Address VARCHAR(255) NOT NULL
);
LOAD DATA INFILE 'E:\\Data\\Multi-location Support\\Locations.csv'
INTO TABLE Locations
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
CREATE TABLE InventoryLocations (
    InventoryLocationID INT AUTO_INCREMENT PRIMARY KEY,
    LocationID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
LOAD DATA INFILE 'E:\\Data\\Multi-location Support\\Inventory_locations.csv'
INTO TABLE InventoryLocations
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- 8. Mobile Access
CREATE TABLE MobileDevices (
    DeviceID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    DeviceType VARCHAR(50) NOT NULL,
    DeviceToken VARCHAR(255) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
LOAD DATA INFILE 'E:\\Data\\Mobile_access\\Mobile_Devices.csv'
INTO TABLE MobileDevices
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
CREATE TABLE MobileAccessLogs (
    MobileAccessID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    DeviceID INT,
    LocationID INT,
    AccessTime DATE NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (DeviceID) REFERENCES MobileDevices(DeviceID),
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);
LOAD DATA INFILE 'E:\\Data\\Mobile_access\\Mobile_Access_logs.csv'
INTO TABLE MobileAccessLogs
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- 9. Integration with ERP
CREATE TABLE ERPSystems (
    ERPSystemID INT AUTO_INCREMENT PRIMARY KEY,
    ERPSystemName VARCHAR(255) NOT NULL
);
LOAD DATA INFILE 'E:\\Data\\Integration with ERP\\ERPSystems.csv'
INTO TABLE ERPSystems
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
CREATE TABLE ERPIntegrations (
    ERPIntegrationID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    ERPSystemID INT,
    IntegrationDate DATE NOT NULL,
    Status VARCHAR(50) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ERPSystemID) REFERENCES ERPSystems(ERPSystemID)
);
LOAD DATA INFILE 'E:\\Data\\Integration with ERP\\ERPIntegrations.csv'
INTO TABLE ERPIntegrations
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- 10. Real-time Updates
CREATE TABLE RealTimeInventory (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    StockQuantity INT NOT NULL,
    LastUpdated DATE, 
    Time TIME
);
LOAD DATA INFILE 'E:\\Data\\Real-time Updates\\RealTimeInventory.csv'
INTO TABLE  RealTimeInventory
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
CREATE TABLE OrderStatuses (
  OrderStatusID INT AUTO_INCREMENT PRIMARY KEY,
  StatusName VARCHAR(50) NOT NULL
);
LOAD DATA INFILE 'E:\\Data\\Real-time Updates\\OrderStatuses.csv'
INTO TABLE  OrderStatuses
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE RealTimeOrders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    OrderStatusID INT,
    CreatedAtDate DATE,
    CreatedAtTime TIME,
    UpdatedAtDate DATE,
    UpdatedAtTime TIME,
    FOREIGN KEY (ProductID) REFERENCES RealTimeInventory(ProductID),
    FOREIGN KEY (OrderStatusID) REFERENCES OrderStatuses(OrderStatusID)
);
LOAD DATA INFILE 'E:\\Data\\Real-time Updates\\Real_time_order.csv'
INTO TABLE RealTimeOrders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE ShipmentStatuses (
  ShipmentStatusID INT AUTO_INCREMENT PRIMARY KEY,
  StatusName VARCHAR(50) NOT NULL
);
LOAD DATA INFILE 'E:\\Data\\Real-time Updates\\Shipment_status.csv'
INTO TABLE ShipmentStatuses
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE Shipments (
    ShipmentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ShipmentStatusID INT,
    ShipmentDate DATE,
    ShipmentTime TIME,
    FOREIGN KEY (OrderID) REFERENCES RealTimeOrders(OrderID),
    FOREIGN KEY (ShipmentStatusID) REFERENCES ShipmentStatuses(ShipmentStatusID)
);
LOAD DATA INFILE 'E:\\Data\\Real-time Updates\\Shipments.csv'
INTO TABLE Shipments
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 11. Audit Trail
CREATE TABLE AuditTrails (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    TableName VARCHAR(255) NOT NULL,
    ActionType ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    ChangedData TEXT,
    ChangedBy VARCHAR(255),
    ChangedAtDate DATE,
    ChangedAtTime TIME
);
LOAD DATA INFILE 'E:\\Data\\Audit_Trail\\AuditTrails.csv'
INTO TABLE AuditTrails
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 12. Notifications
CREATE TABLE NotificationStatuses (
  NotificationStatusID INT AUTO_INCREMENT PRIMARY KEY,
  StatusName VARCHAR(50) NOT NULL
);
LOAD DATA INFILE 'E:\\Data\\Notifications\\Notification_status.csv'
INTO TABLE NotificationStatuses
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE Notifications (
    NotificationID INT AUTO_INCREMENT PRIMARY KEY,
	NotificationStatusID INT,
    UserID INT NOT NULL,
    NotificationType VARCHAR(50) NOT NULL,
    NotificationMessage TEXT NOT NULL,
    CreatedAtDate DATE,
    CreatedAtTime TIME,
    FOREIGN KEY (UserID) REFERENCES ers(UserID),
    FOREIGN KEY (NotificationStatusID) REFERENCES NotificationStatuses(NotificationStatusID)
);
LOAD DATA INFILE 'E:\\Data\\Notifications\\Notification1.csv'
INTO TABLE Notifications
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- Use case: Order Management
-- 1. Create New Order
START TRANSACTION;
INSERT INTO Orders (CustomerID, OrderDate, Status, PaymentMethod, DeliveryDate, ShippingAddress)
VALUES (1, CURDATE(), 'Pending', 'Credit Card', DATE_ADD(CURDATE(), INTERVAL 5 DAY), 'Ha Noi');
COMMIT;
SELECT * FROM Orders;
-- 2. Update Order Status
START TRANSACTION;
UPDATE Orders 
SET Status = 'Processing' 
WHERE OrderID = 1;
COMMIT;
SELECT * FROM Orders;
-- 3. View Canceled Order Details
SELECT o.OrderDate, c.CustomerID, c.Name, o.Status 
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.Status = 'cancelled'
ORDER BY o.OrderDate;
-- Use Case:  Inventory Tracking
-- 1. Update inventory when there are changes
DELIMITER //
CREATE PROCEDURE UpdateInventoryAfterOrder(IN order_id INT)
BEGIN
    DECLARE product_id INT;
    DECLARE product_quantity INT;
    DECLARE done INT DEFAULT 0;
    
    DECLARE product_cursor CURSOR FOR
        SELECT ProductID, Quantity
        FROM OrderDetails
        WHERE OrderID = order_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN product_cursor;
    read_loop: LOOP
        FETCH product_cursor INTO product_id, product_quantity;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Update inventory quantity
        UPDATE InventoryItems
        SET Quantity = Quantity - product_quantity
        WHERE ProductID = product_id;
    END LOOP;
    CLOSE product_cursor;
END //
DELIMITER ;

SET SQL_SAFE_UPDATES = 0;

CALL UpdateInventoryAfterOrder(1);

SELECT * FROM InventoryItems WHERE ProductID IN (SELECT ProductID FROM OrderDetails WHERE OrderID = 1);
 -- Performance
 SET profiling = 1;
CALL UpdateInventoryAfterOrder(1);
SHOW PROFILES;

-- Use case 2: Automatically warn when inventory is low
DELIMITER $$
CREATE TRIGGER CheckInventoryLevel
AFTER UPDATE ON InventoryLocations
FOR EACH ROW
BEGIN
    DECLARE productReorderLevel INT;
    DECLARE productName VARCHAR(255);
    DECLARE locationName VARCHAR(255);
    DECLARE alertMessage VARCHAR(255);
    -- Lấy giá trị ReorderLevel từ bảng Products
    SELECT ReorderLevel INTO productReorderLevel
    FROM Products
    WHERE ProductID = NEW.ProductID;
    -- Lấy tên sản phẩm và tên kho từ các bảng tương ứng
    SELECT Name INTO productName
    FROM Products
    WHERE ProductID = NEW.ProductID;

    SELECT LocationName INTO locationName
    FROM Locations
    WHERE LocationID = NEW.LocationID;
    -- Tạo thông báo cảnh báo
    SET alertMessage = CONCAT('ALERT: Stock for product "', productName, '" is low at Location "', locationName, '". Current stock: ', NEW.Quantity);
    -- Kiểm tra nếu tồn kho dưới mức ReorderLevel, tạo cảnh báo
    IF NEW.Quantity < productReorderLevel THEN
        -- Ném ra một lỗi cảnh báo
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = alertMessage;
    END IF;
END $$
DELIMITER ;
-- Route Planning and Optimization
-- 1. Automatic Route Plan Creation
	 -- Stored Procedure (Create automatic delivery plans)
	DELIMITER $$
	CREATE PROCEDURE CreateRoutePlan(
		IN route_id INT,
		IN start_time DATETIME,
		IN end_time DATETIME,
		IN driver_id INT,
		IN vehicle_id INT
	)
	BEGIN
		DECLARE vehicle_capacity INT;
		DECLARE exit_handler_for_sqlstate CONDITION FOR SQLSTATE '45000';  -- Định nghĩa lỗi tùy chỉnh
		-- Kiểm tra xem phương tiện có tồn tại hay không
		SELECT Capacity INTO vehicle_capacity
		FROM Vehicles
		WHERE VehicleID = vehicle_id;
		-- Nếu không tìm thấy phương tiện, báo lỗi
		IF vehicle_capacity IS NULL THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Vehicle not found';
		END IF;
		-- Chèn thông tin vào bảng RoutePlans
		INSERT INTO RoutePlans (RouteID, DriverID, VehicleID, StartTime, EndTime)
		VALUES (route_id, driver_id, vehicle_id, start_time, end_time);
		-- Thông báo thành công
		SELECT 'Route plan created successfully' AS Status;
	END$$
	DELIMITER ;

	CALL CreateRoutePlan(2, '2024-12-23 09:00:00', '2024-12-23 17:00:00', 7, 3);

	SELECT * FROM RoutePlans;
	 -- Trigger (Check the capabilities of the vehicle and driver before creating a plan)
	 DELIMITER $$
	CREATE TRIGGER check_vehicle_and_driver_before_insert
	BEFORE INSERT ON RoutePlans
	FOR EACH ROW
	BEGIN
		-- Khai báo các biến
		DECLARE vehicle_capacity INT;
		DECLARE driver_exists INT;
		-- Kiểm tra phương tiện có tồn tại không
		SELECT Capacity INTO vehicle_capacity
		FROM Vehicles
		WHERE VehicleID = NEW.VehicleID;
		-- Nếu phương tiện không tồn tại, báo lỗi
		IF vehicle_capacity IS NULL THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Vehicle not found';
		END IF;
		-- Kiểm tra lái xe có hợp lệ không
		SELECT COUNT(*) INTO driver_exists
		FROM Drivers
		WHERE DriverID = NEW.DriverID;
		-- Nếu lái xe không tồn tại, báo lỗi
		IF driver_exists = 0 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Driver not found';
		END IF;
		-- Kiểm tra thời gian (start_time phải trước end_time)
		IF NEW.StartTime >= NEW.EndTime THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Start time must be before end time';
		END IF;
	END$$

	DELIMITER ;

	INSERT INTO RoutePlans (VehicleID, DriverID, StartTime, EndTime)
	VALUES (9999, 1, '2024-12-23 09:00:00', '2024-12-23 17:00:00');

	 -- View (Display delivery plan information)
	CREATE OR REPLACE VIEW RoutePlansView AS
	SELECT
		rp.RoutePlanID,
		rp.VehicleID,
		v.Capacity AS VehicleCapacity,
		rp.DriverID,
		d.Name AS DriverName,  -- Giả sử tên cột đúng là 'Name' trong bảng 'Drivers'
		rp.StartTime,
		rp.EndTime
	FROM
		RoutePlans rp
	JOIN Vehicles v ON rp.VehicleID = v.VehicleID
	JOIN Drivers d ON rp.DriverID = d.DriverID;

	SELECT * FROM RoutePlansView;
	-- Performance of procedure 
	SET profiling = 1;
	CALL CreateRoutePlan(2, '2024-12-23 09:00:00', '2024-12-23 17:00:00', 7, 3);
	SHOW PROFILE FOR QUERY 1;

	-- Performance of trigger 
	SET profiling = 1;
	INSERT INTO RoutePlans (VehicleID, DriverID, StartTime, EndTime) VALUES (2, 1, '2024-12-23 09:00:00', '2024-12-23 17:00:00');
	SHOW PROFILE FOR QUERY 1;
	-- -- Performance of view 
	EXPLAIN SELECT * FROM RoutePlansView;

-- 2. Calculate total distance and delivery time for each route
CREATE OR REPLACE VIEW RouteAnalytics AS
SELECT 
    rp.RouteID,
    COUNT(DISTINCT rp.RoutePlanID) AS TotalPlans,         -- Tổng số kế hoạch giao hàng trên tuyến
    SUM(r.TotalDistance) AS TotalDistance,               -- Tổng quãng đường giao hàng
    TIMESTAMPDIFF(MINUTE, MIN(rp.StartTime), MAX(rp.EndTime)) AS TotalTimeSpent, -- Tổng thời gian trên tuyến
    COUNT(DISTINCT o.OrderID) AS TotalOrders             -- Tổng số đơn hàng đã xử lý trên tuyến
FROM 
    RoutePlans rp
JOIN 
    Routes r ON rp.RouteID = r.RouteID
LEFT JOIN 
    Orders o ON o.Status = 'Delivered' AND rp.RouteID = r.RouteID -- Hoặc thay điều kiện JOIN khác nếu cần
GROUP BY 
    rp.RouteID; 
SELECT * FROM RouteAnalytics;
 -- Performance
SET profiling = 1;
SELECT SQL_NO_CACHE * FROM RouteAnalytics;
SHOW PROFILES;

-- Customer Management
-- 1.  Record customer behavior
DELIMITER //
CREATE TRIGGER RecordCustomerBehaviorAfterOrder
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    DECLARE actionTypeID INT;
    DECLARE currentTime TIME;
    DECLARE currentDate DATE;
    -- Lấy ActionTypeID từ bảng ActionTypes 
    SELECT ActionTypeID INTO actionTypeID
    FROM ActionTypes
    WHERE ActionName = 'Order placed';  -- Hoặc bạn có thể thay đổi hành động ở đây
    -- Lấy thời gian và ngày hiện tại
    SET currentTime = CURRENT_TIME;
    SET currentDate = CURRENT_DATE;
    -- Ghi nhận hành vi của khách hàng vào bảng CustomerBehavior
    INSERT INTO CustomerBehavior (CustomerID, ActionTypeID, ActionDate, Time)
    VALUES (NEW.CustomerID, actionTypeID, currentDate, currentTime);
END//
DELIMITER ;
-- 2. Analyze Customer Segments
SELECT c.Name, cs.SegmentName, at.ActionName, COUNT(cb.ActionTypeID) AS ActionCount
FROM Customers c
JOIN CustomerSegmentMappings csm ON c.CustomerID = csm.CustomerID
JOIN CustomerSegments cs ON csm.SegmentID = cs.SegmentID
JOIN CustomerBehavior cb ON c.CustomerID = cb.CustomerID
JOIN ActionTypes at ON cb.ActionTypeID = at.ActionTypeID
GROUP BY c.Name, cs.SegmentName, at.ActionName
ORDER BY cs.SegmentName, ActionCount DESC;
-- Reporting and Analytics
-- 1. View Daily User Registrations
SELECT CreatedAtDate, COUNT(UserID) AS DailyCount 
FROM Users 
GROUP BY CreatedAtDate 
ORDER BY CreatedAtDate DESC 
LIMIT 7;
-- 2. Create View for Frequent Customers
CREATE VIEW FrequentCustomers AS
SELECT Customers.CustomerID, Customers.Name, COUNT(Orders.OrderID) AS OrderCount, SUM(OrderDetails.Quantity * OrderDetails.Price) AS TotalSpent
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Customers.CustomerID, Customers.Name
HAVING OrderCount >= 2
ORDER BY TotalSpent DESC;
SELECT * FROM FrequentCustomers;
-- User Access Control
-- 1. Assign User roles:
START TRANSACTION;
UPDATE Users 
SET RoleID = (SELECT RoleID FROM Roles WHERE RoleName = 'Admin' LIMIT 1) 
WHERE UserID = 1;
COMMIT;

SELECT * FROM Users;
-- 2. Trigger for Automatic Role Assignment 
DELIMITER //
CREATE TRIGGER AutoAssignRole
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    IF NEW.Email LIKE '%@company.com' THEN
        UPDATE Users
        SET RoleID = (SELECT RoleID FROM Roles WHERE RoleName = 'Admin')
        WHERE UserID = NEW.UserID;
    END IF;
END //
DELIMITER ;
-- Testing the Trigger
INSERT INTO Users (Username, Email, Password, CreatedAtDate)
VALUES ('Than Huy', 'thanhuy@gmail.com', 'admin13', CURDATE());
SELECT * FROM Users WHERE Email = 'thanhuy@gmail.com';
-- Multi-location Support
-- 1. Transfer Inventory Between Locations
START TRANSACTION;

UPDATE InventoryLocations 
SET Quantity = Quantity - 50 
WHERE ProductID = 202 AND LocationID = 1;

INSERT INTO InventoryLocations (LocationID, ProductID, Quantity) 
VALUES (2, 4, 50)
ON DUPLICATE KEY UPDATE Quantity = Quantity + 50;

COMMIT;
SELECT * FROM InventoryLocations;
-- Mobile Access
-- 1. Register Mobile Device
START TRANSACTION;
INSERT INTO MobileDevices (UserID, DeviceType, DeviceToken) 
VALUES (2, 'Android', 'abc123token');
COMMIT;
SELECT * FROM MobileDevices;
DELIMITER ;

-- Integration with ERP
START TRANSACTION;
-- 1. Fetch Products from ERP
INSERT INTO Products (Name, Description, Price, StockQuantity)
SELECT Name, Description, Price, Stock 
FROM ERPProductTable;
COMMIT;
-- Real-time Updates
-- 1. Update Real-time Inventory
START TRANSACTION;

UPDATE RealTimeInventory 
SET StockQuantity = StockQuantity + 100, LastUpdated = CURRENT_DATE, Time = CURRENT_TIME 
WHERE ProductID = 20;

COMMIT;
SELECT * FROM RealTimeInventory; 
-- 2. View Real-time Orders
SELECT rt.OrderID, rt.ProductID, rt.Quantity, os.StatusName, rt.CreatedAtDate, rt.CreatedAtTime, rt.UpdatedAtDate, rt.UpdatedAtTime
FROM RealTimeOrders rt
JOIN OrderStatuses os ON rt.OrderStatusID = os.OrderStatusID
ORDER BY rt.UpdatedAtDate DESC, rt.UpdatedAtTime DESC;
-- Audit Trail
-- 2. Export Audit Log
SELECT AuditID, TableName, ActionType, ChangedData, ChangedBy, ChangedAtDate, ChangedAtTime 
FROM AuditTrails
INTO OUTFILE 'E:\\Data\\Audit_Trail\\audit_log2.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

-- Notification
-- 1. Send Order Status Notification
DELIMITER //
CREATE TRIGGER OrderStatusNotification
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF NEW.Status != OLD.Status THEN
        INSERT INTO Notifications (UserID, NotificationType, NotificationMessage, CreatedAtDate, CreatedAtTime)
        VALUES ((SELECT CustomerID FROM Orders WHERE OrderID = NEW.OrderID), 'Order Status', 
        CONCAT('Your order status has changed to: ', NEW.Status), CURRENT_DATE, CURRENT_TIME);
    END IF;
END //


