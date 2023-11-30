USE Northwind
GO

--Consulta 1

SELECT P.ProductName, C.CategoryName 
FROM Products P
INNER JOIN Categories C ON C.CategoryID = P.CategoryID


--Consulta 2
SELECT TOP 1 P.ProductName,  O.Quantity
FROM [Order Details] O
INNER JOIN Products P ON P.ProductID = O.ProductID
ORDER BY Quantity DESC

--Consulta 3
--Indicar la cantidad de órdenes atendidas por cada empleado 
--(mostrar el nombre y apellido de cadaempleado).
SELECT E.LastName + ' ' + E.FirstName as 'Full Name', COUNT(O.OrderID) CantOrdenes
FROM Employees E
INNER JOIN Orders O ON O.EmployeeID = E.EmployeeID
GROUP BY E.LastName + ' ' + E.FirstName 

--Consulta 4
--Indicar la cantidad de órdenes realizadas por cada cliente 
--(mostrar el nombre de la compañía de cada cliente).
SELECT C.CompanyName, COUNT(O.OrderID) Cantidad
FROM Customers C
INNER JOIN Orders O ON O.CustomerID = C.CustomerID
GROUP BY  C.CompanyName

--Consulta 5
--Identificar la relación de clientes (nombre de compañía) 
--que no han realizado pedidos
SELECT C.CompanyName, COUNT(O.OrderID) Cantidad
FROM Customers C
LEFT JOIN Orders O ON O.CustomerID = C.CustomerID
GROUP BY  C.CompanyName
HAVING COUNT(O.OrderID) = 0



--Consulta 6
--Muestre el código y nombre de todos los clientes 
--(nombre de compañía) que tienen órdenes pendientes de despachar.

SELECT *
FROM Orders


SELECT C.CustomerID, C.CompanyName
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.ShippedDate IS NULL

--Consulta 7
--Muestre el código y nombre de todos los clientes 
--(nombre de compañía) que tienen órdenes
--pendientes de despachar, y la cantidad de órdenes 
--con esa característica.

SELECT C.CustomerID, C.CompanyName,  COUNT(O.OrderID) AS Cantidad
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.ShippedDate IS NULL
GROUP BY C.CustomerID, C.CompanyName
HAVING COUNT(O.OrderID) > 0
ORDER BY Cantidad DESC



--Consulta 8
--Encontrar los pedidos que debieron despacharse a una ciudad o código postal diferente de la ciudad
--o código postal del cliente que los solicitó. Para estos pedidos, mostrar el país, ciudad y código postal
--del destinatario, así como la cantidad total de pedidos por cada destino.

SELECT C.Country, O.ShipCity, O.ShipPostalCode, COUNT(O.OrderID) AS Cantidad
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE O.ShipCity <> C.City OR O.ShipPostalCode <> C.PostalCode
GROUP BY C.Country, O.ShipCity, O.ShipPostalCode
ORDER BY Cantidad DESC;


--Consulta 9
SELECT * FROM Orders
--9. Seleccionar todas las compañías de envío (código y nombre) que hayan efectuado algún despacho a
--México entre el primero de enero y el 28 de febrero de 2018.
--Formatos sugeridos a emplear para fechas:
--• Formatos numéricos de fecha (por ejemplo, '15/4/2018')
--• Formatos de cadenas sin separar (por ejemplo, '20181207')

SELECT * FROM Orders
SELECT O.ShipVia, O.CustomerID, O.ShippedDate
FROM Customers C, Shippers S
LEFT JOIN Orders O ON O.ShipVia = S.ShipperID
WHERE O.ShippedDate = '19980501'

--Consulta 10 
--Mostrar los nombres y apellidos de los empleados junto con los 
--nombres y apellidos de sus respectivos Jefes
SELECT E1.EmployeeID, E1.LastName, E1.FirstName, E2.ReportsTo, E2.LastName, E2.FirstName
FROM Employees E1
INNER JOIN Employees E2 ON E1.EmployeeID = E2.ReportsTo	

--Consulta 11
--Mostrar el ranking de venta anual por país de origen del empleado, tomando como base la fecha de
--las órdenes, y mostrando el resultado por año y venta total (descendente).

