------------------------------------
-- Borrado de las tablas
------------------------------------
DROP TABLE Avisos;
DROP TABLE Presentan;
DROP TABLE SeEnvianA;
DROP TABLE LineasOferta;
DROP TABLE Ofertas;
DROP TABLE Tienen;
DROP TABLE Franquicias;
DROP TABLE Lentillas;
DROP TABLE Lentes;
DROP TABLE Monturas;
DROP TABLE LineasEncargo;
DROP TABLE Productos;
DROP TABLE Encargos;
DROP TABLE Ojos;
DROP TABLE Graduaciones;
DROP TABLE Clientes;
DROP TABLE CodigosPostales;

------------------------------------
-- Borrado de las secuencias
------------------------------------
DROP SEQUENCE SEC_IDREFERENCIAPRODUCTO;
DROP SEQUENCE SEC_AVISOS;
DROP SEQUENCE SEC_LineasOferta;
DROP SEQUENCE SEC_Presentan;
DROP SEQUENCE SEC_SeEnvianA;
DROP SEQUENCE SEC_Tienen;
DROP SEQUENCE SEC_LINEAENCARGO;
DROP SEQUENCE SEC_OJO;
DROP SEQUENCE SEC_GRADUACION;
DROP SEQUENCE SEC_CLIENTE;
DROP SEQUENCE SEC_IDREFERENCIA_ENCARGO;





------------------------------------
-- Creación de las tablas
------------------------------------
CREATE TABLE CodigosPostales (
    codpostal SMALLINT,
    provincia VARCHAR(50) NOT NULL,
    localidad VARCHAR(50) NOT NULL,
    
    PRIMARY KEY (codpostal)
    );
----------------------------------------------------------
CREATE TABLE Clientes (
    OID_C SMALLINT,
    codigoPostal SMALLINT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    fechaRegistro DATE NOT NULL,
    dni VARCHAR(9) UNIQUE,
    profesion VARCHAR(50),
    telefono SMALLINT,
    email VARCHAR(50),
    razonVenida VARCHAR(100),
    direccion VARCHAR(50),
    sexo VARCHAR(50) NOT NULL,
    
    CONSTRAINT SEXOFALLA CHECK (sexo IN ('Hombre','Mujer','Otro')),
    CONSTRAINT EMAILFALLA CHECK (REGEXP_LIKE(email, '.*@.*\..*')),
    CONSTRAINT DNIFALLA  CHECK (REGEXP_LIKE(dni, '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]')),
    PRIMARY KEY (OID_C),
    FOREIGN KEY (codigoPostal) REFERENCES CodigosPostales(codpostal) 
    );

-------------------------------------------------------------
CREATE TABLE Graduaciones (
    OID_G SMALLINT,
    OID_C SMALLINT NOT NULL,
    graduadoPor VARCHAR(50),
    atendidoPor VARCHAR(50),
    fecha DATE NOT NULL, 
    
    PRIMARY KEY (OID_G),
    FOREIGN KEY (OID_C) REFERENCES Clientes(OID_C) ON DELETE CASCADE
    );

---------------------------------------------------------------
CREATE TABLE Ojos (
    OID_O SMALLINT,
    OID_G SMALLINT NOT NULL,
    cilindro NUMBER(12,2),
    estOjo NUMBER(12,2),
    eje NUMBER(12,2),
    esteCerca NUMBER(12,2),
    lejos NUMBER(12,2),
    cerca NUMBER(12,2),
    cc NUMBER(12,2),
    queratometria NUMBER(12,2),
    prisma NUMBER(12,2),
    sc NUMBER(12,2),
    
    CONSTRAINT CCDECIMAL CHECK(cc >= 0 AND cc <= 1),
    PRIMARY KEY (OID_O),
    FOREIGN KEY (OID_G) REFERENCES Graduaciones(OID_G) ON DELETE CASCADE  
    );

---------------------------------------------------------
CREATE TABLE Encargos (
    idReferenciaEncargo SMALLINT,
    OID_C SMALLINT NOT NULL,
    fechaPedido DATE NOT NULL,
    fechaEntrega DATE,
    descripcion VARCHAR(100),
    
    PRIMARY KEY (idReferenciaEncargo),
    FOREIGN KEY (OID_C) REFERENCES Clientes(OID_C) ON DELETE CASCADE
    );


