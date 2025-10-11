-- =====================================================================
-- Olist DQL Starter Pack (PostgreSQL)
-- Target table: treated_dataset
-- =====================================================================


SELECT * FROM treated_dataset LIMIT 20;

SELECT
  COUNT(*)                              AS rows_total,
  COUNT(DISTINCT order_id)              AS orders,
  COUNT(DISTINCT customer_id)           AS customers,
  COUNT(DISTINCT seller_zip_code_prefix) AS seller_zip_codes,
  MIN(order_purchase_timestamp)::date   AS first_purchase_date,
  MAX(order_purchase_timestamp)::date   AS last_purchase_date
FROM treated_dataset;


SELECT
  order_status,
  COUNT(*)                      AS orders,
  ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (), 2) AS pct
FROM treated_dataset
GROUP BY order_status
ORDER BY orders DESC;


SELECT
  DATE(order_purchase_timestamp) AS day,
  SUM(total_payment_value) AS gmv,
  COUNT(DISTINCT order_id) AS orders
FROM treated_dataset
GROUP BY day
ORDER BY day;

SELECT
  DATE_TRUNC('month', order_purchase_timestamp)::date AS month,
  SUM(total_payment_value) AS gmv,
  COUNT(DISTINCT order_id) AS orders,
  AVG(total_payment_value) AS avg_ticket
FROM treated_dataset
GROUP BY month
ORDER BY month;

SELECT
  AVG(total_payment_value) AS avg_ticket_overall,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_payment_value) AS median_ticket,
  PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_payment_value) AS p90_ticket
FROM (
  SELECT order_id, SUM(total_payment_value) AS total_payment_value
  FROM treated_dataset
  GROUP BY order_id
) o;

SELECT
  customer_state,
  COUNT(DISTINCT order_id) AS orders,
  SUM(total_payment_value) AS gmv,
  AVG(total_payment_value) AS avg_ticket
FROM treated_dataset
GROUP BY customer_state
ORDER BY gmv DESC;


SELECT
  order_id,
  COUNT(*) AS items_in_order,
  SUM(total_payment_value) AS order_value
FROM treated_dataset
GROUP BY order_id
ORDER BY order_value DESC
LIMIT 50;

WITH per_order AS (
  SELECT order_id, COUNT(*) AS items_in_order
  FROM treated_dataset
  GROUP BY order_id
)
SELECT items_in_order, COUNT(*) AS num_orders
FROM per_order
GROUP BY items_in_order
ORDER BY items_in_order;

SELECT
  AVG(delivery_time_days)::numeric(10,2)  AS avg_delivery_days,
  AVG(delivery_delay_days)::numeric(10,2) AS avg_delay_days,
  AVG(CASE WHEN delivered_late IN (true, 'true', 1) THEN 1 ELSE 0 END)::numeric(10,4) AS late_rate
FROM treated_dataset;

SELECT
  DATE_TRUNC('month', order_purchase_timestamp)::date AS month,
  AVG(delivery_time_days)  AS avg_delivery_days,
  AVG(delivery_delay_days) AS avg_delay_days,
  AVG(CASE WHEN delivered_late IN (true, 'true', 1) THEN 1 ELSE 0 END) AS late_rate
FROM treated_dataset
GROUP BY month
ORDER BY month;

SELECT
  customer_state,
  customer_city,
  COUNT(DISTINCT order_id) AS orders,
  SUM(total_payment_value) AS gmv
FROM treated_dataset
GROUP BY customer_state, customer_city
ORDER BY gmv DESC
LIMIT 50;

SELECT
  seller_state,
  seller_city,
  COUNT(DISTINCT order_id) AS orders,
  SUM(total_payment_value) AS gmv
FROM treated_dataset
GROUP BY seller_state, seller_city
ORDER BY gmv DESC
LIMIT 50;

SELECT
  seller_state,
  seller_city,
  COUNT(DISTINCT order_id) AS orders,
  COUNT(*) AS items,
  SUM(total_payment_value) AS gmv,
  AVG(total_payment_value) AS avg_item_value
