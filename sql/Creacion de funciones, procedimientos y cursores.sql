------------------------------------
-- Creación de los procedimientos y funciones
------------------------------------


--Registrar una franquicia
CREATE OR REPLACE PROCEDURE PR_registrar_franquicia (
    w_nombreFranquicia IN Franquicias.nombreFranquicia%TYPE,
    w_direccion IN Franquicias.direccion%TYPE,
    w_propietario IN Franquicias.propietario%TYPE
) IS
    BEGIN
        INSERT INTO Franquicias (nombreFranquicia, direccion, propietario) 
        VALUES (w_nombreFranquicia, w_direccion, w_propietario);
        COMMIT;
    END PR_registrar_franquicia;
/

-----------------------------------------------------------------------------------
--Borrar una franquicia
CREATE OR REPLACE PROCEDURE PR_eliminar_franquicia (
  w_nombreFranquicia IN Franquicias.nombreFranquicia%TYPE )
  IS
    BEGIN
        
        DELETE FROM Tienen WHERE nombreFranquicia = w_nombreFranquicia;
        DELETE FROM Franquicias WHERE nombreFranquicia = w_nombreFranquicia;
        COMMIT;
    END PR_eliminar_franquicia;
/

-----------------------------------------------------------------------------------
--Actualizar una franquicia
-----------------------------------------------------------------------------------
--Registrar un cliente y lo agrega a una franquicia (El modelo presentan una relacion 1.*)
CREATE OR REPLACE PROCEDURE PR_registrar_cliente (
  w_nombreFranquicia IN Franquicias.nombreFranquicia%TYPE,
  w_codigoPostal IN Clientes.codigoPostal%TYPE,
  w_nombre IN Clientes.nombre%TYPE,
  w_apellido IN Clientes.apellido%TYPE,
  w_fechaNacimiento IN Clientes.fechaNacimiento%TYPE,
  w_dni IN Clientes.dni%TYPE,
  w_profesion IN Clientes.profesion%TYPE,
  w_telefono IN Clientes.telefono%TYPE,
  w_email IN Clientes.email%TYPE,
  w_razonVenida IN Clientes.razonVenida%TYPE,
  w_direccion IN Clientes.direccion%TYPE,
  w_sexo IN Clientes.sexo%TYPE
) IS
    BEGIN
        INSERT INTO Clientes (codigoPostal, nombre, apellido, fechaNacimiento, dni, profesion, telefono, email, razonVenida, direccion, sexo) 
        VALUES (w_codigoPostal, w_nombre, w_apellido, w_fechaNacimiento, w_dni, w_profesion, w_telefono, w_email, w_razonVenida, w_direccion, w_sexo);
        COMMIT;
        
        INSERT INTO Tienen(nombreFranquicia, OID_C)
        VALUES(w_nombreFranquicia, SEC_CLIENTE.CURRVAL);
        COMMIT;
        
    END PR_registrar_cliente;
/

-----------------------------------------------------------------------------------
--Registra a un cliente en una franquicia (Un cliente puede estar en mas de una franquicia)
CREATE OR REPLACE PROCEDURE PR_agre_Cliente_Franquicia (
w_nombreFranquicia IN Franquicias.nombreFranquicia%TYPE,
w_OID_C IN Clientes.OID_C%TYPE
) IS
    BEGIN
        INSERT INTO Tienen(nombreFranquicia, OID_C)
        VALUES(w_nombreFranquicia, w_OID_C );
        COMMIT;
    END PR_agre_Cliente_Franquicia;
/
-----------------------------------------------------------------------------------
--Borra a un cliente de una franquicia
CREATE OR REPLACE PROCEDURE PR_elim_cliente_Franquicia (
  w_OID_C IN Tienen.OID_C%TYPE,
  w_nombreFranquicia IN Tienen.nombreFranquicia%TYPE
  )
  IS
    BEGIN
        DELETE FROM Tienen WHERE OID_C = w_OID_C AND nombreFranquicia = w_nombreFranquicia;
        COMMIT;
    END PR_elim_cliente_Franquicia;
