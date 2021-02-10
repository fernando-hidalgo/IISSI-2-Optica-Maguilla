<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarClientes.php");
require_once("navBar.php");

// Comprobar que hemos llegado a esta página porque se ha rellenado el formulario
if (isset($_SESSION["formulario_EC"])) {
    $bajaCliente = $_SESSION["formulario_EC"];
    $_SESSION["formulario_EC"] = null;
    $_SESSION["errores"] = null;
}
else 
    Header("Location: tabla_cliente.php");	

$conexion = crearConexionBD(); 

$cliente = consultarDatosCliente($conexion, $bajaCliente["dni"]);
$oid_c_baja=$cliente[0];
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>Resultado de la baja del cliente</title>
</head>
<body>
	<?php
		include_once("cabecera.php");
	?>

	<main>
		<?php if (baja_cliente($conexion, $oid_c_baja)) {
			//Eliminar fotos de la BD
			$cara = "images/cara/" . $bajaCliente["dni"] . ".png";
			$firma = "images/firma/" . $bajaCliente["dni"] . ".png";
			if (file_exists($cara)) { //File_exist evita el error que saltaría si la foto no existiese y se intentase borrar
				unlink($cara);
			}
			if (file_exists($firma)) {
				unlink($firma);
			}
			?>
			<fieldset class="formulario" style="width:350px">
			<?php
            echo "Cliente ".$bajaCliente["nombre"].", con DNI ".$bajaCliente["dni"]." eliminado";
		?>
		<div >	
			Pulsa <a href="paginacion_clientes.php">aquí</a> para volver a Inicio.
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