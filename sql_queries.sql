-- Q1 Replenishment Rates for Products
select
  Product_Name,
  sum(case when Product_Purchase_Number_ > 1 then 1 else 0 end) as replenished,
  count(*) as total_ordered,
  100*round(sum(case when Product_Purchase_Number_ > 1 then 1 else 0 end)/count(*),4) as replenishment_rate
from
  Trinny.example
group by 1
order by 1




  
-- Q1 Replenishment Rates for Product Variants
select
 concat(Product_Name, ' ', Variant_Name) as product_variant,
 sum(case when Product_Purchase_Number_ > 1 AND Variant_Purchase_Number > 1 then 1 else 0 end) as replenished,
 count(*) as total_ordered,
 100*round(sum(case when Product_Purchase_Number_ > 1 AND Variant_Purchase_Number > 1 then 1 else 0 end)/count(*),4) as replenishment_rate
from
 Trinny.example
group by 1
order by 1




  
-- Q2 Repurchase Rate by Product
with FirstTimePurchases as (
 select
   Customer_ID,
   Product_Name
 from
   `Trinny.example`
 where
   Order_Row_Number = 1
),
  
Repurchases as (
 select
   f.Customer_ID,
   f.Product_Name,
   count(*) as repurchase_count
 from
   FirstTimePurchases f
 left join `Trinny.example` t
 on f.Customer_ID = t.Customer_ID
    and f.product_name = t.product_name
    and t.order_row_number = 2
 group by f.customer_id, f.product_name
),
  
TotalPurchases as (
 select
   Product_name,
   count(*) as total_purchases
 from
   `Trinny.example`
 group by 1
)
  
select
 r.product_name,
 count(*) as total_first_time_purchases,
 sum (case when r.repurchase_count = 1 then 1 else 0 end) as repurchase_count,
 t.total_purchases,
 sum (case when r.repurchase_count = 1 then 1 else 0 end) / t.total_purchases as proportion_repurchased
from
 Repurchases r
left join TotalPurchases t
on r.product_name = t.product_name
group by r.product_name, t.total_purchases



  
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
   order_row_number = 1
),
  
Repurchases as (
 select
   f.customer_id,
   f.product_variant,
   count(*) as repurchase_count
 from
   FirstTimePurchases f
 left join TrinnySet t
 on f.customer_id = t.customer_id
    and f.product_variant = t.product_variant
    and t.order_row_number = 2
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
 sum (case when r.repurchase_count = 1 then 1 else 0 end) / t.total_purchases as proportion_repurchased
from
 Repurchases r
left join TotalPurchases t
on r.product_variant = t.product_variant
group by r.product_variant, t.total_purchases




