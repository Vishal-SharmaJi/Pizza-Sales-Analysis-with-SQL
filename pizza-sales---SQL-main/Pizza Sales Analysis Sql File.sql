# 1. Retrieve the total number of orders placed.

select count(order_id) as total_orders from orders;

                            -- Total-orders are 21350
                            
                            
--------------------------------------------------------------------------------------------------------
# 2. Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS Total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;

# By sum() we sum all the multiplied values and the answer is in multiple poiints values.. so we use round(**,2) function so we write 2 then only 2 decimals are shown in the final result.

# Total_sales is 817860.05


---------------------------------------------------------------------------------------------------------
		  --        To beautify any query we select the query an press Ctrl + B          --
---------------------------------------------------------------------------------------------------------



# 3. Identify the highest-priced pizza. 

-- For max price [ select max(pizzas.price) as Highest_Price_Pizza from pizzas;  ]

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1
;
---------------------------------------------------------------------------------------------------------

# 4. Identify the most common pizza size ordered.

SELECT 
    pizzas.size, COUNT(order_details.order_details_id) as count_of_Sizes
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY count_of_Sizes desc ; 
 
---------------------------------------------------------------------------------------------------------

# 5. List the top 5 most ordered pizza types along with their quantities.
 
SELECT 
    pizza_types.name, SUM(order_details.quantity) AS Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY Quantity DESC
LIMIT 5;

--  in this Query we use 2 join to joining the 3 table because we have to apply the direct join on "order_details" & "Pizza_type" 
-- Order_details have 'Pizza_id' & 'Quantity'.
-- Pizza_type have 'pizza_type_id' & 'name'.
#               but there we not found any common column.
-- So we pick up 3rd Table named "Pizza" which has 'pizza_id' and 'pizza_type_id' also.
-- we apply join firstly in pizza_type :- 'pizza_type_id' & pizzas :- 'pizza_Type_id'    and then   order_details :- 'pizza_id' & pizza :- 'pizza_id'.
-- Then we sum the order_details:- 'Quantity' for the get the tital number of pizza orders based on the name..
-- To see the sum of orders of each pizza type name separatly we use group by .
-- every time uses a aggregrate function like : "sum(),avg() etc. " we use group by function on the non-aggregrate column like "name".
-- order by for order , desc for decending order .
-- In question we have to ask the 5 top order pizzas name. so we put limit 5.


---------------------------------------------------------------------------------------------------------
											-- Intermediate:
# 6. Join the necessary tables to find the total quantity of each pizza category ordered.
 
 SELECT 
    pizza_types.category, SUM(order_details.quantity) AS Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY Quantity Desc;
 
-- same as 5th question only we replace pizza name by pizza category.
---------------------------------------------------------------------------------------------------------


# 7. Determine the distribution of orders by hour of the day. 

SELECT 
    HOUR(order_time) AS Hours, COUNT(order_id) AS Orders_count
FROM
    orders
GROUP BY Hours
ORDER BY Orders_Count DESC;

-- by hour() we getting the hours from order_time. & apply count function og order_id so app the orders count we get according to corresponding hours.

---------------------------------------------------------------------------------------------------------
                                        -- In Easy question
                                        
# 8. Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

---------------------------------------------------------------------------------------------------------

# 9. Group the orders by date and calculate the average number of pizzas ordered per day. 
 select avg(Quantity) from
(Select orders.order_date,sum(order_details.quantity) as Quantity from order_details join  orders on orders.order_id= order_details.order_id  group by orders.order_date) AS Order_quantity;
 
										# Important
 
 
 -- whenever we use single table we dont need to mention table name in front of column name. like:- select "order_date" from orders;
     
 -- but when we use 2 or more tables by joining it we need to mention the table name before column name every time. like:-  select "orders.order_date" from order_details join  orders on orders.order_id= order_details.order_id;
 
 -- By this query we can get total numbers of orders by each date.   
 #   "Select orders.order_date,sum(order_details.quantity) as Quantity from order_details join
 #    orders on orders.order_id= order_details.order_id  group by orders.order_date;" 
 
 -- we can make the above query to a sub query and extract avg. numbers of orders .
 -- sub query must be have an alias "as *****" because the main query only executed when sub-query have an alias only.
 
 
 ---------------------------------------------------------------------------------------------------------

# 10.  Determine the top 3 most ordered pizza types based on revenue.
 
 
SELECT 
    pizza_types.name AS Name,
    ROUND(SUM(order_details.quantity * pizzas.price),2) AS Revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY Revenue DESC
LIMIT 3;


 -- SUM(order_details.quantity * pizzas.price) by this query. The small pizza quantity is multipy by small pizaa price only and same for large & medium. when all the price is multiplied we applied a sum function to sum all the multipied prices.. we put group by on the basis of name so all pizza_m, pizza_l,pizza_s sizes are grouped into main name and all the revenue generated by all of the categories will show by summing up into the main category. the we apply oeder by on the basis of revenue.
 
 
 
 ---------------------------------------------------------------------------------------------------------

                                       # Advanced:
                                       
# 11. Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.category AS Category,
    ROUND(
    (
    SUM(order_details.quantity * pizzas.price) -- Each pizza category revenue
    
    / -- Divide both
    
    (select SUM(order_details.quantity * pizzas.price) FROM 
    order_details join pizzas ON pizzas.pizza_id = order_details.pizza_id)  -- Total revenue
    )
    *100 -- (Each category revenue / Total revenue )*100  for percentage value.
    ,2) AS Revenue  -- ,2) for Round() function round the values to 2 decimal places only.
FROM
    pizza_types JOIN pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY Revenue DESC ;


-- this sub query gives the ttal revenue "(select SUM(order_details.quantity * pizzas.price) FROM order_details join pizzas ON pizzas.pizza_id = order_details.pizza_id)"




---------------------------------------------------------------------------------------------------------
                                       
# 12. Analyze the cumulative revenue generated over time.

select orders.order_date,sum(order_details.quantity*pizzas.price) as Revenue from orders join order_details on orders.order_id = order_details.order_id join pizzas on pizzas.pizza_id = order_details.pizza_id group by orders.order_date ; -- This query gives the revenue of each date. 

select order_date ,round(sum(revenue) over (order by order_date),2) as cum_revenue  
From 
(select orders.order_date,sum(order_details.quantity*pizzas.price) as Revenue from orders join order_details on orders.order_id = order_details.order_id join pizzas on pizzas.pizza_id = order_details.pizza_id group by orders.order_date) as sales ;

-- For sum(revenue) over (order by order_date) cumilative sum we use this query.



---------------------------------------------------------------------------------------------------------
                                       
# 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category,Name,Revenue,Rank_ from
(  select category ,name , revenue ,rank() over(partition by category order by revenue desc ) as Rank_ 
FROM
( SELECT 
    pizza_types.category,
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category , pizza_types.name
ORDER BY category , revenue DESC )as a
) as b
where rank_ <=3;



