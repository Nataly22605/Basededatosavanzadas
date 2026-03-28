
# Store Procedure

## Fundamentos

1.- ¿Qué es un store procedure?

Es un bloque de código SQL guardado dentro de la base de datos(**un objeto de la BD**) que puede 
ejecutarse cuando se necesite 

Es similar a una funcion o método en programación:

Ventajas.
1. Reutilización de código 
2. Mejor rendimiento 
3. Mayor seguridad(Evitar la inyección SQL)
4. Centralización de la lógica del Negocio
5. Menos trafico entre la aplicacón y el servidor 
 
```
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

2.- Parametros en StoreProcedure


--validaciones,lo que no se puede mover (logica del Negocio)
--
--Investigar sobre SQL DINAMICO 

´´´´
--Store Procedure
CREATE DATABASE bdstore;
GO 
USE bdstore;
GO


CREATE OR ALTER PROC spu_persona_saludar
@nombre VARCHAR(50) --parametro de entrada 

AS 
BEGIN
PRINT 'Hola '+ @nombre;
END;
GO

EXEC spu_persona_saludar 'Arcadio';
EXEC spu_persona_saludar 'Roberta';
EXEC spu_persona_saludar 'Juana';
EXEC spu_persona_saludar 'Alamas';
GO

SELECT CustomerID,CompanyName,City,Country
INTO customers
FROM Northwind.dbo.Customers;
GO

--Realzar un store que reciba un parametro de un cliente en particulae y 
--lo muestre 
CREATE OR ALTER PROCEDURE spu_cliente_consultarporid
    @Id CHAR(10) 
AS
BEGIN 
SELECT 
CustomerID AS [NUMERO],
CompanyName AS [CLIENTE],
City AS [CIUDAD],
Country AS [PAIS]
FROM customers
WHERE  CustomerID =RTRIM(@Id);
END;

EXEC spu_cliente_consultarporid 'ANTON'; 
GO


SELECT*FROM customers
WHERE EXISTS (SELECT 1
FROM customers 
WHERE CustomerID='ANTONT')


--quiero que en el store valide si ese cliente existe,sino existe mandar un mensaje
DECLARE @valor int 


SET @valor =( SELECT 1
FROM customers 
WHERE CustomerID='ANTONT');

IF @valor =1
BEGIN 
   PRINT 'Existe'
END 
ELSE 
BEGIN 
   PRINT 'No existe'
END
GO


CREATE OR ALTER PROCEDURE spu_cliente_consultarporid2
    @Id CHAR(10)
AS
BEGIN 
    IF LEN(@id)>5
    BEGIN
    RAISERROR ('el numero del cliente debe ser menor o igual a 5',16,1);
    --THROW 50001 'el numero del cliente debe ser menor o igual a 5',1
    RETURN 
    END;

IF EXISTS( SELECT 1
FROM customers 
WHERE CustomerID='@Id')
BEGIN 

    SELECT 
CustomerID AS [NUMERO],
CompanyName AS [CLIENTE],
City AS [CIUDAD],
Country AS [PAIS]
FROM customers
WHERE  CustomerID =@Id;

RETURN; --Con el return se pueden ahorrar los else  ->una funcion de flecha es una landa
END     --cuando se consume una API se hace es Fetch, es decir se hace una consulta y se obtiene un resultado, si el resultado es correcto se muestra la informacion, si el resultado es incorrecto se muestra un mensaje de error

   PRINT 'El cliente no existe';
END;
GO

EXEC spu_cliente_consultarporid2 @Id= 'ANTON';
DECLARE @id2 AS CHAR(10)=(SELECT customerId FROM customers WHERE customerid='ANTON');

EXEC spu_cliente_consultarporid2 @id2;

DECLARE @id3 CHAR(10);
SELECT @ID3=(SELECT customerId FROM customers WHERE customerid='ANTON');
EXEC spu_cliente_consultarporid2 @id3;
```
3. PARAMETROS OUTPUT
Los parametros OUTPUT devuelven los valores al usuario
´´´sql
---Parametros OUTPUT ->QUIERE DECIR PARAMETROS DE SALIDA
CREATE OR ALTER PROCEDURE spu_operacion_sumar
@a INT,
@b AS INT,
@Resultado INT OUTPUT
AS
BEGIN
SET @Resultado=@a+@b;
END;

--Utilizar la variable de salida 

DECLARE @res INT;
EXEC spu_operacion_sumar 4, 5, @res OUTPUT;
SELECT @res AS [SUMA];
GO 

4.- Logica dentro del SP
Puedes usar:

-IF
-IF/ELSE
-WHILE
-VARIABLES
-CASE


/*===============================LOGICA DENTRO DEL SP===============================*/
--Sirve para evaluar condiciones como un switch o if multiple
CREATE OR ALTER PROC usp_Calificacion_Evaluar
@calificacion INT

