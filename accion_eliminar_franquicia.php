<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarFranquicias.php");
require_once("navBar.php");

if (isset($_SESSION["formulario_MODF"])) {
    $eliminarFranquicia = $_SESSION["formulario_MODF"];
    $_SESSION["formulario_MODF"] = null;
}
else 
    Header("Location: tabla_franquicia.php");	

$conexion = crearConexionBD(); 
?>


<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>Resultado de eliminar la franquicia</title>
</head>
<body>
	<?php
		include_once("cabecera.php");
	?>

    <main>
		<?php if (eliminar_franquicia($conexion, $eliminarFranquicia["nombre"])) {
			 ?>
			 <fieldset class="formulario" style="width:350px">
			 <?php
            echo "Franquicia ".$eliminarFranquicia["nombre"]." eliminada";
		?>
		<div >	
			Pulsa <a href="paginacion_franquicia.php">aquí</a> para volver a Inicio.
		</div>
		</fieldset>
		<?php } ?>		
	</main>

	<?php
		include_once("pie.php");
	?>
</body>
</html>
<?php
	cerrarConexionBD($conexion);
?>