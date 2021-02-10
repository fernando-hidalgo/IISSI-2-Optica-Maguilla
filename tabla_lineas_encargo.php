<?php
session_start();
require_once ("gestionBD.php");
require_once("gestionarEncargos.php");
require_once("navBar.php");


$conexion = crearConexionBD();
$id=($_GET["Id_enc"]);
$encargo=consultarDatosEncargo($conexion,$id);
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/styleEncargos.css"> 
    <title>Encargos</title>
</head>
<body>
    <form action="form_mostrar_linea_encargo.php" method="GET">
    <div>
    <fieldset class="formulario">
            <legend> Lineas de Encargo</legend>
            <!-- este if hace que si el encargo ya esté entregado, no se pueda modificar -->
            <?php  if($encargo[3]==""){  ?>
            <input id="add" type="button" value="+" class="right" onclick="window.location.href = 'formulario_linea_encargos.php?Id_enc=<?php echo $id ?>'">
            <?php }?>
            <table class="fixed_header" id="tabla">
                <thead> 
                    <tr>
                        <th>ID</th>
                        <th>ID producto</th>
                        <th>cantidad</th>
                        <th>precio unitario</th>
                        <th>precio total</th>
                        
                    </tr>
                </thead>
                <tbody>
                    <?php
                                                                                                                                                                     

                    $sql = "SELECT * FROM LINEASENCARGO WHERE IDREFERENCIAENCARGO = '$id'";
                    $resultado = $conexion->query($sql);
                    foreach($resultado as $row)
                    {                 
                    
                    ?>
                    <tr>
                        <th><?php echo $row[0]?></th>
                        <th><?php echo $row["IDREFERENCIAPRODUCTO"]; ?></th>
                        <th><?php echo $row["CANTIDAD"]; ?></th>
                        <th><?php echo $row["PRECIOUNITARIO"]; ?></th>
                        <th><?php echo $row["PRECIOTOTAL"]; ?></th>
                        <th>
                           <button class="button" type="submit" name=Id_enc value="<?php echo $row[0]?>">Mostrar</button>
                     
                        </th>
                    </tr>
                    <?php
                    }  
                    ?>
                </tbody> 
            </table> 
        </fieldset>
    </div>
    </form>
    <?php	
    include_once("pie.php");
    cerrarConexionBD($conexion);
    ?>
<body> 
</html>
