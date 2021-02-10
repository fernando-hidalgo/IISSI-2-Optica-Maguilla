<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarGraduaciones.php");
require_once("navBar.php");
require_once("cabecera.php");

if (isset($_SESSION["formulario_GRAD"])) {
    $eliminarGraduacion = $_SESSION["formulario_GRAD"];
    $_SESSION["formulario_GRAD"] = null;
}
else 
    Header("Location: paginacion_franquicia.php");	

$conexion = crearConexionBD();
?>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <link rel="stylesheet" type="text/css" href="css/formulario.css">
  <title>Resultado de eliminar graduacion</title>
</head>

<body>
	<?php
		include_once("cabecera.php");
	?>

	<main>
    <fieldset class="formulario" style="width:350px">
        <?php if ($eliminarGraduacion["oid_g"]==""){
            echo "No puedes eliminar el formulario en blanco";
        }else if (eliminar_graduacion($conexion, $eliminarGraduacion["oid_g"])){
            echo "Graduacion eliminada";
        }
        ?>
        <div >
            Pulsa <a href="<?php echo "form_graduaciones.php?dni_grad=" .$eliminarGraduacion['dni']. "&oid_g="?>">aquí</a> para volver a las graduaciones.
		</div>
        </fieldset>
	</main>

	<?php
		include_once("pie.php");
	?>
</body>
</html>
<?php
	cerrarConexionBD($conexion);
?>