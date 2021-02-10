CREATE OR REPLACE FUNCTION ASSERT_EQUALS (salida BOOLEAN, salida_esperada BOOLEAN) 
RETURN VARCHAR2 AS
BEGIN
    IF(salida= salida_esperada) THEN
        RETURN 'EXITO';
    ELSE
        RETURN 'FALLO';
    END IF;
END ASSERT_EQUALS;
/
----------------------------------------------------------------
----------------------------------------------------------------

CREATE OR REPLACE PACKAGE Pruebas_Avisos AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_idReferenciaProducto NUMBER,salidaEsperada BOOLEAN);
PROCEDURE Actualizar_descripcion(nombre_prueba VARCHAR2,w_OID_AV NUMBER,w_new_descripcion VARCHAR2,salidaEsperada BOOLEAN);
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_AV NUMBER,salidaEsperada BOOLEAN);
END Pruebas_Avisos;
/
----------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY Pruebas_Avisos AS
PROCEDURE Inicializar AS
    BEGIN
  
    DELETE FROM Productos;
    INSERT INTO PRODUCTOS(nombre,cantidad,precio,iva)VALUES ('gafas pull', 10,'21,2','0,21');
    DELETE FROM Avisos;
    
    END Inicializar;

PROCEDURE Insertar(nombre_prueba VARCHAR2,w_idReferenciaProducto NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;

    BEGIN
 
        UPDATE PRODUCTOS SET CANTIDAD = 2 WHERE idReferenciaProducto = w_idReferenciaProducto;
        COMMIT;

        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Avisos WHERE PRODUCTOERR = w_idReferenciaProducto;
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;
    

PROCEDURE Actualizar_descripcion(nombre_prueba VARCHAR2,w_OID_AV NUMBER,w_new_descripcion VARCHAR2,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
     
        UPDATE Avisos SET descripcion=w_new_descripcion WHERE OID_AV=w_OID_AV;
        
         --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Avisos WHERE OID_AV=w_OID_AV AND descripcion = w_new_descripcion; 
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_descripcion;
    
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_AV NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN

        DELETE FROM Avisos WHERE OID_AV = w_OID_AV;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Avisos WHERE OID_AV=w_OID_AV;
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;
END Pruebas_Avisos;
/



--------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE PACKAGE Pruebas_Cliente AS

PROCEDURE Inicializar;

PROCEDURE Insertar(nombrePrueba VARCHAR2,w_codigoPostal SMALLINT ,w_nombre VARCHAR,w_apellido VARCHAR ,w_fechaNacimiento DATE ,w_dni VARCHAR ,w_profesion VARCHAR,w_telefono SMALLINT,w_email VARCHAR,w_razonVenida VARCHAR,w_direccion VARCHAR,w_sexo VARCHAR,w_fotoURL VARCHAR,w_firmaURL VARCHAR,salidaEsperada BOOLEAN);
PROCEDURE Actualizar_telefono(nombre_prueba VARCHAR2,w_OID_C NUMBER,w_new_telefono NUMBER,salidaEsperada BOOLEAN);
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_C NUMBER,salidaEsperada BOOLEAN);
END Pruebas_Cliente;
/
----------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY Pruebas_Cliente AS

PROCEDURE Inicializar AS
    BEGIN
        DELETE FROM CLIENTES;
        DELETE FROM CODIGOSPOSTALES;
        INSERT INTO CODIGOSPOSTALES VALUES(41110,'Sevilla','Carrion');
    END Inicializar;

PROCEDURE Insertar(nombrePrueba VARCHAR2,w_codigoPostal SMALLINT ,w_nombre VARCHAR,w_apellido VARCHAR ,w_fechaNacimiento DATE ,w_dni VARCHAR ,w_profesion VARCHAR,w_telefono SMALLINT,w_email VARCHAR,w_razonVenida VARCHAR,w_direccion VARCHAR,w_sexo VARCHAR,w_fotoURL VARCHAR,w_firmaURL VARCHAR,salidaEsperada BOOLEAN) AS

salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
aux_id SMALLINT;
    BEGIN
        --Insertar codigopostal
        INSERT INTO Clientes(codigoPostal,nombre,apellido ,fechaNacimiento  ,dni  ,profesion,telefono,email,razonVenida,direccion,sexo,fotoURL,firmaURL)
        VALUES (w_codigoPostal,w_nombre,w_apellido ,w_fechaNacimiento ,w_dni,w_profesion,w_telefono,w_email,w_razonVenida,w_direccion,w_sexo,w_fotoURL,w_firmaURL);
        COMMIT;
        
       aux_id := SEC_CLIENTE.CURRVAL;
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Clientes WHERE OID_C=aux_id;--Codigo postal es unico
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombrePrueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombrePrueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;
    

PROCEDURE Actualizar_telefono(nombre_prueba VARCHAR2,w_OID_C NUMBER,w_new_telefono NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Actualizar nombres
        UPDATE Clientes SET telefono=w_new_telefono WHERE OID_C=w_OID_C;
        
         --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Clientes WHERE OID_C=w_OID_C AND telefono=w_new_telefono;--Codigo postal es unico
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_telefono;
    
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_C NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM Clientes WHERE OID_C=w_OID_C;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Clientes WHERE OID_C=w_OID_C;--Codigo postal es unico
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;
 
END Pruebas_Cliente;
/
--------------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE PACKAGE Pruebas_CodPost AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_codPostal NUMBER,w_provincia VARCHAR2,w_localidad VARCHAR2,salidaEsperada BOOLEAN);
PROCEDURE Actualizar_cod(nombre_prueba VARCHAR2,w_codPostal NUMBER,w_newcodPostal NUMBER,salidaEsperada BOOLEAN);
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_codPostal NUMBER,salidaEsperada BOOLEAN);
END Pruebas_CodPost;
/
----------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY Pruebas_CodPost AS
PROCEDURE Inicializar AS
    BEGIN
        DELETE FROM CLIENTES;
        DELETE FROM CODIGOSPOSTALES;
    END Inicializar;

