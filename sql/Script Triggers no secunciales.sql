------------------------------------
-- Creación de los trigger NO asociados a secuencias
------------------------------------
--Comprobar que graduacion no se realiza en el futuro
CREATE OR REPLACE TRIGGER TR_Graduaciones_FechaFutura 
BEFORE INSERT OR UPDATE ON Graduaciones
FOR EACH ROW
DECLARE 
BEGIN
   
    IF(:NEW.fecha> SYSDATE) 
        THEN raise_application_error
        (-20050,'La fecha de graduacion no puede haber ocurrido antes que la fecha del dia');
    END IF;
END;
/

 --Comprobar que la fecha de nacimiento no sea posterior al presente
CREATE OR REPLACE TRIGGER TR_Cliente_FechaActual
BEFORE INSERT OR UPDATE ON Clientes
FOR EACH ROW
DECLARE 
  futuro NUMBER;
BEGIN
    futuro := (SYSDATE - :NEW.fechaNacimiento) ;
    IF(futuro < 0) 
        THEN raise_application_error
        (-20010,'Un cliente no puede haber nacido en el futuro');
    END IF;
END;
/

 --Poner fecha de registro cuando se crea un clienet
CREATE OR REPLACE TRIGGER TR_Cliente_FechaActual
BEFORE INSERT OR UPDATE ON Clientes
FOR EACH ROW
BEGIN
   :NEW.fechaRegistro := SYSDATE;
END;
/
-----------------------------------------------------------------------------------
--Comprobar que la fecha de entrega no sea anterior a la fecha de pedida
CREATE OR REPLACE TRIGGER TR_Encargos_FechaEntrega 
BEFORE INSERT OR UPDATE ON Encargos
FOR EACH ROW
DECLARE 
  entrega NUMBER;
BEGIN
    entrega := (:NEW.fechaEntrega - :NEW.fechaPedido ) ;
    IF(entrega < 0) 
        THEN raise_application_error
        (-20020,'La fecha de entrega no puede haber ocurrido antes que la fecha de pedido');
    END IF;
END;
/
-----------------------------------------------------------------------------------
--RN-003 Avisos de stock -> Comprobar si el stock es bajo, para modificar la tabla de aviso
CREATE OR REPLACE TRIGGER TR_STOCK_PRODUCTO
AFTER INSERT OR UPDATE ON PRODUCTOS
FOR EACH ROW
BEGIN
    IF(:NEW.CANTIDAD < 5) 
        THEN 
        INSERT INTO AVISOS(productoerr,descripcion,cantidadActual)
        VALUES(:NEW.idReferenciaProducto, 'Stock bajo, menos de 5 unidades',:NEW.CANTIDAD);
         ELSE 
        DELETE FROM AVISOS WHERE productoerr = :NEW.idReferenciaProducto;
    END IF;
END;
/
-----------------------------------------------------------------------------------
--Calculo del precio con el IVA aplicado y el descuento
CREATE OR REPLACE TRIGGER TR_precioIVA 
BEFORE INSERT OR UPDATE ON PRODUCTOS
FOR EACH ROW
BEGIN
    :NEW.precioIva := :NEW.precio + (:NEW.precio * :NEW.iva) - (:NEW.precio * :NEW.descuento);
END;
/


-----------------------------------------------------------------------------------
--Modificar el campo descuento del precio
CREATE OR REPLACE TRIGGER TR_nuevo_desc
AFTER INSERT OR UPDATE ON LineasOferta
FOR EACH ROW
BEGIN
    UPDATE Productos SET descuento = :NEW.descuentoOferta WHERE idReferenciaProducto = :NEW.idReferenciaProducto;
END;
/

-------------------------------------------------------------------------------------
 -- Evitar que un cliente no esté en ninguna franquicia
CREATE OR REPLACE TRIGGER TR_sin_franquicia
BEFORE INSERT OR UPDATE ON Tienen
FOR EACH ROW
DECLARE
numeroFCliente SMALLINT;
BEGIN
    SELECT COUNT(*)INTO numeroFCliente FROM Tienen WHERE OID_C = :OLD.OID_C;
    IF(numeroFCliente = 1)
    THEN raise_application_error
        (-20030, 'No se puede eliminar a un cliente de su ultima franquicia, debe eliminar el cliente');
     END IF;
    
END;
/

-----------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER TR_prod_yaoferta
BEFORE INSERT OR UPDATE ON LineasOferta
FOR EACH ROW
DECLARE
n_ SMALLINT;
BEGIN
    SELECT COUNT(*) INTO n_ FROM LineasOferta WHERE idReferenciaProducto = :new.idReferenciaProducto;
    IF(n_>=1) 
    THEN
        UPDATE LineasOferta SET NombreOferta = :NEW.nombreOferta WHERE OID_LO = :NEW.OID_LO;
        UPDATE LineasOferta SET descripcion = :NEW.descripcion WHERE OID_LO = :NEW.OID_LO;
    END IF;
END;
/
-----------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER TR_ProductoYaEnLE
BEFORE INSERT ON LineasEncargo
FOR EACH ROW
DECLARE
n_ SMALLINT;
cant SMALLINT;
BEGIN
    SELECT COUNT(*) INTO n_ FROM LineasEncargo WHERE idReferenciaProducto = :new.idReferenciaProducto;
    IF(n_ = 1) 
    THEN
        SELECT cantidad INTO cant FROM LineasEncargo WHERE idReferenciaProducto = :new.idReferenciaProducto;
        DELETE FROM LineasEncargo Where idReferenciaProducto = :new.idReferenciaProducto;
        :new.cantidad := :new.cantidad + cant;
       
    END IF;
END;
/
