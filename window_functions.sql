use ecommerce_db;

drop table employees
CREATE TABLE employees (
	employee_id int primary key,
    employee_name varchar(100),
    hire_date date,
    department_name varchar(100),
    salary decimal(10,2)
);
INSERT INTO employees 
(employee_id, employee_name, hire_date, department_name, salary)
VALUES
(1, 'Arjun Kumar', '2020-01-15', 'IT', 65000.00),
(2, 'Priya Sharma', '2019-03-22', 'Finance', 72000.00),
(3, 'Rahul Verma', '2021-07-10', 'IT', 58000.00),
(4, 'Sneha Reddy', '2018-11-05', 'HR', 55000.00),
(5, 'Vikram Singh', '2022-02-18', 'Sales', 48000.00),
(6, 'Ananya Rao', '2020-06-25', 'Finance', 72000.00),
(7, 'Kiran Patel', '2017-09-12', 'IT', 85000.00),
(8, 'Meera Nair', '2023-01-09', 'HR', 45000.00),
(9, 'Aditya Reddy', '2019-12-16', 'Sales', 52000.00),
(10, 'Pooja Desai', '2021-04-20', 'Marketing', 60000.00),
(11, 'Rohit Kumar', '2016-08-30', 'IT', 92000.00),
(12, 'Divya Sharma', '2022-10-11', 'Marketing', 51000.00),
(13, 'Suresh Babu', '2018-05-17', 'Finance', 76000.00),
(14, 'Neha Kapoor', '2020-09-03', 'Sales', 57000.00),
(15, 'Manoj Rao', '2017-02-14', 'HR', 62000.00),
(16, 'Isha Patel', '2023-06-19', 'IT', 49000.00);

select *from employees e;
#basic window function operation or syntax
select *, max(salary) over(partition by department_name) as max_salary from employees;

#ROW_NUMBER() fucntion usecase
select row_number() over(partition by department_name) as r0w_Number,e.* from employees e;

#find first two employees who joined in the company from each department
select *from
(select e.*, row_number() over( partition by department_name order by hire_date asc) as rn 
from employees e) x
where x.rn<3;

#Find the top3 highest paid employees in each deparment using the RANK() function
select *from
(select e.*,rank() over(partition by department_name order by salary desc) as high_salary 
	from employees e) high
where high.high_salary<4;

#Find the top3 highest paid employees in each deparment using the DENSE_RANK() function
select *from
(select e.*,dense_rank() over(partition by department_name order by salary desc) as dense_R
	from employees e) high
where high.dense_R<4;

/*The Lag() and Lead() Functions in SQL are window functions 
that allow you to access data from a previous row (LAG()) or a subsequent row (LEAD())
in the result set,without needing to perform a self-join.
These functions are very useful when you need to compare values between consecutive rows or
analyze trends over time.*/

#use case of the lag() function
select e.*,lag(salary) over(partition by department_name order by employee_id) as pre_emp_salary
from employees e;

select e.*,lag(salary,2,0) over(partition by department_name order by employee_id) as pre_emp_salary
from employees e;

#usecase of the LEAD() function
select e.*,	lead(salary) over(partition by department_name order by employee_id) as pre_emp_salary
from employees e;

select e.*,	lead(salary,2,0) over(partition by department_name order by employee_id) as pre_emp_salary
from employees e;