PROCEDURE Insertar(nombre_prueba VARCHAR2,w_codPostal NUMBER,w_provincia VARCHAR2,w_localidad VARCHAR2,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        INSERT INTO CodigosPostales VALUES (w_codPostal,w_provincia,w_localidad);
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM CodigosPostales WHERE codPostal=w_codPostal;--Codigo postal es unico
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;
    
    
PROCEDURE Actualizar_cod(nombre_prueba VARCHAR2,w_codPostal NUMBER,w_newcodPostal NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Actualizar nombres
        UPDATE CodigosPostales SET codpostal=w_newcodPostal WHERE codpostal=w_codPostal;
        
         --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM CodigosPostales WHERE codPostal=w_newcodPostal;--Codigo postal es unico
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_cod;
    
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_codPostal NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM CodigosPostales WHERE codPostal=w_codPostal;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM CodigosPostales WHERE codPostal=w_codPostal;--Codigo postal es unico
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;
END Pruebas_CodPost;
/
--------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE Pruebas_Encargos AS
PROCEDURE Inicializar;
PROCEDURE  Insertar(nombre_prueba VARCHAR2,w_OID_C NUMBER,salidaEsperada BOOLEAN) ;
PROCEDURE Actualizar_cli(nombre_prueba VARCHAR2,w_idReferenciaEncargo NUMBER,w_new_OID_C NUMBER,salidaEsperada BOOLEAN);
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_idReferenciaEncargo NUMBER,salidaEsperada BOOLEAN) ;
END Pruebas_Encargos;
/

CREATE OR REPLACE PACKAGE BODY Pruebas_Encargos AS
PROCEDURE Inicializar AS
    BEGIN
    DELETE FROM CLIENTES;
    DELETE FROM CODIGOSPOSTALES;
    
    INSERT INTO CODIGOSPOSTALES VALUES(41110,'Sevilla','Bollullos');
    INSERT INTO CLIENTES(CODIGOPOSTAL,NOMBRE,APELLIDO,FECHANACIMIENTO,DNI,PROFESION,TELEFONO,EMAIL,RAZONVENIDA,DIRECCION,SEXO,FOTOURL,FIRMAURL)
    VALUES(41110,'An','An',TO_DATE('2012-06-05', 'YYYY-MM-DD'),'27283847E','An',777283927,'sss@sss.ss','An','An','Hombre','https://asdasd.asda/asdasd.html','https://asdasd.asda/asdasd.html');
    
    INSERT INTO CLIENTES(CODIGOPOSTAL,NOMBRE,APELLIDO,FECHANACIMIENTO,DNI,PROFESION,TELEFONO,EMAIL,RAZONVENIDA,DIRECCION,SEXO,FOTOURL,FIRMAURL)
    VALUES(41110,'An','An',TO_DATE('2012-06-05', 'YYYY-MM-DD'),'27283848Z','An',777283927,'sss@sss.ss','An','An','Hombre','https://asdasd.asda/asdasd.html','https://asdasd.asda/asdasd.html');
    DELETE FROM Encargos;
    
    END Inicializar;
    
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_OID_C NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
aux_id SMALLINT;
    BEGIN
        --Insertar graduaciones
       INSERT INTO Encargos(OID_C,fechaPedido)
        VALUES(w_OID_C,SYSDATE);
        COMMIT;
        
       
        
        --Comprobar que todo se ha introducido OK.
        aux_id:=SEC_IDREFERENCIA_ENCARGO.CURRVAL;
        
        SELECT COUNT(*)  INTO aux
            FROM Encargos WHERE idReferenciaEncargo= aux_id;
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;


PROCEDURE Actualizar_cli(nombre_prueba VARCHAR2,w_idReferenciaEncargo NUMBER,w_new_OID_C NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Actualizar nombres
        UPDATE Encargos SET OID_C=w_new_OID_C WHERE idReferenciaEncargo=w_idReferenciaEncargo;
        
         --Comprobar que todo se ha introducido OK.
       SELECT COUNT(*)  INTO aux
            FROM Encargos WHERE idReferenciaEncargo=w_idReferenciaEncargo;
            
          IF(AUX<>1) THEN
            salida:=FALSE;
            END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_cli;
    
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_idReferenciaEncargo NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM Encargos WHERE idReferenciaEncargo=w_idReferenciaEncargo;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
       SELECT COUNT(*)  INTO aux
            FROM Encargos WHERE idReferenciaEncargo=w_idReferenciaEncargo;
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;    
  
    
END Pruebas_Encargos;
/

--------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE Pruebas_Franquicia AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_nombreFranquicia VARCHAR2,w_direccion VARCHAR2,w_propietario VARCHAR2,salidaEsperada BOOLEAN);
PROCEDURE Actualizar_nombre(nombre_prueba VARCHAR2,w_nombreFranquicia VARCHAR2,w_new_nombreFranquicia VARCHAR2,salidaEsperada BOOLEAN);
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_nombreFranquicia VARCHAR2,salidaEsperada BOOLEAN);
END Pruebas_Franquicia;
/
----------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY Pruebas_Franquicia AS
PROCEDURE Inicializar AS
    BEGIN
 
    DELETE FROM Franquicias;
    
    END Inicializar;

