CREATE DATABASE db_triggers;
GO

USE db_triggers;
GO

CREATE TABLE Productos
(
id INT PRIMARY KEY,
nombre VARCHAR(50),
precio DECIMAL(10,2)
);
GO

--Ejercicio 1.Evento Everest (Tigger)

CREATE OR ALTER TRIGGER trg_test_insert ---CREA EL TRIGGER
ON Productos  --Tabla a la que se asocia el trigger 
AFTER INSERT  --EL EVENTO CON EL QUE SE VA A DISPARAR
AS
BEGIN 
        SELECT*FROM inserted;
END;
GO

--otro ejercicio de practica 
CREATE OR ALTER TRIGGER trg_test_insert ---CREA EL TRIGGER
ON Productos  --Tabla a la que se asocia el trigger 
AFTER INSERT  --EL EVENTO CON EL QUE SE VA A DISPARAR
AS
BEGIN 
        SELECT*FROM inserted;
        SELECT*FROM Productos; --para que imprima los dos select
        SELECT*FROM deleted;
END;
GO

--------*se ejecuta insertando ,.-  () son opcionales ,si se quieren poner en desorden esta bien 

--EVALUAR 
INSERT INTO Productos(id,nombre,precio)
VALUES(1,'BACALAO',300);

INSERT INTO Productos(id,nombre,precio)
VALUES(2,'3030',310);

INSERT INTO Productos(id,nombre,precio)
VALUES(3,'BUCAÑAS',230);

INSERT INTO Productos(id,nombre,precio)
VALUES(4,'30X30',18),
    (5,'CHARANDA',5.50);

INSERT INTO Productos(id,nombre,precio)
VALUES(6,'Don Peter',100),
    (7,'Presimuerte',98);
GO
--antes deque se ejecute el trigger ejecuta las restricciones de la tabla
SELECT*FROM Productos;
GO

--Evento DELETE

CREATE OR ALTER TRIGGER trg_test_delete
ON Productos
AFTER DELETE
AS
BEGIN
    SELECT*FROM deleted;
    SELECT*FROM inserted;
    SELECT*FROM Productos;
    END;
    --*los triggers se asocian a las tablas 

    DELETE FROM Productos WHERE id=1;
GO

--Evento update 

CREATE OR ALTER TRIGGER trg_test_update
ON Productos 
AFTER UPDATE 
AS 
BEGIN  
    SELECT*FROM inserted;
    SELECT*FROM deleted;
END;
GO

UPDATE Productos
SET precio=600
WHERE id=2;
GO

--REALIZAR UN TRIGGER  QUE PERMITA CANCELAR LA OPERACION SI SE INSERTAN MAS DE 
--UN REGISTRO AL MISMO TIEMPO 

CREATE TABLE Productos2
(
id INT PRIMARY KEY,
nombre VARCHAR(50),
precio DECIMAL(10,2)
);
GO
--*los triggers no reciben parametros 
--*empiezan 
--*SQL HACE TRANSACCIONES IMPLICITAS 

CREATE OR ALTER TRIGGER trg_un_solo_registro
ON Productos2 
AFTER INSERT 
AS
BEGIN
--Contar el numero de registros insertados 
SELECT COUNT(*) FROM inserted
--si-
IF(SELECT COUNT(*)FROM inserted)>1
BEGIN
RAISERROR('SOLO SE PERMITE INSERTAR UN REGISTRO A LA VEZ',16,1);
ROLLBACK TRANSACTION; 
END;
END;

SELECT*FROM Productos2;
GO

--no da error es solo 1
INSERT INTO Productos2(id,nombre,precio)
VALUES(1,'Don Jose',721);
--da error
INSERT INTO Productos2(id,nombre,precio)
VALUES(6,'Don Peter',100),
    (7,'Presimuerte',98);
GO
    --REALIZAR UN TRIGGER QUE DETECTE UN CAMBIO EN EL PRECIO Y MANDE UN MENSAJE DE QUE EL 
    --PRECIO SE CAMBIO 

    CREATE OR ALTER TRIGGER  trg_validar_cambio
    ON Productos2
    AFTER UPDATE 
    AS
    BEGIN 

    IF EXISTS(
        SELECT 1 
        FROM
         inserted AS i
         INNER JOIN 
         deleted as d 
         ON  i.id=d.id
         WHERE i.precio<>d.precio
    )

BEGIN 
PRINT 'EL PRECIO FUE CAMBIADO ';
END
    END; 
    GO

    --TRIGGER QUE EVITE QUE CAMBIE EL PRECIO JAMAS 
    --EVITAR QUE SE PUEDA CAMBIAR EL PRECIO DE LA TABLA DETALLE DE VENTA 