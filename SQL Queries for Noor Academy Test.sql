----Find the highest and lowest selling groups by quantity during the month of July 2022----

SELECT 	b.Group_Id, b.Payment_date, MAX(b.Number_Of_Sales) as Group_With_Highest_Number_of_Sales

FROM 	(
			SELECT Groups.Group_Id, Sales.Payment_date, COUNT(SALES.Group_Id) AS Number_Of_Sales 
					
			FROM 
					Teachers 
					JOIN Groups ON Teachers.Teacher_Id = Groups.Teachers_Id
					JOIN Sales ON Groups.Group_Id = Sales.Group_Id
			WHERE Sales.Payment_date BETWEEN '7/1/2022' AND '7/31/2022'
			GROUP BY Groups.Group_Id, Sales.Payment_date
			ORDER BY Payment_date) b;
			

----Find the highest and lowest selling groups by revenue during the month of July 2022.----			

SELECT b.Group_Id, b.Payment_date, MAX(b.Revenue) AS Highest_Revenue_K, MIN(b.Revenue) AS Lowest_Revenue_In_K

FROM 
		(
			SELECT 
					Groups.Group_Id, Sales.Payment_date, ROUND(SUM(Sales.Paid_Amount),2) AS Revenue
			FROM 
					Teachers 
					JOIN Groups ON Teachers.Teacher_Id = Groups.Teachers_Id
					JOIN Sales ON Groups.Group_Id = Sales.Group_Id
			WHERE Sales.Payment_date BETWEEN '7/1/2022' AND '7/31/2022'
			GROUP BY Groups.Group_Id, Sales.Payment_date) b;


---- teachers’ total sales Revenue and sales quantity for that month----

SELECT 
		Teachers.Teacher_Id, SUM(Sales.Paid_Amount) AS REVENUE, COUNT(Sales.Group_Id) AS Quantity_Sold
FROM 
		Teachers 
		JOIN Groups ON Teachers.Teacher_Id = Groups.Teachers_Id
		JOIN Sales ON Groups.Group_Id = Sales.Group_Id
WHERE Sales.Payment_date BETWEEN '7/1/2022' AND '7/31/2022'
GROUP BY Teachers.Teacher_Id
LIMIT 3;
		
			
----If we were to have 1 table on sales that would have all the data from all 3 tables combined, how  would you go about and write it ----
			
			
SELECT 
		*
FROM 
		Teachers 
		JOIN Groups ON Teachers.Teacher_Id = Groups.Teachers_Id
		JOIN Sales ON Groups.Group_Id = Sales.Group_Id;
		

			
			
			
			
			

			