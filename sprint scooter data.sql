SELECT * FROM scooter.sales;
where product_id = 7
order by date_of_purchase ;

SELECT count(product_id) FROM sales;

SELECT count(product_id) FROM sales
where product_id='7';

-----------------------------------------------------------------------------

select date(sales_transaction_date) from sales;

alter table sales add column date_of_purchase date;
update sales
set date_of_purchase = (date(sales_transaction_date));

------------------------------------------------------------------------------

SELECT year(sales_transaction_date) from sales;

alter table sales add column year_of_purchase varchar(10);
update sales
set year_of_purchase = (year(sales_transaction_date));

------------------------------------------------------------------------------

select count(product_id), year_of_purchase from sales 
where product_id = 7
group by 2
order by 2;

------------------------------------------------------------------------------

/* What is the cumulative sales volume (in units) for the first 7 days between 10- 10 -2016 and 16-10-2016? */
 
 select count(product_id), date_of_purchase from sales 
 where date_of_purchase between '2016-10-10' and '2016-10-16' and product_id = 7
 group by 2
 order by 2;
 
 select count(product_id), date_of_purchase,
 sum(count(product_id)) over() as total
 from sales s
 where date_of_purchase between '2016-10-10' and '2016-10-16' and product_id = 7
 group by 2
 order by 2;	
 

 ------------------------------------------------------------------------------
 
 /* On 20th Oct, What are the last 7 days' Cumulative Sales of Sprint Scooter (in units)? */
 
/*select * from ( select count(product_id), date_of_purchase,
 row_number () over () as rn,
 sum(count(product_id)) over(partition by product_id rows between 6 preceding and current row ) as total_sold
 from sales 
 where date_of_purchase ='2016-10-20' and product_id = 7
 group by 2
 order by 2) as x
 where x.rn <=6;*/
 
 
  select count(product_id), date_of_purchase,
 sum(count(product_id)) over( ) as total_sold
 from sales s
 where date_of_purchase between '2016-10-14' and '2016-10-20' and  product_id = 7
 group by 2
 order by 2;
 
 ------------------------------------------------------------------------------
 
/* On which date did the sales volume reach its highest point? */

select count(product_id), date_of_purchase
from sales
group by 2 
order by 1 desc
limit 3;

/* highest sales volume of sprint scooters withing days of its release*/

select count(product_id), date_of_purchase
from sales
where date_of_purchase between '2016-10-10' and '2016-10-21' and product_id = 7
group by 2 
order by 1 desc
limit 3;

------------------------------------------------------------------------------
 
/*On 22-10-2016 by what percentage, cumulative sales of last 7 days dropped compared to last 7 days cumulative sales on 21-10-2016?*/


with temp as ( select count(product_id), date_of_purchase,
 sum(count(product_id)) over( ) as total_sold1
 from sales s
 where date_of_purchase between '2016-10-15' and '2016-10-21' and product_id = 7
 group by 2
 order by 2),
temp_2 as (select count(product_id), date_of_purchase,
 sum(count(product_id)) over( ) as total_sold2
 from sales s
 where date_of_purchase between '2016-10-16' and '2016-10-22' and product_id = 7
 group by 2
 order by 2) 
select (((total_sold2 - total_sold1) / total_sold1)*100) as percentage_drop
from temp, temp_2;


------------------------------------------------------------------------------

select date_of_purchase, count(product_id) as unit_sold,
sum(count(product_id)) over(order by date_of_purchase rows between 6 preceding and unbounded following) as cumm_sale
  from sales 
where product_id = 7
group by 1
order by 1;

select  p.model, (select count(s.product_id)) as unit_sold,
sum(count(s.product_id)) over(partition by p.model rows between 6 preceding and current row) as cumm_sale
from sales as s
join products as p on p.product_id = s.product_id 
group by 1;

------------------------------------------------------------------------------

/* 3 week sale of sprint scooter */

select p.model, s.product_id, date_of_purchase, count(s.product_id) as unit_sold
from sales as s
join products as p on p.product_id = s.product_id
where s.product_id = 7
group by 1,3
order by 3
limit 21;