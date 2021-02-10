<?php  
    session_start();
    $_SESSION["formulario"] = null;
    require_once("gestionBD.php");
    require_once("gestionarEncargos.php");
    require_once("consultarProductos.php");
    require_once("gestionarClientes.php");
    
    require_once("navBar.php");
    require_once("cabecera.php");
    $conexion=crearConexionBD();
    $idref=($_GET["Id_enc"]);
    $encargo=consultarDatosEncargo($conexion,$idref);

    if (!isset($_SESSION["formulario"])) {
       
        $formulario["id"]=$idref;
        $formulario["fechaPedida"]= $encargo[2];
        $formulario["fechaEntrega"]=$encargo[3];
        $formulario["descripcion"]=$encargo[4];
        $formulario["clientes"]=$encargo[1];
       
        $_SESSION["formulario"]=$formulario;
    }
    
    if (isset($_SESSION["errores"])) {
        $errores=$_SESSION["errores"];
        unset($_SESSION["errores"]);
    }
   
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
<fieldset class="formulario" style="width:400px">
    <h2>Encargo numero <?php echo $idref ?></h2>
    <p>
		<i>Los campos no editables están marcados con </i><em>º</em> <i>(ordinal)</i>
    </p>
    <form id="altaEncargos" action="accion_editar_encargo.php" method="get">    
            <!-- la fecha de pedida siempre sera la actual -->
            <label for="FechaPedida">Fecha de Pedida<em>º</em></label>
            <input type="text" name="FechaPedida" readonly value="<?php echo $formulario["fechaPedida"];?>"/>
            
            <br>
            <label for="fechaEntrega">Fecha Entrega<em>º</em></label>
            <input type="text" name="fechaEntrega" readonly placeholder="No fijada" value="<?php echo $formulario['fechaEntrega'];?>"/>

            <br>
            <label for="descripcion" >Descripción<em>º</em></label>
            <textarea rows="4" cols="50" name="descripcion" readonly><?php echo $formulario['descripcion'];?></textarea>

            <br>
            <?php 
                $clientes=SeleccionarDNIClientes($conexion,$formulario["clientes"]);
            ?> 
            <label for="nombre de Cliente">DNI del Cliente<em>º</em></label>
            <input readonly type="text" name="clientes" value="<?php echo $clientes[0];?>">
            <br>
            
            <br>
            <div><input class="button" type="submit" value="Guardar"></div>
            <br>
    </form>
    
            <form>
                <input type="hidden" name="Id_enc" readonly value="<?php echo $idref;?>"/>
                <button class="button" type="submit" formaction="tabla_lineas_encargo.php?Id_enc=<?php echo $idref ?>">Lineas de Encargo</button>
            </form>
            <?php  if($formulario["fechaEntrega"]==""){  ?>
                <form>
                    <input type="hidden" name="Id_enc" readonly value="<?php echo $idref;?>"/>
                     <button class="button" type="submit" formaction="accion_anadir_fecha_entrega.php?Id_enc=<?php echo $idref ?>">Fijar Fecha Entrega</button>
                </form>
            <?php }?>

            <form>
                <input type="hidden" name="Id_enc" readonly value="<?php echo $idref;?>"/>
                <button class="button" type="submit" formaction="accion_eliminar_encargo.php?Id_enc=<?php echo $idref ?>">Eliminar Encargo</button>
            </form>
</fieldset>
   
    
    <?php
        require_once("pie.php");
        cerrarConexionBD($conexion); 
    ?>
</body>
</html>