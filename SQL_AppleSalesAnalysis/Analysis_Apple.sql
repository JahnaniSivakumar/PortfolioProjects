-- Apple Retail Sales
/*

DB Name: Apple
==============

Tables (5):
===========
1. Category -- parent
2. Product
3. Sales
4. Warranty
5. Stores -- parent

*/

/*Select commands to view the tables
=====================================
*/


Select * from category;
Select * from product;
Select * from stores;
Select * from sales;
Select * from warranty;

/* Simple EDA
==============
*/


-- To know what all the repair status from warranty DB
Select DISTINCT repair_status from warranty;

-- To know how many records exist in sales table - 1B records
Select count(*) from sales;

/* Improving query performance
===============================
- Creating index for sales table 
- when selected any product_id from the 1B record dataset the results were fetched in 64ms
- after index the query gives result in 4ms
- bitmap indexing
*/

CREATE INDEX sales_product_id On sales(product_id);

CREATE INDEX sales_store_id on sales(store_id);

CREATE INDEX sales_sale_date ON sales(sale_date);


-- Business Problems
-- 1) Find the number of stores in each country

select country, count(store_id) as num_of_stores
from stores
group by country
order by num_of_stores desc;

-- 2) Calculate the total number of units sold by each store

select s.store_id, st.store_name, sum(s.quantity) as total_units_sold
from sales as s
join stores as st 
on s.store_id = st.store_id
group by s.store_id, st.store_name
order by total_units_sold desc;

-- 3) Identify how many sales occured in December 2023

select count(sales_id) as num_of_sales
from sales
where to_char(sale_date, 'MM-YYYY') = '12-2023'

--4) Determine how many stores have never had a warranty claim filed

Select count(*)  as num_of_stores_no_warranty_claim
from stores 
where store_id not in (

                            Select DISTINCT store_id
                            from warranty as w
                            left join sales as s
                            on w.sales_id = s.sales_id
) ;


--5) Calculate the percentage of warranty claims marked as "Warranty Void"
-- (Number of warranty void claims / total claims) * 100

select 
    round((count(claim_id) / 
                    (select count(claim_id) from warranty)::numeric)
    * 100 ,2)
    as warranty_void_percentage
from warranty
where repair_status = 'Warranty Void'

-- 6) Identify which store had the highest total units sold in the last year

select s.store_id, st.store_name, sum(s.quantity) as total_units_sold
from sales as s
join stores as st
where s.sale_date >= (CURRENT_DATE - INTERVAL '1 year')
group by s.store_id, st.store_name
order by total_units_sold desc
limit 1;

-- 7) Count the number of unique products sold in the last year

select COUNT(DISTINCT product_id) as num_of_unique_products
from sales
where sale_date >= (CURRENT_DATE - INTERVAL '1 year')

-- 8) Find the average price of products in each category

select p.category_id, c.category_name, avg(p.price) as average_price
from product as p
join category as c 
p.category_id = c.category_id
group by p.category_id, c.category_name
order by average_price desc;

-- 9) How many warranty claims were filed in 2020?

select count(claim_id) as num_of_claims_files_2020
from warranty
where EXTRACT(YEAR FROM claim_date) = 2020;

-- 10) For each store, identify the best-selling day based on highest quantity sold
-- store_id, day_name, sum(qty), window function rank
with cte as(
                select store_id, to_char(sale_date, 'Day') as best_day, 
                        sum(quantity) as total_units_sold,
                        rank() over(partition by store_id order by sum(quantity) DESC) as rnk
                from sales
                group by 1, 2
                order by 1, 3 desc);


select * from cte 
where rnk = 1; 

-- 11) Identify the least selling product in each country for each year based on total units sold

Select * from 
                (select st.country, p.product_name, sum(s.quantity) as total_units_sold,
                    rank() over(partition by st.country order by sum(s.quantity)) as rnk
                from sales as s
                join stores as st
                on s.sales_id = st.sales_id
                join product as p
                s.product_id = p.product_id
                group by 1, 2
                order by 1, 3) as t 
where t.rnk = 1;

-- 12) Calculate how many warranty claims were filed within 180 days of a product sale

select count(*) as num_of_claims_within_180_days
from warranty as w
left join sales as s
on s.sales_id = w.sales_id
where w.claim_date - s.sale_date <=180;

-- 13) Determine how many warranty claims were filed for products launched in the last two years.

select p.product_name, 
        count(w.claim_id) as num_of_claims_within_2_years,
        count(s.sales_id) as num_of_units_sold
