<?php	
	session_start();	
    require_once("gestionBD.php");
    require_once("gestionarEncargos.php");
    require_once("navBar.php");
    require_once("cabecera.php");
	if (isset($_SESSION["formulario"])) {
        
		$encargo = $_SESSION["formulario"];
		unset($_SESSION["formulario"]);
		
		$conexion = crearConexionBD();		
        $funciona = cancelarEncargo($conexion,$encargo["id"]);
		cerrarConexionBD($conexion);
			
		
		
	}
	else Header("Location: paginacion_encargos.php"); // Se ha tratado de acceder directamente a este PHP
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
<?php if ($funciona) { 
    echo "El encargo se ha eliminado con exito";
    ?>
            <div >	
                   Pulsa <a href="paginacion_encargos.php">aquí</a> para acceder al inicio.
            </div>
    <?php } else { ?>
            <h1>Ha habido un error.</h1>
            <div >	
                Pulsa <a href="form_mostrar_encargos.php">aquí</a> para volver al formulario o <a href="paginacion_encargos.php">aqui</a>
                para volver al inicio.
            </div>
    <?php } 
    ?>
</fieldset>
<?php
include_once("pie.php");
?>

</body>
</html>