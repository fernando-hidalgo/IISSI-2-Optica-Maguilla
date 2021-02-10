CREATE OR REPLACE PACKAGE Pruebas_LinOfertas AS
PROCEDURE Inicializar;
PROCEDURE Insertar(nombre_prueba VARCHAR2,w_nombreOferta VARCHAR2,w_idReferenciaProducto NUMBER,w_descuentoOferta NUMBER,w_descripcion VARCHAR2,salidaEsperada BOOLEAN);
PROCEDURE Actualizar_descuento(nombre_prueba VARCHAR2,w_OID_LO NUMBER,w_new_descuento NUMBER,salidaEsperada BOOLEAN);
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_LO NUMBER,salidaEsperada BOOLEAN);
END Pruebas_LinOfertas;
/

CREATE OR REPLACE PACKAGE BODY Pruebas_LinOfertas AS
PROCEDURE Inicializar AS
    BEGIN
        DELETE FROM Productos;
        DELETE FROM Ofertas;
        DELETE FROM LineasOferta;
        
        INSERT INTO Ofertas(nombreOferta) VALUES ('Oferta de Prueba');
        INSERT INTO Ofertas(nombreOferta) VALUES ('Oferta de Prueba 2');
        INSERT INTO Productos(nombre,cantidad,precio,descuento,iva) VALUES('Producto de Prueba',4,'7,9','0,0','0,420');
    END Inicializar;

PROCEDURE Insertar(nombre_prueba VARCHAR2,w_nombreOferta VARCHAR2,w_idReferenciaProducto NUMBER,w_descuentoOferta NUMBER,w_descripcion VARCHAR2,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
aux_id NUMBER;
    BEGIN
        --Insertar graduaciones
        INSERT INTO LineasOferta(nombreOferta,idReferenciaProducto, descuentoOferta, descripcion)
        VALUES (w_nombreOferta,w_idReferenciaProducto,w_descuentoOferta, w_descripcion);
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        aux_id := SEC_LineasOferta.CURRVAL;
        SELECT COUNT(*)  INTO aux
            FROM LineasOferta WHERE OID_LO= aux_id;--Codigo postal es unico
            
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
    
    
PROCEDURE Actualizar_descuento(nombre_prueba VARCHAR2,w_OID_LO NUMBER,w_new_descuento NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
     
        --Actualizar nombres
        UPDATE LineasOferta SET descuentoOferta=w_new_descuento WHERE OID_LO=w_OID_LO;
        
         --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM LineasOferta WHERE OID_LO=w_OID_LO AND descuentoOferta=w_new_descuento;
        
        IF(AUX<>1) THEN
        
            salida:=FALSE;
        END IF;
        COMMIT;
        
        --Mostrar resultado de la prueba
        DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(salida,salidaEsperada));
        EXCEPTION WHEN OTHERS THEN
                 
                DBMS_OUTPUT.put_line(nombre_prueba || ':' || ASSERT_EQUALS(FALSE,salidaEsperada));
                ROLLBACK;
    END Actualizar_descuento;
    
PROCEDURE Eliminar(nombre_prueba VARCHAR2,w_OID_LO NUMBER,salidaEsperada BOOLEAN) AS
salida BOOLEAN :=TRUE; --Salida esperada
aux SMALLINT;
    BEGIN
        --Insertar codigopostal
        DELETE FROM LineasOferta WHERE OID_LO=w_OID_LO;
        COMMIT;
        
        --Comprobar que todo se ha introducido OK.
        SELECT COUNT(*)  INTO aux
            FROM LineasOferta WHERE OID_LO=w_OID_LO;--Codigo postal es unico
            
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
END Pruebas_LinOfertas;
/


SET SERVEROUTPUT ON;
DECLARE
BEGIN
Pruebas_LinOfertas.Inicializar;
Pruebas_LinOfertas.Insertar('Prueba1','Oferta de Prueba',SEC_IDREFERENCIAPRODUCTO.CURRVAL,'0,98','Descripcion',true);
Pruebas_LinOfertas.Actualizar_descuento('Prueba2',SEC_LineasOferta.CURRVAl ,'0,32',true);
Pruebas_LinOfertas.Eliminar('Prueba3',SEC_LineasOferta.CURRVAL,true);

END;