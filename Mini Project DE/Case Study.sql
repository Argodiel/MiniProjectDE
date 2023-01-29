/** Customer Analisis **/
/* Step 1 Filter Data */
with dataset as (
	select 	
		Customers.CustomerID, 
		Customers.CompanyName,
		Orders.OrderID, 
		Orders.OrderDate, 
		sum([Order Details].UnitPrice*Quantity*(1-Discount)) as Total_Sales
	from Customers
		inner join Orders on Customers.CustomerID=Orders.CustomerID
		inner join [Order Details] on Orders.OrderID=[Order Details].OrderID
	where year (Orders.OrderDate) between '1997' and '1998'
	group by Customers.CompanyName, Customers.CustomerID, Orders.OrderID,Orders.OrderDate
),

/* Step 2 Summirized Data */
 Order_Summary as (
	select
		CustomerID, OrderID, OrderDate, Total_Sales
	from dataset
	group by CustomerID, OrderID,OrderDate, Total_Sales
)

/* Step 3 Put together the RFM Report */
select 
t1.CustomerID, --t1.OrderID, t1.OrderDate,
--(select MAX(OrderDate) from Order_Summary) as max_order_date,
--(select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID) as max_customer_order_date
	datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) as Recency,
	count (t1.OrderID) as Frequency,
	sum (t1.Total_Sales) as Monetary,
	ntile (3) over (order by datediff (day, (select max(OrderDate) from Order_Summary where CustomerID = t1.CustomerID), (select MAX(OrderDate) from Order_Summary)) desc) as R,
	ntile (3) over (order by count (t1.OrderID) asc) as F,
	ntile (3) over (order by sum (t1.Total_Sales) asc) as M
from Order_Summary t1
group by t1.CustomerID --, t1.OrderID, t1.OrderDate
order by 1,3 desc;

/** Supplier Analisis **/
WITH T1 AS
	(SELECT p.ProductName, s.companyname, sum(p.unitsinstock) as Stock,
		sum(od.unitprice*quantity*(1 - discount)) as Total_Sales, Month (o.OrderDate) AS Bulan, 
		ROW_NUMBER () OVER(PARTITION BY MONTH(o.OrderDate) ORDER BY sum(od.UnitPrice*Quantity*(1-discount)) ASC) as LeastSales,o.OrderDate
	FROM Suppliers s
		inner join Products p on p.SupplierID=s.SupplierID
		inner join [Order Details] od on p.ProductID=od.ProductID
		inner join Orders o on o.OrderID=od.OrderID
	WHERE YEAR(o.OrderDate)='1998'
	group by p.ProductName, s.CompanyName, od.Quantity, od.Discount, o.OrderDate,p.UnitsOnOrder)
SELECT  * 
FROM T1
where LeastSales<=5
order by Total_Sales asc;

/** Product Analisis **/
 WITH T1 AS
	(SELECT p.ProductName, s.companyname, sum(od.UnitPrice*Quantity*(1-discount)) AS Total_Sales, 
		sum(p.unitsinstock) as stock, MONTH(o.OrderDate) AS Bulan, 
		ROW_NUMBER () OVER(PARTITION BY MONTH(o.OrderDate) ORDER BY sum(od.UnitPrice*Quantity*(1-discount)) DESC) as TopSales, o.OrderDate
	FROM Products p
		inner join Suppliers s on p.SupplierID=s.SupplierID
		inner join [Order Details] od on p.ProductID=od.ProductID
		inner join Orders o on o.OrderID=od.OrderID
	WHERE YEAR(o.OrderDate)='1998'
	group by p.ProductName, p.UnitsInStock, s.CompanyName, od.Quantity, od.Discount, o.OrderDate)
SELECT  * 
FROM T1
where TopSales<=5
order by Total_Sales desc;