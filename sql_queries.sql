-- Q1 Replenishment Rates for Products
select
  Product_Name,
  sum(case when Product_Purchase_Number_ > 1 then 1 else 0 end) as replenished,
  count(*) as total_ordered,
  sum(case when Product_Purchase_Number_ > 1 then 1 else 0 end)/count(*) as replenishment_rate
from
  Trinny.example
group by 1
order by 1




  
-- Q1 Replenishment Rates for Product Variants
select
 concat(Product_Name, ' ', Variant_Name) as product_variant,
 sum(case when Variant_Purchase_Number > 1 then 1 else 0 end) as replenished,
 count(*) as total_ordered,
 sum(case when Variant_Purchase_Number > 1 then 1 else 0 end)/count(*) as replenishment_rate
from
 Trinny.example
group by 1
order by 2 desc, 3 desc, 4 desc




-- Q2 Repurchase Rate by Product
WITH FirstTimePurchases AS (
    SELECT
        Customer_ID,
        Product_Name
    FROM
        `Trinny.example`
    WHERE
        Product_Purchase_Number_ = 1
),

Repurchases AS (
    SELECT
        f.Customer_ID,
        f.Product_Name,
        COUNT(distinct t.Customer_ID) AS repurchase_count
    FROM
        FirstTimePurchases f
    LEFT JOIN `Trinny.example` t
    ON f.Customer_ID = t.Customer_ID
    AND f.product_name = t.product_name
    AND t.Product_Purchase_Number_ = 2
    GROUP BY f.customer_id, f.product_name
),

TotalPurchases AS (
    SELECT
        Product_name,
        COUNT(*) AS total_purchases
    FROM
        `Trinny.example`
    GROUP BY 1
)

SELECT
    r.product_name,
    COUNT(*) AS total_first_time_purchases,
    SUM(CASE WHEN r.repurchase_count = 1 THEN 1 ELSE 0 END) AS repurchase_count,
    t.total_purchases,
    SUM(CASE WHEN r.repurchase_count = 1 THEN 1 ELSE 0 END) / t.total_purchases AS repurchase_rate
FROM
    Repurchases r
LEFT JOIN TotalPurchases t ON r.product_name = t.product_name
GROUP BY r.product_name, t.total_purchases;




  
-- Q2 Repurchase Rate by Product Variant
with TrinnySet as (
 select
   concat(product_name, ' ', variant_name) as product_variant,
   *
 from
   `Trinny.example`
),
  
FirstTimePurchases as (
 select
   customer_id,
   product_variant
 from
   TrinnySet
 where
   variant_purchase_number = 1
),
  
Repurchases as (
 select
   f.customer_id,
   f.product_variant,
   count(distinct t.customer_id) as repurchase_count
 from
   FirstTimePurchases f
 left join TrinnySet t
 on f.customer_id = t.customer_id
    and f.product_variant = t.product_variant
    and t.variant_purchase_number = 2
 group by f.customer_id, f.product_variant
),
  
TotalPurchases as (
 select
   product_variant,
   count(*) as total_purchases
 from
   TrinnySet
 group by product_variant
)
  
select
 r.product_variant,
 count(*) as total_first_time_purchases,
 sum (case when r.repurchase_count = 1 then 1 else 0 end) as repurchase_count,
 t.total_purchases,
 sum (case when r.repurchase_count = 1 then 1 else 0 end) / t.total_purchases as repurchase_rate
from
 Repurchases r
left join TotalPurchases t
on r.product_variant = t.product_variant
group by r.product_variant, t.total_purchases




