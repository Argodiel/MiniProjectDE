CREATE VIEW [Order_Details]
AS
SELECT od.OrderId, od.ProductId, p.ProductName, od.UnitPrice, od.Quantity, od.Discount, od.UnitPrice*(1-Discount) AS HARGADISKON
FROM [Order Details] od, Products p;