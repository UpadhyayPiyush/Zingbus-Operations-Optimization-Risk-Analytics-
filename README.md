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

## Visuals Analysis
![img1](https://github.com/UpadhyayPiyush/Zingbus-Operations-Optimization-Risk-Analytics-/blob/main/Graphs/img1.png)  
This chart shows that a few partner operators consistently have higher cancellation rates than the platform average (~8%). It indicates that cancellations are not random but linked to specific service providers. These operators may be facing operational issues such as poor fleet management, scheduling delays, or last-minute trip changes. Zingbus can improve reliability by auditing these operators, enforcing performance SLAs, or reallocating high-demand routes to better-performing partners. Monitoring operator-level KPIs regularly can directly reduce revenue loss and improve customer trust.  

![img2](https://github.com/UpadhyayPiyush/Zingbus-Operations-Optimization-Risk-Analytics-/blob/main/Graphs/img2.png)  
This chart highlights routes where passengers cancel bookings more frequently than others. Many of these routes appear to be long-distance or hill routes, which are operationally complex and prone to uncertainty in travel time. High cancellations on these routes suggest scheduling mismatch, delay expectations, or unreliable trip execution. Zingbus can improve performance by adjusting departure timings, reducing over-frequency, or assigning more reliable operators to these routes. Proactive communication or flexible rescheduling options on these routes could also help reduce cancellations and improve customer satisfaction.  

![img3](https://github.com/UpadhyayPiyush/Zingbus-Operations-Optimization-Risk-Analytics-/blob/main/Graphs/img3.png)  
This chart analyzes whether departure timing influences booking cancellations. The cancellation rate remains almost consistent across all hours of the day, indicating that time of departure alone is not a major driver of cancellations. This suggests that operational reliability (such as operator performance and route complexity) has a stronger impact than scheduling hour. Therefore, simply rescheduling buses to different times will not significantly reduce cancellations. Zingbus should instead prioritize improving operator reliability and route execution quality rather than relying only on timing adjustments.  

![img4](https://github.com/UpadhyayPiyush/Zingbus-Operations-Optimization-Risk-Analytics-/blob/main/Graphs/img4.png)  
This chart highlights routes with the highest Route Performance Score, calculated using demand, revenue, reliability, and delay metrics. These routes consistently generate strong bookings and revenue while maintaining acceptable service reliability. It indicates that customer demand on these corridors is higher than current service capacity. Zingbus can consider increasing bus frequency, allocating larger capacity buses, or applying dynamic pricing on these routes to maximize revenue. Expanding operations on these routes can directly improve seat occupancy and overall profitability.  

![img5](https://github.com/UpadhyayPiyush/Zingbus-Operations-Optimization-Risk-Analytics-/blob/main/Graphs/img5.png)  
This chart shows routes with the lowest Route Performance Score, mainly due to lower booking demand rather than poor service reliability. These routes are not necessarily operational failures but appear to have insufficient passenger volume compared to deployed capacity. Running frequent buses on such routes may lead to underutilized seats and unnecessary operational costs. Zingbus should review scheduling frequency, adjust departure timings, or deploy smaller capacity buses on these routes. Optimizing capacity instead of completely removing these routes can help balance coverage and operational efficiency.  

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
