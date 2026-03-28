
--scrip de cuando se crearon las tablas y se llenaron 

CREATE OR ALTER usp_insertar_Venta
@id_cliente NCHAR(5),
@id_producto INT,
@cantidad INT
AS
BEGIN TRANSACTION

DECLARE
         @existencia INT

         BEGIN TRY
         IF NOT EXISTS (SELECT 1 FROM clientes WHERE idcliente = @idcliente)
         BEGIN
         THROW 50001,'El cliente no existe',1;
            END      --empieza insercion

            
        

        --VALIDAR SI EL PRODUCTO EXISTE
      
        --VERIFICAR EL STOCK CON LA 


            BEGIN TRANSACTION
        --INSERCION DE VENTAS
          --VERIFICAR EL PRECIO DEL PRODUCTO
        --INSERCION EN DETALLEVENTAS
        --ACTUALIZAR STOCK EN PRODUCTO 
            COMMIT;
            END TRY 
            BEGIN CATCH
         IF @@TRANCOUNT > 0
         ROLLBACK;             --EL ROLLBACK SE HACE EN CASO DE QUE HAYA,PERO NO SE HACE ARRIBA 
        PRINT 'Error:' + ERROR_MESSAGE();


         END TRY
         BEGIN CATCH
         END CATCH
END;
GO