/
-----------------------------------------------------------------------------------
--Borrar un cliente
CREATE OR REPLACE PROCEDURE PR_eliminar_cliente (
  w_OID_C IN Clientes.OID_C%TYPE )
  IS
    BEGIN
        DELETE FROM Clientes WHERE OID_C = w_OID_C;
        COMMIT;
    END PR_eliminar_cliente;
/
-----------------------------------------------------------------------------------
--Realizar un encargo (Crea el encargo e introduce la primera linea)
CREATE OR REPLACE PROCEDURE PR_realizar_encargo(
w_OID_C IN Clientes.OID_C%TYPE,
w_ID_referenciaProducto IN Productos.idReferenciaProducto%TYPE,
w_descripcion VARCHAR2,
w_cantidad SMALLINT

) IS
    BEGIN
        INSERT INTO Encargos(OID_C,fechaPedido,descripcion)
        VALUES(w_OID_C,SYSDATE,w_descripcion);
        COMMIT;
        
        INSERT INTO LineasEncargo(idReferenciaProducto,idReferenciaEncargo,cantidad,precioUnitario)
        VALUES(w_ID_referenciaProducto,SEC_IDREFERENCIA_ENCARGO.CURRVAL,w_cantidad,(SELECT precioIVA FROM Productos WHERE idReferenciaProducto = w_ID_referenciaProducto));
        COMMIT;
        
        UPDATE PRODUCTOS SET CANTIDAD = CANTIDAD - w_cantidad where idReferenciaProducto = w_ID_referenciaProducto;    
        COMMIT;
    END PR_realizar_encargo;
/
-----------------------------------------------------------------------------------
--Borrar un encargo
CREATE OR REPLACE PROCEDURE PR_cancelar_encargo (
  w_idReferenciaEncargo IN Encargos.idReferenciaEncargo%TYPE )
  IS
  checker DATE;
   x_1 NUMBER;
   cantidadN NUMBER;
    BEGIN
        SELECT fechaEntrega INTO checker FROM Encargos WHERE idReferenciaEncargo = w_idReferenciaEncargo;
        IF(checker is null)THEN
            SELECT idReferenciaProducto,cantidad  INTO x_1,cantidadN FROM LineasEncargo WHERE idReferenciaEncargo = w_idReferenciaEncargo;
            UPDATE Productos SET cantidad = cantidad + cantidadN WHERE idReferenciaProducto = x_1;
            DELETE FROM Encargos WHERE idReferenciaEncargo = w_idReferenciaEncargo;
            COMMIT;
        END IF;
         EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.put_line('No puedes cancelar un encargo ya entregado');
                ROLLBACK;
END PR_cancelar_encargo;
/
-----------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE PR_encargoRecibido (
  w_idReferenciaEncargo IN Encargos.idReferenciaEncargo%TYPE ) IS
  entrega DATE;
  checker DATE;
BEGIN
  SELECT fechaEntrega INTO checker FROM Encargos WHERE idReferenciaEncargo = w_idReferenciaEncargo;
  IF(checker IS NULL) THEN
    SELECT SYSDATE INTO entrega FROM DUAL;
    UPDATE Encargos SET FECHAENTREGA = entrega WHERE IDREFERENCIAENCARGO = w_idReferenciaEncargo;
    COMMIT;
  END IF;
  
  
END PR_encargoRecibido;
/

--Registrar un producto
CREATE OR REPLACE PROCEDURE PR_registrar_producto (
  w_nombre IN Productos.nombre%TYPE,
  w_cantidad IN Productos.cantidad%TYPE,
  w_precio IN Productos.precio%TYPE,
  w_iva IN Productos.iva%TYPE)
  IS
    BEGIN
    INSERT INTO Productos(nombre,cantidad,precio,iva) VALUES(w_nombre,w_cantidad,w_precio,w_iva);
    COMMIT;
END PR_registrar_producto;
/
-----------------------------------------------------------------------------------

