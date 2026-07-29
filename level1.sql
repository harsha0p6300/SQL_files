use harshadb
CREATE TABLE employe (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary DECIMAL(10,2),
    age INT,
    city VARCHAR(30),
    joining_date DATE
);
INSERT INTO employe
(emp_id, emp_name, department, salary, age, city, joining_date)
VALUES
(101, 'Harsha', 'IT', 55000, 22, 'Hyderabad', '2024-01-15'),
(102, 'Rahul', 'HR', 42000, 25, 'Bengaluru', '2023-08-10'),
(103, 'Priya', 'IT', 65000, 27, 'Chennai', '2022-05-20'),
(104, 'Anjali', 'Finance', 48000, 30, 'Pune', '2021-11-01'),
(105, 'Kiran', 'Sales', 39000, 24, 'Hyderabad', '2024-03-18'),
(106, 'Sneha', 'IT', 70000, 29, 'Mumbai', '2020-07-12'),
(107, 'Arjun', 'HR', 45000, 26, 'Delhi', '2022-09-25'),
(108, 'Meena', 'Finance', 52000, 31, 'Chennai', '2021-02-14'),
(109, 'Vikram', 'Sales', 47000, 28, 'Bengaluru', '2023-04-08'),
(110, 'Divya', 'Marketing', 43000, 23, 'Hyderabad', '2024-06-30');


#1) Write a query to display all employee details.
select *from employe;

#2) Display only employees who belong to the IT department.
select *from employe
where department='IT';

#3) Find the highest, lowest, and average salary of all employees.
select max(salary) as max_salary,min(salary) as lowest_salary, avg(salary) as avg_salary
from employe;

#4) Display each department along with its average salary.
select department,avg(salary) as average_salary from employe
group by department;

#5) Display employees whose salary is greater than the average salary of all employees.
select *from employe
where salary>(
	select avg(salary) from employe);

#6) Display the names and salaries of employees whose salary is greater than ₹45,000.
select emp_name,salary from employe
where salary>45000;

#7) Display each department and the total salary paid in that department.
select department,sum(salary) as total_salarypaid from employe
group by department;

#Display employee names along with a new column called Salary_Status:
select emp_name,salary,
CASE
	when salary>=60000 then "High"
    when salary between 40000 and 59999 then "Medium"
    when salary<40000 then "low"
end as Salary_status
from employe;

#Display all employees whose names: Start with R, OR End with n
select *from employe
where emp_name like 'R%'
or emp_name like'%n';


#Display the second highest salary.
select emp_name,salary
from employe
where salary=(
select max(salary)
from employe
where salary<(select max(salary) from employe));
#for the reference to find the highest salary
select emp_name,max(salary) as high 
from employe
group by emp_name
order by high desc limit 2;

#2. Display employees whose salary is greater than the average salary of all employees.
select *from employe
where salary>(
select avg(salary)
from employe);

#3)Find the department with the highest average salary.
select department,avg(salary) as high_avg_salary from employe
group by department
order by high_avg_salary desc limit 1;

#Display each department along with its total salary.
select department,sum(salary) as total_salary
from employe
group by department;

#Find employees whose salary is greater than every employee in the HR department.
select department,salary from employe
where salary>ALL(
select salary from employe
where department='HR');

#Display the top 2 highest-paid employees from each department.
select department, emp_name,salary
from(
	select department,emp_name,salary,
    row_number() over(PARTITION by department order by salary desc) as rn
    from employe) ranked
where rn<=2;

#Find employees who earn more than their department's average salary.
select emp_name,salary,department
from employe
where salary in(
	select avg(salary) as avg_salary 
    from employe
    group by department);
    
#Display each employee's name in uppercase.
select upper(emp_name)  from employe;

#Display employees who joined after 1st January 2021.
select *from employe
where joining_date>'2021-01-01';

#If an employee's salary is NULL, display 0 instead.
select emp_id,emp_name,department,coalesce(salary,0) as salary
from employe;

#Display the department-wise average salary using a CTE.
with depwisesalary as(
	select department,avg(salary) as avg_salary
    from employe
    group by department
)
select *from depwisesalary;

#Rank employees by salary using ROW_NUMBER().
select emp_id,emp_name,department,salary,
	row_number()OVER(order by salary desc) as rank_salary
from employe;

#Display the previous employee's salary using LAG().
select emp_id, emp_name,department,salary,
	LAG(salary,2) over (order by salary) as two_rows_back
from employe;

#1.)Find the 3rd highest salary without using LIMIT.
select emp_name,max(salary) as third_high_salary
from employe
where salary<(
	select max(salary) from employe
	where salary<(
    select max(salary) from employe
    )
);

#or use denserank() (recomended)
select salary
from(
	select salary,
		dense_rank() over(order by salary desc) as rnk from employe) t
where rnk=3;


#2.)Display employees whose salary is higher than their manager's salary.
select emp_name,department,salary from employe
where salary>(
	select max(salary)
    from employe
    where department='HR');

#Find departments that have more than 3 employees.
select department,count(*) as num_employes
from employe
group by department
having count(*)>=3;

#Display each employee along with the department average salary.
select emp_name,department,salary from employe
where salary=(
	select avg(salary) 
    from employe)
group by department;