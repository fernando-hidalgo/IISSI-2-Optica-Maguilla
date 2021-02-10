 DELETE FROM ENCARGOS;
 DELETE FROM PRODUCTOS;
 DELETE FROM CLIENTES;
 DELETE FROM CODIGOSPOSTALES;
 DELETE FROM OFERTAS;
 DELETE FROM FRANQUICIAS;
      
 INSERT INTO CODIGOSPOSTALES VALUES(41110,'Sevilla','Bollullos');
 INSERT INTO CODIGOSPOSTALES VALUES(42310,'Sevilla','Gelves');
 INSERT INTO CODIGOSPOSTALES VALUES(41120,'Sevilla','Coria');
 INSERT INTO CODIGOSPOSTALES VALUES(42320,'Sevilla','Dos Hermanas');
    
 EXECUTE PR_registrar_franquicia ('Optica Maguilla','C/Cristo de los gitanos,12','Jose Antonio');
    
 EXECUTE PR_registrar_cliente ('Optica Maguilla',41110,'Antonio','Osborne',TO_DATE('2012-06-05', 'YYYY-MM-DD'),'27283847E','Cocinero',777183927,'sss@sss.ss','Me he quedado tuerto de ir por la autopista a 180','C/Gustavo Adolfo Becquer, 32','Otro');
 EXECUTE PR_registrar_cliente ('Optica Maguilla',41110,'Alex','Osborne',TO_DATE('2012-06-05', 'YYYY-MM-DD'),'27283842F','Misterioso',777483927,'sss@sss.ss','Me he quedado tuerto de ir por la autopista a 180','C/Gustavo Adolfo Becquer, 32','Otro');
 EXECUTE PR_registrar_cliente ('Optica Maguilla',41110,'Jose','Osborne',TO_DATE('2012-06-05', 'YYYY-MM-DD'),'27583842X','Peluquero',677483927,'sss@sss.ss','Me he quedado tuerto de ir por la autopista a 180','C/Gustavo Adolfo Becquer, 32','Otro');
 EXECUTE PR_registrar_cliente ('Optica Maguilla',41110,'Fernado','Osborne',TO_DATE('2012-06-05', 'YYYY-MM-DD'),'27283647B','Profesor de iNgles',777883927,'sss@sss.ss','Me he quedado tuerto de ir por la autopista a 180','C/Gustavo Adolfo Becquer, 32','Otro');
 EXECUTE PR_registrar_cliente ('Optica Maguilla',41110,'Victor','Osborne',TO_DATE('2012-06-05', 'YYYY-MM-DD'),'27283817P','Nini',777083927,'sss@sss.ss','Me he quedado tuerto de ir por la autopista a 180','C/Gustavo Adolfo Becquer, 32','Otro');

 
 EXECUTE PR_registrar_lentilla('Lentillas Vista',420 ,'5,7','0,2','0,3');
 EXECUTE PR_registrar_montura('Montura Buena',420 ,'5,7','0,2','Metalica','Hombre');
 EXECUTE PR_registrar_lente('Lente Nitida',420 ,'5,7','0,2','12,5');
 EXECUTE PR_registrar_producto ('Gafas Rojas',2 ,'5,7','0,2'); 
 EXECUTE PR_registrar_producto ('Gafas Verdes',6 ,'5,7','0,2'); 
 EXECUTE PR_registrar_producto ('Gafas Azules',6 ,'2,1','0,2'); 

------------------------------------
--Presentar oferta / Eliminar oferta
 EXECUTE PR_presentar_Oferta('Verano en Sevilla',SEC_IDREFERENCIAPRODUCTO.CURRVAL,'0,2','Gafas fabricadas en Sevilla rebajadas','Optica Maguilla');
 EXECUTE PR_presentar_Oferta('Vision 2020',SEC_IDREFERENCIAPRODUCTO.CURRVAL - 1,'0,4','Gafas nuevas en oferta','Optica Maguilla');

------------------------------------
--Añadir producto oferta / Eliminar producto oferta
 EXECUTE PR_añadirProducto_Oferta('Verano en Sevilla',SEC_IDREFERENCIAPRODUCTO.CURRVAL-3,'0,4','Gafas fabricadas en Sevilla rebajadas');
 EXECUTE PR_añadirProducto_Oferta('Vision 2020',SEC_IDREFERENCIAPRODUCTO.CURRVAL - 4,'0,3','Gafas nuevas en oferta');

 EXECUTE PR_realizar_encargo(SEC_CLIENTE.CURRVAL,SEC_IDREFERENCIAPRODUCTO.CURRVAL,'Encargo de prueba',417);
 EXECUTE PR_añadirProducto_encargo(SEC_IDREFERENCIAPRODUCTO.CURRVAL ,SEC_IDREFERENCIA_ENCARGO.CURRVAL,100);