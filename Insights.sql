-- SELECT 
-- (SELECT COUNT(*) FROM users) AS users,
-- (SELECT COUNT(*) FROM operators) AS operators,
-- (SELECT COUNT(*) FROM buses) AS buses,
-- (SELECT COUNT(*) FROM routes) AS routes,
-- (SELECT COUNT(*) FROM trips) AS trips,
-- (SELECT COUNT(*) FROM Coupons) AS Coupons,
-- (SELECT COUNT(*) FROM bookings) AS bookings,
-- (SELECT COUNT(*) FROM payments) AS payments,
-- (SELECT COUNT(*) FROM delays) AS delays;


###### Data Understading ###########

# Total Platform Users
-- SELECT COUNT(*) AS total_users
-- FROM users;

# Active Users (Users Who Booked At Least Once)
-- SELECT COUNT(DISTINCT user_id) AS active_users
-- FROM bookings;

# Total Bookings on Platform 
-- SELECT COUNT(*) AS total_bookings
-- FROM bookings;

# Confirmed vs Cancelled Bookings 
-- SELECT 
--     booking_status,
--     COUNT(*) AS total_bookings
-- FROM bookings
-- GROUP BY booking_status;

# Total Revenue Generated 
-- SELECT ROUND(SUM(price_paid),0) AS total_revenue
-- FROM bookings
-- WHERE booking_status='Confirmed';

# Average Ticket Value (ATV)
-- SELECT 
-- ROUND(AVG(price_paid),2) AS avg_ticket_value
-- FROM bookings
-- WHERE booking_status='Confirmed';

# Average Seats per Booking
-- SELECT 
-- ROUND(AVG(seats_booked),2) AS avg_seats_per_booking
-- FROM bookings
-- WHERE booking_status='Confirmed';

# Booking Channel Distribution
-- SELECT 
-- booking_channel,
-- COUNT(*) AS bookings
-- FROM bookings
-- GROUP BY booking_channel
-- ORDER BY bookings DESC;

# Device Type of users 
-- SELECT 
-- device_type,
-- COUNT(*) AS users
-- FROM users
-- GROUP BY device_type;

# Most Popular Source Cities
-- SELECT 
-- r.source_city,
-- SUM(b.seats_booked) AS total_seats
-- FROM bookings b
-- JOIN trips t ON b.trip_id=t.trip_id
-- JOIN routes r ON t.route_id=r.route_id
-- WHERE b.booking_status='Confirmed'
-- GROUP BY r.source_city
-- ORDER BY total_seats DESC;

########## Operational Monitoring ############

# Peak Booking Day of Week
-- SELECT 
-- DAYNAME(booking_datetime) AS day_of_week,
-- COUNT(*) AS total_bookings
-- FROM bookings
-- GROUP BY day_of_week
-- ORDER BY total_bookings DESC;

# Peak Booking Hour
-- SELECT 
-- HOUR(booking_datetime) AS booking_hour,
-- COUNT(*) AS total_bookings
-- FROM bookings
-- GROUP BY booking_hour
-- ORDER BY total_bookings DESC;

# Monthly Booking Trend 
-- SELECT 
-- MONTH(booking_datetime) AS month,
-- COUNT(*) AS bookings
-- FROM bookings
-- GROUP BY month
-- ORDER BY month;

# Cancellation Rate
-- SELECT 
-- ROUND(
-- SUM(CASE WHEN booking_status='Cancelled' THEN 1 ELSE 0 END)*100.0
-- / COUNT(*),2) AS cancellation_rate_percent
-- FROM bookings;

# Routes with highest cancellations 
-- SELECT 
-- r.source_city,
-- r.destination_city,
-- COUNT(*) AS cancelled_bookings
-- FROM bookings b
-- JOIN trips t ON b.trip_id=t.trip_id
-- JOIN routes r ON t.route_id=r.route_id
-- WHERE b.booking_status='Cancelled'
-- GROUP BY r.source_city,r.destination_city
-- ORDER BY cancelled_bookings DESC
-- LIMIT 10;


################ Decision Support #############

# High Demand Routes 
-- SELECT 
-- r.source_city,
-- r.destination_city,
-- SUM(b.seats_booked) AS total_seats
-- FROM bookings b
-- JOIN trips t ON b.trip_id=t.trip_id
-- JOIN routes r ON t.route_id=r.route_id
-- WHERE b.booking_status='Confirmed'
-- GROUP BY r.source_city,r.destination_city
-- ORDER BY total_seats DESC
-- LIMIT 10;

# Low Performing Routes 
-- SELECT 
-- r.source_city,
-- r.destination_city,
-- SUM(b.seats_booked) AS total_seats
-- FROM bookings b
-- JOIN trips t ON b.trip_id=t.trip_id
-- JOIN routes r ON t.route_id=r.route_id
-- WHERE b.booking_status='Confirmed'
-- GROUP BY r.source_city,r.destination_city
-- ORDER BY total_seats ASC
-- LIMIT 10;

