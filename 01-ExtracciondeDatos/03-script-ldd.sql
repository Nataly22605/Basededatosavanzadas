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
 REFERENCES clientes_2 (cliente_id)     --integridad referencial,ON DELETE- ON UPDATE -> NO ACTION,SET NULL,SET DEFAULD,CASCADE
 ON DELETE NO ACTION                  -- DELETE FROM clientes WHERE cliente_id=3; es como si decidiera eliminarlo pero no se puede porque tiene hijos,ha sido usado
 ON UPDATE NO ACTION
 ); 
 GO

 drop table pedidos;


 INSERT INTO clientes_2
 values('coca-cola',100),
       ('pecsi',80),
       ('chicharrones pork',34);
GO

SELECT*FROM clientes_2;


 INSERT INTO pedidos
 values(GETDATE(),1),
 ('2026-01-19',1),
 ('2026-04-06',4),
 ('2026-12-12',NULL);

 SELECT*
 FROM pedidos;

 --Eliminacion DELETE NO ACTION 

 --Eliminar a los hijos
 DELETE pedidos
 WHERE pedido_id=3;

 --Eliminar al padre
 DELETE FROM clientes_2
 WHERE cliente_id=4;

 --UPDATE NO ACTION

  CREATE TABLE pedidos(
 pedido_id INT not null,    
 fecha_pedido DATE not null,
 cliente_id INT,
 CONSTRAINT pk_pedidos
 PRIMARY KEY(pedido_id),
 CONSTRAINT fk_pedidos_clientes        
 FOREIGN KEY (cliente_id)
 REFERENCES clientes_2 (cliente_id)     --integridad referencial,ON DELETE- ON UPDATE -> NO ACTION,SET NULL,SET DEFAULD,CASCADE
 ON DELETE NO ACTION                  -- DELETE FROM clientes WHERE cliente_id=3; es como si decidiera eliminarlo pero no se puede porque tiene hijos,ha sido usado
 ON UPDATE NO ACTION
 ); 
 GO


 INSERT INTO pedidos
 VALUES(1,GETDATE(),1),
 (2,'2026-01-19',1),
 (3,'2026-04-06',2),
 (4,'2026-12-12',2);


 UPDATE clientes_2
 SET cliente_id=3
 WHERE cliente_id=2;     --BETWEEN ESTE ENTRE 1 Y 10 

         --producto es foreing key N 

 --DELETE Y UPDATE SET NULL
 CREATE TABLE proveedor(
 proveedor_id int not null,       --dominio,valores nulos,check
 nombre nvarchar(60) not null,
 tipo nvarchar(1) not null,
 limite_credito money not null,
 CONSTRAINT pk_proveedor 
 PRIMARY KEY(proveedor_id),
 CONSTRAINT unique_nombre 
 UNIQUE(nombre),
 CONSTRAINT chk_tipo
 CHECK (tipo in ('g','s','b')),
 CONSTRAINT chk_limite_credito
 CHECK (limite_credito between 0 and 30000)
 );
 GO


 CREATE TABLE productos(      --foreign mismo dominio  ENTERO
 producto_id int not null identity(1,1),
 nombre nvarchar(50) not null,
 precio money not null,
 stock_maximo int not null,
 stock_minimo int not null,
 cantidad int not null,
 proveedor_id int,
 CONSTRAINT pk_productos
 PRIMARY KEY (producto_id),
 CONSTRAINT unique_nombre_pr    --no se pueden llamar igual 
 UNIQUE (nombre),
 CONSTRAINT chk_stock_maximo
 CHECK (stock_maximo >=5 and stock_maximo<=400),
 CONSTRAINT chk_stock_minimo
 CHECK (stock_minimo>=1 and stock_minimo <stock_maximo),
 CONSTRAINT chk_cantidad_pr
 CHECK(cantidad>0),
 CONSTRAINT fk_productos_proveedor
 FOREIGN KEY (proveedor_id)
 REFERENCES proveedor(proveedor_id)
 ON DELETE SET NULL
 ON UPDATE SET NULL
 );
 GO


 --DELETE Y UPDATE SET DEFAULT

 --DELETE Y UPDATE CASCADE

 --RESTRICCION CHECK

 --RESTRICCION UNIQUE

