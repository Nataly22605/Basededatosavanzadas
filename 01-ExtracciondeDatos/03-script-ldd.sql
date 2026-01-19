-- Restricciones SQL
CREATE DATABASE restricciones;
GO

USE restricciones;
GO

CREATE TABLE clientes(
cliente_id int not null primary key,          --primary key (int-dominio)
nombre nvarchar(50) not null,
apellido_paterno nvarchar(20) not null,
apellido_materno nvarchar(20) not null
)
GO

INSERT INTO clientes
VALUES(1,'PANFILO PANCRACIO','BAD BUNNY','GOOD BUNNY');
GO

INSERT INTO clientes
VALUES(2,'ARCADIA','LORENZA','LOCA');
GO

INSERT INTO clientes
(apellido_paterno,nombre,cliente_id,apellido_materno)
VALUES('Aguilar','Toribio',3,'Cow');
GO

INSERT INTO clientes 
VALUES 
(4,'MONICO','BUENA VISTA','DEL OJO'),
 (5,'RICARDA','DE LA PARED','PINTADA'),
 (6,'ANGEL GUADALUPE','GUERRERO','HERNANDEZ'),
 (7,'JOSE ANGEL ETHAN','DANIELO','LINUXCEN');
 GO


 SELECT*
 FROM clientes;
 GO

 CREATE TABLE clientes_2(
 cliente_id int not null identity(1,1),   --identity no es una restriccion,es una autoincremental
 nombre nvarchar(50) not null,
 edad int not null,
 CONSTRAINT pk_clientes_2                   --se le dio el nombre 
 PRIMARY KEY(cliente_id) 
 );
 GO

 CREATE TABLE pedidos(
 pedido_id INT not null identity(1,1),    
 fecha_pedido DATE not null,
 cliente_id INT,
 CONSTRAINT pk_pedidos
 PRIMARY KEY(pedido_id),
 CONSTRAINT fk_pedidos_clientes
 FOREIGN KEY (cliente_id)
 REFERENCES clientes (cliente_id)     --integral referencial,ON DELETE- ON UPDATE -> NO ACTION,SET NULL,SET DEFAULD,CASCADE
 ON DELETE NO ACTION
 ON UPDATE NO ACTION
 ); 
 GO