#Find the Minimum and Maximum Salary
SELECT MIN(salary) AS MinSalary, MAX(salary) AS MaxSalary FROM employees;

#Find Total Salary Paid in Each Department
SELECT department, SUM(salary) FROM employees GROUP BY department;

#INNER JOIN – Get Employee Details with Department Names
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;



#LEFT JOIN – Get All Employees (Even If They Have No Department)
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

#Find Employees Who Earn More Than the Average Salary
SELECT first_name, last_name, salary 
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);

#Rank Employees by Salary (DENSE_RANK)
SELECT first_name, last_name, salary, 
       DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

#Replace NULL Values with Default Text (COALESCE)
SELECT first_name, last_name, COALESCE(department, 'No Department') 
FROM employees;

#Find Employees with Missing Department Information
SELECT * FROM employees WHERE department_id IS NULL;

#Categorize Employees Based on Salary
SELECT first_name, last_name, salary,
    CASE 
        WHEN salary > 80000 THEN 'High Salary'
        WHEN salary BETWEEN 50000 AND 80000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS SalaryCategory
FROM employees;

#Find the Second Highest Salary
SELECT DISTINCT salary 
FROM employees 
ORDER BY salary DESC 
LIMIT 1 OFFSET 1;

# Find Employees Who Have the Same Salary as Someone Else
SELECT first_name, last_name, salary 
FROM employees 
WHERE salary IN (SELECT salary FROM employees GROUP BY salary HAVING COUNT(*) > 1);

#ROW_NUMBER() – Assigns a Unique Row Number
#Use Case: Assign a unique rank to each row, even if values are the same.


#RANK() – Assigns a Rank with Gaps
#Use Case: Assigns ranks, but duplicates cause gaps.

#DENSE_RANK() – Assigns a Rank Without Gaps
#Use Case: Like RANK(), but without gaps.

#Find the Second Highest Salary Using RANK()
SELECT salary 
FROM (SELECT salary, RANK() OVER (ORDER BY salary DESC) AS rnk FROM employees) ranked
WHERE rnk = 2;

#Find the Nth Highest Salary Using DENSE_RANK()
WITH RankedSalaries AS (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk 
    FROM employees
)
SELECT salary FROM RankedSalaries WHERE rnk = 3;

# Running Total Using SUM() with PARTITION
SELECT department, first_name, salary, 
       SUM(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS running_total
FROM employees;

#Moving Average Using AVG()
#Looks at the current row + 2 preceding rows for the average.
#Useful for trend analysis.
SELECT first_name, salary, 
       AVG(salary) OVER (ORDER BY salary ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM employees;

#Percentile Rank Using PERCENT_RANK()
SELECT first_name, salary, 
       PERCENT_RANK() OVER (ORDER BY salary DESC) AS percentile
FROM employees;

# NTILE() – Divide Data into Equal Buckets
#Divides data into 4 groups (quartiles).
#Useful for data segmentation.
SELECT first_name, salary, 
       NTILE(4) OVER (ORDER BY salary DESC) AS quartile
FROM employees;

#second highest salary in each department
WITH RankedSalaries AS (
    SELECT department, employee_name, salary, 
           DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
)
SELECT department, employee_name, salary 
FROM RankedSalaries 
WHERE rnk = 2;   

OR

SELECT department, employee_name, salary 
FROM (
    SELECT department, employee_name, salary, 
           DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
) AS RankedSalaries
WHERE rnk = 2;


#Summary: Which Window Function to Use?
Function	           Use Case
ROW_NUMBER()	       Assigns a unique row number
RANK()	              Ranks with gaps
DENSE_RANK()	       Ranks without gaps
SUM() OVER()	       Running total
AVG() OVER()	       Moving average
PERCENT_RANK()       Percentile ranking
NTILE(n)	       Divide into n buckets