PROCEDURE Insertar(nombre_prueba VARCHAR2,w_nombreFranquicia VARCHAR2,w_direccion VARCHAR2,w_propietario VARCHAR2,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;

    BEGIN
 
        INSERT INTO Franquicias VALUES (w_nombreFranquicia ,w_direccion ,w_propietario);
        COMMIT;

        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Franquicias WHERE nombreFranquicia= w_nombreFranquicia;
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;
    

PROCEDURE Actualizar_nombre(nombre_prueba VARCHAR2,w_nombreFranquicia VARCHAR2,w_new_nombreFranquicia VARCHAR2,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
     
        UPDATE Franquicias SET nombreFranquicia=w_new_nombreFranquicia WHERE nombreFranquicia=w_nombreFranquicia;
        
         --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Franquicias WHERE nombreFranquicia=w_new_nombreFranquicia; 
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_nombre;
    
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_nombreFranquicia VARCHAR2,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN

        DELETE FROM Franquicias WHERE nombreFranquicia=w_nombreFranquicia;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Franquicias WHERE nombreFranquicia=w_nombreFranquicia;
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;
END Pruebas_Franquicia;
/

--------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE Pruebas_Graduaciones AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_OID_C NUMBER,w_graduadoPor VARCHAR2,w_atendidoPor VARCHAR2,w_fecha DATE,salidaEsperada BOOLEAN);
PROCEDURE Actualizar_cliente(nombre_prueba VARCHAR2,w_OID_G NUMBER,w_new_OID_C NUMBER,salidaEsperada BOOLEAN);
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_G NUMBER,salidaEsperada BOOLEAN);
END Pruebas_Graduaciones;
/
----------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY Pruebas_Graduaciones AS
PROCEDURE Inicializar AS
    BEGIN
    DELETE CLIENTES;
    DELETE CODIGOSPOSTALES;
    INSERT INTO CODIGOSPOSTALES VALUES(41110,'Sevilla','Bollullos');
    INSERT INTO CLIENTES(CODIGOPOSTAL,NOMBRE,APELLIDO,FECHANACIMIENTO,DNI,PROFESION,TELEFONO,EMAIL,RAZONVENIDA,DIRECCION,SEXO,FOTOURL,FIRMAURL)
    VALUES(41110,'An','An',TO_DATE('2012-06-05', 'YYYY-MM-DD'),'27283847E','An',777283927,'sss@sss.ss','An','An','Hombre','https://asdasd.asda/asdasd.html','https://asdasd.asda/asdasd.html');
    
    DELETE FROM Graduaciones;
    END Inicializar;

PROCEDURE Insertar(nombre_prueba VARCHAR2,w_OID_C NUMBER,w_graduadoPor VARCHAR2,w_atendidoPor VARCHAR2,w_fecha DATE,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
graduacion NUMBER;
    BEGIN
        --Insertar graduaciones
        INSERT INTO Graduaciones VALUES (SEC_GRADUACION.NEXTVAL,w_OID_C,w_graduadoPor,w_atendidoPor,w_fecha);
        COMMIT;
        graduacion := SEC_GRADUACION.CURRVAL;
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Graduaciones WHERE OID_G= graduacion;--Codigo postal es unico
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;
    
    
PROCEDURE Actualizar_cliente(nombre_prueba VARCHAR2,w_OID_G NUMBER,w_new_OID_C NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Actualizar nombres
        UPDATE Graduaciones SET OID_C=w_new_OID_C WHERE OID_G=w_OID_G;
        
         --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Graduaciones WHERE OID_G=w_OID_G AND OID_C =w_new_OID_C ;--Codigo postal es unico
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_cliente;
    
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_G NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM Graduaciones WHERE OID_G=w_OID_G;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Graduaciones WHERE OID_G=w_OID_G;--Codigo postal es unico
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;
END Pruebas_Graduaciones;
/
--------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE Pruebas_Lentes AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,w_Curvatura NUMBER,salidaEsperada BOOLEAN);

PROCEDURE Actualizar_Curvatura(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,w_new_Curvatura NUMBER,salidaEsperada BOOLEAN);

PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,salidaEsperada BOOLEAN) ;