--Registrar una lentilla
CREATE OR REPLACE PROCEDURE PR_registrar_lentilla (
  w_nombre IN Productos.nombre%TYPE,
  w_cantidad IN Productos.cantidad%TYPE,
  w_precio IN Productos.precio%TYPE,
  w_iva IN Productos.iva%TYPE,
  w_tamaño IN Lentillas.tamaño%TYPE)
  IS
    ProductoID SMALLINT;
    BEGIN
    INSERT INTO Productos(nombre,cantidad,precio,descuento,iva) VALUES(w_nombre,w_cantidad,w_precio,'0,0',w_iva);
     COMMIT;
    SELECT SEC_IDREFERENCIAPRODUCTO.CURRVAL INTO ProductoID FROM DUAL;
    INSERT INTO LENTILLAS VALUES(productoID,w_tamaño);
    COMMIT;
END PR_registrar_lentilla;
/
-----------------------------------------------------------------------------------

--Registrar una montura
CREATE OR REPLACE PROCEDURE PR_registrar_Montura (
  w_nombre IN Productos.nombre%TYPE,
  w_cantidad IN Productos.cantidad%TYPE,
  w_precio IN Productos.precio%TYPE,
  w_iva IN Productos.iva%TYPE,
  w_familiaMontura IN Monturas.familiaMontura%TYPE,
  w_sexo IN Monturas.sexo%TYPE)
  IS
    ProductoID SMALLINT;
    BEGIN
    INSERT INTO Productos(nombre,cantidad,precio,descuento,iva) VALUES(w_nombre,w_cantidad,w_precio,'0,0',w_iva);
     COMMIT;
    SELECT SEC_IDREFERENCIAPRODUCTO.CURRVAL INTO ProductoID FROM DUAL;
    INSERT INTO Monturas VALUES(productoID,w_familiaMontura,w_sexo);
    COMMIT;
END PR_registrar_Montura;
/
-----------------------------------------------------------------------------------
--Registrar una Lente
CREATE OR REPLACE PROCEDURE PR_registrar_Lente (
  w_nombre IN Productos.nombre%TYPE,
  w_cantidad IN Productos.cantidad%TYPE,
  w_precio IN Productos.precio%TYPE,
  w_iva IN Productos.iva%TYPE,
  w_curvatura IN Lentes.curvatura%TYPE)
  IS
    ProductoID SMALLINT;
    BEGIN
    INSERT INTO Productos(nombre,cantidad,precio,descuento,iva) VALUES(w_nombre,w_cantidad,w_precio,'0,0',w_iva);
     COMMIT;
    SELECT SEC_IDREFERENCIAPRODUCTO.CURRVAL INTO ProductoID FROM DUAL;
    INSERT INTO Lentes VALUES(productoID,w_curvatura);
    COMMIT;
END PR_registrar_Lente;
/
-----------------------------------------------------------------------------------
--Borrar un producto
CREATE OR REPLACE PROCEDURE PR_eliminar_producto (
  w_idreferenciaProducto IN Productos.idreferenciaProducto%TYPE )
  IS
    BEGIN
DELETE FROM Productos WHERE idreferenciaProducto = w_idreferenciaProducto;
COMMIT;
END PR_eliminar_producto;
/
-----------------------------------------------------------------------------------
--Añadir un producto a un pedido (Se crea una linea de encargo)
CREATE OR REPLACE PROCEDURE PR_añadirProducto_encargo(
w_idreferenciaProducto IN Productos.idReferenciaProducto%TYPE,
w_idReferenciaEncargo IN Encargos.idReferenciaEncargo%TYPE,
w_cantidad SMALLINT
) IS
    BEGIN
        INSERT INTO LineasEncargo(idreferenciaProducto,idReferenciaEncargo,cantidad,precioUnitario)
        VALUES(w_idreferenciaProducto,w_idReferenciaEncargo,w_cantidad,(SELECT precioIVA FROM Productos WHERE idReferenciaProducto = w_idReferenciaProducto));
        COMMIT;
        UPDATE PRODUCTOS SET CANTIDAD = CANTIDAD - w_cantidad where idReferenciaProducto = w_idreferenciaProducto;    
        COMMIT;
    END PR_añadirProducto_encargo;
/
-----------------------------------------------------------------------------------
--Eliminar un producto de un pedido (Se elimina una linea de encargo)
CREATE OR REPLACE PROCEDURE PR_eliminarProducto_encargo (
  w_OID_LE IN LineasEncargo.OID_LE%TYPE )
  IS
    BEGIN
