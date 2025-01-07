![image](https://github.com/user-attachments/assets/f1878605-036a-4895-9550-445829fb1819)

# Apple Sales Analysis - SQL [Dataset - 1M+]

### Problem Statement

- Apple operates a global retail ecosystem, with thousands of products sold across stores.
- The company aims to understand its sales performance, product trends, and warranty claims while identifying key drivers of revenue growth and customer satisfaction
- However, the massive dataset, comprising multiple tables (category, products, stores, sales transactions, and warranty claims), requires exploration and analysis
- The **goal** is to derive **actionable insights using SQL for effective decision-making** to answer questions about product performance, store efficiency, and claim resolutions

### Solution Breakdown - [Link to Solution](Analysis_Apple.sql)

This project primarily focuses on leveraging SQL to explore data from multiple tables
- **Complex Joins and Aggregations**: Demonstrating the ability to perform complex SQL joins and aggregate data frm multiple tables
- **Window Functions**: Using advanced window functions for running totals, growth analysis, and time-based queries.
- **Data Segmentation**: Analyzing data across different time frame to gain insights into product performance.
- **Correlation Analysis**: Applying SQL functions to determine relationships between variables, such as product price and warranty claims.

### Entity Relationship Diagram [ERD]

![image](https://github.com/user-attachments/assets/9f0f7509-2f97-42e6-a393-87b444c494e1)

## Database Overview

Five main tables:

1. **stores**: Contains information about Apple retail stores.
   - `store_id`: Unique identifier for each store.
   - `store_name`: Name of the store.
   - `city`: City where the store is located.
   - `country`: Country of the store.

2. **category**: Holds product category information.
   - `category_id`: Unique identifier for each product category.
   - `category_name`: Name of the category.

3. **products**: Details about Apple products.
   - `product_id`: Unique identifier for each product.
   - `product_name`: Name of the product.
   - `category_id`: References the category table.
   - `launch_date`: Date when the product was launched.
   - `price`: Price of the product.

4. **sales**: Stores sales transactions.
   - `sale_id`: Unique identifier for each sale.
   - `sale_date`: Date of the sale.
   - `store_id`: References the store table.
   - `product_id`: References the product table.
   - `quantity`: Number of units sold.

5. **warranty**: Contains information about warranty claims.
   - `claim_id`: Unique identifier for each warranty claim.
   - `claim_date`: Date the claim was made.
   - `sale_id`: References the sales table.
   - `repair_status`: Status of the warranty claim (e.g., Paid Repaired, Warranty Void).

## Key Business Problems Solved

1. Optimized the performance of the DB by creating Index
2. Initial exploratory analysis to understand the dataset and featured new fields

     **Example: Determining how many stores have never had a warranty claim filed to understand store efficiency**
      ```
      Select count(*)  as num_of_stores_no_warranty_claim
      from stores 
      where store_id not in (
      
                                  Select DISTINCT store_id
                                  from warranty as w
                                  left join sales as s
                                  on w.sales_id = s.sales_id
      ) ;
    ```
3. Identifying the key insights from the data by creating key point indicators

   **Example: a) Identifying the best sales day based on highest quantity sold in the week for every store**

   ```
   with cte as(
                  select store_id, to_char(sale_date, 'Day') as best_day, 
                          sum(quantity) as total_units_sold,
                          rank() over(partition by store_id order by sum(quantity) DESC) as rnk
                  from sales
                  group by 1, 2
                  order by 1, 3 desc);


      select * from cte 
      where rnk = 1; 
   ```
   **Example: b) Identifying the product category with most warranty claims filed in the last 2-years**

   ```
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
      order by 2 desc
   ```
4. Developed stakeholder-focused insights to analyze and interpret data trends over time

   **Example: a) Analyzing the year-by-year growth ratio for each store**

   ```
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
   ```
   **Example: b) Calculating the monthly running total of sales for each store over the past four years to compare the trends**

   ```
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
   ```

## Conclusion

Therefore, by leveraging SQL, was able to achieve valuable insights into sales trends, product performance, and customer behavior, helping businesses make data-driven decisions for optimizing sales strategies and improving overall operational efficiency.