```sql
/*=============================== LOGICA DENTRO DEL SP ==========================*/

--CREAR UN SP QUE EVALUE LA EDAD DE UNA PERSONA
CREATE OR ALTER PROC usp_Persona_EvaluarEdad
@edad INT
AS
BEGIN
IF @edad >=18 AND @edad<=45
BEGIN
PRINT('Eres un adulto sin pension')
 PRINT('Ya merito')
 END
 ELSE
PRINT('Eres menor de Edad')
END;
GO

EXEC usp_Persona_EvaluarEdad 22;
EXEC usp_Persona_EvaluarEdad @edad = 50;
GO


-- Otro ejercicio 
CREATE OR ALTER PROC usp_Valores_Imprimir
    @n AS INT
AS
BEGIN

    IF @n<=0
    BEGIN
        PRINT ('ERROR: VALOR DE N NO VALIDO')
        RETURN;
        END
        
    
    DECLARE @i AS INT;
    SET @i = 1;

    WHILE (@i<=@n)
    BEGIN
        PRINT CONCAT ('Este es el numero: ',@i);
        SET @i = @i + 1;
    END
END;
GO

-- Ejecutar 
EXEC usp_Valores_Imprimir 10;
GO


--OTRO
CREATE OR ALTER PROC usp_Valores_Tabla
    @n AS INT
AS
BEGIN

    IF @n<=0
    BEGIN
        PRINT ('ERROR: VALOR DE N NO VALIDO')
        RETURN;
        END
        
    
    DECLARE @i AS INT;
    DECLARE @j INT = 1;
    SET @i = 1;

    WHILE (@i<=@n)
    BEGIN
        WHILE (@j<=10)
        BEGIN
            PRINT CONCAT(@i, '*', @j, '=', @i*@j);
            SET @j = @j +1;
        END
        PRINT (CHAR(13) + CHAR(10))
        SET @i = @i +1;
        SET @j = 1;
    END
END;
GO

EXEC usp_Valores_Tabla 5;
GO

/*=============================== CASE ==========================*/

--Sirve para evaluar condiciones como un switch o if multiple

 CREATE OR ALTER PROC usp_Calificacion_Evaluar

    @calificacion INT
AS
BEGIN
    SELECT 
    CASE 
        WHEN @calificacion >= 90 THEN 'EXELENTE'
        WHEN @calificacion >= 70 THEN 'APROVADO'
        WHEN @calificacion >= 60 THEN 'REGULAR'
        ELSE 'NO ACREDITADO'
    END AS Resultado

END;
GO

EXEC usp_Calificacion_Evaluar 89;
GO

USE Northwind1;

SELECT 
    ProductName,
    unitPrice,
    CASE
        WHEN UnitPrice>=200 THEN 'CARO'
        WHEN UnitPrice>100 THEN 'MEDIO'
        ELSE 'BARATO'
    END AS [CATEGORIA]
FROM Products;
GO

--OTRO EJERCICIO CON CASE EN CUANTO A  ORDEN DE DINERO
CREATE OR ALTER PROC usp_comision_ventas
    @idCliente nchar(10)
AS
BEGIN
    IF LEN(@idCliente) > 5
    BEGIN
        PRINT('El tamaño del id del cliente debe ser de 5');
        RETURN;
    END;

    IF NOT EXISTS(SELECT 1 FROM Customers WHERE CustomerID = @idCliente)
    BEGIN 
        PRINT('Cliente no existe');
        RETURN;
    END;

    DECLARE @comision DECIMAL(10,2);
    DECLARE @total MONEY;

    -- SUM para acumular todas las ventas del cliente
    SET @total = (
        SELECT SUM(UnitPrice * Quantity) 
        FROM [Order Details] AS od
        INNER JOIN Orders AS o ON o.OrderID = od.OrderID
        WHERE o.CustomerID = @idCliente
    );

    SET @comision =
        CASE 
            WHEN @total >= 19000 THEN 5000
            WHEN @total >= 15000 THEN 2000
            WHEN @total >= 10000 THEN 1000
            ELSE 500
        END;

    PRINT CONCAT(
        'TOTAL VENTAS: ', @total, CHAR(13) + CHAR(10),
        'Comision: ', @comision, CHAR(13) + CHAR(10),
        'Ventas más comision: ', @total + @comision
    );
END;
GO

--EJECUTAR
EXEC usp_comision_ventas 'SEVES';
GO
```

5️⃣## STORED PROCEDDURE CON INSERT, UPDATE Y DELETE

Los SP para manejo de un CRUD:

- Create (INSERT)
- Read (SELECT)
- Update (UPDATE)
- Delete (DELETE)

´´´
/*=============================== SP PARA INSERT ==========================*/
CREATE OR ALTER PROCEDURE usp_insertarCliente
    @nombre VARCHAR (50),
    @precio DECIMAL (10,2)
AS
BEGIN
    INSERT INTO productos
        (nombre, precio)
    VALUES
        (@nombre, @precio);

END;
GO

EXEC usp_insertarCliente 'Tonayan', 4500.13;
GO
SELECT *
FROM productos;
 GO

--SP PARA UPDATE 
CREATE OR ALTER PROC usp_Actualizar_precio
    @id INT,
    @precio DECIMAL(10,2)
AS
BEGIN

    IF EXISTS(SELECT 1
    FROM productos
    WHERE id=@id)
