<?php  
    session_start();
    require_once("gestionBD.php");
    require_once("consultarProductos.php");
    require_once("gestionarClientes.php");
    $id=$_GET["Id_enc"];

    if (!isset($_SESSION["formulario"])) {
        //linea 
        $formulario["idEnc"]="";
        $formulario["cantidadProducto"]="";
        $formulario["producto"]="";
       
        $_SESSION["formulario"]=$formulario;
    }else 
        $formulario=$_SESSION["formulario"];
    if (isset($_SESSION["errores"])) {
        $errores=$_SESSION["errores"];
        unset($_SESSION["errores"]);
    }
    $conexion=crearConexionBD();

    require_once("navBar.php");
    include_once("cabecera.php"); 
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>Encargos</title>
</head>

<fieldset class="formulario" style="width:400px">
    <h2>Nueva Línea de Encargo</h2>
    <p>
		<i>Los campos obligatorios están marcados con </i><em>*</em> <i>(asterisco)</i>
    </p>
<form id="altaEncargos" action="accion_alta_linea_encargos.php" method="get">
            <label for="idEnc">ID Encargo</label>
            <input type="text"  name="idEnc" value="<?php echo $id?>" readonly>
            <br>

            <label for="producto">Producto<em>*</em></label>
                <select name="producto" id="producto" required>
                <?php 
                $producto=seleccionarProductos($conexion);
                
               
                foreach($producto as $p){
                    ?>
                        <option value="<?php  echo $p["IDREFERENCIAPRODUCTO"];?>"><?php  echo $p["NOMBRE"];?></option>
                <?php
                }
                ?>
                </select>
                <br>
                <label for="cantidadProducto">Cantidad<em>*</em></label>
                <input type="number" name ="cantidadProducto" value="<?php echo $formulario['cantidadProducto'];?>"min="1" required>
            </div>
            <div><input type="submit" value="Añadir Linea"></div>
        </fieldset>
            
    </form>
    <?php 
        include_once("pie.php"); 
        cerrarConexionBD($conexion); 
    ?>
    </body>
</html>