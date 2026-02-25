-- CREATE DATABASE zingbus_analysis;
-- USE zingbus_analysis;

# Create User table
-- CREATE TABLE users (
--     user_id INT PRIMARY KEY,
--     signup_date DATE,
--     city VARCHAR(50),
--     device_type VARCHAR(20)
-- );

# Operators Table
-- CREATE TABLE operators (
--     operator_id INT PRIMARY KEY,
--     operator_name VARCHAR(100),
--     rating DECIMAL(3,2)
-- );

# Buses Table
-- CREATE TABLE buses (
--     bus_id INT PRIMARY KEY,
--     operator_id INT,
--     bus_type VARCHAR(50),
--     seat_capacity INT,
--     FOREIGN KEY (operator_id) REFERENCES operators(operator_id)
-- );

# Routes Table
-- CREATE TABLE routes (
--     route_id INT PRIMARY KEY,
--     source_city VARCHAR(50),
--     destination_city VARCHAR(50),
--     distance_km INT
-- );

#Trips table 
-- CREATE TABLE trips (
--     trip_id INT PRIMARY KEY,
--     route_id INT,
--     bus_id INT,
--     departure_datetime DATETIME,
--     arrival_datetime DATETIME,
--     base_price INT,
--     FOREIGN KEY (route_id) REFERENCES routes(route_id),
--     FOREIGN KEY (bus_id) REFERENCES buses(bus_id)
-- );

# Coupons table 
-- CREATE TABLE coupons (
--     coupon_id INT PRIMARY KEY,
--     campaign_name VARCHAR(50),
--     discount_pct INT
-- );

# Bookings Table 
-- CREATE TABLE bookings (
--     booking_id BIGINT PRIMARY KEY,
--     user_id INT,
--     trip_id INT,
--     booking_datetime DATETIME,
--     seats_booked INT,
--     booking_channel VARCHAR(20),
--     coupon_id INT,
--     booking_status VARCHAR(20),
--     price_paid DECIMAL(10,2),
--     FOREIGN KEY (user_id) REFERENCES users(user_id),
--     FOREIGN KEY (trip_id) REFERENCES trips(trip_id),
--     FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id)
-- );

# Payments table 
-- CREATE TABLE payments (
--     payment_id BIGINT PRIMARY KEY,
--     booking_id BIGINT,
--     payment_method VARCHAR(20),
--     payment_status VARCHAR(20),
--     amount DECIMAL(10,2),
--     FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
-- );

# Delays table 
-- CREATE TABLE delays (
--     trip_id INT,
--     delay_minutes INT,
--     FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
-- );

# Steps for removing data from user table
-- SET FOREIGN_KEY_CHECKS = 0;
-- TRUNCATE TABLE users;
-- SET FOREIGN_KEY_CHECKS = 1;
-- SELECT COUNT(*) FROM users;

-- SHOW VARIABLES LIKE 'secure_file_priv';

# Enable File Import (One Time)
-- SET GLOBAL local_infile = 1;

# USERS
-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv'
-- INTO TABLE users
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (user_id, signup_date, city, device_type);
 
# Operators 
-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/operators.csv'
-- INTO TABLE operators
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (operator_id, operator_name, rating); 

-- SELECT COUNT(*) FROM operators;

# Buses 
-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/buses.csv'
-- INTO TABLE buses
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (bus_id, operator_id, bus_type, seat_capacity);
-- SELECT COUNT(*) FROM buses;

# Routes 
-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/routes.csv'
-- INTO TABLE routes
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (route_id, source_city, destination_city, distance_km);
-- Select Count(*) from routes ;

# Trips 
-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/trips.csv'
-- INTO TABLE trips
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (trip_id, route_id, bus_id, departure_datetime, arrival_datetime, base_price);
-- SELECT COUNT(*) FROM trips;

# Coupons 
-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/coupons.csv'
-- INTO TABLE coupons
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (coupon_id, campaign_name, discount_pct);
-- Select COUNT(*) FROM coupons;

# INcreasing Packet size for 1.2M Rows
-- SET GLOBAL max_allowed_packet = 1073741824;


# Some error occured while imorting 
-- SET FOREIGN_KEY_CHECKS = 0;
-- TRUNCATE TABLE bookings;
-- SET FOREIGN_KEY_CHECKS = 1;

-- ALTER TABLE bookings DROP FOREIGN KEY bookings_ibfk_3;
-- ALTER TABLE bookings MODIFY coupon_id INT NULL;
-- ALTER TABLE bookings
-- ADD CONSTRAINT fk_coupon
-- FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id)
-- ON DELETE SET NULL;

# Bookings 
-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bookings.csv'
-- INTO TABLE bookings
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (booking_id, user_id, trip_id, booking_datetime, seats_booked, booking_channel, @coupon_id, booking_status, price_paid)
-- SET coupon_id = NULLIF(@coupon_id, 0);

# Payment Table 
-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/payments.csv'
-- INTO TABLE payments
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (payment_id, booking_id, payment_method, payment_status, amount);
-- Select count(*) from payments

# Delays table 
-- LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/delays.csv'
-- INTO TABLE delays
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (trip_id, delay_minutes);




