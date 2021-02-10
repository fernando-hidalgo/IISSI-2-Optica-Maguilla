<?php	
	session_start();	
    require_once("gestionBD.php");
    require_once("gestionarEncargos.php");
    require_once("navBar.php");
    require_once("cabecera.php");

	$oid_le=  $_GET["oid_le"];
    $conexion=crearConexionBD();
	$eliminarEncargos=eliminarLineasEncargo($conexion,$oid_le);
	
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>Eliminar Encargo</title>
</head>
<body>

<fieldset class="formulario" style="width:350px">
<?php if ($eliminarEncargos) { 
    echo "El encargo se ha eliminado con exito";
    ?>
            <div >	
                   Pulsa <a href="paginacion_encargos.php">aquí</a> para acceder al inicio.
            </div>
    <?php } else { 
        echo "Ha habido un error";
        ?>
            <div >	
                Pulsa <a href="tabla_lineas_encargos.php">aquí</a> para volver al formulario </a>
            </div>
    <?php } ?>
</fieldset>  
</body>
</html>