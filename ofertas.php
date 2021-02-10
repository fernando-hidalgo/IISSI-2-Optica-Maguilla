
<?php
    session_start();
    require_once("gestionBD.php");
    require_once("gestionarOfertas.php");
    $conexion = crearConexionBD();
    $ofertas = todasOfertas($conexion);   
    $_SESSION["ventana"] = "ofertas";
    if(!isset($_SESSION["oferta"])){
        $_SESSION["oferta"] = "";
    }
    $_SESSION["errorForm"] = "false";
?>
<!DOCTYPE html>
<html lang="es">
    <head>
        <link rel="stylesheet" href="css/style.css">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Optica</title>
    </head>
    <body>
        <?php require_once("navBar.php");?>
        <div>
            <fieldset id="field" name="field">
                <button id="add" type="button" name="add" onclick="window.location.href='validacionOfertas.php'">+</button>
                <form action="validacionOfertas.php" method="get">
                    <div id= tablecont>
                    <table class="fixed_header">
                        <thead>
                                <tr>
                                    <th>Nombre</th>
                                </tr>
                            </thead>
                            <tbody>
                            <?php
                                $i=0;
                                foreach($ofertas as $oferta){
                                    $idname = "tr".$i;
                                    ?>  
                                    <tr>
                                        <td class="linea" style="background-color:#333333">
                                            <input type="submit" class="tableRow" value="<?php echo $oferta["NOMBREOFERTA"]; ?>" id="<?php echo $idname; ?>" name="ofertaSeleccionada" >
                                        </td>
                                        <td style="background-color:#333333">
                                            <button class="button" id="eliminar" type="submit" onclick="return check()" value="<?php echo $oferta["NOMBREOFERTA"]; ?>" name="eliminar">Eliminar</button>
                                        </td>
                                        <td style="background-color:#333333">
                                            <button class="button" id="añadirProductos" type="submit" value="<?php echo $oferta["NOMBREOFERTA"]; ?>" name="añadirProductos">Añadir Productos</button>
                                        </td>
                                    </tr>
                                    
                                    <?php 
                                    $i = $i+1;
                                }            
                                ?>
                            </tbody>
                        </table>
                    </div>
                </form>
            </fieldset>
        </div> 
        <script>
            function check(){
                var foo = confirm("¿Seguro que quieres eliminar la oferta?");
                if(foo == true){
                    return true;
                }else{
                    return false;
               }
            }
        </script>
    </body>
    <?php include_once("pie.php") ?>
</html>
