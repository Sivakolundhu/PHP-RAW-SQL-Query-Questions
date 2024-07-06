-- 1. Find the second highest salary in each department.
SELECT department_id, department_name, max(salary) as salaryMax FROM employees as e1, departments
where 
departments.department_id = employees.department_id AND
salary < (
	SELECT max(salary) as actualhighSalary 
    from employees as e2 
    WHERE
    e2.department_id = e1.department_id
)
group by e1.department_id;


-- 2. Calculate the difference in sales between each employee's current sale and their previous sale.
SELECT employees.name, s1.amount as current_amount, s2.amount as prev_amount, (s1.amount-s2.amount) as sales_difference 
from employees, sales as s1
JOIN sales as s2 ON s1.employee_id = s2.employee_id AND 
s1.sale_date > s2.sale_date
WHERE
employees.employee_id = s1.employee_id AND 
s2.saledate = ( SELECT max(s3.sales_date) as  
    from sales as s3 
    WHERE  s3.employee_id = s1.employee_id AND 
           s3.sale_date < s1.sale_date
) group by s1.employee_id, s1.sale_date;


-- Retrieve the average salary of employees in each department and the difference of each employee's salary from the department's average salary.
SELECT e.employee_id, e.name, d1.department_name, e.salary, e.salary - d.avg_salary as salary_difference 
FROM employees as e, departments as d1
JOIN (
    SELECT department_id, AVG(salary) as avg_salary from employees group by department_id
) as d 
ON d.department_id = e.department_id
WHERE
e.department_id = d1.department_id;


-- Find the cumulative percentage of total sales amount for each employee.

SELECT 
    employees.name,
    employees.employee_id,
    sales.sales_id,
    sales.sales_date,
    sales.amount,
    totalsales.sumofsales,
    ( (sum(sales.amount) / totalsales.sumofsales) * 100 ) as cumulative_percent
FROM sales, employees  
JOIN ( select employee_id, sum(amount) as sumofsales from sales group by employee_id ) as totalsales 
ON totalsales.employee_id = sales.employee_id 
WHERE employees.employee_id = sales.employee_id
ORDER BY sales.employee_id, sales.sales_date


-- Retrieve the top 3 most expensive products in each category.
Select mp.* from products as mp 
where (
    select count(*) from products as p1 
    where p1.category = mp.category AND p1.price < mp.price 
) < 4
group by category DESC; 


-- Retrieve the sales of each employee as a percentage of the total sales in their department.
Select
    em.employee_id,
    em.name,
    em.department_id,
    s1.amount,
    (s1.amount / totalsales.sumofsales) * 100 as percent_of_total_sales
from sales as s1 , employees as em
JOIN ( 
    select s2.employee_id, sum(s2.amount) as sumofsales 
    from sales as s2, employees as e1  
    where s2.employee_id = e1.employee_id
    group by e1.department_id ) as totalsales    
group by s1.employee_id 


-- Retrieve the name and total sales amount for the employee with the second highest total sales.
select 
    e.name,
    sum(sh.totsales) as total_sales_amount 
from employees as e 
JONI (
    Select employee_id, sum(amount) as totsales from sales group by employee_id order by totsales DESC limit 1,1
) as sh ON e.employee_id = sh.employee_id

-- Identify the customers who have not placed any orders in the last 6 months.
Select customer_id, name from customers, orders where orders.customer_id=cusmomers.customer_id AND orders.order_data >= (DATE_SUB(NOW(), INTERVAL 6 MONTH)







