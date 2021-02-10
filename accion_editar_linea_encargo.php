<?php	
	session_start();	
	require_once("gestionBD.php");
    require_once("gestionarEncargos.php");
    require_once("navBar.php");
    require_once("cabecera.php");
	
        
        $oid_le = $_REQUEST["oid_le"];
        $idEnc = $_REQUEST["idEnc"];
        $cantidad = $_REQUEST["cantidad"];
        $preciouni = $_REQUEST["preciouni"];
        

        $conexion = crearConexionBD(); 
				
		$respuesta = actualizar_lineas_encargo($conexion,$oid_le,$cantidad,$preciouni);
		cerrarConexionBD($conexion);
			
		
	
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>eliminar encargo</title>
</head>
<body>

<fieldset class="formulario" style="width:350px">
<?php if ($respuesta) { 
            Header("Location: paginacion_encargos.php");
    ?>         
    <?php } else { 
        echo "Ha habido un error";
        ?>
            <div >	
                Pulsa <a href="form_mostrar_encargos.php">aquí</a> para volver al formulario o <a href="paginacion_encargos.php">aqui</a>
                para volver al inicio.
            </div>
    <?php } ?>
</fieldset>     
</body>
</html>