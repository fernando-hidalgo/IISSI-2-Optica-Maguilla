<?php  
    session_start();
    require_once("gestionBD.php");
    require_once("consultarProductos.php");
    require_once("gestionarClientes.php");
    //require_once("navBar.php");

    if (!isset($_SESSION["formulario"])) {
        $formulario["fechaPedida"]="";
        $formulario["descripcion"]="";
        $formulario["clientes"]="";
        //linea 1
        $formulario["cantidadProducto1"]="";
        $formulario["producto1"]="";
       
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
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>Encargos</title>
</head>
<body>
    <?php 
    if (isset($errores)&&count($errores)>0) {
        echo "<div id=\"div_errores\" class=\"error\">";
        echo "<h4> Errores en el formulario:</h4>";
        foreach($errores as $error){
            echo $error;
        } 
        echo "</div>";
    }
    ?>

    <fieldset class="formulario" style="width:550px">
    <h2>Formulario de Registro - Nuevo Encargo</h2>
    <p>
		<i>Los campos obligatorios están marcados con </i><em>*</em> <i>(asterisco)</i>
    </p>

    <form id="altaEncargos" action="validacion_alta_encargos.php" method="get">
            <!-- la fecha de pedida siempre sera la actual -->
            <label for="fechaPedida">Fecha Pedida<em>*</em></label>
            <?php
            $fechaPedida = date("j/n/Y");
            ?>
            <input type="text" name="fechaPedida" value="<?php echo $fechaPedida?>" readonly>

            <br>
            <label for="descripcion" >Descripción<em>*</em></label>
            <textarea rows="4" cols="50" name="descripcion"><?php echo $formulario['descripcion'];?></textarea>
            <br>

            <label for="nombre de Cliente">DNI del Cliente<em>*</em></label>
                <select name="clientes" id="clientes">
                <?php 
                $clientes=SeleccionarOIDClientes($conexion);
                foreach($clientes as $c){
                    ?>
                    <option value="<?php  echo $c["OID_C"];?>"><?php  echo $c["DNI"];?></option>
                <?php
                }    
                ?>
                </select>
            </br>
            <fieldset>
            <legend>Linea 1</legend>
                <label for="producto1">Producto<em>*</em></label>
                <select name="producto1" id="producto1" >
                <br>

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
                <label for="cantidadProducto1">Cantidad de productos<em>*</em></label>
                <input type="number" name ="cantidadProducto1" value="<?php echo $formulario['cantidadProducto1'];?>" min="1">
            </fieldset>

            <div><input type="submit" value="Guardar Encargo"></div>
    </form>
    </fieldset>
    <?php
        include_once("pie.php"); 
        cerrarConexionBD($conexion); 
    ?>
    </body>
</html>