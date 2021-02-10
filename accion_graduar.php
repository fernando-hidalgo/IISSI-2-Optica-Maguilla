<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarGraduaciones.php");
require_once("navBar.php");
require_once("cabecera.php");

// Comprobar que hemos llegado a esta página porque se ha rellenado el formulario
if (isset($_SESSION["formulario_GRAD"])) {
	$nuevaGraduacion['oid_c'] = $_REQUEST["id_c"];
	$nuevaGraduacion['dni'] = $_REQUEST["dni"];
    $nuevaGraduacion['graduadoPor'] = $_REQUEST["graduadoPor"];
    $nuevaGraduacion['atendidoPor'] = $_REQUEST["atendidoPor"];
    $nuevaGraduacion['fechagrad'] = $_REQUEST["fechagrad"];
    $nuevaGraduacion['ejeI'] = $_REQUEST["ejeI"];
    $nuevaGraduacion['lejosI'] = $_REQUEST["lejosI"];
    $nuevaGraduacion['cercaI'] = $_REQUEST["cercaI"];
    $nuevaGraduacion['ejeD'] = $_REQUEST["ejeD"];
    $nuevaGraduacion['lejosD'] = $_REQUEST["lejosD"];
    $nuevaGraduacion['cercaD'] = $_REQUEST["cercaD"];
    
    $_SESSION["formulario_GRAD"] = null;
}
else 
    Header("Location: tabla_cliente.php");	

$conexion = crearConexionBD(); 
?>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Resultado de la graduación</title>
  <link rel="stylesheet" type="text/css" href="css/formulario.css">
</head>

<body>
	<?php
		include_once("cabecera.php");
	?>

    <main>
		<fieldset class="formulario" style="width:350px">
		<?php if (graduar($conexion, $nuevaGraduacion)) {
			echo "Graduación realizada con éxito";
		?>
		<div >
			Pulsa <a href="<?php echo "form_graduaciones.php?dni_grad=" .$nuevaGraduacion['dni']. "&oid_g="?>">aquí</a> para volver a las graduaciones.
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