------------------------------------------------------------------------------

CREATE TABLE Productos (
    idReferenciaProducto SMALLINT,
    nombre VARCHAR(50),
    cantidad SMALLINT NOT NULL,
    precio NUMBER (12,2)NOT NULL,
    iva NUMBER (12,2)NOT NULL,
    precioIVA NUMBER(12,2),
    descuento NUMBER(12,2) DEFAULT '0,0',
    
    CONSTRAINT PRECIONEGATIVO_P CHECK(precio >= 0),
    CONSTRAINT DESCUENTOPORCENTAJEPRODUCTOS CHECK(descuento >= 0 AND descuento <=1),
    CONSTRAINT IVAPORCENTAJE CHECK(iva >= 0 AND iva <=1),
    PRIMARY KEY (idReferenciaProducto)
    );

--------------------------------------------------------------------------------

CREATE TABLE LineasEncargo (
    OID_LE SMALLINT,
    idReferenciaProducto SMALLINT NOT NULL,
    idReferenciaEncargo SMALLINT NOT NULL,
    cantidad SMALLINT,
    precioUnitario NUMBER(12,2),
    
    CONSTRAINT CANTIDADNEGATIVA_LE CHECK(cantidad > 0),
    CONSTRAINT PRECIONEGATIVO_LE CHECK(precioUnitario >= 0),
    PRIMARY KEY (OID_LE),
    FOREIGN KEY (idReferenciaProducto) REFERENCES Productos(idReferenciaProducto) ON DELETE CASCADE,
    FOREIGN KEY (idReferenciaEncargo) REFERENCES Encargos(idReferenciaEncargo) ON DELETE CASCADE
    );
    ALTER TABLE LineasEncargo ADD (precioTotal number(12,2) AS (precioUnitario * cantidad)) ;
CREATE TABLE Monturas (
    idReferenciaProducto SMALLINT,
    familiaMontura VARCHAR(50),
    sexo VARCHAR(50),
    
    CONSTRAINT ERRORSEXO_MONTURAS CHECK(sexo IN ('Hombre','Mujer','Otro')),
    PRIMARY KEY (idReferenciaProducto),
    FOREIGN KEY (idReferenciaProducto) REFERENCES Productos(idReferenciaProducto) ON DELETE CASCADE
    );
--------------------------------------------------------------------------------
CREATE TABLE Lentes (
    idReferenciaProducto SMALLINT,
    curvatura NUMBER(12,2),
    
    PRIMARY KEY (idReferenciaProducto),
    FOREIGN KEY (idReferenciaProducto) REFERENCES Productos(idReferenciaProducto) ON DELETE CASCADE
    );
---------------------------------------------------------------------------------
CREATE TABLE Lentillas (
    idReferenciaProducto SMALLINT,
    tamaño NUMBER(12,2),
    
    CONSTRAINT TAMAÑONEGATIVO CHECK(tamaño > 0),
    PRIMARY KEY (idReferenciaProducto),
    FOREIGN KEY (idReferenciaProducto) REFERENCES Productos(idReferenciaProducto) ON DELETE CASCADE
    );

--------------------------------------------------------------------------------
CREATE TABLE Franquicias (
    nombreFranquicia VARCHAR(50),
    direccion VARCHAR(50) NOT NULL,
    propietario VARCHAR(50),
    
    PRIMARY KEY (nombreFranquicia)
    );
---------------------------------------------------------------------------------
CREATE TABLE Tienen (
    OID_T SMALLINT,
    nombreFranquicia VARCHAR(50) NOT NULL,
    OID_C SMALLINT NOT NULL,
    
    PRIMARY KEY (OID_T),
    FOREIGN KEY (nombreFranquicia) REFERENCES Franquicias(nombreFranquicia) ON DELETE CASCADE,
    FOREIGN KEY (OID_C) REFERENCES Clientes(OID_C) ON DELETE CASCADE
    );
----------------------------------------------------------------------------------
CREATE TABLE Ofertas (
    nombreOferta VARCHAR(50),
     
    PRIMARY KEY (nombreOferta)
    );