END Pruebas_Lentes;
/

CREATE OR REPLACE PACKAGE BODY Pruebas_Lentes AS
PROCEDURE Inicializar AS
    BEGIN
    DELETE FROM PRODUCTOS;
    INSERT INTO PRODUCTOS(nombre,cantidad,precio,iva) VALUES ('Producto Prueba',10,'12,2','0,21');
  
    END Inicializar;
   
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,w_Curvatura NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
aux_id SMALLINT;
    BEGIN
        --Insertar graduaciones
       INSERT INTO Lentes VALUES(w_IDREFERENCIAPRODUCTO,w_Curvatura);
        COMMIT;
        
        SELECT COUNT(*)  INTO aux
            FROM LENTES WHERE IDREFERENCIAPRODUCTO= w_IDREFERENCIAPRODUCTO;
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;


PROCEDURE Actualizar_Curvatura(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,w_new_Curvatura NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Actualizar nombres
        UPDATE Lentes SET Curvatura=w_new_Curvatura WHERE IDREFERENCIAPRODUCTO=w_IDREFERENCIAPRODUCTO;
        
         --Comprobar que todo se ha introducido OK.
       SELECT COUNT(*)  INTO aux
            FROM Lentes WHERE IDREFERENCIAPRODUCTO=w_IDREFERENCIAPRODUCTO AND Curvatura=w_new_Curvatura;
            
          IF(AUX<>1) THEN
            salida:=FALSE;
            END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_Curvatura;
 
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM Lentes WHERE IDREFERENCIAPRODUCTO=w_IDREFERENCIAPRODUCTO;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
       SELECT COUNT(*)  INTO aux
            FROM Lentes WHERE IDREFERENCIAPRODUCTO=w_IDREFERENCIAPRODUCTO;
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;    
    

END Pruebas_Lentes;
/
--------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE Pruebas_Lentillas AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,w_TAMAÑO NUMBER,salidaEsperada BOOLEAN);

PROCEDURE Actualizar_tamaño(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,w_new_TAMAÑO NUMBER,salidaEsperada BOOLEAN);

PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,salidaEsperada BOOLEAN) ;

END Pruebas_Lentillas;
/

CREATE OR REPLACE PACKAGE BODY Pruebas_Lentillas AS
PROCEDURE Inicializar AS
    BEGIN
    DELETE FROM PRODUCTOS;
    INSERT INTO PRODUCTOS(nombre,cantidad,precio,iva) VALUES ('Producto Prueba',10,'12,2','0,21');
  
    END Inicializar;
   
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,w_TAMAÑO NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
aux_id SMALLINT;
    BEGIN
        --Insertar graduaciones
       INSERT INTO Lentillas VALUES(w_IDREFERENCIAPRODUCTO,w_TAMAÑO);
        COMMIT;
        
        SELECT COUNT(*)  INTO aux
            FROM LENTILLAS WHERE IDREFERENCIAPRODUCTO= w_IDREFERENCIAPRODUCTO;
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;