FROM treated_dataset
GROUP BY seller_state, seller_city
ORDER BY gmv DESC;

WITH dates AS (
  SELECT MAX(order_purchase_timestamp)::date AS max_day FROM treated_dataset
),
per_order AS (
  SELECT order_id, customer_id, DATE(order_purchase_timestamp) AS day, SUM(total_payment_value) AS order_value
  FROM treated_dataset
  GROUP BY order_id, customer_id, day
),
rfm AS (
  SELECT
    customer_id,
    (SELECT max_day FROM dates) - MAX(day) AS recency_days,
    COUNT(*) AS frequency,
    SUM(order_value) AS monetary
  FROM per_order
  GROUP BY customer_id
)
SELECT *
FROM rfm
ORDER BY monetary DESC
LIMIT 100;

WITH items AS (
  SELECT
    order_id,
    (NULLIF(product_length_cm,0)::numeric
     * NULLIF(product_height_cm,0)::numeric
     * NULLIF(product_width_cm,0)::numeric) AS volume_cm3,
    NULLIF(product_weight_g,0)::numeric AS weight_g,
    total_payment_value
  FROM treated_dataset
)
SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY volume_cm3) AS median_volume_cm3,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY weight_g)   AS median_weight_g,
  CORR(volume_cm3, total_payment_value) AS corr_volume_value,
  CORR(weight_g, total_payment_value)   AS corr_weight_value
FROM items;

WITH orders AS (
  SELECT order_id, SUM(total_payment_value) AS order_value
  FROM treated_dataset
  GROUP BY order_id
),
buckets AS (
  SELECT
    order_id,
    order_value,
    CASE
      WHEN order_value < 50     THEN '0–49.99'
      WHEN order_value < 100    THEN '50–99.99'
      WHEN order_value < 200    THEN '100–199.99'
      WHEN order_value < 500    THEN '200–499.99'
      WHEN order_value < 1000   THEN '500–999.99'
      ELSE '1000+'
    END AS value_bucket
  FROM orders
)
SELECT value_bucket, COUNT(*) AS orders
FROM buckets
GROUP BY value_bucket
ORDER BY
  CASE value_bucket
    WHEN '0–49.99' THEN 1
    WHEN '50–99.99' THEN 2
    WHEN '100–199.99' THEN 3
    WHEN '200–499.99' THEN 4
    WHEN '500–999.99' THEN 5
    ELSE 6
  END;

WITH recent AS (
  SELECT *
  FROM treated_dataset
  WHERE order_purchase_timestamp >= NOW() - INTERVAL '90 days'
)
SELECT
  DATE(order_purchase_timestamp) AS day,
  COUNT(DISTINCT order_id) AS orders,
  SUM(total_payment_value) AS gmv
FROM recent
GROUP BY day
ORDER BY day;

SELECT
  SUM( (order_id IS NULL)::int )                        AS null_order_id,
  SUM( (customer_id IS NULL)::int )                     AS null_customer_id,
  SUM( (order_purchase_timestamp IS NULL)::int )        AS null_purchase_ts,
  SUM( (total_payment_value IS NULL)::int )             AS null_payment,
  SUM( (product_length_cm IS NULL OR product_height_cm IS NULL OR product_width_cm IS NULL)::int ) AS null_any_dim
FROM treated_dataset;

SELECT *
FROM treated_dataset
WHERE order_purchase_timestamp >= TIMESTAMP '2017-01-01'
  AND order_purchase_timestamp <  TIMESTAMP '2018-01-01';

SELECT
  order_id,
  SUM(freight_value) AS freight,
  SUM(total_payment_value) AS ticket,
  CASE WHEN SUM(total_payment_value) > 0
       THEN SUM(freight_value)/SUM(total_payment_value)
       ELSE NULL END AS freight_share
FROM treated_dataset
GROUP BY order_id;