SELECT YEAR(OrderDate) Año, Employees.Country, SUM(UnitPrice * Quantity) MontoTotal
FROM Orders
INNER JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
GROUP BY YEAR(OrderDate), Employees.Country
ORDER BY YEAR(OrderDate) DESC, SUM(UnitPrice * Quantity) DESC;




--Consulta 12
--Mostrar de la tabla Orders, para los pedidos cuya diferencia entre la fecha de despacho y la fecha de
--la orden sea mayor a 4 semanas, las siguientes columnas:
--OrderId, CustomerId, Orderdate, Shippeddate, diferencia en días, diferencia en semanas y diferencia
--en meses entre ambas fechas.
SELECT * FROM Orders
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    ShippedDate,
    DATEDIFF(day, OrderDate, ShippedDate) AS Diferencia_En_Dias,
    DATEDIFF(week, OrderDate, ShippedDate) AS Diferencia_En_Semanas,
    DATEDIFF(month, OrderDate, ShippedDate) AS Diferencia_En_Meses
FROM Orders
WHERE DATEDIFF(week, OrderDate, ShippedDate) > 4 * 7
  AND OrderDate IS NOT NULL
  AND ShippedDate IS NOT NULL;

--consulta 13

--La empresa tiene como política otorgar a los jefes una comisión del 0.5% sobre la venta de sus
--subordinados. Calcule la comisión mensual que le ha correspondido a cada jefe por cada año
--(basándose en la fecha de la orden) según las ventas que figuran en la base de datos. Muestre el
--código del jefe, su apellido, el año y mes de cálculo, el monto acumulado de venta de sus
--subordinados, y la comisión obtenida.

SELECT * FROM Orders
SELECT * FROM Employees



SELECT E2.EmployeeID, E2.LastName, YEAR(O.OrderDate) Año, MONTH(O.OrderDate) Mes, E.Country,SUM(OD.UnitPrice * OD.Quantity) MontoTotal, SUM(0.0005*OD.UnitPrice * OD.Quantity) Comision
FROM Orders O
INNER JOIN Employees E ON O.EmployeeID = E.EmployeeID
INNER JOIN Customers C ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
INNER JOIN Employees E2 ON E.ReportsTo = E2.EmployeeID
GROUP BY E2.EmployeeID, E2.LastName, YEAR(O.OrderDate), MONTH(O.OrderDate), E.Country
ORDER BY YEAR(O.OrderDate) DESC, MONTH(O.OrderDate) DESC, SUM(OD.UnitPrice * OD.Quantity) DESC, SUM(0.0005*OD.UnitPrice * OD.Quantity) DESC


--consulta 14


--consulta 15


--consulta 16


--consulta 17



--Consulta 14: Obtener los países donde el importe total anual de las órdenes enviadas supera los $45,000.

SELECT 
    ShipCountry AS Pais,
    YEAR(OrderDate) AS Anio,
    SUM(UnitPrice * Quantity) AS ImporteAnualVenta
FROM Orders O
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY ShipCountry, YEAR(OrderDate)
HAVING SUM(UnitPrice * Quantity) > 45000
ORDER BY ImporteAnualVenta DESC;


--Consulta 15: De cada producto que haya tenido venta en por lo menos 20 transacciones del año 2017.

SELECT 
    OD.ProductID,
    P.ProductName,
    SUM(OD.Quantity) AS CantidadUnidadesVendidas,
    COUNT(*) AS CantidadOrdenesVendidas
FROM [Order Details] OD
JOIN Products P ON OD.ProductID = P.ProductID
JOIN Orders O ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = 2017
GROUP BY OD.ProductID, P.ProductName
HAVING COUNT(*) >= 20;


--Consulta 16: Determinar si existe algún problema de stock para la atención de las órdenes pendientes de despacho.

SELECT 
    P.ProductName,
    SUM(OD.Quantity) AS CantidadPendienteEntrega,
    P.UnitsInStock AS StockActual,
    (P.UnitsInStock - SUM(OD.Quantity)) AS CantidadFaltante
FROM [Order Details] OD
JOIN Products P ON OD.ProductID = P.ProductID
JOIN Orders O ON OD.OrderID = O.OrderID
WHERE P.Discontinued = 0
    AND O.ShippedDate IS NULL
GROUP BY P.ProductName, P.UnitsInStock
HAVING P.UnitsInStock < SUM(OD.Quantity);

