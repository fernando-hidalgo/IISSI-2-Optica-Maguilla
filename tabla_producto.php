<?php
  session_start();
    require_once("gestionBD.php");
  if(!isset($_SESSION["tabla_producto"])){
    $tabla_producto["nombreproducto"]="";
    $tabla_producto["cantidad"]="";
    $tabla_producto["precio"]="";
    $tabla_producto["IVA"]="";
    $tabla_producto["PrecioIVA"]="";
    $_SESSION["tabla_producto"]=$tabla_producto;
  }
  else
    $tabla_producto=$_SESSION["tabla_producto"];
  if(isset($_SESSION["errores"])){
    $errores=$_SESSION["errores"];
    unset($_SESSION["errores"]);
  }
  $conexion=crearConexionBD();
?>


<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>Formulario nuevo producto</title>
</head>
<body>
<?php require_once("navBar.php");
  include_once("cabecera.php"); ?>
<fieldset class="formulario" style="width:450px">
<h2>Formulario de Registro - Nuevo Producto</h2>
    <p>
		<i>Los campos obligatorios están marcados con </i><em>*</em> <i>(asterisco)</i>
    </p>
<form action="accion_nuevo_producto.php" method="get">
  <label for="nombreproducto">Nombre del producto:<em>*</em></label>
  <input id="nombreproducto" name="nombreproducto" type="text" value="<?php echo $tabla_producto['nombreproducto'];?>"required>
  <br>
  <label for="cantidad">Cantidad<em>*</em></label>
  <input id="cantidad" name="cantidad" type="text" value="<?php echo $tabla_producto['cantidad'];?>" pattern="^[0-9]+" placeholder="x" required>
  <br>
  <label for="precio">Precio<em>*</em></label>
  <input id="precio" name="precio" type="text" value="<?php echo $tabla_producto['precio'];?>" pattern="^[0-9]+,[0-9]+" placeholder="x,xx" required>
  <br>
  <label for="IVA">IVA<em>*</em></label>
  <input id="IVA" name="IVA" type="text" value="<?php echo $tabla_producto['IVA'];?>" pattern="^[0]+,[0-9]+" placeholder="0,xx" required>
  <br>
  <p>
    <input type="submit" value="Guardar">
  </p>
</form>
</fieldset>

<?php
    include_once("pie.php"); 
		cerrarConexionBD($conexion);
?>
</body>
</html>
