--Crear un store procedure que registre una venta.
--1)manejo de errores y transacciones 
--2)INsertar venta,que incluya la fecha actual y el cliente que lo realiza,(verificar si el cliente existe)
--3)Registren el detalle con un solo producto  ,(verificar si el producto existe)deben obtener el precio Actual del Producto para insertar lo en 
--en detalle de venta ,tambien se debe verificar que el producto tenga sufuciente existencia.
--4)Actualizar la existencia con la cantidad vendida


USE Northwind;
GO

CREATE TABLE Cliente
(
    IdCliente NCHAR(5) PRIMARY KEY,
    Nombre NVARCHAR(40),
    Pais NVARCHAR(15),
    Ciudad NVARCHAR(15)
);
GO

CREATE TABLE Producto
(
    IdProducto INT PRIMARY KEY,
    Nombre NVARCHAR(40),
    Precio MONEY,
    Existencia INT
);
GO
-- Tabla de Ventas
CREATE TABLE Venta
(
    IdVenta INT IDENTITY(1,1) PRIMARY KEY,
    Fecha DATETIME NOT NULL,
    IdCliente NCHAR(5) NOT NULL,
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY(IdCliente)
        REFERENCES Cliente(IdCliente)
);
GO
-- Tabla de Detalle de Venta
CREATE TABLE DetalleVenta
(
    IdVenta INT NOT NULL,
    IdProducto INT NOT NULL,
    PrecioVenta MONEY NOT NULL,
    Cantidad INT NOT NULL,
    CONSTRAINT PK_DetalleVenta PRIMARY KEY(IdVenta, IdProducto),
    CONSTRAINT FK_DetalleVenta_Venta FOREIGN KEY(IdVenta)
        REFERENCES Venta(IdVenta),
    CONSTRAINT FK_DetalleVenta_Producto FOREIGN KEY(IdProducto)
        REFERENCES Producto(IdProducto)
);
GO



INSERT INTO Cliente
    (IdCliente, Nombre, Pais, Ciudad)
SELECT TOP 10
    CustomerID, CompanyName, Country, City
FROM Customers;
GO

INSERT INTO Producto
    (IdProducto, Nombre, Precio, Existencia)
SELECT TOP 10
    ProductID, ProductName, UnitPrice, UnitsInStock
FROM Products;
GO


SELECT *
FROM Producto;
GO

SELECT *
FROM Cliente;
GO


CREATE PROCEDURE spu_Registrar_Venta
    @IdCliente NCHAR(5),
    @IdProducto INT,
    @Cantidad INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar cliente
        IF NOT EXISTS (SELECT 1
    FROM Cliente
    WHERE IdCliente = @IdCliente)
        BEGIN
        RAISERROR('El cliente no existe.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

        -- Verificar producto
        IF NOT EXISTS (SELECT 1
    FROM Producto
    WHERE IdProducto = @IdProducto)
        BEGIN
        RAISERROR('El producto no existe.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

        -- Verificar existencia
        DECLARE @ExistenciaActual INT;
        SELECT @ExistenciaActual = Existencia
    FROM Producto
    WHERE IdProducto = @IdProducto;

        IF @ExistenciaActual < @Cantidad
        BEGIN
        RAISERROR('No hay suficiente existencia.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

        -- Insertar venta
        DECLARE @IdVenta INT;
        INSERT INTO Venta
        (Fecha, IdCliente)
    VALUES
        (GETDATE(), @IdCliente);

        SET @IdVenta = SCOPE_IDENTITY();

        -- Obtener precio actual
        DECLARE @PrecioActual MONEY;
        SELECT @PrecioActual = Precio
    FROM Producto
    WHERE IdProducto = @IdProducto;

        -- Insertar detalle
        INSERT INTO DetalleVenta
        (IdVenta, IdProducto, PrecioVenta, Cantidad)
    VALUES
        (@IdVenta, @IdProducto, @PrecioActual, @Cantidad);

        -- Actualizar existencia
        UPDATE Producto
        SET Existencia = Existencia - @Cantidad
        WHERE IdProducto = @IdProducto;

        COMMIT TRANSACTION;
        PRINT 'Venta registrada correctamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

--EJECUCIOJN

EXEC spu_Registrar_Venta @IdCliente = 'ALFKI', @IdProducto = 1, @Cantidad = 5;
GO

--SP MAS COMPLEYO  Y LISTO 
CREATE PROCEDURE spu_Registrar_Venta1
    @IdCliente NCHAR(5),
    @IdProducto INT,
    @Cantidad INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar cliente
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE IdCliente = @IdCliente)
        BEGIN
            RAISERROR('El cliente no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar producto
        IF NOT EXISTS (SELECT 1 
                FROM Producto   
                WHERE IdProducto = @IdProducto)
        BEGIN
            RAISERROR('El producto no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar existencia
        DECLARE @ExistenciaActual INT;

        SELECT @ExistenciaActual = Existencia
        FROM Producto
        WHERE IdProducto = @IdProducto;

        IF @ExistenciaActual < @Cantidad
        BEGIN
            RAISERROR('No hay suficiente existencia.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar venta
        DECLARE @IdVenta INT;

        INSERT INTO Venta (Fecha, IdCliente)
        VALUES (GETDATE(), @IdCliente);

        SET @IdVenta = SCOPE_IDENTITY();

        -- Obtener precio actual
        DECLARE @PrecioActual MONEY;

        SELECT @PrecioActual = Precio
        FROM Producto
        WHERE IdProducto = @IdProducto;

        -- Insertar detalle
        INSERT INTO DetalleVenta 
        (IdVenta, IdProducto, PrecioVenta, Cantidad)
        VALUES (
                @IdVenta, 
                @IdProducto,
             @PrecioActual, 
             @Cantidad);

        -- Actualizar existencia
        UPDATE Producto
        SET Existencia = Existencia - @Cantidad
        WHERE IdProducto = @IdProducto;

        COMMIT TRANSACTION;

        PRINT 'Venta registrada correctamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO



EXEC spu_Registrar_Venta 
    @IdCliente = 'ALFKI', 
    @IdProducto = 1, 
    @Cantidad = 5;
    GO


CREATE TRIGGER trg_NoModificarPrecioDetalle
ON DetalleVenta
AFTER UPDATE
AS
BEGIN
    IF UPDATE(PrecioVenta)
    BEGIN
        RAISERROR('No se permite modificar el Precio de Venta.',16,1);
        ROLLBACK TRANSACTION;
    END
END;





--EVITAR QUE SE PUEDA CAMBIAR EL PRECIO DE LA TABLA DETALLE DE VENTA 

--primero que no permita calcular  precio_venta y cantidad vendida
--EN EL MD DOCUMENTAR DESDE CREACION DE BASE DE DATOS *SELECT INSERT DE NORTWHIN,TODO

--scrip de cuando se crearon las tablas y se llenaron 

