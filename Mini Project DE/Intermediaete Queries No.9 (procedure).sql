CREATE PROCEDURE INVOICE @CustomerID NVARCHAR(5)
AS
SELECT c.CustomerID, c.CompanyName, o.OrderID, o.OrderDate, o.RequiredDate, o.ShippedDate
FROM Orders o
FULL JOIN Customers c ON o.CustomerID=c.CustomerID
WHERE c.CustomerID = @CustomerID;