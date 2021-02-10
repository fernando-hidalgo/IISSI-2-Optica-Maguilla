<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarProducto.php");
require_once("navBar.php");

if (isset($_SESSION["form_mostrar_prod"])) {
    $eliminarProducto = $_SESSION["form_mostrar_prod"];
    $_SESSION["form_mostrar_prod"] = null;
}
else 
    Header("Location: paginacion_productos.php");	

$conexion = crearConexionBD(); 
?>


<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>Resultado de eliminar el producto</title>
</head>
<body>
	<?php
		include_once("cabecera.php");
	?>

    <main>
		<?php if (eliminar_prod($conexion, $eliminarProducto)) {
			 ?>
			 <fieldset class="formulario" style="width:350px">
			 <?php
            echo "Producto ".$eliminarProducto["nombreproducto"]." borrado";
		?>
		<div >	
			Pulsa <a href="paginacion_productos.php">aquí</a> para volver a Inicio.
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