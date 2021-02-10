<?php
    session_start();
    require_once("gestionBD.php");
    require_once("gestionarProducto.php");
    require_once("navBar.php"); 
    include_once("cabecera.php");
    $conexion=crearConexionBD();
    
    $id_sel = ($_GET["Id_prod"]);
    $productoSel = consultarDatosProducto($conexion,$id_sel);

  if(!isset($_SESSION["form_mostrar_prod"])){
    $form_mostrar_prod["ID"]=$id_sel;
    $form_mostrar_prod["nombreproducto"]=$productoSel[1];
    $form_mostrar_prod["cantidad"]=$productoSel["CANTIDAD"];
    $form_mostrar_prod["precio"]=$productoSel["PRECIO"];
    $form_mostrar_prod["IVA"]=$productoSel["IVA"];
    $form_mostrar_prod["PrecioIVA"]=$productoSel["PRECIOIVA"];
    $form_mostrar_prod["descuento"]=$productoSel["DESCUENTO"];
    $_SESSION["form_mostrar_prod"]=$form_mostrar_prod;
  }
  else
    $form_mostrar_prod=$_SESSION["form_mostrar_prod"];
  if(isset($_SESSION["errores"])){
    $errores=$_SESSION["errores"];
    unset($_SESSION["errores"]);
  }
  $_SESSION["ventana"] = "productos";
?>


<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>Detalles del producto</title>
</head>
<body>

<fieldset class="formulario" style="width:400px">
<h2><?php echo "Detalles del producto ". $form_mostrar_prod["nombreproducto"] ?></h2>
<p>
	<i>Los campos obligatorios están marcados con </i><em>*</em> <i>(asterisco)</i>
</p>

<form action="accion_editar_prod.php" method="get">
  <input type="hidden" id="id_prod" name="id_prod" value="<?php echo $id_sel?>">

  <label for="nombreproducto">Nombre del producto:<em>*</em></label>
  <input id="nombreproducto" name="nombreproducto" type="text" value="<?php echo $form_mostrar_prod['nombreproducto'];?>"required readonly>
  <br>
  <label for="cantidad">Cantidad<em>*</em></label>
  <input id="cantidad" name="cantidad" type="text" value="<?php echo $form_mostrar_prod['cantidad'];?>" required readonly>
  <br>
  <label for="precio">Precio<em>*</em></label>
  <input id="precio" name="precio" type="text" value="<?php echo $form_mostrar_prod['precio'];?>"pattern="^[0-9]+,[0-9]+" required readonly>
  <br>
  <label for="IVA">IVA<em>*</em></label>
  <input id="IVA" name="IVA" type="text" value="<?php echo "0". $form_mostrar_prod['IVA'];?>"pattern="^[0]+,[0-9]+" placeholder="0,xx" required readonly>
  <br>
  
  <input id="botonGuardar" type="submit" value="Guardar" disabled/>
  </form>
  <input class="button" id="botonEditar" type="button" value="Editar" />
  <button class="button" onclick="eliminar()">Eliminar</button>
  </fieldset>

<script>
  document.getElementById('botonEditar').onclick = function() {
    document.getElementById('botonGuardar').removeAttribute('disabled');
    document.getElementById('nombreproducto').removeAttribute('readonly');
    document.getElementById('cantidad').removeAttribute('readonly');
    document.getElementById('precio').removeAttribute('readonly');
    document.getElementById('IVA').removeAttribute('readonly');
    };
</script>

<script>
  function eliminar() {
    var confirma = window.confirm("¿Está seguro de eliminar el producto? La accion es permanente");
    if (confirma) {
       window.location.href = "accion_eliminar_prod.php";
       }
  }
</script>

<?php
    include_once("pie.php"); 
		cerrarConexionBD($conexion);
?>

</body>
</html>
