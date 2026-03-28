# Fundamentos Programables
1.-¿Que es la parte programable de T-SQL?
Es todo lo que permite:
- usar variables
-Control de Flujo
-Crear procedimientos almacenados(Strore Procedures)
-manejar errores
-crear funciones
-usar transacciones
-disparadores(Triggers)


Nota: Es convertir SQL en un lenguaje casi como C/java pero dentro del engine

2.Variable
Una variable almecena un valor temporal 




´´--Transac es el lenguaje programable de SQL 
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


``DECLARE @edad2 INT
 SET @edad2=18

 IF @edad2 >= 18
 BEGIN
 PRINT 'Es mayor de edad'
 PRINT 'Felicidades'
 END
 ELSE 
 PRINT 'Es menor'
/*===================if/else====================*/

4.WHILE
--------
 ```DECLARE @contador INT;
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
```

##Procedimientos almacenados( Store Procedures)

5. ¿Que es un Strore Procedure?

😒 Es un bloque de código guardado en la base de datos que se
 puede ejecutar cuando se necesite

 ```sql
CREATE PROCEDURE usp_objeto_accion --Sintaxis
[Paremeters] --son opcionales
AS 
BEGGIN
--Body *cuerpo 
END;


CREATE PROC usp_objeto_accion --Sintaxis
[Paremeters] --son opcionales
AS 
BEGGIN
--Body  
END;


CREATE OR ALTER PROCEDURE usp_objeto_accion --Sintaxis
[Paremeters] 
AS 
BEGGIN
--Body 
END;


CREATE OR ALTER PROCEDURE usp_objeto_accion --Sintaxis
[Paremeters] 
AS 
BEGGIN
--Body 
END;

 ``` 
 /*===================Ejercicios====================*/