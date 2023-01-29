/* No.1 */
SELECT MONTH(OrderDate) MONTH, COUNT(CustomerID) COUNT FROM Orders WHERE YEAR(OrderDate)=1997 GROUP BY MONTH(OrderDate);

/* No.2 */
SELECT FirstName, LastName FROM Employees WHERE Title='Sales Representative';

/* No.3 */
SELECT TOP 5
Products.ProductName,SUM([Order Details].Quantity) AS TOTAL_QUANTITY
FROM [Order Details]
FULL OUTER JOIN Orders ON [Order Details].OrderID=Orders.OrderID
FULL OUTER JOIN Products on [Order Details].ProductID=Products.ProductID
WHERE YEAR(Orders.OrderDate)='1997'AND MONTH(Orders.OrderDate)='01'
GROUP BY Products.ProductName
ORDER BY TOTAL_QUANTITY DESC;

/* No.4 */
SELECT DISTINCT Customers.CompanyName, Products.ProductName
FROM [Order Details]
FULL OUTER JOIN Orders ON [Order Details].OrderID=Orders.OrderID
FULL OUTER JOIN Customers ON Orders.CustomerID=Customers.CustomerID
FULL OUTER JOIN Products ON [Order Details].ProductID=Products.ProductID
WHERE YEAR (Orders.OrderDate)='1997' AND MONTH (Orders.OrderDate)='06' AND Products.ProductName='Chai'

/* No.5 */
SELECT OrderID, (UnitPrice*Quantity) AS PEMBELIAN,
CASE 
	WHEN UnitPrice*Quantity <=100 THEN 'PEMBELIAN <=100'
	WHEN UnitPrice*Quantity >100 AND UnitPrice*Quantity<=250 THEN 'PEMBELIAN 100<X<=250'
	WHEN UnitPrice*Quantity >250 AND UnitPrice*Quantity<=500 THEN 'PEMBELIAN 250<X<=500'
	WHEN UnitPrice*Quantity >500 THEN 'PEMBELIAN >500'
	END AS CATEGORIES
FROM [Order Details]
ORDER BY PEMBELIAN ASC;

/* No.6 */
SELECT DISTINCT Customers.CompanyName, UnitPrice*Quantity AS PEMBELIAN
FROM [Order Details]
FULL OUTER JOIN Orders ON [Order Details].OrderID=Orders.OrderID
FULL OUTER JOIN Customers ON Orders.CustomerID=Customers.CustomerID
WHERE YEAR (Orders.OrderDate)='1997' AND (UnitPrice*Quantity)>500
ORDER BY PEMBELIAN ASC;

/* No.7 */
WITH T1 AS
(SELECT p.ProductName, od.UnitPrice*Quantity AS Pembelian, MONTH(o.OrderDate) AS Bulan,
ROW_NUMBER () OVER(PARTITION BY MONTH(o.OrderDate) ORDER BY od.UnitPrice*Quantity DESC) as TOP_5_PER_MONTH
FROM [Order Details] od
FULL OUTER JOIN Products p ON od.ProductID=p.ProductID
FULL OUTER JOIN Orders o ON od.OrderID=o.OrderID
WHERE YEAR(o.OrderDate)=1997)
SELECT * FROM T1
WHERE TOP_5_PER_MONTH <=5