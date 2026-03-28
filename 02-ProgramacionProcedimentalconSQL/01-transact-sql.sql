USE Northwind
/*================Variables=======================*/

DECLARE @Edad INT 
SET @Edad = 42 

SELECT @Edad AS Edad
PRINT CONCAT('La edad es: ', @Edad)

/*===================Ejericios con Variables====================*/
/*
1.Declarar una varoable precio
2.Asignar el de valor de 150
3.Calcular el iva del 16% 
4.Mostrar el total 
*/

DECLARE @Precio MONEY=150 --SE LE PUEDE DAR UN VALOR INICIAL }
DECLARE @Total MONEY
SET @Total= @Precio+1.16
SELECT @Total AS [Total]

 /*===================IF/ELSE====================*/
 DECLARE @edad2 INT
 SET @edad2=18

 IF @edad2 >= 18
 BEGIN
 PRINT 'Es mayor de edad'
 PRINT 'Felicidades'
 END
 ELSE 
 PRINT 'Es menor'
 /*===================EJERCICIO IF/ELSE====================*/
 /*
 1.Crear una variable calificacion
 2.Evaluar si es mayor a 70 imprimir "Aprobado",sino "Reprobado"
 */
DECLARE @Calificacion INT
SET @Calificacion=100
IF @Calificacion >= 70
BEGIN
 PRINT 'Aprobado'
 END
 ELSE
 PRINT 'Reprobado'
 --------
 DECLARE @contador INT;
 SET @contador=1;
 SET @contador2=1;

 WHILE @contador2<=5
 BEGIN 

     WHILE @contador2<=5
     BEGIN
         PRINT CONCAT( @contador,' - ', @contador2);
         SET @contador2=@contador2+1;
         END;
      SET @contador2=1
      SET @contador=@contador+1;
END;
GO   
--*se debe correr toda la linea 

 --TODO: CICLO WHILE --documentacion TODO POR SI HACE FALTA ALGO 

--Imprime los numeros del 1 al 10 
DECLARE @i INT;
 SET @i=10;


 WHILE @i>=1
 BEGIN 
         PRINT @i;
         SET @i=@i-1;

END;
GO   


/*===================STORED PROCEDURES====================*/
CREATE PROCEDURE usp_mensaje_saludar
AS 
BEGIN 
PRINT ('Hola Mundo Transact-SQL');
END;
GO  --Procedimiento por lotes

--Elimina un SP
--DROP PROCEDURE usp_mensaje_saludar;
--DROP PROCEDURE usp_mensaje_saludar;


EXECUTE  usp_mensaje_saludar;
GO

EXEC usp_mensaje_saludar;
GO

--EJERCICIO SP 
/*===================EJERCICIOS====================*/

--Crea un stored procedure que imprima la fecha Actual 

CREATE PROCEDURE usp_fecha_mostrar
AS
BEGIN
SELECT GETDATE() AS [FechaActual];
END;
GO

CREATE PROCEDURE usp_fecha_mostrar2
AS
BEGIN
PRINT GETDATE();
END;
GO
EXEC usp_fecha_mostrar2;

--Crea un stored procedure que muestre el nombre de la base de datos actual 
CREATE OR ALTER PROC usp_nombredb_mostrar
AS 
BEGIN 
SELECT DB_NAME() AS [NOMBRE_BD];
END;

EXEC usp_nombredb_mostrar