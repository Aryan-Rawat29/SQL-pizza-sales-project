--										PIZZA HUT PROJECT

select * from orders;
select * from order_details;
select * from pizzas;
select * from pizza_types1;

--Q   Retrieve the total number of orders placed

select count(order_id) as total_order from orders;

--Q   Calculate the total revenue generated from pizza sales.

select round(sum(od.quantity * p.price),2) as total_revenue
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id;

--Q   Determine the distribution of orders by hour of the day.

select DATEPART(hour,time) as hours , count(order_id) as total_orders
from orders
group by datepart(hour,time)
order by datepart(hour,time);

--Q   Join relevant tables to find the category-wise distribution of pizzas

select pt.category , count(o.order_details_id) as pizza_distributed
from order_details as o join pizzas as p
on o.pizza_id = p.pizza_id join pizza_types1 as pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.category;

--Q   Group the orders by month and calculate the average number of pizzas ordered per month

with cte1 as (
select o.date as date, sum(od.quantity) as total_pizza
from orders as o
join order_details as od
on o.order_id = od.order_id
group by o.date
)
select datepart(month, date) as Months , avg(total_pizza) as avg_pizza
from cte1
group by datepart(month, date);


--Q   Determine the top 3 most ordered pizza types based on revenue

select top 3 pt.name, round(sum(od.quantity * p.price),2) as total_sales
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
join pizza_types1 as pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.name
order by total_sales desc ;

--Q   Show the top 3 pizza categories by revenue.

select top 3 pt.category, round(sum(od.quantity * p.price),2) as total_sales
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
join pizza_types1 as pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.category
order by total_sales desc;

--Q   Identify the pizza type with their total revenue in July 2015. 

select pt.name, 
datepart(month,o.date) as months
,round(sum(od.quantity * p.price),2) as total_sales
from orders as o
join order_details as od
on o.order_id = od.order_id
join pizzas as p
on od.pizza_id = p.pizza_id
join pizza_types1 as pt
on p.pizza_type_id = pt.pizza_type_id
where datepart(month,o.date) = 7
group by pt.name, datepart(month,o.date);

--Q   Compare current month sales with previous month sales.

with cte1 as (
select DATEPART(month,o.date) as date_month,
round(sum(od.quantity * p.price),2) as total_sales
from orders as o
join order_details as od
on o.order_id = od.order_id
join pizzas as p
on od.pizza_id = p.pizza_id
group by DATEPART(month,o.date)
)
select date_month,total_sales,
lag(total_sales) over (order by date_month) as previous_month_sales
from cte1
order by date_month;

--Q   Identify the highest-priced pizza

select top 1 pt.name, p.price
from pizzas as p join pizza_types1 as pt
on p.pizza_type_id = pt.pizza_type_id
order by p.price desc;

--Q   Identify the most common pizza size ordered.

select p.size , count(od.quantity) as total_orders
from order_details as od join pizzas as p
on od.pizza_id = p.pizza_id
group by p.size
order by total_orders desc;

--Q   List the top 5 most ordered pizza types along with their quantities.

	select top 5 pt.name, count(od.quantity) as total_orders
	from pizzas as p join pizza_types1 as pt
	on p.pizza_type_id = pt.pizza_type_id 
	join order_details as od on od.pizza_id = p.pizza_id
	group by pt.name
	order by total_orders desc;

--Q   Join the necessary tables to find the total quantity of each pizza category ordered.

select pt.category, sum(od.quantity) as total_quantity
from 
order_details as od join pizzas as p
on od.pizza_id = p.pizza_id
join pizza_types1 as pt on p.pizza_type_id = pt.pizza_type_id
group by pt.category;


