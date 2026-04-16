CREATE DATABASE inventarioDB;
GO

USE inventarioDB;
GO


CREATE TABLE clasificacion (
    id_clasificacion     INT IDENTITY(1,1) PRIMARY KEY,
    descripcion          VARCHAR(100) NOT NULL,
    nivel_clasificacion  VARCHAR(50)  NOT NULL
);
GO


CREATE TABLE proveedor (
    id_proveedor     INT IDENTITY(1,1) PRIMARY KEY,
    rfc              VARCHAR(20)  NOT NULL,
    razon_social     VARCHAR(150) NOT NULL,
    nombre_contacto  VARCHAR(100) NOT NULL,
    tel_principal    VARCHAR(15)  NOT NULL,
    tel_movil        VARCHAR(15),
    e_mail           VARCHAR(100),
    estatus          VARCHAR(10)  NOT NULL DEFAULT 'activo'
                     CHECK (estatus IN ('activo', 'cancelado')),
    fecha_registro   DATE         NOT NULL DEFAULT GETDATE()
);
GO


CREATE TABLE direccion_proveedor (
    id_proveedor  INT          NOT NULL PRIMARY KEY,
    calle         VARCHAR(150) NOT NULL,
    no_int        VARCHAR(10),
    no_ext        VARCHAR(10)  NOT NULL,
    colonia       VARCHAR(100) NOT NULL,
    localidad     VARCHAR(100) NOT NULL,
    id_entidad    INT          NOT NULL,
    id_municipio  INT          NOT NULL,
    pais          VARCHAR(50)  NOT NULL DEFAULT 'México',
    cod_postal    VARCHAR(10)  NOT NULL,
    CONSTRAINT FK_dir_proveedor FOREIGN KEY (id_proveedor)
        REFERENCES proveedor(id_proveedor)
);
GO


CREATE TABLE articulo (
    cod_barras            VARCHAR(50)    NOT NULL PRIMARY KEY,
    cod_asociado          VARCHAR(50),
    id_clasificacion      INT            NOT NULL,
    cod_interno           VARCHAR(30),
    descripcion           VARCHAR(200)   NOT NULL,
    descripcion_corta     VARCHAR(100),
    cantidad_um           DECIMAL(10,2)  NOT NULL DEFAULT 1,
    id_unidad             INT            NOT NULL,
    id_proveedor          INT            NOT NULL,
    precio_compra         DECIMAL(10,2)  NOT NULL,
    utilidad              DECIMAL(5,2)   NOT NULL DEFAULT 0,
    precio_venta          DECIMAL(10,2)  NOT NULL,
    tipo_articulo         VARCHAR(50),
    stock                 INT            NOT NULL DEFAULT 0,
    stock_min             INT            NOT NULL DEFAULT 0,
    stock_max             INT            NOT NULL DEFAULT 0,
    iva                   DECIMAL(5,2)   NOT NULL DEFAULT 16,
    kit_fecha_ini         DATE,
    kit_fecha_fin         DATE,
    articulo_disponible   BIT            NOT NULL DEFAULT 1,
    kit                   BIT            NOT NULL DEFAULT 0,
    fecha_registro        DATE           NOT NULL DEFAULT GETDATE(),
    visible               BIT            NOT NULL DEFAULT 1,
    puntos                INT            NOT NULL DEFAULT 0,
    last_update_inventory DATETIME,
    cve_producto          VARCHAR(30),
    estatus               VARCHAR(10)    NOT NULL DEFAULT 'activo'
                          CHECK (estatus IN ('activo', 'cancelado')),

    CONSTRAINT FK_art_clasificacion FOREIGN KEY (id_clasificacion)
        REFERENCES clasificacion(id_clasificacion),

    CONSTRAINT FK_art_proveedor FOREIGN KEY (id_proveedor)
        REFERENCES proveedor(id_proveedor)
);
GO

INSERT INTO clasificacion (descripcion, nivel_clasificacion) VALUES
('Electrodomesticos', 'A'),
('Deporte', 'B'),
('Electronica', 'C');
GO


INSERT INTO proveedor (rfc, razon_social, nombre_contacto, tel_principal, tel_movil, e_mail, estatus)
VALUES
('NAXX019281000', 'PLAZA COMERCIAL REAL', 'Enrique', '5511230067', '7719876543', 'enrique2te.com', 'activo'),
('UNB880326XXX', 'Coopel SA de CV', 'Mortin', '77123736278', NULL, 'mortin27sur.com', 'activo');
GO

INSERT INTO direccion_proveedor (id_proveedor, calle, no_ext, colonia, localidad, id_entidad, id_municipio, pais, cod_postal)
VALUES
(1, 'Av. Principal', '101', 'Centro', 'Pachuca', 13, 48, 'México', '42000'),
(2, 'Calle Reforma', '55', 'Reforma', 'Tula', 13, 72, 'México', '42800');
GO


INSERT INTO articulo (cod_barras, id_clasificacion, descripcion, descripcion_corta, cantidad_um, id_unidad, id_proveedor, precio_compra, utilidad, precio_venta, stock, stock_min, stock_max, iva, estatus)
VALUES
(NEWID(), 1, 'Televisión 32 pulgadas', 'TV 32"', 1, 1, 1, 3500.00, 20.00, 4200.00, 10, 2, 50, 16, 'activo'),
(NEWID(), 1, 'MICROONDAS', 'Microondas LG', 1, 1, 1, 8000.00, 15.00, 9200.00, 5, 1, 20, 16, 'activo'),
(NEWID(), 3, 'Caja de Cereales', 'Cereal', 1, 2, 2, 45.00, 30.00, 58.50, 100, 20, 500, 0, 'activo');
GO
SELECT * FROM clasificacion
SELECT * FROM proveedor
SELECT * FROM articulo
SELECT * FROM direccion_proveedor


USE inventarioDB;
GO


DROP TABLE IF EXISTS direccion_proveedor;
GO


CREATE TABLE direccion_proveedor (
    id_direccion  INT IDENTITY(1,1) PRIMARY KEY,
    id_proveedor  INT          NOT NULL,
    calle         VARCHAR(150) NOT NULL,
    no_int        VARCHAR(10),
    no_ext        VARCHAR(10)  NOT NULL,
    colonia       VARCHAR(100) NOT NULL,
    localidad     VARCHAR(100) NOT NULL,
    id_entidad    INT          NOT NULL,
    id_municipio  INT          NOT NULL,
    pais          VARCHAR(50)  NOT NULL DEFAULT 'México',
    cod_postal    VARCHAR(10)  NOT NULL,
    CONSTRAINT FK_dir_proveedor FOREIGN KEY (id_proveedor)
        REFERENCES proveedor(id_proveedor)
);
GO


INSERT INTO direccion_proveedor 
    (id_proveedor, calle, no_ext, colonia, localidad, id_entidad, id_municipio, pais, cod_postal)
VALUES
    (1, 'Av. Principal',  '101', 'Centro',  'Pachuca', 13, 48, 'México', '42000'),
    (1, 'Calle Juárez',   '22',  'Reforma', 'Tula',    13, 75, 'México', '42800'),
    (2, 'Blvd. Pedregal', '55',  'Del Valle','Pachuca', 13, 48, 'México', '42060');
GO

SELECT * FROM direccion_proveedor
SELECT * FROM proveedor