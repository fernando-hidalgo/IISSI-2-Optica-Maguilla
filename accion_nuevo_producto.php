<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarProducto.php");
require_once("navBar.php");

if (isset($_SESSION["tabla_producto"])) {
    $nuevoProducto['nombreproducto'] = $_REQUEST["nombreproducto"];
    $nuevoProducto['cantidad'] = $_REQUEST["cantidad"];
    $nuevoProducto['precio'] = $_REQUEST["precio"];
    $nuevoProducto['IVA'] = $_REQUEST["IVA"];

    $_SESSION["tabla_producto"] = null;
}
else 
    Header("Location: paginacion_productos.php");

$conexion = crearConexionBD(); 
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Resultado del registro del producto</title>
  <link rel="stylesheet" type="text/css" href="css/formulario.css">
</head>

<body>
    <?php
        include_once("cabecera.php");
    ?>

    <main>
    <fieldset class="formulario" style="width:350px">
        <?php if (Producto($conexion, $nuevoProducto)) {
            echo "producto registrado con éxito";
        ?>
        <div >
            Pulsa <a href="paginacion_productos.php">aquí</a> para volver a Inicio.
        </div>
        <?php } ?>
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