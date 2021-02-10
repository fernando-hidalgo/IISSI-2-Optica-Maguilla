<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarFranquicias.php");
require_once("navBar.php");
include_once("cabecera.php");

// Comprobar que hemos llegado a esta página porque se ha rellenado el formulario
if (isset($_SESSION["formulario_REGF"])) {
    $nuevaFranquicia["nombre"] = $_REQUEST["nombre"]; //con $_SESSION["formulario_REGF"] no lo pilla??;
    $nuevaFranquicia["propietario"] = $_REQUEST["propietario"];
    $nuevaFranquicia["direccion"] = $_REQUEST["direccion"];
    $_SESSION["formulario_REGF"] = null;
}
else 
    Header("Location: form_nueva_franquicia.php");	

$conexion = crearConexionBD(); 
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>Resultado de el formulario de nueva franquicia</title>
</head>
<body>
   <main>
		<?php if (alta_franquicia($conexion, $nuevaFranquicia)) {
				?>
				<fieldset class="formulario" style="width:350px">
				<?php
				echo "Franquicia ".$nuevaFranquicia["nombre"]." registrada";
		?>
				<div >
				Pulsa <a href="<?php echo "form_mostrar_editar_franquicia.php?btn_franq=".$nuevaFranquicia["nombre"]?>">aquí</a> para ir al perfil.
				</div>
		<?php } else { ?>
				<fieldset class="formulario">
				<div >
					La franquicia ya existe en la base de datos.
					Pulsa <a href="paginacion_franquicia.php">aquí</a> para volver al formulario de registro de franquicia.
				</div>
		<?php } ?>
		</fieldset>
	</main>
    <?php
		include_once("pie.php");
	?>
</body>
</html>