----------------------------------------------------------------------------------
CREATE TABLE LineasOferta (
    OID_LO SMALLINT,
    nombreOferta VARCHAR(50) NOT NULL,
    idReferenciaProducto SMALLINT NOT NULL,
    descuentoOferta NUMBER(12,2) NOT NULL,
    descripcion  VARCHAR(100),
    
    PRIMARY KEY (OID_LO),
    CONSTRAINT b_nombreOfer FOREIGN KEY (nombreOferta) REFERENCES Ofertas(nombreOferta),
    FOREIGN KEY (idReferenciaProducto) REFERENCES Productos(idReferenciaProducto) ON DELETE CASCADE,
    
    CONSTRAINT DESCUENTOPORCENTAJELINEAOFERTA CHECK(descuentoOferta >= 0 AND descuentoOferta <=1)
    );

-----------------------------------------------------------------------------------
CREATE TABLE SeEnvianA (
    OID_SEA SMALLINT,
    nombreOferta VARCHAR(50) NOT NULL,
    OID_C SMALLINT NOT NULL,
    
    PRIMARY KEY (OID_SEA),
    FOREIGN KEY (nombreOferta) REFERENCES Ofertas(nombreOferta) ON DELETE CASCADE,
    FOREIGN KEY (OID_C) REFERENCES Clientes(OID_C) ON DELETE CASCADE
    );

-----------------------------------------------------------------------------------
CREATE TABLE Presentan (
    OID_P SMALLINT,
    nombreOferta VARCHAR(50) NOT NULL,
    nombreFranquicia VARCHAR(50) NOT NULL,
    
    PRIMARY KEY (OID_P),
    FOREIGN KEY (nombreOferta) REFERENCES Ofertas(nombreOferta) ON DELETE CASCADE,
    FOREIGN KEY (nombreFranquicia) REFERENCES Franquicias(nombreFranquicia)ON DELETE CASCADE
    );

-----------------------------------------------------------------------------------
CREATE TABLE AVISOS (
OID_AV SMALLINT,
productoerr SMALLINT,
descripcion VARCHAR(50),
cantidadActual SMALLINT,

PRIMARY KEY(OID_AV),
FOREIGN KEY(productoerr) REFERENCES Productos(idReferenciaProducto) ON DELETE CASCADE
);








------------------------------------
-- Creación de las secuencias
------------------------------------
CREATE SEQUENCE SEC_CLIENTE
INCREMENT BY 1 
START WITH 1 
MAXVALUE 9999999;

-----------------------------------------------------------------------------------
CREATE SEQUENCE SEC_GRADUACION
INCREMENT BY 1 
START WITH 1 
MAXVALUE 9999999;

-----------------------------------------------------------------------------------
CREATE SEQUENCE SEC_OJO
INCREMENT BY 1 
START WITH 1 
MAXVALUE 9999999;

-----------------------------------------------------------------------------------
CREATE SEQUENCE SEC_LINEAENCARGO
INCREMENT BY 1 
START WITH 1 
MAXVALUE 9999999;

-----------------------------------------------------------------------------------
CREATE SEQUENCE SEC_Tienen
INCREMENT BY 1 
START WITH 1 
MAXVALUE 9999999;

-----------------------------------------------------------------------------------
CREATE SEQUENCE SEC_SeEnvianA
INCREMENT BY 1 
START WITH 1 
MAXVALUE 9999999;

-----------------------------------------------------------------------------------
CREATE SEQUENCE SEC_Presentan
INCREMENT BY 1 
START WITH 1 
MAXVALUE 9999999;

-----------------------------------------------------------------------------------
CREATE SEQUENCE SEC_LineasOferta
INCREMENT BY 1 
START WITH 1 
MAXVALUE 9999999;

-----------------------------------------------------------------------------------
CREATE SEQUENCE SEC_IDREFERENCIA_ENCARGO
INCREMENT BY 1 
START WITH 1 
MAXVALUE 9999999;

-----------------------------------------------------------------------------------
CREATE SEQUENCE SEC_AVISOS
INCREMENT BY 1 
START WITH 1 
MAXVALUE 9999999;

-----------------------------------------------------------------------------------
CREATE SEQUENCE SEC_IDREFERENCIAPRODUCTO
INCREMENT BY 1 
START WITH 1 
MAXVALUE 9999999;

-----------------------------------------------------------------------------------
------------------------------------
-- Creación de los trigger asociados a las secuencias
------------------------------------
CREATE OR REPLACE TRIGGER TRIGGER_SEC_CLIENTE
BEFORE INSERT ON CLIENTES 
FOR EACH ROW 
DECLARE 
  secuenciaCliente NUMBER := 0; 
