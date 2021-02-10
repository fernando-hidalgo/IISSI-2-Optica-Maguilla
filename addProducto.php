<?php
    session_start();    
    require_once("gestionBD.php");
    require_once("gestionarOfertas.php");
    require_once("gestionarProductos.php");
    require_once("gestionarLineasOferta.php");
    $conexion = crearConexionBD();
    $oferta = $_SESSION["oferta"];
    $productos = todosProductos($conexion);
    $idRefProd = [];
    $nomProd = [];
    foreach($productos as $producto){
        array_push($idRefProd,$producto["IDREFERENCIAPRODUCTO"]);
        array_push($nomProd,$producto["NOMBRE"]);
    }
    $tam = count($idRefProd);

    cerrarConexionBD($conexion);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <title>Optica Maguilla</title>
</head>
<body>
    <?php require_once("navBar.php") ?>
    <br>
    <div class="formOferta">
        <form action="validacionLineaOferta.php" onsubmit="return validarAdd()" method="get">
            <br>
            <p>Selecciona la casilla del producto que quieras añadir</p>
            <ul>
            <?php
                for($i=0; $i<5; $i++){
                    ?>
                <div id="lineaOferta<?php echo $i; ?>" name="lineaOferta<?php echo $i; ?>">
                    <label for="producto<?php echo $i; ?>">Producto</label>
                    <select name="producto<?php echo $i; ?>" id="producto<?php echo $i; ?>">
                    <?php
                        for($j=0;$j<$tam;$j++){
                            ?>
                            <option value='<?php echo $idRefProd[$j]?>'><?php echo $nomProd[$j]?></option>
                        <?php }
                    
                    ?>
                    </select>
                    <label for="descuento<?php echo $i; ?>">Descuento</label>
                    <input name= "descuento<?php echo $i; ?>" id = "descuento<?php echo $i; ?>" type="text" placeholder="0,X" value='0'>
                    <input type="checkbox" id='<?php echo "checkbox".$i ?>' name="check[]" value="<?php echo $i; ?>">
                </div>
                <?php
                }
            ?>

            <button class="button" type="submit">Enviar</button>
            </ul>
        </form>
    <br>
    </div>
    <?php include_once("pie.php");?>
    <script>
    function validarAdd(){
        var descuento = "descuento";
        var i = 5;

        const checkboxes = document.querySelectorAll('input[name="check[]"]:checked');
        let values = [];
        checkboxes.forEach((checkbox) => {
            values.push(checkbox.value);
        });
        
        for(number in values){
            var nombre = "descuento" + number;
            if(!(/^0\,[0-9]+/.test(document.getElementById("nombre").value))){
                alert("Debes escribir los decimales de la siguiente forma X,XX...");
                return false;
            }
        }
        return true;        
    }
    </script>
</body>
</html>