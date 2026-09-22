# PIZZA SALES ANALYSIS

-- The goal can be:
-- Analyze pizza orders and sales to identify revenue trends, best-selling pizzas,
-- customer ordering patterns, and product performance. 

CREATE DATABASE pizza_sales;
USE pizza_sales;

CREATE TABLE orders (
order_id INT NOT NULL,
order_date  DATE NOT NULL,
order_time TIME NOT NULL,
PRIMARY KEY(order_id));

CREATE TABLE order_details (
order_details_id INT NOT NULL,
order_id INT NOT NULL,
pizza_id TEXT NOT NULL,
quantity INT NOT NULL,
PRIMARY KEY(order_details_id));

# SALES

-- (1) What is the total revenue?
SELECT 
    SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id;

-- (2) What is the total number of orders?
SELECT COUNT(*) AS total_orders
FROM orders;

-- (3) What is the total quantity of pizzas sold?
SELECT 
    SUM(quantity) AS total_pizzas_sold
FROM order_details;

-- (4) What is the average order value?
SELECT 
    SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id) AS average_order_value
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id;
 
-- (5) What is the average number of pizzas per order?
SELECT 
    SUM(quantity) / COUNT(DISTINCT order_id) AS avg_pizzas_per_order
FROM order_details;

# Product analysis

-- (6) Which pizza is the best-selling?
SELECT 
    p.pizza_id,
    pt.name AS pizza_name,
    SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY p.pizza_id, pt.name
ORDER BY total_quantity_sold DESC
LIMIT 1;
 
-- (7) Which pizza generates the highest revenue?
SELECT
    pt.name AS pizza_name,
    SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 1;
-- (8) Which pizza category sells the most?
SELECT
    pt.category,
    SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity_sold DESC
LIMIT 1;
-- (9) Which pizza size is most popular?
SELECT
    p.size,
    SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- (10) Which pizzas have the lowest sales?
SELECT
    pt.name AS pizza_name,
    SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity_sold ASC
LIMIT 10;

#Time analysis
-- (11) What are the daily sales?
SELECT
    o.order_date,
    SUM(od.quantity * p.price) AS daily_sales
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
GROUP BY o.order_date
ORDER BY o.order_date;


 -- (12) What are the monthly sales?
 SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(od.quantity * p.price) AS monthly_sales
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- (13) Which day of the week has the most orders?
SELECT
    DAYNAME(o.order_date) AS day_of_week,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
GROUP BY DAYNAME(o.order_date)
ORDER BY total_orders DESC
LIMIT 1;

-- (14) Which hour has the most orders?
 SELECT
    HOUR(o.order_time) AS order_hour,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
GROUP BY HOUR(o.order_time)
ORDER BY total_orders DESC
LIMIT 1;
 
 -- (15) What are the peak ordering hours?
SELECT
    HOUR(o.order_time) AS order_hour,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
GROUP BY HOUR(o.order_time)
ORDER BY total_orders DESC
LIMIT 5;

# Business analysis

-- (16) What percentage of revenue comes from each category?
SELECT
    pt.category,
    SUM(od.quantity * p.price) AS category_revenue,
    ROUND(
        SUM(od.quantity * p.price) * 100 /
        (
            SELECT SUM(od2.quantity * p2.price)
            FROM order_details od2
            JOIN pizzas p2
                ON od2.pizza_id = p2.pizza_id
        ), 2
    ) AS revenue_percentage
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY revenue_percentage DESC;

-- (17) What are the top 10 pizzas by revenue?
SELECT
    pt.name AS pizza_name,
    SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 10;

-- (18) What are the top 10 pizzas by quantity sold?
SELECT
    pt.name AS pizza_name,
    SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- (19) Which category generates the most revenue?
SELECT
    pt.category,
    SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_revenue DESC
LIMIT 1;

-- (20) How does revenue change month by month?
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(od.quantity * p.price) AS monthly_revenue
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;