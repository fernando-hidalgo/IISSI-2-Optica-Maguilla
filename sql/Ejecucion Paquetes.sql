SET SERVEROUTPUT ON;

DECLARE
aviso NUMBER;
producto NUMBER;
BEGIN
DBMS_OUTPUT.put_line('Paquete Avisos');
Pruebas_Avisos.Inicializar;
producto:= SEC_IDREFERENCIAPRODUCTO.CURRVAL;
Pruebas_Avisos.Insertar('Prueba1',producto,true);
aviso:= SEC_AVISOS.CURRVAL;
Pruebas_Avisos.Actualizar_descripcion('Prueba2',aviso,'eoeo',true);
Pruebas_Avisos.Actualizar_descripcion('Prueba3',aviso + 1,'eoeo',false);
Pruebas_Avisos.Eliminar('Prueba4',aviso,true);

END;
/
BEGIN
DBMS_OUTPUT.put_line('Paquete Clientes');
Pruebas_Cliente.Inicializar;

Pruebas_Cliente.Insertar('Prueba1',41110,'Ant','Per',SYSDATE - 1,'42357456R','Peletero',635276984,'aaa@aaa.aa','Veo poco','C/eo,89','Hombre','https://google.com/flights','https://google.com/flights',true);
Pruebas_Cliente.Insertar('Prueba2',41110,'Jos','Tab',SYSDATE - 4,'42357426R','Financieramente libre',737848991,'aaa@qwe.aa','Veo poco','C/qwe,89','Hombre','https://google.com/flights','https://google.com/flights',true);
Pruebas_Cliente.Actualizar_telefono('Prueba3',SEC_CLIENTE.CURRVAL,666000888,true);
Pruebas_Cliente.Eliminar('Prueba4',SEC_CLIENTE.CURRVAL,true);

END;
/
BEGIN
DBMS_OUTPUT.put_line('Paquete CodigosPostales');
Pruebas_CodPost.Inicializar;
Pruebas_CodPost.Insertar('Prueba1',41120,'SEVILLA','GELVES',true);
Pruebas_CodPost.Actualizar_cod('Prueba2',41120,41130,true);
Pruebas_CodPost.Eliminar('Prueba3',41130,true);
END;
/
BEGIN
DBMS_OUTPUT.put_line('Paquete Encargos');
Pruebas_Encargos.Inicializar;
Pruebas_Encargos.Insertar('Prueba1',SEC_CLIENTE.CURRVAL,true);
Pruebas_Encargos.Actualizar_cli('Prueba2',SEC_IDREFERENCIA_ENCARGO.CURRVAL,SEC_CLIENTE.CURRVAL,true);
Pruebas_Encargos.Eliminar('Prueba3',SEC_IDREFERENCIA_ENCARGO.CURRVAL,true);
END;
/
BEGIN
DBMS_OUTPUT.put_line('Paquete Franquicia');
Pruebas_Franquicia.Inicializar;
Pruebas_Franquicia.Insertar('Prueba1','Optica Maguilla','Av. Ronda de Triana 21','Jesus',true);
Pruebas_Franquicia.Actualizar_nombre('Prueba2','Optica Maguilla','Opticalia',true);
Pruebas_Franquicia.Eliminar('Prueba3','Optica Maguilla',true);

END;
/
DECLARE
cliente NUMBER;
graduacion NUMBER;

BEGIN
DBMS_OUTPUT.put_line('Paquete Graduaciones');
Pruebas_Graduaciones.Inicializar;
cliente:= SEC_CLIENTE.CURRVAL;
Pruebas_Graduaciones.Insertar('Prueba1',cliente,'eee','eee',SYSDATE,true);
graduacion:= SEC_GRADUACION.CURRVAL;
Pruebas_Graduaciones.Insertar('Prueba2',cliente,'eee','eee',SYSDATE + 1,false);
Pruebas_Graduaciones.Actualizar_cliente('Prueba3',graduacion,cliente,true);
Pruebas_Graduaciones.Eliminar('Prueba4',graduacion,true);

END;
/
DECLARE
IDprod NUMBER;
BEGIN
DBMS_OUTPUT.put_line('Paquete Lentes');
Pruebas_Lentes.Inicializar;
IDprod := SEC_IDREFERENCIAPRODUCTO.CURRVAL;
Pruebas_Lentes.Insertar('Prueba1',IDprod,'0,2',true);
Pruebas_Lentes.Actualizar_Curvatura('Prueba2',IDprod,'0,3',true);
Pruebas_Lentes.Eliminar('Prueba3',IDprod,true);