BEGIN 
  SELECT SEC_CLIENTE.NEXTVAL INTO secuenciaCliente FROM DUAL; 
  :NEW.OID_C := secuenciaCliente; 
END; 
/
-----------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRIGGER_SEC_GRADUACION
BEFORE INSERT ON GRADUACIONES
FOR EACH ROW 
DECLARE 
  secuenciaGraduacion NUMBER := 0; 
BEGIN 
  SELECT SEC_GRADUACION.NEXTVAL INTO secuenciaGraduacion FROM DUAL; 
  :NEW.OID_G := secuenciaGraduacion; 
END; 
/
-----------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRIGGER_SEC_OJO
BEFORE INSERT ON OJOS 
FOR EACH ROW 
DECLARE 
  secuenciaOjo NUMBER := 0; 
BEGIN 
  SELECT SEC_OJO.NEXTVAL INTO secuenciaOjo FROM DUAL; 
  :NEW.OID_O := secuenciaOjo; 
END; 
/
-----------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRIGGER_SEC_LINEAENCARGO
BEFORE INSERT ON LINEASENCARGO 
FOR EACH ROW 
DECLARE 
  secuenciaLineaEncargo NUMBER := 0; 
BEGIN 
  SELECT SEC_LINEAENCARGO.NEXTVAL INTO secuenciaLineaEncargo FROM DUAL; 
  :NEW.OID_LE := secuenciaLineaEncargo; 
END; 
/
-----------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER TR_SEC_Tienen
BEFORE INSERT ON Tienen 
FOR EACH ROW 
DECLARE 
  valorTienen NUMBER := 0; 
BEGIN 
  SELECT SEC_Tienen.NEXTVAL INTO valorTienen FROM DUAL; 
  :NEW.OID_T:= valorTienen; 
END; 
/
-----------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER TR_SEC_SeEnvianA
BEFORE INSERT ON SeEnvianA 
FOR EACH ROW 
DECLARE 
  valorSeEnvianA NUMBER := 0; 
BEGIN 
  SELECT SEC_SeEnvianA.NEXTVAL INTO valorSeEnvianA FROM DUAL; 
  :NEW.OID_SEA:= valorSeEnvianA; 
END; 
/
-----------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER TR_SEC_Presentan
BEFORE INSERT ON Presentan 
FOR EACH ROW 
DECLARE 
  valorPresentan NUMBER := 0; 
BEGIN 
  SELECT SEC_Presentan.NEXTVAL INTO valorPresentan FROM DUAL; 
  :NEW.OID_P:= valorPresentan; 
END;
/
-----------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER TR_SEC_LineasOferta
BEFORE INSERT ON LineasOferta 
FOR EACH ROW 
DECLARE 
  valorLineasOferta NUMBER := 0; 
BEGIN 
  SELECT SEC_LineasOferta.NEXTVAL INTO valorLineasOferta FROM DUAL; 
  :NEW.OID_LO:= valorLineasOferta; 
END;
/
-----------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER TR_SEC_IDREFERENCIA_ENCARGO
BEFORE INSERT ON Encargos 
FOR EACH ROW 
DECLARE 
  valorIdReferencia NUMBER := 0; 
BEGIN 
  SELECT SEC_IDREFERENCIA_ENCARGO.NEXTVAL INTO valorIdReferencia FROM DUAL; 
  :NEW.idReferenciaEncargo:= valorIdReferencia; 
END;
/
-----------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER TRIGGER_SEC_AVISOS
BEFORE INSERT ON AVISOS 
FOR EACH ROW 
DECLARE 
  secuenciaAvisos NUMBER := 0; 
BEGIN 
  SELECT SEC_AVISOS.NEXTVAL INTO secuenciaAvisos FROM DUAL; 
  :NEW.OID_AV := secuenciaAvisos; 
END; 
/

CREATE OR REPLACE TRIGGER TRIGGER_SEC_IDREFPROD
BEFORE INSERT ON Productos 
FOR EACH ROW 
DECLARE 
  secuenciaProductos NUMBER := 0; 
BEGIN 
  SELECT SEC_IDREFERENCIAPRODUCTO.NEXTVAL INTO secuenciaProductos FROM DUAL; 
  :NEW.idReferenciaProducto := secuenciaProductos; 
END; 
/