from warranty as w
right join sales as s
on s.sales_id = w.sales_id
join product as p
on p.product_id = s.product_id
where p.launch_date >= CURRENT_DATE - INTERVAL '2 year'
group by 1
having count(w.claim_id) > 0;

-- 14) List the months in the last three years where sales exceeded 5,000 units in the USA

Select 
    to_char(sale_date, 'MM-YYYY') as month,
    sum(s.quantity) as total_units_sold
from sales as s
join stores as st
on s.store_id = st.store_id
where st.country = 'USA'
and s.sale_date >= CURRENT_DATE - INTERVAL '3 years'
group by 1
having sum(s.quantity) > 5000;

-- 15) Identify the product category with the most warranty claims filed in the last two years

select c.category_name, count(w.claim_id) as num_of_claims
from warranty as w
left join sales as s
    on w.sales_id =  s.sales_id
join product as p
    on p.product_id = s.product_id
join category as c
    on c.category_id = p.category_id
where w.claim_date >= CURRENT_DATE - INTERVAL '2 years'
group by 1
order by 2 desc;

-- 16) Determine the percentage chance of receiving warranty claims after each purchase for each country

select country, total_units_sold, num_of_claims,
 coalesce(num_of_claims::numeric/total_units_sold::numeric * 100, 0) as risk
from (select 
                st.country, sum(s.quantity) as total_units_sold,
                count(w.claim_id) as num_of_claims
                from sales as s
                join stores as st
                on s.store_id = st.store_id
                left join warranty as w on w.sales_id = s.sales_id
                group by 1) t1 
order by 4 desc;


-- 17) Analyze the year-by-year growth ratio for each store


with yearly_sales as(
                        Select s.store_id, st.store_name, EXTRACT(YEAR FROM sale_date) as year, 
                        sum(s.quantity * p.price) as total_sales 
                        from sales as s
                        join product as p
                        on s.product_id = p.product_id
                        join stores as st on st.store_id = s.store_id
                        group by 1, 2, 3
                        order by 2, 3) 
,
growth_ratio as(
                    select store_name, year, 
                    lag(total_sales,1) over(partition by store_name order by year) as previous_year_sales,
                    total_sales as current_year_sales
                    from yearly_sales)

select store_name, year, previous_year_sales, current_year_sales,
round((current_year_sales - previous_year_sales)::numeric/previous_year_sales::numeric * 100,3) as growth_ratio
from growth_ratio
where previous_year_sales IS NOT NULL
and year <> EXTRACT(YEAR FROM CURRENT_DATE)

 -- 18) Calculate the correlation between product price and warranty claim 

select 
    case
    when p.price < 500 then 'Less Expensive Product'
    when p.price BETWEEN 500 and 1000 THEN 'Mid Range Product'
    else 'Expensive Product'
    end as price_segment,
    count(w.claim_id) as num_of_claims, 
from warranty as w
left join sales as s
on w.sales_id = s.sales_id
join products as p
on p.product_id = s.product_id
where claim_date >= CURRENT_DATE - INTERVAL '5 year'
group by 1

-- 19) Identify the store with the highest percentage of "Paid Repaired" claims relative to total claims filed

with paid_repaired as(

                    Select s.store_id, count(w.claim_id) as num_of_claims_paid_repair
                    from sales as s
                    join warranty as w
                    on w.sales_id = s.sales_id
                    where w.repair_status = 'Paid Repaired'
                    group by 1)

, 
total_repaired as (
                    Select s.store_id, count(w.claim_id) as num_of_claims
                    from sales as s
                    join warranty as w
                    on w.sales_id = s.sales_id
                    group by 1)

select tr.store_id, st.store_name,
    pr.num_of_claims_paid_repair, tr.num_of_claims,
    round
    (pr.num_of_claims_paid_repair::numeric/tr.num_of_claims::numeric * 100,2) as percentage_paid_repair
from paid_repaired as pr 
join total_repaired as tr
on pr.store_id = tr.store_id
join stores as st
on tr.store_id = st.store_id;


-- 20) Write a query to calculate the monthly running total of sales for 
--each store over the past four years and compare the trends during 
--this period.

with monthly_sale as (
                        select 
                        store_id, EXTRACT(YEAR FROM sale_date) as year,
                        EXTRACT(MONTH FROM s.sale_date) as month,
                        sum(p.price * s.quantity) as total_revenue
                        from sales as s 
                        join products as p
                        on s.product_id = p.product_id
                        group by 1,2,3
                        order by 1, 2, 3)

select store_id, month,year, total_revenue,
sum(total_revenue) over(partition by store_id order by year, month) as running_total
from monthly_sale;
