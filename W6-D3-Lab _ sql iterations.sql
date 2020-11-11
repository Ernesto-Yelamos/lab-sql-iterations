# Lab | SQL Iterations
	# In this lab, you will be using the Sakila database of movie rentals.

use sakila;
-- set sql_safe_updates=0;
-- SET sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

### Instructions
	# Write queries to answer the following questions:

	-- 1. Write a query to find what is the total business done by each store.
    
			-- I will check the total business first:
			select sum(amount) as total_business from sakila.payment;

select b.store_id, sum(a.amount) as total_business from sakila.payment as a
join sakila.staff as b on b.staff_id = a.staff_id
group by b.store_id;


	-- 2. Convert the previous query into a stored procedure.
    
drop procedure if exists total_business_per_store;
delimiter //
create procedure total_business_per_store ()
begin
	select b.store_id, sum(a.amount) as total_business from sakila.payment as a
	join sakila.staff as b on b.staff_id = a.staff_id
	group by b.store_id;
end;
//
delimiter ;

call total_business_per_store ();


	-- 3. Convert the previous query into a stored procedure that takes the input for `store_id` and displays the *total sales for that store*.

drop procedure if exists total_business_per_store_2;
delimiter //
create procedure total_business_per_store_2 (in param1 tinyint)
begin
	select b.store_id, sum(a.amount) as total_business from sakila.payment as a
	join sakila.staff as b on b.staff_id = a.staff_id
	group by b.store_id
    having b.store_id = param1;
end
//
delimiter ;

call total_business_per_store_2 (2);
    

	/*
	4. Update the previous query. Declare a variable `total_sales_value` of float type, 
    that will store the returned result (of the total sales amount for the store). 
    Call the stored procedure and print the results.
	*/
drop procedure if exists total_business_per_store_3;
delimiter //
create procedure total_business_per_store_3 (in param1 tinyint)
begin
	declare total_business float default 0.0;
	select sum(a.amount) into total_business from sakila.payment as a
	join sakila.staff as b on b.staff_id = a.staff_id
	group by b.store_id
    having b.store_id = param1;
    select param1, total_business;
end
//
delimiter ;
    
call total_business_per_store_3 (1);


	/*
	5. In the previous query, add another variable `flag`. 
    If the total sales value for the store is over 30.000, then label it as `green_flag`, otherwise label is as `red_flag`. 
    Update the stored procedure that takes an input as the `store_id` and returns total sales value for that store and flag value.
	*/
-- Using IF/ELSE
drop procedure if exists total_business_per_store_4;
delimiter //
create procedure total_business_per_store_4 (in param1 tinyint, out param2 varchar(20))
begin
	declare total_business float default 0.0;
    declare flag varchar(20) default "";
	select sum(a.amount) into total_business from sakila.payment as a
	join sakila.staff as b on b.staff_id = a.staff_id
	group by b.store_id
    having b.store_id = param1;
    
    if total_business > 30000 then
		set flag = 'green';
	else
		set flag = 'red';
	end if;
    select flag into param2;
    select param1, total_business, flag;
end
//
delimiter ;
    
call total_business_per_store_4 (2, @x);




-- using CASE
drop procedure if exists total_business_per_store_4;
delimiter //
create procedure total_business_per_store_4 (in param1 tinyint, out param2 varchar(20))
begin
	declare total_business float default 0.0;
    declare flag varchar(20) default "";
	select sum(a.amount) into total_business from sakila.payment as a
	join sakila.staff as b on b.staff_id = a.staff_id
	group by b.store_id
    having b.store_id = param1;
    case 
		when total_business > 30000 then set flag = 'green';
		else set flag = 'red';
	end case;
    select flag into param2;
    select param1, total_business, flag;
end
//
delimiter ;
    
call total_business_per_store_4 (1, @x);
