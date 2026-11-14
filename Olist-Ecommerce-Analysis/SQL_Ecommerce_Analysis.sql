USE Olist_Ecommerce_Analysis;
GO

SELECT 'orders' AS tbl, COUNT(*) AS n FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers;

ALTER TABLE order_items ALTER COLUMN price DECIMAL(10,2);
ALTER TABLE order_items ALTER COLUMN freight_value DECIMAL(10,2);
ALTER TABLE order_payments ALTER COLUMN payment_value DECIMAL(10,2);
----------------------------------------------------------------------------------------------------------------

-- Q1: Total revenue
-- Rule: sum of payments, excluding canceled and unavailable orders
SELECT SUM(payment_value) AS TotalPaymentValue
FROM Olist_Ecommerce_Analysis.dbo.order_payments
JOIN Olist_Ecommerce_Analysis.dbo.orders
   ON order_payments.order_id = orders.order_id
   WHERE order_status IN (
    'delivered', 'shipped', 'invoiced', 'processing', 'approved', 'created'
);

-- Q2: Orders placed (all vs. valid)
-- Rule: valid orders exclude canceled and unavailable statuses
SELECT
    COUNT(*) AS total_orders_placed,
    SUM(CASE WHEN order_status IN (
    'delivered', 'shipped', 'invoiced', 'processing', 'approved', 'created'
) THEN 1 ELSE 0 END) AS valid_orders
FROM orders;

-- Q3: Revenue by month
-- Rule: excludes canceled and unavailable orders; date = purchase timestamp

-- Revenue By Month, 2016
SELECT DATENAME(MONTH, order_purchase_timestamp) AS order_month,
SUM(payment_value) AS RevenueByMonth
FROM Olist_Ecommerce_Analysis.dbo.orders
JOIN Olist_Ecommerce_Analysis.dbo.order_payments
   ON order_payments.order_id = orders.order_id
   WHERE order_status IN (
    'delivered', 'shipped', 'invoiced', 'processing', 'approved', 'created'
)
AND YEAR(order_purchase_timestamp) = 2016
GROUP BY DATENAME(MONTH, order_purchase_timestamp), MONTH(order_purchase_timestamp)
ORDER BY MONTH(order_purchase_timestamp);

-- Revenue By Month, 2017
SELECT DATENAME(MONTH, order_purchase_timestamp) AS order_month,
SUM(payment_value) AS RevenueByMonth
FROM Olist_Ecommerce_Analysis.dbo.orders
JOIN Olist_Ecommerce_Analysis.dbo.order_payments
   ON order_payments.order_id = orders.order_id
   WHERE order_status IN (
    'delivered', 'shipped', 'invoiced', 'processing', 'approved', 'created'
)
AND YEAR(order_purchase_timestamp) = 2017
GROUP BY DATENAME(MONTH, order_purchase_timestamp), MONTH(order_purchase_timestamp)
ORDER BY MONTH(order_purchase_timestamp);

-- Revenue By Month, 2018
SELECT DATENAME(MONTH, order_purchase_timestamp) AS order_month,
SUM(payment_value) AS RevenueByMonth
FROM Olist_Ecommerce_Analysis.dbo.orders
JOIN Olist_Ecommerce_Analysis.dbo.order_payments
   ON order_payments.order_id = orders.order_id
   WHERE order_status IN (
    'delivered', 'shipped', 'invoiced', 'processing', 'approved', 'created'
)
AND YEAR(order_purchase_timestamp) = 2018
GROUP BY DATENAME(MONTH, order_purchase_timestamp), MONTH(order_purchase_timestamp)
ORDER BY MONTH(order_purchase_timestamp);

-- Revenue by month, (Highest to lowest)
SELECT YEAR(order_purchase_timestamp) AS order_year,
       DATENAME(MONTH, order_purchase_timestamp) AS order_month,
       SUM(payment_value) AS RevenueByMonth
FROM Olist_Ecommerce_Analysis.dbo.orders
JOIN Olist_Ecommerce_Analysis.dbo.order_payments
   ON order_payments.order_id = orders.order_id
WHERE order_status IN (
    'delivered', 'shipped', 'invoiced', 'processing', 'approved', 'created'
)
GROUP BY YEAR(order_purchase_timestamp),
         DATENAME(MONTH, order_purchase_timestamp),
         MONTH(order_purchase_timestamp)
