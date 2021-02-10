<?php  
    session_start();
    $_SESSION["formulario"] = null;
    //importa las librerias
    require_once("gestionBD.php");
    require_once("gestionarEncargos.php");
    require_once("consultarProductos.php");
    require_once("gestionarClientes.php");

    $conexion=crearConexionBD();
    $idref=($_GET["Id_enc"]);
    
    $lineaEncargo = consultarLineasEncargo($conexion,$idref);
     
    if (!isset($_SESSION["formulario"])) {
        $formulario["oid_le"]=$idref;
        $formulario["idEnc"]= $lineaEncargo[1];
        $formulario["cantidad"]=$lineaEncargo[3];
        $formulario["preciouni"]=$lineaEncargo[4];
        
        $_SESSION["formulario"]=$formulario;
    }
    
    if (isset($_SESSION["errores"])) {
        $errores=$_SESSION["errores"];
        unset($_SESSION["errores"]);
    }
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

<!--modificar action para que me lleve a accion_editar_encargos.php-->
<fieldset class="formulario" style="width:400px">
    <h2>Línea Número <?php echo $idref ?></h2>
    <p>
		<i>Los campos obligatorios están marcados con </i><em>*</em> <i>(asterisco)</i>
    </p>
    <p>
		<i>Los campos no editables están marcados con </i><em>º</em> <i>(ordinal)</i>
    </p>
<form id="editarEncargos" action="accion_editar_linea_encargo.php" method="get">
     
            <!-- la fecha de pedida siempre sera la actual -->
            <label for="oid_le">Linea<em>º</em></label>
            <input type="text" name="oid_le" value="<?php echo $idref?>" readonly required>
            
            <br>
            <label for="idEnc">ID Producto<em>º</em></label>
            <input type="text" name="idEnc" value="<?php echo $formulario['idEnc'];?>" readonly required>

            <br>
            <label for="cantidad" >Cantidad<em>*</em></label>
            <input type="number" name="cantidad" value="<?php echo $formulario['cantidad'];?>"required>

            <br>
            <label for="preciouni">Precio Unitario<em>*</em></label>
            <input type="text" name="preciouni" value="<?php echo $formulario['preciouni'];?>"required>   
            <br>
            

            <div><input class="button" type="submit" value="Editar"></div>
    </form>
    
    <form>
        <input type="hidden" name="oid_le" readonly value="<?php echo $idref;?>"/>
        <button class="button" type="submit" formaction="accion_eliminar_linea_encargo.php?oid_le=<?php echo $idref ?>">Eliminar Linea</button>
    </form>
    </fieldset>
    <?php 
        include_once("pie.php"); 
        cerrarConexionBD($conexion); 
    ?>
    </body>
</html>