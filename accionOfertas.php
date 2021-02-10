<?php
    session_start();
    
    require_once("gestionBD.php");
    require_once("gestionarOfertas.php");
    require_once("gestionarFranquicias.php");
    require_once("gestionarProductos.php");
    require_once("gestionarClientes.php");
    require_once("gestionarLineasOferta.php");
    require_once("gestionarSeEnvianA.php");
    $conexion = crearConexionBD();
    $_SESSION["checkValidacion"] = "correct";
    $franquicias = todasFranquicias($conexion);
    $productos = todosProductos($conexion);
    $clientes = todosClientes($conexion);
    $oferta = $_SESSION["oferta"];
    $descripcion = descripcionOferta($conexion,$oferta);
    $productosLinea0 = lineasOferta($conexion,$oferta);
    $prueba = NULL;
    foreach($productosLinea0 as $productol0){
        $prueba = $productol0;
    }
    $seEnvianPDO = todoSeEnvianA($conexion,$oferta);

    $seEnvianNOID_C = array();
    foreach($seEnvianPDO as $seEnviaNOID_C){
       $seEnvianNOID_C[] = $seEnviaNOID_C["OID_C"];
    }
    cerrarConexionBD($conexion);
    if($_SESSION["errorForm"]=="true"){
        $productoError =  $_SESSION["errorFormGuardado"];
        $oferta = $productoError["NOMBREOFERTA"];
        $descripcion = $productoError["DESCRIPCION"];
        $prueba = $productoError;
    }
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="css/style.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <?php include "navBar.php"; ?>
    <br>
    <div class="formOferta">
    <form name="addOferta" id="addOferta" onsubmit="return validarForm()" action="validacionFormOferta.php" method="get">
            <br>
            <ul>
                <li>
                    <label for="franquicia">Franquicia<span style="color:#008dba">*</span></label> 
                </li>
                <li>
                    <select name="franquicia" id="franquicia">
                        <?php
                            foreach($franquicias as $franquicia){
                            ?>
                                <option value="<?php  echo $franquicia["NOMBREFRANQUICIA"];?>"><?php echo $franquicia["NOMBREFRANQUICIA"];?></option>
                        <?php
                            }
                        ?>
                    </select>
                </li>
                <li>
                    <label for="nombreOferta">Nombre de Oferta<span style="color:#008dba">*</span></label>
                </li>
                <li>
                    <input type="text" name= "nombreOferta" id ="nombreOferta" value="<?php echo $oferta?>" placeholder="Introduzca el nombre..." required <?php if($oferta != "") echo "readonly"; ?>><br>
                </li> 
                <li>
                    <label for="descripcion">Descripción<span style="color:#008dba">*</span></label>
                </li>  
                <li>
                    <textarea name= "descripcion" id = "descripcion0" type="text" rows="4" maxlength="100" placeholder="Hasta 100 caracteres"><?php if($descripcion != "error") echo $descripcion; ?></textarea>
                </li>
                <li>
                    <label for="productosDiv">Producto/s a añadir<span style="color:#008dba">*</span></label>
                </li>
                <div name="productosDiv">
                    <?php 
                        if(existeOferta($conexion,$oferta)){
                            
                            $idRefProd = [];
                            $nomProd = [];
                            foreach($productos as $producto){
                                array_push($idRefProd,$producto["IDREFERENCIAPRODUCTO"]);
                                array_push($nomProd,$producto["NOMBRE"]);
                            }
                            $tam = count($idRefProd);
                            $i = 0;
                            foreach(lineasOferta($conexion,$oferta) as $linea){
                    ?>  
                    <div id="<?php echo 'lineaOferta'.$i?>" name="<?php echo 'lineaOferta'.$i?>">
                        <label for="<?php echo 'producto'.$i?>">Producto<span style="color:#008dba">*</span></label>
                        <select name="<?php echo 'producto'.$i?>" id="<?php echo 'producto'.$i?>">
                        <?php
                            for($j=0;$j<$tam;$j++){
                                ?>
                                <option value='<?php echo $idRefProd[$j]?>' <?php if($idRefProd[$j] == $linea["IDREFERENCIAPRODUCTO"] ){ echo 'selected="selected"';}?>><?php echo $nomProd[$j]?></option>
                        <?php }
                        ?>
                        </select>
                        <label for="<?php echo 'descuento'.$i?>">Descuento<span style="color:#008dba">*</span></label>
                        <input name= "<?php echo 'descuento'.$i?>" id = "<?php echo 'descuento'.$i?>" type="text" placeholder="0,X" value='0<?php echo $linea["DESCUENTOOFERTA"] ?>'>
                    </div>  

                    <?php
                        $i++;
                            }
                        $_SESSION["lineasOfertaNum"] = $i;
                        }
                        else{
                            $_SESSION["lineasOfertaNum"] = 1;
                        ?>  
                        <div id="lineaOferta0" name="lineaOferta0">
                        <label for="producto0">Producto</label>
                        <select name="producto0" id="producto0">
                        <?php
                            foreach($productos as $producto){
                                ?>
                                <option value='<?php echo $producto["IDREFERENCIAPRODUCTO"]?>' <?php if($producto["IDREFERENCIAPRODUCTO"] == $prueba["IDREFERENCIAPRODUCTO"] ){ echo 'selected="selected"';}?>><?php echo $producto["NOMBRE"]?></option>
                        <?php }
                        ?>
                        </select>
                        <label for="descuento0">Descuento</label>
                        <input name= "descuento0" id = "descuento0" type="text" placeholder="0,X" value='0<?php echo $prueba["DESCUENTOOFERTA"] ?>'>
                    </div>  
                    <?php  
                        }
                    ?>                   
                </div>
                <div>   
                    <fieldset name="enviarA">
                        <legend for="enviarA">Enviar A</legend>
                        <?php
                            foreach($clientes as $cliente){
                                ?><input type='checkbox' name='enviarA[]' value='<?php echo $cliente["OID_C"]?>' <?php if(in_array($cliente["OID_C"],$seEnvianNOID_C)){echo"checked";} ?>> <?php echo $cliente["NOMBRE"]." ".$cliente["APELLIDO"]?><br>
                    <?php   }
                        
                        ?>
                    </fieldset>
                <button type="submit" class="button">Guardar</button>
            </ul>
            <br>
        </form>
    </div>
    <?php include_once("pie.php");?>
    <script> 
    function validarForm(){
            if(document.forms["addOferta"]["descripcion"].value.length > 100){
                alert("No puedes escribir mas de 100 caracteres en la descripcion");
                return false;
            }
            var descuento = "descuento"
            var i = "<?php echo $_SESSION["lineasOfertaNum"]?>";
            if(i!=""){
                var iParsed = parseInt(i);
                for(var j = 0; j<iParsed; j++){
                    var descuentoCheck = descuento+j;
                    if(!(/^0\,[0-9]+/.test(document.forms["addOferta"][descuentoCheck].value))){
                        alert("Debes escribir los decimales de la siguiente forma X,XX...");
                        return false;
                    }
                }
                return true;
            }else{
                if(!(/^0\,[0-9]+/.test(document.forms["addOferta"]["descuento0"].value))){
                    alert("Debes escribir los decimales de la siguiente forma X,XX...");
                    return false;
                }
                return true;
            }    
    }
</script>

</body>
</html>