PROCEDURE Actualizar_tamaño(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,w_new_TAMAÑO NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Actualizar nombres
        UPDATE Lentillas SET TAMAÑO=w_new_TAMAÑO WHERE IDREFERENCIAPRODUCTO=w_IDREFERENCIAPRODUCTO;
        
         --Comprobar que todo se ha introducido OK.
       SELECT COUNT(*)  INTO aux
            FROM Lentillas WHERE IDREFERENCIAPRODUCTO=w_IDREFERENCIAPRODUCTO AND TAMAÑO=w_new_TAMAÑO;
            
          IF(AUX<>1) THEN
            salida:=FALSE;
            END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_tamaño;
 
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM Lentillas WHERE IDREFERENCIAPRODUCTO=w_IDREFERENCIAPRODUCTO;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
       SELECT COUNT(*)  INTO aux
            FROM Lentillas WHERE IDREFERENCIAPRODUCTO=w_IDREFERENCIAPRODUCTO;
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;    
    

END Pruebas_Lentillas;
/
--------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE Pruebas_LinEnc AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_ID_referenciaProducto NUMBER,w_idReferenciaEncargo NUMBER,w_cantidad NUMBER,salidaEsperada BOOLEAN);
PROCEDURE Actualizar_enc(nombre_prueba VARCHAR2,w_OID_LE NUMBER,w_new_Enc NUMBER,salidaEsperada BOOLEAN);
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_LE NUMBER,salidaEsperada BOOLEAN);
END Pruebas_LinEnc;
/
-----------------------------------------------------
CREATE OR REPLACE PACKAGE BODY Pruebas_LinEnc AS
PROCEDURE Inicializar AS
    BEGIN
    DELETE FROM CLIENTES;
    DELETE FROM CODIGOSPOSTALES;
    DELETE FROM PRODUCTOS;
    DELETE FROM ENCARGOS;
    
    INSERT INTO CODIGOSPOSTALES VALUES(41110,'Sevilla','Bollullos');
    INSERT INTO CLIENTES(CODIGOPOSTAL,NOMBRE,APELLIDO,FECHANACIMIENTO,DNI,PROFESION,TELEFONO,EMAIL,RAZONVENIDA,DIRECCION,SEXO,FOTOURL,FIRMAURL)
    VALUES(41110,'An','An',TO_DATE('2012-06-05', 'YYYY-MM-DD'),'27283847E','An',777283927,'sss@sss.ss','An','An','Hombre','https://asdasd.asda/asdasd.html','https://asdasd.asda/asdasd.html');
    
    INSERT INTO PRODUCTOS(nombre,cantidad,precio,iva)VALUES ('gafas pull', 10,'21,2','0,21');
    
    INSERT INTO Encargos(OID_C,fechaPedido) VALUES(SEC_CLIENTE.CURRVAL,SYSDATE);
    INSERT INTO Encargos(OID_C,fechaPedido) VALUES(SEC_CLIENTE.CURRVAL,SYSDATE);
    
    DELETE FROM Graduaciones;
    END Inicializar;
    
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_ID_referenciaProducto NUMBER,w_idReferenciaEncargo NUMBER,w_cantidad NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
aux_id SMALLINT;
    BEGIN
        --Insertar graduaciones
        INSERT INTO LineasEncargo(idReferenciaProducto,idReferenciaEncargo,cantidad,precioUnitario)
        VALUES(w_ID_referenciaProducto,w_idReferenciaEncargo,w_cantidad,(SELECT precioIVA FROM Productos WHERE idReferenciaProducto = w_ID_referenciaProducto));
        COMMIT;
        
        UPDATE PRODUCTOS SET CANTIDAD = CANTIDAD - w_cantidad where idReferenciaProducto = w_ID_referenciaProducto;    
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        aux_id := SEC_LINEAENCARGO.CURRVAL;
        SELECT COUNT(*)  INTO aux
            FROM LineasEncargo WHERE OID_LE= aux_id;--Codigo postal es unico
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;


PROCEDURE Actualizar_enc(nombre_prueba VARCHAR2,w_OID_LE NUMBER,w_new_Enc NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Actualizar nombres
        UPDATE LineasEncargo SET idReferenciaEncargo=w_new_Enc WHERE OID_LE= w_OID_LE;
        
         --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM LineasEncargo WHERE OID_LE= w_OID_LE ;--Codigo postal es unico
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_enc;

PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_LE NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM LineasEncargo WHERE OID_LE= w_OID_LE;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM LineasEncargo WHERE OID_LE= w_OID_LE;--Codigo postal es unico
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;

END Pruebas_LinEnc;
/
--------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE Pruebas_Monturas AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,w_FAMILIAMONTURA VARCHAR,w_SEXO VARCHAR,salidaEsperada BOOLEAN);

PROCEDURE Actualizar_sexo(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,w_new_SEXO VARCHAR,salidaEsperada BOOLEAN);

PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,salidaEsperada BOOLEAN) ;

END Pruebas_Monturas;
/

CREATE OR REPLACE PACKAGE BODY Pruebas_Monturas AS
PROCEDURE Inicializar AS
    BEGIN
    DELETE FROM PRODUCTOS;
    INSERT INTO PRODUCTOS(nombre,cantidad,precio,iva) VALUES ('Producto Prueba',10,'12,2','0,21');
  
    END Inicializar;
   
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,w_FAMILIAMONTURA VARCHAR,w_SEXO VARCHAR,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
aux_id SMALLINT;
    BEGIN
        --Insertar graduaciones
       INSERT INTO Monturas VALUES(w_IDREFERENCIAPRODUCTO,w_FAMILIAMONTURA,w_SEXO);
        COMMIT;
        
        SELECT COUNT(*)  INTO aux
            FROM Monturas WHERE IDREFERENCIAPRODUCTO= w_IDREFERENCIAPRODUCTO;
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;


PROCEDURE Actualizar_sexo(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,w_new_SEXO VARCHAR,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Actualizar nombres
        UPDATE Monturas SET SEXO=w_new_SEXO WHERE IDREFERENCIAPRODUCTO=w_IDREFERENCIAPRODUCTO;
        
         --Comprobar que todo se ha introducido OK.
       SELECT COUNT(*)  INTO aux
            FROM Monturas WHERE IDREFERENCIAPRODUCTO=w_IDREFERENCIAPRODUCTO AND  SEXO=w_new_SEXO;
            
          IF(AUX<>1) THEN
            salida:=FALSE;
            END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_sexo;
 
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_IDREFERENCIAPRODUCTO NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM Monturas WHERE IDREFERENCIAPRODUCTO=w_IDREFERENCIAPRODUCTO;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
       SELECT COUNT(*)  INTO aux
            FROM Monturas WHERE IDREFERENCIAPRODUCTO=w_IDREFERENCIAPRODUCTO;
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;    
    

END Pruebas_Monturas;
/
--------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE Pruebas_Ofertas AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_nombreOferta VARCHAR2,salidaEsperada BOOLEAN);
PROCEDURE Actualizar_nom(nombre_prueba VARCHAR2,w_nombreOferta VARCHAR2,w_new_nom VARCHAR2,salidaEsperada BOOLEAN);
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_nombreOferta VARCHAR2,salidaEsperada BOOLEAN);
END Pruebas_Ofertas;
/

