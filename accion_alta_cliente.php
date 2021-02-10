<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarClientes.php");
require_once("navBar.php");

// Comprobar que hemos llegado a esta página porque se ha rellenado el formulario
if (isset($_SESSION["formulario_NC"])) {
    $nuevoCliente = $_SESSION["formulario_NC"];
    $_SESSION["formulario_NC"] = null;
    $_SESSION["errores"] = null;
}
else 
    Header("Location: form_nuevo_cliente.php");	

$conexion = crearConexionBD(); 
?>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Resultado de el formulario de registro</title>
  <link rel="stylesheet" type="text/css" href="css/formulario.css">
</head>

<body>
	<?php
		include_once("cabecera.php");
	?>

	<main>
		<?php if (alta_cliente($conexion, $nuevoCliente)) {
				?>
				<fieldset class="formulario" style="width:350px">
				<?php
				echo "Cliente ".$nuevoCliente["nombre"].", con DNI ".$nuevoCliente["dni"]." registrado";
				?>
				<div>
			   		Pulsa <a href="<?php echo "form_mostrar_editar_cliente.php?btn_dni=".$nuevoCliente["dni"]?>">aquí</a> para ir al perfil.
				</div>

				</fieldset>
		<?php } else { ?>
				<fieldset class="formulario">
				<div>	
				    El cliente ya existe en la base de datos.
					Pulsa <a href="form_nuevo_cliente.php">aquí</a> para volver al formulario de registro de cliente.
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