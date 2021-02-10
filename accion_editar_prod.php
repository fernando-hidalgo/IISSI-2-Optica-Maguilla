<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarProducto.php");
require_once("navBar.php");

// Comprobar que hemos llegado a esta página porque se ha rellenado el formulario
if (isset($_SESSION["form_mostrar_prod"])) {
    $editProducto['nombreproducto'] = $_REQUEST["nombreproducto"];
    $editProducto['cantidad'] = $_REQUEST["cantidad"];
    $editProducto['precio'] = $_REQUEST["precio"];
    $editProducto['IVA'] = $_REQUEST["IVA"];
    $editProducto['id_prod'] = $_REQUEST["id_prod"];

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
    <title>Resultado de la edición del producto</title>
</head>
<body>
	<?php
		include_once("cabecera.php");
	?>
	<main>
        <fieldset class="formulario" style="width:350px">
        <?php if (edicion_Producto($conexion, $editProducto)) {
            echo "Producto editado con exito";
         }
         ?>	
         	<div >	
			Pulsa <a href="paginacion_productos.php">aquí</a> para volver a Inicio.
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