CREATE OR REPLACE PACKAGE BODY Pruebas_Ofertas AS
PROCEDURE Inicializar AS
    BEGIN
    DELETE FROM Ofertas;
    END Inicializar;
    
    
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_nombreOferta VARCHAR2,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar graduaciones
        INSERT INTO Ofertas VALUES(w_nombreOferta);
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Ofertas WHERE nombreOferta= w_nombreOferta;--Codigo postal es unico
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;   
    
PROCEDURE Actualizar_nom(nombre_prueba VARCHAR2,w_nombreOferta VARCHAR2,w_new_nom VARCHAR2,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Actualizar nombres
        UPDATE Ofertas SET nombreOferta=w_new_nom WHERE nombreOferta=w_nombreOferta;
        
        SELECT COUNT(*)  INTO aux
            FROM Ofertas WHERE nombreOferta= w_new_nom;--Codigo postal es unico
        
        --Comprobar que todo se ha introducido OK.
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_nom;
    
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_nombreOferta VARCHAR2,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM Ofertas WHERE nombreOferta=w_nombreOferta;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Ofertas WHERE  nombreOferta=w_nombreOferta;--Codigo postal es unico
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;    
    
    
END Pruebas_Ofertas;
/
--------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE Pruebas_Ojos AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_OID_G NUMBER,w_CILINDRO NUMBER,w_ESTOJO NUMBER,w_EJE NUMBER,w_ESTECERCA NUMBER
,w_LEJOS NUMBER,w_CERCA NUMBER,w_CC NUMBER,w_QUERATOMETRIA NUMBER,w_PRISMA NUMBER,w_SC NUMBER,salidaEsperada BOOLEAN);
PROCEDURE Actualizar_lejos(nombre_prueba VARCHAR2,w_OID_O NUMBER,w_new_lejos NUMBER,salidaEsperada BOOLEAN);
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_O NUMBER,salidaEsperada BOOLEAN);
END Pruebas_Ojos;
/
----------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY Pruebas_Ojos AS
PROCEDURE Inicializar AS
    BEGIN
    DELETE FROM Graduaciones;
    DELETE FROM CLIENTES;
    DELETE FROM CODIGOSPOSTALES;
    INSERT INTO CODIGOSPOSTALES VALUES(41110,'Sevilla','Bollullos');
    INSERT INTO CLIENTES(CODIGOPOSTAL,NOMBRE,APELLIDO,FECHANACIMIENTO,DNI,PROFESION,TELEFONO,EMAIL,RAZONVENIDA,DIRECCION,SEXO,FOTOURL,FIRMAURL)
    VALUES(41110,'An','An',TO_DATE('2012-06-05', 'YYYY-MM-DD'),'27283847E','An',777283927,'sss@sss.ss','An','An','Hombre','https://asdasd.asda/asdasd.html','https://asdasd.asda/asdasd.html');
    INSERT INTO GRADUACIONES(OID_C,GRADUADOPOR,ATENDIDOPOR,FECHA) VALUES(SEC_CLIENTE.CURRVAL,'ee','ee',SYSDATE);
    DELETE FROM OJOS;
    END Inicializar;