END;
/
DECLARE
IDprod NUMBER;
BEGIN
DBMS_OUTPUT.put_line('Paquete Lentillas');
Pruebas_Lentillas.Inicializar;
IDprod := SEC_IDREFERENCIAPRODUCTO.CURRVAL;
Pruebas_Lentillas.Insertar('Prueba1',IDprod,'0,2',true);
Pruebas_Lentillas.Actualizar_tamaño('Prueba2',IDprod,'0,3',true);
Pruebas_Lentillas.Eliminar('Prueba3',IDprod,true);

END;
/
BEGIN
DBMS_OUTPUT.put_line('Paquete LineasEncargo');
Pruebas_LinEnc.Inicializar;
Pruebas_LinEnc.Insertar('Prueba1',SEC_IDREFERENCIAPRODUCTO.CURRVAL,SEC_IDREFERENCIA_ENCARGO.CURRVAL,7,true);
Pruebas_LinEnc.Actualizar_enc('Prueba2',SEC_LINEAENCARGO.CURRVAL,SEC_IDREFERENCIA_ENCARGO.CURRVAL,true);
Pruebas_LinEnc.Eliminar('Prueba3',SEC_LINEAENCARGO.CURRVAL,true);

END;
/
DECLARE
IDprod NUMBER;
BEGIN
DBMS_OUTPUT.put_line('Paquete Monturas');
Pruebas_Monturas.Inicializar;
IDprod := SEC_IDREFERENCIAPRODUCTO.CURRVAL;
Pruebas_Monturas.Insertar('Prueba1',IDprod,'Metalica','Hombre',true);
Pruebas_Monturas.Actualizar_sexo('Prueba2',IDprod,'Mujer',true);
Pruebas_Monturas.Eliminar('Prueba3',IDprod,true);

END;
/
BEGIN
DBMS_OUTPUT.put_line('Paquete Ofertas');
Pruebas_Ofertas.Inicializar;
Pruebas_Ofertas.Insertar('Prueba1','Oferta de Prueba',true);
Pruebas_Ofertas.Actualizar_nom('Prueba2','Oferta de Prueba','-----',true);
Pruebas_Ofertas.Eliminar('Prueba3','-----',true);
END;
/
DECLARE
graduacion NUMBER;
ojo NUMBER;

BEGIN
DBMS_OUTPUT.put_line('Paquete Ojos');
Pruebas_Ojos.Inicializar;
graduacion:= SEC_GRADUACION.CURRVAL;
Pruebas_Ojos.Insertar('Prueba1',graduacion,'0,1','0,1','0,1','0,1','0,1','0,1','0,1' ,'0,1','0,1','0,1',true);
ojo:= SEC_OJO.CURRVAL;
Pruebas_Ojos.Insertar('Prueba2',graduacion,'0,1','0,1','0,1','0,1','0,1','0,1','2' ,'0,1','0,1','0,1',false);
Pruebas_Ojos.Actualizar_lejos('Prueba3',ojo,'0,2',true);
Pruebas_Ojos.Eliminar('Prueba4',ojo,true);

END;
/
BEGIN
DBMS_OUTPUT.put_line('Paquete Presentan');
Pruebas_Presentan.Inicializar;
Pruebas_Presentan.Insertar('Prueba1','Oferta de Prueba','Franquicia de Prueba',true);
Pruebas_Presentan.Actualizar_nom('Prueba2',SEC_Presentan.CURRVAL,'Optica Nombre Nuevo',true);
Pruebas_Presentan.Eliminar('Prueba3',SEC_Presentan.CURRVAL,true);
END;
/
BEGIN
DBMS_OUTPUT.put_line('Paquete Producto');
Pruebas_Producto.Inicializar;
Pruebas_Producto.Insertar('Prueba1','a',2 ,'5,7','0,2',true);
Pruebas_Producto.Insertar('Prueba1','a',2 ,'5,7','0,2',true);
Pruebas_Producto.Actualizar_nom('Prueba2',SEC_IDREFERENCIAPRODUCTO.CURRVAL,'b',true);
Pruebas_Producto.Eliminar('Prueba3',SEC_IDREFERENCIAPRODUCTO.CURRVAL,true);
END;
/
BEGIN
DBMS_OUTPUT.put_line('Paquete SeEnvianA');
Pruebas_SeEnvianA.Inicializar;
Pruebas_SeEnvianA.Insertar('Prueba1','Oferta de Prueba',SEC_CLIENTE.CURRVAL,true);
Pruebas_SeEnvianA.Actualizar_cod('Prueba2',SEC_SeEnvianA.CURRVAL,SEC_CLIENTE.CURRVAL-1,true);
Pruebas_SeEnvianA.Eliminar('Prueba3',SEC_SeEnvianA.CURRVAL,true);
END;
/