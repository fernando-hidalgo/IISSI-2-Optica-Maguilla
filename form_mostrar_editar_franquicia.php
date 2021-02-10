<?php
session_start();
require_once ("gestionBD.php");
require_once("gestionarFranquicias.php");
require_once("gestionarClientes.php");
$conexion = crearConexionBD();
$franq_click = ($_GET["btn_franq"]);
$franquicia = consultarDatosFranquicia($conexion, $franq_click);
require_once("navBar.php");

if (!isset($_SESSION["formulario_MODF"])) {
    $formulario_MODF['nombre'] = $franquicia[0];
    $formulario_MODF['propietario'] = $franquicia[2];
    $formulario_MODF['direccion'] = $franquicia[1];

    $_SESSION["formulario_MODF"] = $formulario_MODF;
    }
    // Si ya existían valores, los cogemos para inicializar el formulario
    else
    $formulario_MODF = $_SESSION["formulario_MODF"];

    $conexion = crearConexionBD();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/formulario_franq.css">
    <title>Perfil de Franquicia</title>
</head>
<body>
    <?php	
	    include_once("cabecera.php"); 
    ?>
    <fieldset class="formulario">
    <h2><?php echo "Perfil de la franquicia ". $franquicia[0] ?></h2>
    <p>
		<i>Los campos obligatorios están marcados con </i><em>*</em> <i>(asterisco)</i>
    </p>

    
    <form id="Formulario_modf"action="accion_editar_franquicia.php" method="GET">
        <label for="nombre">Nombre<em>*</em></label>
        <input id="nombre" name="nombre" type="text" value="<?php echo $formulario_MODF['nombre'];?>" readonly required>
        <br>
    
        <label for="propietario">Propietario</label>
        <input id="propietario" name="propietario" type="text" value="<?php echo $formulario_MODF['propietario'];?>" readonly required>
        <br>

        <label for="direccion">Direccion</label>
        <input id="direccion" name="direccion" type="text" value="<?php echo $formulario_MODF['direccion'];?>" readonly required>
        <br>
        
        <input id="botonGuardar" type="submit" value="Guardar Franquicia" disabled/>
    </form>
    <input class="button" id="botonEditar" type="button" value="Editar" />
    <button class="button" onclick="eliminar()">Eliminar</button>
    </fieldset>
    
    <?php	
        include_once("pie.php"); 
    ?>

    <script>
        document.getElementById('botonEditar').onclick = function() {
            document.getElementById('botonGuardar').removeAttribute('disabled');
            //document.getElementById('nombre').removeAttribute('readonly');
            document.getElementById('propietario').removeAttribute('readonly');
            document.getElementById('direccion').removeAttribute('readonly');
            };
    </script>

    <script>
        function eliminar() {
            var confirma = window.confirm("¿Está seguro de querer eliminar la franquicia? Se perderán todos sus datos, así como sus adscripciones y ofertas presentadas");
            if (confirma) {
                window.location.href = "accion_eliminar_franquicia.php";
            }
        }
    </script>
    <?php
		cerrarConexionBD($conexion);
	?>
</body>
</html>