BEGIN
        UPDATE productos
SET precio=@precio
WHERE id=@id;
        RETURN
    END
    PRINT 'EL ID DEL PRODUCTO NO EXISTE,NO SE REALIZO LA MODIFICACION';
END;
GO

--Ejecutarlo
EXEC usp_Actualizar_precio 12,78.6;
EXEC usp_Actualizar_precio 1,11233.01;
GO
--SP para DELETE
CREATE OR ALTER PROC usp_Eliminar_Producto
    @id AS INT
AS
BEGIN
    DELETE productos 
    WHERE id=@id;
END;
GO
EXEC usp_Eliminar_Producto 1;
GO


´´´
6️⃣Manejo de errores 
Se utiliza TRY CATCH

Sintaxis
```
BEGIN TRY 
   --CODIGO QUE PUEDE GENERAR ERROR 
END TRY
BEGIN CATCH

--CODIGO QUE SE EJECUTA SI OCURRE UN ERROR

END CATCH
```
Obtener Informacion de error ´CATCH´,SQL Server tiene funciones 
especiales:

Dentro del 

#Store Procedure
##STORED PROCEDURES CON INSERT,UPDATE Y DELETE 
| Funcion | Descripcion |
| :--- | :--- |
| ERROR_MESSAGE() | Mensaje de error|
| ERROR_NUMBER()  | Numero del error |
| ERROR_LINE() | Linea donde ocurrio |
| ERROR_PROCEDURE() | Procedimiento |
| ERROR_SEVERITY() | Nivel de Gravedad |
| ERROR_STATE() | Estado del error |


/*=============================== MANEJO DE ERRORES ==========================*/
--Sin manejo de errores
SELECT 10/0;
--Esto genera una excepcion y detiene la ejecucion 
BEGIN TRY 
SELECT 10/0;
END TRY 
BEGIN CATCH 
PRINT 'Ocurrio el error';
END CATCH
GO

BEGIN TRY 
SELECT 10/0;
END TRY 
BEGIN CATCH
PRINT 'Mensaje: ' + ERROR_MESSAGE();
PRINT 'NUMERO: ' + CAST (ERROR_NUMBER() AS VARCHAR);
PRINT 'LINEA: ' + CAST(ERROR_LINE() AS VARCHAR);
END CATCH;
GO

--USO CON INSERT 


CREATE TABLE productos2
(
    id int ,
    nombre VARCHAR (50),
    precio DECIMAL (10,2)
);
GO

INSERT INTO productos2
VALUES (1,'Pitufo',359.0);

BEGIN TRY 
INSERT INTO productos2 
VALUES (1,'Quemadita',65.0);
END TRY 
BEGIN CATCH
PRINT 

END CATCH;
GO

-- EJEMPLO DE USO DE UNA TRANSACCION 3/23/2026

BEGIN TRANSACCION;

INSERT INTO producto2
VALUES(2, 'Pitufina', 56.8);

ROLLBACK; -- CANCELA LA TRANSACCION, PERMITE QUE BD NO QUEDE INCONSISTENTE
COMMIT; -- CONFIRMA LA TRANSACCION, POR QUE TODO FUE ATOMICO O SE CUMPLIO 

/*=============================== USO DE TRANSACCIONES ==========================*/

--ejercicio par averificar en donde el TRY CATCH  se vuelve poderoso

BEGIN TRY 
--primero     
BEGIN TRANSACTION;

INSERT INTO productos2
VALUES (3,'Charro Negro',123.0);

INSERT INTO productos2
VALUES (3,'PANTERA ROSA',345.6);

--si todo sale bien COMMIT 
COMMIT ;
END TRY 
BEGIN CATCH 
ROLLBACK ;
PRINT 'SE HIZO UN ROLLBACK CON ERROR'
PRINT 'ERROR: '+ERROR_MESSAGE()
END CATCH;

--VALIDAR SI UNA TRANSACCION ESTA ACTIVA 
--si no existe una transaccion abierta y se hace puede marcar un error grave 

BEGIN TRY     
BEGIN TRANSACTION;

INSERT INTO productos2
VALUES (3,'Charro Negro',123.0);

INSERT INTO productos2
VALUES (3,'PANTERA ROSA',345.6);

--si todo sale bien COMMIT 
COMMIT ;
END TRY 
BEGIN CATCH --siempre se debe verificar si la transaccion esta abierta 
IF @@TRANCOUNT>0 --esto quiere decir que esta definida por el sistema --INvesigar para que funciona el @@ y TRANCOUNT   

    ROLLBACK ;
PRINT 'SE HIZO UN ROLLBACK CON ERROR'
PRINT 'ERROR: '+ERROR_MESSAGE()
END CATCH;

```
>NOTA :ERRORES QUE NO CAPTURA EL TRY-CATCH
 --ERRORES DE COMPILACION (EJ.tabla que no existe)
 --Errores de Sintaxis


```SQL 
BEGIN TRY 
        SELCT*FROM tblquenoexiste;
END TRY 
BEGIN CATCH 
PRINT 'NO ENTRA AQUI';
END 
``` 