--Consulta 17: Mostrar la lista de productos descontinuados (nombre y precio) cuyo precio es menor al precio promedio.

SELECT 
    ProductName,
    UnitPrice
FROM Products
WHERE Discontinued = 1
    AND UnitPrice < (SELECT AVG(UnitPrice) FROM Products WHERE Discontinued = 1);


--Consulta 18: Listar aquellas órdenes cuya diferencia entre la fecha de la orden y la fecha de despacho es mayor que el promedio en días y semanas de dicha diferencia en todas las órdenes.

SELECT 
    OrderID,
    OrderDate,
    ShippedDate,
    DATEDIFF(day, OrderDate, ShippedDate) AS DiferenciaEnDias,
    DATEDIFF(week, OrderDate, ShippedDate) AS DiferenciaEnSemanas
FROM Orders
WHERE DATEDIFF(day, OrderDate, ShippedDate) > (SELECT AVG(DATEDIFF(day, OrderDate, ShippedDate)) FROM Orders)
    AND DATEDIFF(week, OrderDate, ShippedDate) > (SELECT AVG(D




--Consulta 19: Mostrar los productos no descontinuados (código, nombre de producto, nombre de categoría y precio) cuyo precio unitario es mayor al precio promedio de su respectiva categoría.

SELECT 
    P.ProductID,
    P.ProductName,
    C.CategoryName,
    P.UnitPrice
FROM Products P
JOIN Categories C ON P.CategoryID = C.CategoryID
WHERE P.Discontinued = 0
    AND P.UnitPrice > (
        SELECT AVG(P2.UnitPrice)
        FROM Products P2
        WHERE P2.CategoryID = P.CategoryID AND P2.Discontinued = 0
    );


--Consulta 20: Mostrar la relación de productos (nombre) no descontinuados de la categoría 8 que no han tenido venta entre el 1° y el 15 de Agosto de 2016.

SELECT 
    P.ProductName
FROM Products P
LEFT JOIN [Order Details] OD ON P.ProductID = OD.ProductID
LEFT JOIN Orders O ON OD.OrderID = O.OrderID
WHERE P.Discontinued = 0
    AND P.CategoryID = 8
    AND O.OrderDate NOT BETWEEN '2016-08-01' AND '2016-08-15'
    AND O.OrderDate IS NOT NULL;


--Consulta 21: Encontrar la categoría a la que pertenece la mayor cantidad de productos.

SELECT TOP 1
    C.CategoryName,
    COUNT(*) AS CantidadProductos
FROM Products P
JOIN Categories C ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName
ORDER BY COUNT(*) DESC;


--Consulta 22: Encontrar el producto de cada categoría que tuvo la mayor venta (en unidades) durante el año 2017.

WITH VentasPorProducto AS (
    SELECT 
        P.ProductID,
        P.ProductName,
        P.CategoryID,
        SUM(OD.Quantity) AS TotalUnidadesVendidas,
        ROW_NUMBER() OVER (PARTITION BY P.CategoryID ORDER BY SUM(OD.Quantity) DESC) AS RowNum
    FROM Products P
    JOIN [Order Details] OD ON P.ProductID = OD.ProductID
    JOIN Orders O ON OD.OrderID = O.OrderID
    WHERE YEAR(O.OrderDate) = 2017
    GROUP BY P.ProductID, P.ProductName, P.CategoryID
)
SELECT 
    VP.ProductID,
    VP.ProductName,
    C.CategoryName,
    VP.TotalUnidadesVendidas
FROM VentasPorProducto VP
JOIN Categories C ON VP.CategoryID = C.CategoryID
WHERE VP.RowNum = 1;




--Consulta 23: Encontrar el pedido de mayor importe por país al cual se despachó, ordenado por monto de mayor a menor.

WITH MayorImportePorPais AS (
    SELECT 
        ShipCountry AS Pais,
        MAX(UnitPrice * Quantity) AS MayorImportePedido
    FROM Orders O
    JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    GROUP BY ShipCountry
)
SELECT 
    M.Pais,
    M.MayorImportePedido AS MontoPedido
FROM MayorImportePorPais M
ORDER BY M.MayorImportePedido DESC;














--PROCEDIMIENTOS
--Crear una función que retorne el país de procedencia del cliente con la menor cantidad de pedidos
--atendidos para un determinado año.
ALTER FUNCTION PaisClienteMenorPedidos (@anio INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Pais NVARCHAR(100);

    SELECT @Pais = C.Country
    FROM Customers C
    WHERE C.CustomerID IN (
        SELECT O.CustomerID
        FROM Orders O
        WHERE YEAR(O.OrderDate) = @anio
        GROUP BY O.CustomerID
        ORDER BY COUNT(O.OrderID) ASC
        OFFSET 0 ROWS -- OFFSET 0 ROWS es opcional, solo para mayor claridad
    );

    RETURN @Pais;
END;
GO

DECLARE @Year INT = 1997; -- Aquí coloca el año que desees consultar
SELECT dbo.PaisClienteMenorPedidos(@Year) AS PaisClienteMenorPedidos;

--Crear una función que retorne el nombre de la categoría con la mayor cantidad de ítems de productos
--vendidos para un determinado año.

CREATE FUNCTION CategoriaMayorCantidadItemsVendidos (@anio INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Categoria NVARCHAR(100);

    SELECT @Categoria = c.CategoryName
    FROM Categories c
    WHERE c.CategoryID IN (
        SELECT TOP 1 p.CategoryID
        FROM Products p
        INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
        INNER JOIN Orders o ON od.OrderID = o.OrderID
        WHERE YEAR(o.OrderDate) = @anio
        GROUP BY p.CategoryID
        ORDER BY SUM(od.Quantity) DESC
    );

    RETURN @Categoria;
END;
GO

DECLARE @Year INT = 1997; -- Cambia el año según tu necesidad
SELECT dbo.CategoriaMayorCantidadItemsVendidos(@Year) AS CategoriaMayorCantidadItemsVendidos;

--Crear una función que retorne la cantidad de órdenes atendidas para un determinado año.
CREATE FUNCTION CantidadOrdenesAtendidas  (@anio INT)
RETURNS INT
AS
BEGIN
    DECLARE @CantidadOrdenes INT;

    SELECT @CantidadOrdenes = COUNT(OrderID)
    FROM Orders
    WHERE YEAR(OrderDate) = @anio;

    RETURN @CantidadOrdenes;
END;
GO

DECLARE @Year INT = 1997; -- Cambia el año según tu necesidad
SELECT dbo.CantidadOrdenesAtendidas (@Year) AS CantidadOrdenesAtendidas;

--Crear una función que retorne el nombre de la compañía con más órdenes realizadas para un determinado año
ALTER FUNCTION CompaniaMasOrdenes (@anio INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @NombreCompania NVARCHAR(100);

    SELECT @NombreCompania = C.CompanyName
    FROM Customers C
    WHERE C.CustomerID IN (
        SELECT  O.CustomerID
        FROM Orders O
        WHERE YEAR(O.OrderDate) = @anio
        GROUP BY O.CustomerID
        ORDER BY COUNT(O.OrderID) DESC
    );

    RETURN @NombreCompania;
END;


DECLARE @Year INT = 1997; -- Cambia el año según tu necesidad
SELECT dbo.CompaniaMasOrdenes (@Year) AS CompaniaMasOrdenes;


--5. Crear una función que retorne el nombre del shipper con mayor cantidad de pedidos atendidos para un determinado año.
SELECT * FROM Shippers
ALTER FUNCTION ShipperMayorCantidadPedidosAtendidos (@anio INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @NombreShipper NVARCHAR(100);

    SELECT TOP 1 WITH TIES @NombreShipper = S.CompanyName
    FROM Shippers S
    JOIN Orders O ON S.ShipperID = O.ShipVia
    WHERE YEAR(O.OrderDate) = @anio
    GROUP BY S.CompanyName
    ORDER BY COUNT(O.OrderID) DESC;

    RETURN @NombreShipper;
END;
GO


DECLARE @Year INT = 1997; -- Cambia el año según tu necesidad
SELECT dbo.ShipperMayorCantidadPedidosAtendidos (@Year) AS ShipperMayorCantidadPedidosAtendidos;


--Crear una función que retorne el nombre de la compañía proveedora con mayor cantidad de pedidos atendidos para un determinado año.
CREATE FUNCTION ProveedorMayorCantidadPedidosAtendidos (@anio INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @NombreProveedor NVARCHAR(100);

    SELECT TOP 1 @NombreProveedor = S.CompanyName
    FROM Suppliers S
    JOIN Products P ON S.SupplierID = P.SupplierID
    JOIN [Order Details] OD ON P.ProductID = OD.ProductID
    JOIN Orders O ON OD.OrderID = O.OrderID
    WHERE YEAR(O.OrderDate) = @anio
    GROUP BY S.CompanyName
    ORDER BY COUNT(O.OrderID) DESC;

    RETURN @NombreProveedor;
END;

DECLARE @Year INT = 1997; -- Cambia el año según tu necesidad
SELECT dbo.ProveedorMayorCantidadPedidosAtendidos (@Year) AS ProveedorMayorCantidadPedidosAtendidos;



--2. Función que retorne el nombre del cliente con mayor cantidad de pedidos realizados para un determinado año y de un determinado origen país:
CREATE FUNCTION ClienteMayorCantidadPedidosPorPais (@anio INT, @pais NVARCHAR(100))
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @NombreCliente NVARCHAR(100);

    SELECT TOP 1 @NombreCliente = C.CompanyName
    FROM Customers C
    JOIN Orders O ON C.CustomerID = O.CustomerID
    WHERE YEAR(O.OrderDate) = @anio AND O.ShipCountry = @pais
    GROUP BY C.CompanyName
    ORDER BY COUNT(O.OrderID) DESC;

    RETURN @NombreCliente;
END;
DECLARE @Year INT = 1997; -- Cambia el año según tu necesidad
SELECT dbo.ClienteMayorCantidadPedidosPorPais (@Year, 'Germany') AS ClienteMayorCantidadPedidosPorPais;

--3. Procedimiento almacenado que liste la relación de productos para una determinada categoría:
CREATE PROCEDURE ProductosPorCategoria (@categoriaID INT)
AS
BEGIN
    SELECT ProductID, ProductName
    FROM Products
    WHERE CategoryID = @categoriaID;
END;


EXEC ProductosPorCategoria @categoriaID = 3;



--4. Procedimiento almacenado que muestre los productos que comercializa un determinado proveedor:
CREATE PROCEDURE ProductosPorProveedor (@proveedorID INT)
AS
BEGIN
    SELECT ProductID, ProductName
    FROM Products
    WHERE SupplierID = @proveedorID;
END;

EXEC ProductosPorProveedor @proveedorID = 1

--5. Función que retorne el proveedor con la mayor cantidad de productos comercializados de acuerdo a un determinado país de origen:
create function proveedor() returns varchar(20)
as 
begin
 declare @country varchar(20)
	select @country = A.CompanyName from Suppliers A
	left join products B
	ON A.SupplierID = B.SupplierID
	where a.country = 'Australia'
	group by a.CompanyName, A.country
	having count(B.productid) = (select numero from(select max(maxprov) numero, country
	from (select A.country, count(B.productid) maxprov from Suppliers A
	left join products B
	ON A.SupplierID = B.SupplierID
	where a.country = 'Australia'
	group by A.country, A.CompanyName
	) A
	group by country) B)
	return @country
end


print dbo.proveedor()


--6. Procedimiento almacenado que retorne la categoría de producto con la mayor cantidad de órdenes realizadas de acuerdo al país de destino:
CREATE PROCEDURE CategoriaConMasOrdenesPorPais (@pais NVARCHAR(100))
AS
BEGIN
    SELECT TOP 1 C.CategoryName, COUNT(O.OrderID) AS CantidadOrdenes
    FROM Orders O
    JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    JOIN Products P ON OD.ProductID = P.ProductID
    JOIN Categories C ON P.CategoryID = C.CategoryID
    WHERE O.ShipCountry = @pais
    GROUP BY C.CategoryName
    ORDER BY COUNT(O.OrderID) DESC;
END;


EXEC CategoriaConMasOrdenesPorPais @pais='Germany'




--7. Procedimiento almacenado que muestre la categoría en la que se tuvo el mayor monto de venta acumulado:

CREATE PROCEDURE CategoriaMayorVentaAcumulada
AS
BEGIN
    SELECT TOP 1 C.CategoryName, SUM(OD.UnitPrice * OD.Quantity) AS MontoVentaAcumulada
    FROM [Order Details] OD
    JOIN Products P ON OD.ProductID = P.ProductID
    JOIN Categories C ON P.CategoryID = C.CategoryID
    GROUP BY C.CategoryName
    ORDER BY SUM(OD.UnitPrice * OD.Quantity) DESC;
END;


EXEC CategoriaMayorVentaAcumulada


--8. Procedimiento almacenado que muestre el país donde se ha vendido más órdenes durante un año ingresado como parámetro:

CREATE PROCEDURE PaisConMasOrdenesDuranteAnio (@anio INT)
AS
BEGIN
    SELECT TOP 1 O.ShipCountry, COUNT(O.OrderID) AS CantidadOrdenes
    FROM Orders O
    WHERE YEAR(O.OrderDate) = @anio
    GROUP BY O.ShipCountry
    ORDER BY COUNT(O.OrderID) DESC;
END;

EXEC PaisConMasOrdenesDuranteAnio @anio=1997


--9. Procedimiento almacenado que muestre el proveedor que tuvo la menor cantidad de productos vendidos en un año ingresado como parámetro:

CREATE PROCEDURE ProveedorMenosProductosVendidosDuranteAnio (@anio INT)
AS
BEGIN
    SELECT TOP 1 S.CompanyName, COUNT(P.ProductID) AS CantidadProductosVendidos
    FROM Suppliers S
    JOIN Products P ON S.SupplierID = P.SupplierID
    JOIN [Order Details] OD ON P.ProductID = OD.ProductID
    JOIN Orders O ON OD.OrderID = O.OrderID
    WHERE YEAR(O.OrderDate) = @anio
    GROUP BY S.CompanyName
    ORDER BY COUNT(P.ProductID);
END;

exec ProveedorMenosProductosVendidosDuranteAnio  @anio=1997

--10. Procedimiento almacenado que retorne la cantidad de órdenes para un determinado año, el cual es ingresado como parámetro:

CREATE PROCEDURE CantidadOrdenesPorAnio (@anio INT)
AS
BEGIN
    SELECT COUNT(OrderID) AS CantidadOrdenes
    FROM Orders
    WHERE YEAR(OrderDate) = @anio;
END;

exec CantidadOrdenesPorAnio  @anio=1997





--11. Procedimiento almacenado que retorne la categoría con la menor cantidad de órdenes realizadas durante un determinado año, el cual es ingresado como parámetro:

CREATE PROCEDURE CategoriaMenosOrdenesPorAnio (@anio INT)
AS
BEGIN
    SELECT TOP 1 C.CategoryName, COUNT(O.OrderID) AS CantidadOrdenes
    FROM Orders O
    JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    JOIN Products P ON OD.ProductID = P.ProductID
    JOIN Categories C ON P.CategoryID = C.CategoryID
    WHERE YEAR(O.OrderDate) = @anio
    GROUP BY C.CategoryName
    ORDER BY COUNT(O.OrderID);
END;

exec CategoriaMenosOrdenesPorAnio  @anio=1997

--12. Procedimiento almacenado que retorne la cantidad de órdenes atendidas por cada embarcador (shipper) durante un determinado año, el cual es ingresado como parámetro:
CREATE PROCEDURE OrdenesAtendidasPorShipperPorAnio (@anio INT)
AS
BEGIN
    SELECT S.CompanyName AS Shipper, COUNT(O.OrderID) AS CantidadOrdenesAtendidas
    FROM Shippers S
    JOIN Orders O ON S.ShipperID = O.ShipVia
    WHERE YEAR(O.OrderDate) = @anio
    GROUP BY S.CompanyName;
END;

exec OrdenesAtendidasPorShipperPorAnio  @anio=1997


--13. Procedimiento almacenado que retorne el nombre del cliente con la mayor cantidad de órdenes realizadas de acuerdo a un determinado país de destino, el cual es ingresado como parámetro:
CREATE PROCEDURE ClienteMayorCantidadOrdenesPorPais (@pais NVARCHAR(100))
AS
BEGIN
    SELECT TOP 1 C.CompanyName, COUNT(O.OrderID) AS CantidadOrdenes
    FROM Customers C
    JOIN Orders O ON C.CustomerID = O.CustomerID
    WHERE O.ShipCountry = @pais
    GROUP BY C.CompanyName
    ORDER BY COUNT(O.OrderID) DESC;
END;

exec ClienteMayorCantidadOrdenesPorPais @pais = 'Germany'




--14. Procedimiento almacenado que retorne la cantidad de empleados de acuerdo a un determinado país, el cual es ingresado como parámetro:

CREATE PROCEDURE CantidadEmpleadosPorPais (@pais NVARCHAR(100))
AS
BEGIN
    SELECT COUNT(EmployeeID) AS CantidadEmpleados
    FROM Employees
    WHERE Country = @pais;
END;

exec CantidadEmpleadosPorPais @pais = 'Germany'

--15. Procedimiento almacenado que permita mostrar la cantidad de órdenes realizadas por país de destino de acuerdo a un determinado año, el cual es ingresado como parámetro:

CREATE PROCEDURE CantidadOrdenesPorPaisPorAnio (@anio INT)
AS
BEGIN
    SELECT ShipCountry, COUNT(OrderID) AS CantidadOrdenes
    FROM Orders
    WHERE YEAR(OrderDate) = @anio
    GROUP BY ShipCountry;
END;

exec CantidadOrdenesPorPaisPorAnio @anio=1997

--16. Procedimiento almacenado que retorne el cliente con la mayor cantidad de órdenes realizadas de acuerdo a un determinado país de destino, el cual es ingresado como parámetro:

CREATE PROCEDURE ClienteMayorCantidadOrdenesPorPais2 (@pais NVARCHAR(100))
AS
BEGIN
    SELECT TOP 1 C.CompanyName, COUNT(O.OrderID) AS CantidadOrdenes
    FROM Customers C
    JOIN Orders O ON C.CustomerID = O.CustomerID
    WHERE O.ShipCountry = @pais
    GROUP BY C.CompanyName
    ORDER BY COUNT(O.OrderID) DESC;
END;

exec ClienteMayorCantidadOrdenesPorPais2 @pais=1997



--17. Procedimiento almacenado que retorne el nombre del embarcador con mayor cantidad de pedidos atendidos para un determinado país de destino, el cual es ingresado como parámetro:
CREATE PROCEDURE ShipperMayorCantidadPedidosPorPais (@pais NVARCHAR(100))
AS
BEGIN
    SELECT TOP 1 S.CompanyName, COUNT(O.OrderID) AS CantidadPedidos
    FROM Shippers S
    JOIN Orders O ON S.ShipperID = O.ShipVia
    WHERE O.ShipCountry = @pais
    GROUP BY S.CompanyName
    ORDER BY COUNT(O.OrderID) DESC;
END;

exec ShipperMayorCantidadPedidosPorPais @pais='Germany'


--18. Procedimiento almacenado que retorne el país donde se ha vendido más órdenes durante un año ingresado como parámetro:
CREATE PROCEDURE PaisConMasOrdenesDuranteAnio (@anio INT)
AS
BEGIN
    SELECT TOP 1 O.ShipCountry, COUNT(O.OrderID) AS CantidadOrdenes
    FROM Orders O
    WHERE YEAR(O.OrderDate) = @anio
    GROUP BY O.ShipCountry
    ORDER BY COUNT(O.OrderID) DESC;
END;

exec PaisConMasOrdenesDuranteAnio @anio = 1997


--19. Procedimiento almacenado que retorne el proveedor que tuvo la menor cantidad de productos vendidos en un año ingresado como parámetro:
CREATE PROCEDURE ProveedorMenosProductosVendidosDuranteAnio (@anio INT)
AS
BEGIN
    SELECT TOP 1 S.CompanyName, COUNT(P.ProductID) AS CantidadProductosVendidos
    FROM Suppliers S
    JOIN Products P ON S.SupplierID = P.SupplierID
    JOIN [Order Details] OD ON P.ProductID = OD.ProductID
    JOIN Orders O ON OD.OrderID = O.OrderID
    WHERE YEAR(O.OrderDate) = @anio
    GROUP BY S.CompanyName
    ORDER BY COUNT(P.ProductID);
END;

exec ProveedorMenosProductosVendidosDuranteAnio @anio = 1997
