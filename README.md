# Zingbus Operations Optimization & Risk Analytics

## Project Overview
This project analyzes operational performance and customer booking behavior for an intercity mobility platform similar to Zingbus. The analysis was performed on a simulated production-scale dataset containing over 1.2 million booking records. Using SQL and Python, the project investigates cancellations, route demand, and operator reliability to identify operational inefficiencies and provide actionable recommendations.  

The project follows an end-to-end analytics workflow: database creation, data extraction, exploratory analysis, root-cause investigation, visualization, and predictive modeling.  

## Business Problem 
Intercity bus platforms operate on thin margins where empty seats and last-minute cancellations directly impact revenue.  
The platform experienced:
- Frequent booking cancellations (~8%)
- Uncertain operator reliability
- Underutilized routes
- Revenue leakage due to operational inefficiencies

Since each unsold seat represents lost revenue after departure, the operations team needs data-driven insights to identify high-risk routes, unreliable operators, and inefficient scheduling.

## Objective 
The main objectives of this project were:  
- Analyze booking and cancellation behavior
- Identify operational causes of cancellations
- Evaluate route demand and performance
- Detect unreliable operators
- Recommend route expansion or reduction
- Build a predictive model to identify risky trips before departure

## Schema Strucutre 
The relational database was created in MySQL using the following schema:  
``` sql
CREATE DATABASE zingbus_analysis;
USE zingbus_analysis;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    signup_date DATE,
    city VARCHAR(50),
    device_type VARCHAR(20)
);

CREATE TABLE operators (
    operator_id INT PRIMARY KEY,
    operator_name VARCHAR(100),
    rating DECIMAL(3,2)
);

CREATE TABLE buses (
    bus_id INT PRIMARY KEY,
    operator_id INT,
    bus_type VARCHAR(50),
    seat_capacity INT,
    FOREIGN KEY (operator_id) REFERENCES operators(operator_id)
);

CREATE TABLE routes (
    route_id INT PRIMARY KEY,
    source_city VARCHAR(50),
    destination_city VARCHAR(50),
    distance_km INT
);

CREATE TABLE trips (
    trip_id INT PRIMARY KEY,
    route_id INT,
    bus_id INT,
    departure_datetime DATETIME,
    arrival_datetime DATETIME,
    base_price INT,
    FOREIGN KEY (route_id) REFERENCES routes(route_id),
    FOREIGN KEY (bus_id) REFERENCES buses(bus_id)
);

CREATE TABLE bookings (
    booking_id BIGINT PRIMARY KEY,
    user_id INT,
    trip_id INT,
    booking_datetime DATETIME,
    seats_booked INT,
    booking_channel VARCHAR(20),
    coupon_id INT,
    booking_status VARCHAR(20),
    price_paid DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
);

CREATE TABLE payments (
    payment_id BIGINT PRIMARY KEY,
    booking_id BIGINT,
    payment_method VARCHAR(20),
    payment_status VARCHAR(20),
    amount DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

CREATE TABLE delays (
    trip_id INT,
    delay_minutes INT,
    FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
);
```

## Tools & Technologies
- SQL (MySQL): Data storage, querying, and transformation
- Python: Data analysis and modeling
- Pandas & NumPy: Data cleaning and feature engineering
- Matplotlib: Visualization
- Scikit-learn: Predictive modeling (Logistic Regression)
- GitHub: Version control and documentation

## Project Workflow 
- Created relational database and imported 1.2M+ booking records
- Wrote SQL queries to explore booking patterns and operational KPIs
- Investigated cancellations, routes, and operator performance
- Extracted dataset into Python using SQL joins
- Performed feature engineering and exploratory data analysis
- Visualized operational behavior (routes, operators, timing)
- Built Route Performance Score for operational decisions
- Developed cancellation risk prediction model
- Generated actionable recommendations

## Key Insights 
- Created relational database and imported 1.2M+ booking records
- Wrote SQL queries to explore booking patterns and operational KPIs
- Investigated cancellations, routes, and operator performance
- Extracted dataset into Python using SQL joins
- Performed feature engineering and exploratory data analysis
- Visualized operational behavior (routes, operators, timing)
- Built Route Performance Score for operational decisions
- Developed cancellation risk prediction model
- Generated actionable recommendations

## Recommendations 
- Cancellation rate ≈ 8%, causing significant revenue loss
- Estimated revenue leakage ≈ ₹18.4 Crore
- Certain operators consistently showed higher cancellation rates
- Hill and long-distance routes had higher operational uncertainty
- Departure timing had minimal impact on cancellations
- Repeat users formed the majority of platform usage
- UPI was the dominant payment method

## Conclusion 
This project demonstrates how operational analytics can improve decision-making in a mobility platform. Using SQL and Python, the analysis identified revenue leakage, operational inefficiencies, and service reliability issues. The developed route performance scoring and cancellation prediction system can help operations teams proactively manage trips, optimize route allocation, and improve customer experience.  
The project highlights the role of data analytics in converting raw booking data into actionable operational strategies.
