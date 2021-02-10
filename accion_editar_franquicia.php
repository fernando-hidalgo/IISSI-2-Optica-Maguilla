<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarFranquicias.php");
require_once("navBar.php");
include_once("cabecera.php");
$conexion = crearConexionBD();

// Comprobar que hemos llegado a esta página porque se ha rellenado el formulario
if (isset($_SESSION["formulario_MODF"])) {
    $editFranquicia["nombre"] = $_REQUEST["nombre"]; //con $_SESSION["formulario_MODF"] no lo pilla??;
    $editFranquicia["propietario"] = $_REQUEST["propietario"];
	$editFranquicia["direccion"] = $_REQUEST["direccion"];
	
    $_SESSION["formulario_MODF"] = null;
}
else 
    Header("Location: tabla_franquicia.php");	

?>


<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>Resultado de la edición de la franquicia</title>
</head>
<body>
	<main>
		<?php if (edicion_franquicia($conexion, $editFranquicia)) {
		    ?>
		    <fieldset class="formulario" style="width:350px">
			<?php
			echo "Franquicia ".$editFranquicia["nombre"]." editada";
		?>
		<div >	
		Pulsa <a href="<?php echo "form_mostrar_editar_franquicia.php?btn_franq=".$editFranquicia["nombre"]?>">aquí</a> para ir al perfil.
		</div>
		</fieldset>
		<?php } ?>		
	</main>
</body>
</html>
<?php
	cerrarConexionBD($conexion);
	include_once("pie.php");
?>