PROCEDURE Insertar(nombre_prueba VARCHAR2,w_OID_G NUMBER,w_CILINDRO NUMBER,w_ESTOJO NUMBER,w_EJE NUMBER,w_ESTECERCA NUMBER
,w_LEJOS NUMBER,w_CERCA NUMBER,w_CC NUMBER,w_QUERATOMETRIA NUMBER,w_PRISMA NUMBER,w_SC NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
ojo NUMBER;
    BEGIN
        --Insertar graduaciones
        INSERT INTO OJOS(OID_G ,CILINDRO ,ESTOJO ,EJE ,ESTECERCA ,LEJOS ,CERCA ,CC ,QUERATOMETRIA ,PRISMA ,SC) VALUES (w_OID_G ,w_CILINDRO ,w_ESTOJO ,w_EJE ,w_ESTECERCA ,w_LEJOS ,w_CERCA ,w_CC ,w_QUERATOMETRIA ,w_PRISMA ,w_SC);
        COMMIT;
        ojo := SEC_OJO.CURRVAL;
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM OJOS WHERE OID_O= ojo;--Codigo postal es unico
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;
    
    
PROCEDURE Actualizar_lejos(nombre_prueba VARCHAR2,w_OID_O NUMBER,w_new_lejos NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Actualizar nombres
        UPDATE OJOS SET lejos=w_new_lejos WHERE OID_O=w_OID_O;
        
         --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM OJOS WHERE OID_O=w_OID_O AND lejos =w_new_lejos ;--Codigo postal es unico
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_lejos;
    
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_O NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM Ojos WHERE OID_O=w_OID_O;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM OJOS WHERE OID_O=w_OID_O;--Codigo postal es unico
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;
END Pruebas_Ojos;
/
--------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION ASSERT_EQUALS (salida BOOLEAN, salida_esperada BOOLEAN) 
RETURN VARCHAR2 AS
BEGIN
    IF(salida= salida_esperada) THEN
        RETURN 'EXITO';
    ELSE
        RETURN 'FALLO';
    END IF;
END ASSERT_EQUALS;
/
----------------------------------------------------------------

CREATE OR REPLACE PACKAGE Pruebas_Presentan AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_nombreOferta VARCHAR2,w_nombreFranquicia VARCHAR2,salidaEsperada BOOLEAN);
PROCEDURE Actualizar_nom(nombre_prueba VARCHAR2,w_OID_P NUMBER,w_nFran VARCHAR2,salidaEsperada BOOLEAN);
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_P NUMBER,salidaEsperada BOOLEAN);
END Pruebas_Presentan;
/
----------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY Pruebas_Presentan AS
PROCEDURE Inicializar AS
    BEGIN
        DELETE FROM Presentan;
        DELETE FROM OFERTAS;
        DELETE FROM FRANQUICIAS;
        
        INSERT INTO Ofertas(nombreOferta) VALUES ('Oferta de Prueba');
        INSERT INTO Franquicias (nombreFranquicia, direccion, propietario) VALUES ('Franquicia de Prueba', 'C/Prueba', 'Tester');
        INSERT INTO Franquicias (nombreFranquicia, direccion, propietario) VALUES ('Optica Nombre Nuevo', 'C/Prueba', 'Tester');
    END Inicializar;