ORDER BY RevenueByMonth DESC;

-- Q4: Best-performing product categories
-- Rule: item revenue from price (freight excluded), excluding canceled and unavailable orders
SELECT TOP 10 product_category_name_english,
       SUM(price) AS products_revenue
FROM Olist_Ecommerce_Analysis.dbo.orders
JOIN Olist_Ecommerce_Analysis.dbo.order_items ON orders.order_id = order_items.order_id
JOIN Olist_Ecommerce_Analysis.dbo.products ON products.product_id = order_items.product_id
JOIN Olist_Ecommerce_Analysis.dbo.category_name ON category_name.product_category_name = products.product_category_name
   WHERE order_status IN (
    'delivered', 'shipped', 'invoiced', 'processing', 'approved', 'created'
)
GROUP BY product_category_name_english
ORDER BY products_revenue DESC;

-- Q5: States with the most sales
-- Rule: sum of payments by customer state, excluding canceled and unavailable orders
SELECT customer_state,
       COUNT(DISTINCT customers.customer_id) AS order_count,
       SUM(payment_value) AS revenue
FROM Olist_Ecommerce_Analysis.dbo.order_payments
JOIN Olist_Ecommerce_Analysis.dbo.orders ON order_payments.order_id = orders.order_id
JOIN Olist_Ecommerce_Analysis.dbo.customers ON customers.customer_id = orders.customer_id 
   WHERE order_status IN (
    'delivered', 'shipped', 'invoiced', 'processing', 'approved', 'created'
)
GROUP BY customer_state
ORDER BY revenue DESC;

-- Q6: Top 10 customers by spending
-- Rule: grouped by customer_unique_id; sum of payments, excluding canceled and unavailable orders
SELECT TOP 10 customer_unique_id,
       SUM(payment_value) AS amount_spent
FROM Olist_Ecommerce_Analysis.dbo.order_payments
JOIN Olist_Ecommerce_Analysis.dbo.orders ON order_payments.order_id = orders.order_id
JOIN Olist_Ecommerce_Analysis.dbo.customers ON customers.customer_id = orders.customer_id 
   WHERE order_status IN (
    'delivered', 'shipped', 'invoiced', 'processing', 'approved', 'created'
)
GROUP BY customer_unique_id
ORDER BY amount_spent DESC;


-- Q7: Most popular payment methods
-- Rule: excludes canceled and unavailable orders; split-payment orders count under each method used
SELECT payment_type,
       COUNT(DISTINCT order_payments.order_id) AS order_count,
       SUM(payment_value) AS total_payment_value
FROM Olist_Ecommerce_Analysis.dbo.order_payments
JOIN Olist_Ecommerce_Analysis.dbo.orders
   ON order_payments.order_id = orders.order_id
   WHERE order_status IN (
    'delivered', 'shipped', 'invoiced', 'processing', 'approved', 'created'
)
GROUP BY payment_type
ORDER BY order_count DESC;

-- Q8: Average order value
-- Rule: total payments / distinct orders, excluding canceled and unavailable orders
SELECT CAST(SUM(payment_value) / COUNT(DISTINCT order_payments.order_id) AS DECIMAL(10,2)) AS avg_order_value
FROM Olist_Ecommerce_Analysis.dbo.order_payments
JOIN Olist_Ecommerce_Analysis.dbo.orders
   ON order_payments.order_id = orders.order_id
   WHERE order_status IN (
    'delivered', 'shipped', 'invoiced', 'processing', 'approved', 'created'
);

-- Q9: Average delivery time
-- Rule: delivered orders only, with a delivery date.
SELECT AVG(CAST(DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) AS DECIMAL(10,2))) AS average_delivery_days
FROM Olist_Ecommerce_Analysis.dbo.orders
   WHERE order_status = 'delivered'
   AND order_delivered_customer_date IS NOT NULL;

-- Q10: Top sellers by sales
-- Rule: item revenue from price (freight excluded), excluding canceled and unavailable orders
SELECT TOP 10 seller_id,
       SUM(price) AS sales
FROM Olist_Ecommerce_Analysis.dbo.order_items
JOIN Olist_Ecommerce_Analysis.dbo.orders ON order_items.order_id = orders.order_id
   WHERE order_status IN (
    'delivered', 'shipped', 'invoiced', 'processing', 'approved', 'created'
)
GROUP BY seller_id
ORDER BY sales DESC;