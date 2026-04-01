## Registro de Venta con Múltiples Productos

Se desarrolló un procedimiento almacenado que permite registrar una venta con múltiples productos utilizando un TYPE en SQL Server.

### Características

- Uso de transacciones para garantizar integridad
- Validación de cliente
- Validación de productos
- Verificación de stock
- Inserción en tabla Venta
- Inserción múltiple en DetalleVenta
- Actualización automática del inventario

### Tecnología utilizada

- SQL Server
- ADO.NET
- Windows Forms (.NET Framework)

### Funcionamiento

La aplicación permite seleccionar un cliente, agregar múltiples productos a través de una interfaz gráfica, y posteriormente enviar toda la información al stored procedure mediante un DataTable.

El stored procedure recibe los datos como un parámetro tipo tabla, lo que permite procesar múltiples registros en una sola ejecución.

Implementacion de una agrupación de productos en el detalle para evitar duplicidad en la llave primaria y consolidar cantidades cuando un producto se repite.”
USE Northwind;


--Crear tabla para DetalleVentaType
CREATE TYPE DetalleVentaType AS TABLE
(
    IdProducto INT,
    Cantidad INT
);
GO

--Crear procedimiento almacenado para registrar una venta(varios productos)
CREATE PROCEDURE spu_Registrar_Venta_Multiple
    @IdCliente NCHAR(5),
    @Detalle DetalleVentaType READONLY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validacion de cliente  existente 
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE IdCliente = @IdCliente)
        BEGIN
            RAISERROR('El cliente no existe.',16,1); --Mensaje de error personalizado
            ROLLBACK; 
            RETURN;
        END
        -- Validacion de productos  y stock suficiente 
        IF EXISTS (
            SELECT d.IdProducto
            FROM @Detalle d
            LEFT JOIN Producto p ON d.IdProducto = p.IdProducto
            WHERE p.IdProducto IS NULL
        )
        BEGIN
            RAISERROR('Uno o más productos no existen.',16,1);
            ROLLBACK;
            RETURN;
        END

        IF EXISTS (
            SELECT 1
            FROM @Detalle d
            JOIN Producto p ON d.IdProducto = p.IdProducto
            WHERE p.Existencia < d.Cantidad
        )
        BEGIN
            RAISERROR('Stock insuficiente en uno o más productos.',16,1);
            ROLLBACK;
            RETURN;
        END

        -- Insertar venta y obtener el IdVenta 
        DECLARE @IdVenta INT;

        INSERT INTO Venta (Fecha, IdCliente)
        VALUES (GETDATE(), @IdCliente);

        SET @IdVenta = SCOPE_IDENTITY();--obtener el ultimo id insertado en la tabla Venta

        -- Insertar detalle,para varios productos 
        INSERT INTO DetalleVenta (IdVenta, IdProducto, PrecioVenta, Cantidad)
        SELECT 
            @IdVenta,
            p.IdProducto,
            p.Precio,
            d.Cantidad
        FROM @Detalle d
        JOIN Producto p ON d.IdProducto = p.IdProducto;

        -- Actualizar stock de productos
        UPDATE p
        SET p.Existencia = p.Existencia - d.Cantidad
        FROM Producto p
        JOIN @Detalle d ON p.IdProducto = d.IdProducto;

        COMMIT;--La transacción se completo exitosamente

        PRINT 'Venta registrada correctamente';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;--Revertir transaccion si hay error 

        DECLARE @Error NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@Error,16,1);
    END CATCH
END;
GO

------------Pueba de Procedimiento almacenado------------

DECLARE @Detalle DetalleVentaType;
                            --IdVenta,IdProducto
INSERT INTO @Detalle VALUES (1,2);
INSERT INTO @Detalle VALUES (2,3);
INSERT INTO @Detalle VALUES (3,1);


EXEC spu_Registrar_Venta_Multiple
    @IdCliente = 'BOTTM',
    @Detalle = @Detalle;
-----------------------------------------------------------