UPDATE Productos SET Cantidad = (SELECT cantidad FROM LineasEncargo WHERE OID_LE = w_OID_LE) WHERE  idReferenciaProducto = (SELECT idReferenciaProducto FROM LineasEncargo WHERE OID_LE = w_OID_LE);
DELETE FROM LineasEncargo WHERE OID_LE = w_OID_LE;

COMMIT;
END PR_eliminarProducto_encargo;
/
-----------------------------------------------------------------------------------
--Crea la graduación de un cliente
CREATE OR REPLACE PROCEDURE PR_graduar_ClienteReducido(
w_OID_C IN Clientes.OID_C%TYPE,
w_graduadoPor IN Graduaciones.graduadoPor%TYPE,
w_atendidoPor IN Graduaciones.atendidoPor%TYPE,
w_ejeI IN Ojos.eje%TYPE,
w_lejosI IN Ojos.lejos%TYPE,
w_cercaI IN Ojos. cerca%TYPE,
w_ejeD IN Ojos.eje%TYPE,
w_lejosD IN Ojos.lejos%TYPE,
w_cercaD IN Ojos. cerca%TYPE
) IS
    BEGIN
        INSERT INTO Graduaciones(OID_C,graduadoPor,atendidoPor,fecha)
        VALUES(w_OID_C,w_graduadoPor,w_atendidoPor,SYSDATE);
        COMMIT;
        
        INSERT INTO Ojos(OID_G,eje,cerca,lejos) VALUES(SEC_GRADUACION.CURRVAL,w_ejeI,w_cercaI,w_lejosI);
        INSERT INTO Ojos(OID_G,eje,cerca,lejos) VALUES(SEC_GRADUACION.CURRVAL,w_ejeD,w_cercaD,w_lejosD);
        COMMIT;
    END PR_graduar_ClienteReducido;
/
-----------------------------------------------------------------------------------
--Elimina la graduación de un cliente
CREATE OR REPLACE PROCEDURE PR_elim_grad_Clie ( 
w_OID_G IN Graduaciones.OID_G%TYPE
) IS
    BEGIN
        DELETE FROM Graduaciones WHERE OID_G = w_OID_G;
        COMMIT;
    END PR_elim_grad_Clie;
/

-----------------------------------------------------------------------------------
--Presenta una oferta (Crea la oferta e introduce la primera linea)
CREATE OR REPLACE PROCEDURE PR_presentar_Oferta (
w_nombreOferta IN Ofertas.nombreOferta%TYPE,
w_idReferenciaProducto IN Productos.idReferenciaProducto%TYPE,
w_descuentoOferta  IN LineasOferta.descuentoOferta%TYPE,
w_descripcion IN LineasOferta.descripcion%TYPE,
w_nombreFranquicia VARCHAR
) IS
    BEGIN
        INSERT INTO Ofertas(nombreOferta)
        VALUES (w_nombreOferta);
        COMMIT;
        INSERT INTO PRESENTAN(NombreOferta, nombreFranquicia) VALUES(w_nombreOferta, w_nombreFranquicia);
        COMMIT;
        INSERT INTO LineasOferta(nombreOferta,idReferenciaProducto, descuentoOferta, descripcion)
        VALUES (w_nombreOferta,w_idReferenciaProducto,w_descuentoOferta, w_descripcion);
        COMMIT;
     
        
        
    END PR_presentar_Oferta;
/
-----------------------------------------------------------------------------------
--Añade productos (Añade lineas de oferta)
CREATE OR REPLACE PROCEDURE PR_añadirProducto_Oferta(
w_nombreOferta IN Ofertas.nombreOferta%TYPE,
w_idReferenciaProducto IN Productos.idReferenciaProducto%TYPE,
w_descuentoOferta  IN LineasOferta.descuentoOferta%TYPE,
w_descripcion IN LineasOferta.descripcion%TYPE
) IS
    BEGIN
       INSERT INTO LineasOferta(nombreOferta,idReferenciaProducto, descuentoOferta, descripcion)
        VALUES (w_nombreOferta,w_idReferenciaProducto,w_descuentoOferta, w_descripcion);
        COMMIT;
    END PR_añadirProducto_Oferta;