# Operator Performance 
-- SELECT 
-- o.operator_name,
-- AVG(d.delay_minutes) AS avg_delay
-- FROM delays d
-- JOIN trips t ON d.trip_id=t.trip_id
-- JOIN buses b ON t.bus_id=b.bus_id
-- JOIN operators o ON b.operator_id=o.operator_id
-- GROUP BY o.operator_name
-- ORDER BY avg_delay DESC
-- LIMIT 10;

# Payment method usage 
-- SELECT 
-- payment_method,
-- COUNT(*) AS total_payments
-- FROM payments
-- GROUP BY payment_method
-- ORDER BY total_payments DESC;

# Coupon Effectiveness 
-- SELECT 
-- CASE WHEN coupon_id IS NULL THEN 'No Coupon' ELSE 'Used Coupon' END AS coupon_usage,
-- COUNT(*) AS bookings
-- FROM bookings
-- GROUP BY coupon_usage;

# Revenue Impact of Coupons 
-- SELECT 
-- CASE WHEN coupon_id IS NULL THEN 'No Coupon' ELSE 'Used Coupon' END AS coupon_usage,
-- ROUND(AVG(price_paid),2) AS avg_revenue
-- FROM bookings
-- WHERE booking_status='Confirmed'
-- GROUP BY coupon_usage;

# Repeat vs New Customers 
-- SELECT 
-- CASE WHEN booking_count=1 THEN 'New User'
-- ELSE 'Repeat User' END AS user_type,
-- COUNT(*) AS users
-- FROM
-- (
-- SELECT user_id, COUNT(*) AS booking_count
-- FROM bookings
-- GROUP BY user_id
-- ) t
-- GROUP BY user_type;

# Trips with maximum days 
-- SELECT 
-- t.trip_id,
-- AVG(d.delay_minutes) AS avg_delay
-- FROM delays d
-- JOIN trips t ON d.trip_id=t.trip_id
-- GROUP BY t.trip_id
-- ORDER BY avg_delay DESC
-- LIMIT 10;

# Best Departure Time
-- SELECT 
-- HOUR(t.departure_datetime) AS departure_hour,
-- SUM(b.seats_booked) AS seats
-- FROM bookings b
-- JOIN trips t ON b.trip_id=t.trip_id
-- WHERE b.booking_status='Confirmed'
-- GROUP BY departure_hour
-- ORDER BY seats DESC;

# Occupancy Approximation
-- SELECT 
-- r.source_city,
-- r.destination_city,
-- SUM(b.seats_booked)/COUNT(DISTINCT t.trip_id) AS avg_seats_per_trip
-- FROM bookings b
-- JOIN trips t ON b.trip_id=t.trip_id
-- JOIN routes r ON t.route_id=r.route_id
-- WHERE b.booking_status='Confirmed'
-- GROUP BY r.source_city,r.destination_city
-- ORDER BY avg_seats_per_trip DESC
-- LIMIT 10;

# Do Delays Cause Cancellations?
-- SELECT 
-- CASE 
--     WHEN d.delay_minutes IS NULL OR d.delay_minutes = 0 THEN 'On Time'
--     WHEN d.delay_minutes <= 15 THEN 'Minor Delay'
--     WHEN d.delay_minutes <= 30 THEN 'Moderate Delay'
--     ELSE 'Severe Delay'
-- END AS delay_category,
-- COUNT(*) AS total_bookings,
-- SUM(CASE WHEN b.booking_status='Cancelled' THEN 1 ELSE 0 END) AS cancellations
-- FROM bookings b
-- LEFT JOIN delays d ON b.trip_id=d.trip_id
-- GROUP BY delay_category
-- ORDER BY cancellations DESC;

# Revenue Lost Due To Cancellations
-- SELECT 
-- ROUND(SUM(price_paid),0) AS lost_revenue
-- FROM bookings
-- WHERE booking_status='Cancelled';

# Which Operators Cause Most Cancellations?
-- SELECT 
-- o.operator_name,
-- COUNT(*) AS cancelled_trips
-- FROM bookings b
-- JOIN trips t ON b.trip_id=t.trip_id
-- JOIN buses bs ON t.bus_id=bs.bus_id
-- JOIN operators o ON bs.operator_id=o.operator_id
-- WHERE b.booking_status='Cancelled'
-- GROUP BY o.operator_name
-- ORDER BY cancelled_trips DESC
-- LIMIT 10;

# Do Coupons Increase Bookings Size?
-- SELECT 
-- CASE WHEN coupon_id IS NULL THEN 'No Coupon' ELSE 'Coupon Used' END AS coupon_usage,
-- ROUND(AVG(seats_booked),2) AS avg_seats
-- FROM bookings
-- GROUP BY coupon_usage;

# Are New Users More Likely to Cancel?
-- SELECT 
-- user_type,
-- ROUND(
-- SUM(CASE WHEN booking_status='Cancelled' THEN 1 ELSE 0 END)*100.0
-- / COUNT(*),2) AS cancellation_rate
-- FROM
-- (
-- SELECT 
-- b.*,
-- CASE WHEN COUNT(*) OVER (PARTITION BY user_id)=1 THEN 'New User'
-- ELSE 'Repeat User' END AS user_type
-- FROM bookings b
-- ) t
-- GROUP BY user_type;


