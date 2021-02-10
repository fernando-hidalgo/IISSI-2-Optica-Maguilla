<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" type="text/css" href="css/paginacion.css">
  <title>Productos</title>
</head>
<body>
<?php
session_start();
// connect to database
require_once ("gestionBD.php");
$conexion = crearConexionBD();
$_SESSION["formulario_EC"] = null; //Sin esto, si se consulta un cliente, se vuelve a Inicio, y se consulta otro distinto, se mostrarían los datos del primero
$_SESSION["formulario_NC"] = null; //Sin esto, si se intenta crear un cliente, pero se vuelve a Inicio, se resetee todo
$_SESSION["formulario_GRAD"] = null; //Inicio desde Gradauciones
$_SESSION["formulario_REGF"] = null; //Inicio desde Form Nueva Franquicia
$_SESSION["formulario_MODF"] = null; //Inicio desde Modf Franquicia
$_SESSION["form_mostrar_prod"] = null;
$_SESSION["tabla_producto"] = null;

$_SESSION["ventana"] = "productos";
require_once("navBar.php");

include_once("cabecera.php"); 
// define how many results you want per page
if (!isset($_GET['tam_pag'])) {
  $results_per_page = 4;
} else {
  $results_per_page = $_GET['tam_pag'];
}

// find out the number of results stored in database
$res = $conexion->query("select idreferenciaproducto, nombre,cantidad,precio,iva,precioiva from productos");
$contendor = array(); 
$number_of_results = 0;
foreach($res as $row) {
  array_push($contendor, $row);
  $number_of_results++;
}

// determine number of total pages available
$number_of_pages = ceil($number_of_results/$results_per_page);

// determine which page number visitor is currently on
if (!isset($_GET['page'])) { 
  $page = 0;
  $_SESSION["productoPagina"] = 0;
} else {
  $page = $_GET['page'];
  $_SESSION["productoPagina"] = $page;
}
?>
<fieldset class="formulario" style="width:450px">
<form action="paginacion_productos.php" method="GET">
<input type="number" id="tam_pag" name="tam_pag" min="1" max="10" value="<?php echo $results_per_page?>">
<button class="button" name="boton" type="submit">Establecer Nº paginas</button>
<input class="button" type="button" value="Nuevo Producto" class="right" onclick="window.location.href = 'tabla_producto.php'">
</form>

<?php
// determine the starting number for the results on the displaying page
$this_page_first_result = ($page-1)*$results_per_page;

// retrieve selected results from database and display them on page
$trozo = array_chunk($contendor,$results_per_page);
if(count($trozo)!=0){

foreach($trozo[$page] as $row){
  ?>
  <fieldset style="width:350px">
  <legend>Nombre-Cantidad-Precio-IVA-Precio IVA</legend>
  <form action="form_mostrar_editar_producto.php" method="GET">
  <?php echo $row[1] . "  ". $row[2].".uds" . "  ". $row[3]."€" . "  ". $row[4]."%" . "  ". $row[5]."€";?>
  <button class="button" name="Id_prod" value="<?php echo $row[0]?>" type="submit">Mostrar</button>
  </form>
  </fieldset>
<?php
  }
}
?>
<?php
// display the links to the pages
for ($page=0;$page<$number_of_pages;$page++) {
  if($page == $_SESSION["productoPagina"]){
    echo '<a class = "linkPaginacionActive" href="paginacion_productos.php?page=' . $page . '&tam_pag=' . $results_per_page  .'">' . $page . '</a> ';
  }else{
    echo '<a class = "linkPaginacion" href="paginacion_productos.php?page=' . $page . '&tam_pag=' . $results_per_page  .'">' . $page . '</a> ';
  }
  
}
?>
</fieldset>
<?php
include_once("pie.php");
?>
</body>
</html>