PROCEDURE Insertar(nombre_prueba VARCHAR2,w_nombreOferta VARCHAR2,w_nombreFranquicia VARCHAR2,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux_id SMALLINT;
aux_lin Presentan%ROWTYPE;
    BEGIN
        --Insertar codigopostal
        INSERT INTO Presentan(nombreOferta, nombreFranquicia) VALUES(w_nombreOferta,w_nombreFranquicia);
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        aux_id :=SEC_Presentan.CURRVAL;
        SELECT OID_P ,NOMBREOFERTA , NOMBREFRANQUICIA   INTO aux_lin
            FROM Presentan WHERE OID_P=aux_id;
            
        IF(aux_lin.nombreOferta<>w_nombreOferta OR aux_lin.nombreFranquicia<>w_nombreFranquicia) THEN
            salida:=FALSE;
        END IF;
        COMMIT;  
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;
    
    
PROCEDURE Actualizar_nom(nombre_prueba VARCHAR2,w_OID_P NUMBER,w_nFran VARCHAR2,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux_lin NUMBER;
    BEGIN
        --Actualizar nombres
        UPDATE Presentan SET nombreFranquicia=w_nFran WHERE OID_P=w_OID_P;
        COMMIT;
        
         --Comprobar que todo se ha introducido OK.
         SELECT COUNT(*)  INTO aux_lin
            FROM Presentan WHERE OID_P=w_OID_P AND nombreFranquicia=w_nFran;
        
          IF(aux_lin<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;     
            
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_nom;
    
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_P NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM Presentan WHERE OID_P=w_OID_P;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Presentan WHERE OID_P=w_OID_P;--Codigo postal es unico
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;
END Pruebas_Presentan;
/
--------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE Pruebas_Producto AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_nombre VARCHAR2,w_CANTIDAD NUMBER,w_precio NUMBER,w_iva NUMBER,salidaEsperada BOOLEAN);
PROCEDURE Actualizar_nom(nombre_prueba VARCHAR2,w_OID_Prod NUMBER,w_new_nom VARCHAR2,salidaEsperada BOOLEAN);
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_Prod NUMBER,salidaEsperada BOOLEAN);
END Pruebas_Producto;
/

CREATE OR REPLACE PACKAGE BODY Pruebas_Producto AS
PROCEDURE Inicializar AS
    BEGIN
    DELETE FROM Productos;
    END Inicializar;
    


PROCEDURE Insertar(nombre_prueba VARCHAR2,w_nombre VARCHAR2,w_CANTIDAD NUMBER,w_precio NUMBER,w_iva NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
aux_id number;
    BEGIN
        --Insertar graduaciones
        INSERT INTO Productos(nombre,cantidad,precio,descuento,iva) VALUES(w_nombre,w_cantidad,w_precio,'0,0',w_iva);
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        aux_id := SEC_IDREFERENCIAPRODUCTO.CURRVAL;
        SELECT COUNT(*)  INTO aux
            FROM Productos WHERE IDREFERENCIAPRODUCTO= aux_id;--Codigo postal es unico
            
        IF(AUX<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;
    
    
PROCEDURE Actualizar_nom(nombre_prueba VARCHAR2,w_OID_Prod NUMBER,w_new_nom VARCHAR2,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux_lin Productos%ROWTYPE;
aux SMALLINT;
    BEGIN
        --Actualizar nombres
        UPDATE Productos SET nombre=w_new_nom WHERE IDREFERENCIAPRODUCTO=w_OID_Prod;
        
         --Comprobar que todo se ha introducido OK.
        SELECT IDREFERENCIAPRODUCTO ,NOMBRE ,CANTIDAD ,PRECIO ,IVA ,PRECIOIVA ,DESCUENTO    INTO aux_lin
            FROM Productos WHERE IDREFERENCIAPRODUCTO=w_OID_Prod;
            
            --Tambien podria ser count(*) WHERE IDREFERENCIAPRODUCTO=w_OID_Prod AND nombre=w_new_nom
        
          IF(aux_lin.NOMBRE<>w_new_nom) THEN
            salida:=FALSE;
        END IF;
        COMMIT;  
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_nom;
    
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_Prod NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM Productos WHERE IDREFERENCIAPRODUCTO=w_OID_Prod;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Productos WHERE IDREFERENCIAPRODUCTO=w_OID_Prod;--Codigo postal es unico
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;    
    
    
END Pruebas_Producto;
/
--------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE Pruebas_SeEnvianA AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_nombreOferta VARCHAR2,w_OID_C NUMBER,salidaEsperada BOOLEAN);
PROCEDURE Actualizar_cod(nombre_prueba VARCHAR2,w_OID_SEA NUMBER,w_nOID_C NUMBER,salidaEsperada BOOLEAN);
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_SEA NUMBER,salidaEsperada BOOLEAN);
END Pruebas_SeEnvianA;
/
----------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY Pruebas_SeEnvianA AS
PROCEDURE Inicializar AS
    BEGIN

        DELETE FROM Clientes;
        DELETE FROM CodigosPostales;
        
        DELETE FROM OFERTAS;
        INSERT INTO Ofertas(nombreOferta) VALUES ('Oferta de Prueba');
        INSERT INTO CODIGOSPOSTALES VALUES(41110,'Sevilla','Bollullos');
        
         INSERT INTO CLIENTES(CODIGOPOSTAL,NOMBRE,APELLIDO,FECHANACIMIENTO,DNI,PROFESION,TELEFONO,EMAIL,RAZONVENIDA,DIRECCION,SEXO,FOTOURL,FIRMAURL)
        VALUES(41110,'NENE','NANO',TO_DATE('2012-06-05', 'YYYY-MM-DD'),'23283847X','An',777281927,'www@sss.ss','An','An','Hombre','https://asdasd.asda/asdasd.html','https://asdasd.asda/asdasd.html');
        
        INSERT INTO CLIENTES(CODIGOPOSTAL,NOMBRE,APELLIDO,FECHANACIMIENTO,DNI,PROFESION,TELEFONO,EMAIL,RAZONVENIDA,DIRECCION,SEXO,FOTOURL,FIRMAURL)
        VALUES(41110,'An','An',TO_DATE('2012-06-05', 'YYYY-MM-DD'),'27283847E','An',777283927,'sss@sss.ss','An','An','Hombre','https://asdasd.asda/asdasd.html','https://asdasd.asda/asdasd.html');
        
        
        DELETE FROM SeEnvianA
        COMMIT;
         
    END Inicializar;

PROCEDURE Insertar(nombre_prueba VARCHAR2,w_nombreOferta VARCHAR2,w_OID_C NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux_id SMALLINT;
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        INSERT INTO SeEnvianA(nombreOferta, OID_C) VALUES(w_nombreOferta,w_OID_C);
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        aux_id := SEC_SeEnvianA.CURRVAL;
        
        SELECT COUNT(*) INTO aux FROM SEENVIANA WHERE OID_SEA=aux_id;
        
        IF(aux<>1) THEN
            SALIDA:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;
    
    
PROCEDURE Actualizar_cod(nombre_prueba VARCHAR2,w_OID_SEA NUMBER,w_nOID_C NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux_id SMALLINT;
aux SMALLINT;
    BEGIN
        --Actualizar nombres
        UPDATE SeEnvianA SET OID_C=w_nOID_C WHERE OID_SEA=w_OID_SEA;
        
         --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*) INTO aux FROM SEENVIANA WHERE OID_SEA=w_OID_SEA AND OID_C = w_nOID_C;
        
        IF(aux<>1) THEN
            SALIDA:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_cod;
    
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_SEA NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM SeEnvianA WHERE OID_SEA=w_OID_SEA;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM SeEnvianA WHERE OID_SEA=w_OID_SEA;
            
        IF(AUX<>0) THEN
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Eliminar;
END Pruebas_SeEnvianA;
/