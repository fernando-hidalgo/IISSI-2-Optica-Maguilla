<?php
    session_start();
    require_once("gestionBD.php");
    require_once("gestionarEncargos.php");
    require_once("navBar.php");
    require_once("cabecera.php");  
    
    if(isset($_SESSION["formulario"])){
        $nuevaLinea["idEnc"]=$_REQUEST["idEnc"];
        $nuevaLinea["producto"]=$_REQUEST["producto"];
        $nuevaLinea["cantidadProducto"]=$_REQUEST["cantidadProducto"];
       
        $_SESSION["formulario"]=$nuevaLinea;
    
    }else
        Header("Location: paginacion_encargos.php");

    $conexion=crearConexionBD();
?>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>Alta de Encargos</title>
</head>
<body>

   <main>
   <fieldset class="formulario" style="width:350px">
   <?php if (añadirLineaEncargo($conexion,$nuevaLinea["producto"],$nuevaLinea["cantidadProducto"],$nuevaLinea["idEnc"]))  {  
       echo "La linea se ha añadido con éxito al encargo ".  $nuevaLinea["idEnc"];
       ?>
               <div >	
                      Pulsa <a href="paginacion_encargos.php">aquí</a> para acceder al inicio.
               </div>
       <?php } else { 
            echo "Ha habido un error";
           ?>
               <div >	
                   Pulsa <a href="formulario_encargos.php">aquí</a> para volver al formulario o <a href="paginacion_encargos.php">aqui</a>
                   para volver al inicio.
               </div>
       <?php } ?>
    </fieldset>
   </main>  
</body>
</html>
<?php 
    cerrarConexionBD($conexion); 
?>