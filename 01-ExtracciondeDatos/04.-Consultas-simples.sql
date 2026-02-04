--Consultas Simples 
use Northwind;

--Seleccionar cada una de las tablas de la bd northwind

SELECT*
FROM customers;
GO

SELECT*
FROM Employees;
GO

SELECT*
FROM Orders;
GO

SELECT*
FROM OrderDetails;
GO

SELECT*
FROM Shippers;
GO

SELECT*
FROM Suppliers;
GO

SELECT*
FROM Products;
GO


--El * nos da todos los campos
--PROYECCION DE LA TABLA  de tres consultas

SELECT ProductName,unit,price
FROM Products;

--Alias de columna 

SELECT ProductName AS NombreProducto,  --recomedable poner as para el alias
unit 'Unidades Medida',
price AS [Precio Unitario]
FROM Products;


--/el inner join es para buscar datos que coincidan entre las dos tablas o mas de las que se haga la consulta


--Campo calculado y alias de tabla   

SELECT OrderID AS [NUMERO DE ORDEN],
pr.ProductID AS [NUMERO DE PRODUCTO],
ProductName AS 'NOMBRE DE PRODUCTO',
Quantity CANTIDAD,
price AS PRECIO,
(Quantity*price) AS SUBTOTAL
FROM OrderDetails AS od   --es la tabla izquierda 
INNER JOIN   
Products pr     --es la tabla derecha
ON pr.ProductID=od.ProductID;

--Operadores relacionales (< , > , <= , >= , = , != o <>)
--Mostrar todos los productos con precio mayor a 20
--/No se necesita alias de tabla porque solo se utiliza una por el momento 

SELECT
	ProductName AS [Nombre	Producto],
	Unit AS [Descripcion],
	Price AS [Precio]
FROM Products
WHERE price >20;  --primero filtra y despues selecciona los campos 1.-FROM 2.-WHERE 3.-SELECT


--Seleccionar todos los cllientes que no sean de Mexico
SELECT*
FROM Customers
WHERE country <> 'Mexico';


--Seleccionar todas aquellas ordenes realizadas en 1997
SELECT 
	OrderID AS[Numero de Orden],
	OrderDate AS [Fecha de Orden],
	YEAR(OrderDate) AS [Año con Year],  
	DATEPART(Year,OrderDate) AS [Año con DEPART]  --es un sabor de sql server estandar 
FROM Orders
WHERE YEAR (OrderDate)=1997;

--Operadores lógicos (2.-AND,3.-OR,1.-NOT) 
SELECT*
FROM 




