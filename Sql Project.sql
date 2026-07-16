create database amazon;
-- Task 3: Write a query to: 
-- Retrieve all customers from a specific city
select * from amazon.customers
where city = "Bettyport";

-- Fetch all products under the "Fruits" category
select *from amazon.products
where category like "Fruits";

-- Task 4: Write DDL statements to recreate the Customers table with the following  constraints:  
-- CustomerID as the primary key. 
 alter table customers.amazon set CustomerID CustomerID primary key;
 
 alter table amazon.customers
 add Primary key(CustomerID);
 
 -- Ensure Age cannot be null and must be greater than 18.
 select*from amazon.customers;
 alter table amazon.customers modify Age CHECK(Age>18);
 
 
 -- ● Task 5: Insert 3 new rows into the Products table using INSERT statements
 select*from amazon.products;
 
 insert into amazon.products(productID,ProductName,Category,SubCategory,PricePerUnit,StockQuantity,SupplierId) values
 (1,"Weebakers","Bakery","Sub-Dairy-3",234,456,7456454-978678-9760),
 (2,"Rose milk","Bakery","Sub-Dairy-2",345,786,67554-986579-7896),
 (3,"Eggpuffs","Bakery","Sub-Dairy-4",567,876,9876-9886-3456);
 
 -- ● Task 6: Update the stock quantity of a product where ProductID matches a specific ID
set sql_safe_updates=0;
 update amazon.products
 set StockQuantity = 256
 where ProductID ='1';
 
 -- Task 7: Delete a supplier from the Suppliers table where their city matches a specific  values
 
 select*from amazon.suppliers;
 
 delete from amazon.Suppliers
where city ="North Lisa" ;

--  Task  8: Use SQL constraints to:○ Add a CHECK constraint to ensure that ratings in the Reviews table are  between 1 and 5.  
alter table amazon.reviews 
add constraint check(Rating between  1 and 5);

--  Add a DEFAULT constraint for the PrimeMember column in the Customers  table
alter table amazon.customers
alter column  PrimeMember set default "NO";

-- Task 9: Write queries using: WHERE clause to find orders placed after 2024-01-01.
select *from amazon.orders;
select *from amazon.orders
where OrderDate > "2024-01-01"; 

-- nHAVING clause to list products with average ratings greater than 4. .  
select*from amazon.reviews;
select productID,avg(rating)as average from amazon.reviews
group by productID having average > 4 order by average asc;

-- ○ GROUP BY and ORDER BY clauses to rank products by total sales
select p.ProductName,p.ProductID,sum(o.Quantity*o.unitPrice-o.Discount) as total_sales from amazon.order_details as o
join amazon.products as p
on p.ProductID=o.ProductID
group by p.ProductName,p.ProductID
order by total_Sales desc;

-- Amazon Fresh wants to identify top customers based on their total spending. We will:  
-- 1. Calculate each customer's total spending.  
select c.Name,o.OrderId,o.CustomerId,sum(o.OrderAmount + o.DeliveryFee-o.DiscountApplied) as total_spending from amazon.orders as o
join amazon.customers as c
on c.CustomerID =o.CustomerID
group by Name,CustomerID,OrderID order by total_spending desc;

-- Rank customers based on their spending.  
select c.Name,sum(o.OrderAmount+o.DeliveryFee-o.DiscountApplied) as spending ,
dense_rank() over (order  by sum(o.OrderAmount+o.DeliveryFee-o.DiscountApplied)desc)as ranking from amazon.orders as o
join amazon.customers as c
on o.CustomerID =c.CustomerID
group by c.Name order by spending;

-- Identify customers who have spent more than ₹5,000
select c.Name,o.CustomerID,sum(o.OrderAmount+o.DeliveryFee-o.DiscountApplied) as spending from amazon.orders as o
join  amazon.customers as c
on c.CustomerID=o.CustomerID
where (o.OrderAmount+o.DeliveryFee-o.DiscountApplied)> 5000 group by o.CustomerID,c.Name 
order by spending asc;

-- Task 11: Use SQL to: 
-- ○ Join the Orders and OrderDetails tables to calculate total revenue per order
select o.orderID,sum(od.Quantity*od.unitPrice-od.Discount) as total_Revenue from amazon.orders as o
join amazon.order_details as od
on od.OrderID=o.OrderID
group by o.orderID 
order By total_revenue desc;

-- Identify customers who placed the most orders in a specific time period.

select c.Name,c.CustomerID,o.orderDate,Count(o.orderID) as total from amazon.orders as o
join  amazon.customers as c
on c.CustomerID = o.CustomerID
where o.OrderDate = "2025-01-01"
group by c.CustomerID
order by total desc ;

-- Find the supplier with the most products in stock.  
select SupplierID,sum(StockQuantity) as total_count from amazon.products
group by SupplierID order by total_count desc;

-- Task 12: Normalize the Products table to 3NF:  
-- ○ Separate product categories and subcategories into a new table
create table amazon.product_category(
category_id varchar(30),
product_name varchar(20),
product_price int,
product_color text);

insert into amazon.product_category
(category_id,
product_name,
product_price,
product_color) values
(101,"redmi",1000,"Red"),
(102,"Iphone",2000,"black"),
(103,"samsung",3000,"white"),
(104,"nokia",4000,"Blue"),
(105,"microsoft",5000,"green"),
(106,"hp",6000,"grey"),
(107,"puma",7000,"yellow"),
(108,"vivo",8000,"gold"),
(109,"oppo",9000,"Brown");

create table amazon.sub_category
(sub_id varchar(20),category_id varchar(30), model text,year int);

insert into amazon.sub_category
(sub_id,category_id, model,year)values
(201,101,"nine",2015),(202,102,"pro",2021),
(203,103,"six",2023),(204,104,"five",2021),
(205,105,"seven",2016),(206,106,"two",2014),
(207,107,"six",2018),(208,108,"one",2017),
(209,109,"Four",2014);

-- Task 13: Write a subquery to:  
-- ○ Identify the top 3 products based on sales revenue.
select*from amazon.orders;
select p.ProductName,sum(o.Quantity*o.UnitPrice-o.Discount) as Total_revenue from amazon.order_details as o
join amazon.products as p
on o.ProductID=p.ProductID
group by p.ProductName order by Total_revenue desc limit 3;

-- Find customers who haven’t placed any orders yet.
select c.Name,o.OrderId,o.CustomerID from amazon.orders as o
join amazon.customers as c
on c.CustomerID=o.CustomerID
where o.CustomerID =null;

-- Task 14: Provide actionable insights:  
-- ○ Which cities have the highest concentration of Prime members?  
select city,Count(Primemember) as total from amazon.customers
where PrimeMember="Yes" group by city order by total desc;
  
-- ○ What are the top 3 most frequently ordered categories?
select *from amazon.products;
select category,count(category) as top from amazon.products
group by category order by top desc limit 3;


