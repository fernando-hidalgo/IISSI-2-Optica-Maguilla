----------------------------------------------------------------

CREATE OR REPLACE PACKAGE Pruebas_Tienen AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_nombreFranquicia VARCHAR2,w_OID_C NUMBER,salidaEsperada BOOLEAN);
PROCEDURE Actualizar_nom(nombre_prueba VARCHAR2,w_OID_T NUMBER,w_nFran VARCHAR2,salidaEsperada BOOLEAN);
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_T NUMBER,salidaEsperada BOOLEAN);
END Pruebas_Tienen;
/
----------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY Pruebas_Tienen AS
PROCEDURE Inicializar AS
    BEGIN
        
        
        DELETE CLIENTES;
        DELETE CODIGOSPOSTALES;
        DELETE FROM FRANQUICIAS;
        INSERT INTO CODIGOSPOSTALES VALUES(41110,'Sevilla','Bollullos');
        INSERT INTO CLIENTES(CODIGOPOSTAL,NOMBRE,APELLIDO,FECHANACIMIENTO,DNI,PROFESION,TELEFONO,EMAIL,RAZONVENIDA,DIRECCION,SEXO,FOTOURL,FIRMAURL)
        VALUES(41110,'An','An',TO_DATE('2012-06-05', 'YYYY-MM-DD'),'27283847E','An',777283927,'sss@sss.ss','An','An','Hombre','https://asdasd.asda/asdasd.html','https://asdasd.asda/asdasd.html');
        INSERT INTO Franquicias (nombreFranquicia, direccion, propietario) VALUES ('Franquicia de Prueba', 'C/Prueba', 'Tester');
        INSERT INTO Franquicias (nombreFranquicia, direccion, propietario) VALUES ('prro', 'C/Prueba', 'Tester');
        DELETE FROM Tienen;
        
    END Inicializar;

PROCEDURE Insertar(nombre_prueba VARCHAR2,w_nombreFranquicia VARCHAR2,w_OID_C NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux_id SMALLINT;
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        INSERT INTO Tienen(nombreFranquicia, OID_C) VALUES(w_nombreFranquicia,w_OID_C);
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        aux_id :=SEC_Tienen.CURRVAL;
        SELECT COUNT(*)   INTO aux
            FROM Tienen WHERE OID_T=aux_id;
            
        IF(aux<>1) THEN
            salida:=FALSE;
        END IF;
        COMMIT;  
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Insertar;
    
    
PROCEDURE Actualizar_nom(nombre_prueba VARCHAR2,w_OID_T NUMBER,w_nFran VARCHAR2,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux_lin NUMBER;
    BEGIN
        --Actualizar nombres
        UPDATE Tienen SET nombreFranquicia= w_nFran WHERE  OID_T=w_OID_T;
        
         --Comprobar que todo se ha introducido OK.
         SELECT COUNT(*) INTO aux_lin
            FROM Tienen WHERE OID_T=w_OID_T  AND nombreFranquicia= w_nFran;
        
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
    
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_T NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM Tienen WHERE OID_T=w_OID_T;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM Tienen WHERE OID_T=w_OID_T;--Codigo postal es unico
            
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
END Pruebas_Tienen;
/
----------------------------------------------------------------
SET SERVEROUTPUT ON;
DECLARE
BEGIN

Pruebas_Tienen.Inicializar;
Pruebas_Tienen.Insertar('Prueba1','Franquicia de Prueba',SEC_CLIENTE.CURRVAL,true);
Pruebas_Presentan.Actualizar_nom('Prueba2',SEC_Tienen.CURRVAL,'Franquicia de Prueba 2',true);
Pruebas_Presentan.Eliminar('Prueba3',SEC_Tienen.CURRVAL,true);
END;