/
-----------------------------------------------------------------------------------
--Elimina producto de una oferta (Elimina una linea de oferta)
CREATE OR REPLACE PROCEDURE PR_eliminarProducto_Oferta (
  w_OID_LO IN LineasOferta.OID_LO%TYPE )
  IS
  codP SMALLINT;
    BEGIN
        SELECT idReferenciaProducto INTO codP FROM LineasOferta WHERE OID_LO = w_OID_LO;
        UPDATE PRODUCTOS SET descuento = '0,0' WHERE idReferenciaProducto = codP;
        DELETE FROM LineasOferta WHERE OID_LO = w_OID_LO;
        COMMIT;
    END PR_eliminarProducto_Oferta;
/
-----------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PR_eliminar_Oferta (
  w_nombreOferta IN Ofertas.nombreOferta%TYPE )
  IS
  CURSOR c1 IS SELECT idReferenciaProducto FROM LineasOferta WHERE nombreOferta = w_nombreOferta;
  id_ SMALLINT;
    BEGIN
    FOR i_ IN c1 LOOP
    UPDATE PRODUCTOS SET descuento = '0,0' WHERE idReferenciaProducto = i_.idReferenciaProducto;
    DELETE FROM LineasOferta WHERE nombreOferta = w_nombreOferta;
    DELETE FROM SeEnvianA WHERE nombreOferta = w_nombreOferta;
    END LOOP;
    
    DELETE FROM Ofertas WHERE nombreOferta = w_nombreOferta;
    
END PR_eliminar_Oferta;
/

-----------------------------------------------------------------------------------
--Envia una oferta a un cliente
CREATE OR REPLACE PROCEDURE PR_enviar_Oferta ( 
w_nombreOferta IN Ofertas.nombreOferta%TYPE,
w_OID_C IN Clientes.OID_C%TYPE
) IS
    BEGIN
        INSERT INTO SeEnvianA(nombreOferta, OID_C)
        VALUES(w_nombreOferta,w_OID_C);
        COMMIT;
    END PR_enviar_Oferta;
/
-----------------------------------------------------------------------------------
--Elimina el envio de una oferta a un cliente
CREATE OR REPLACE PROCEDURE PR_elim_env_Oferta ( 
w_OID_SEA IN SeEnvianA.OID_SEA%TYPE
) IS
    BEGIN
        DELETE FROM SeEnvianA WHERE OID_SEA = w_OID_SEA;
        COMMIT;
    END PR_elim_env_Oferta;
/

-----------------------------------------------------------------------------------
--Nuevos Clientes (Dado un periodo de tiempo, calcula cuantos clientes se registraron)
CREATE OR REPLACE FUNCTION FN_nuevos_Clientes ( 
fechaInicio DATE, fechaFin DATE)
RETURN NUMBER IS n_clientes SMALLINT;
    BEGIN
        SELECT COUNT(*) INTO n_clientes FROM Clientes WHERE fechaRegistro BETWEEN fechaInicio AND fechaFin;
    RETURN n_clientes;
END;
/
-----------------------------------------------------------------------------------
--Producto mas caro (Sin IVA)
CREATE OR REPLACE FUNCTION FN_prod_masCaro
RETURN NUMBER 
    IS 
    mayor_precio NUMBER(12,2);
    id_prod_mc SMALLINT;
    BEGIN
        SELECT MAX(precio) INTO mayor_precio FROM Productos;
        SELECT idReferenciaProducto INTO id_prod_mc FROM Productos WHERE precio = mayor_precio;
    RETURN id_prod_mc;
END;
/

-----------------------------------------------------------------------------------
--Producto mas barato (Sin IVA)
CREATE OR REPLACE FUNCTION FN_prod_masBarato
RETURN NUMBER 
    IS 
    menor_precio NUMBER(12,2);
    id_prod_mnc SMALLINT;
    BEGIN
        SELECT MIN(precio) INTO menor_precio FROM Productos;
        SELECT idReferenciaProducto INTO id_prod_mnc FROM Productos WHERE precio = menor_precio;
    RETURN id_prod_mnc;
END;
/
