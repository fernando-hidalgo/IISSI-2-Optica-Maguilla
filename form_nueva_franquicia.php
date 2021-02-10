<?php
session_start();
require_once ("gestionBD.php");
require_once("navBar.php");
include_once("cabecera.php");

if (!isset($_SESSION["formulario_REGF"])) {
    $formulario_REGF['nombre'] = "";
    $formulario_REGF['propietario'] = "";
    $formulario_REGF['direccion'] = "";

    $_SESSION["formulario_REGF"] = $formulario_REGF;
    }
    // Si ya existían valores, los cogemos para inicializar el formulario
    else
    $formulario_REGF = $_SESSION["formulario_REGF"];
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/formulario_franq.css">
    <title>Formulario Nueva Franquicia</title>
</head>
<body>
    <fieldset class="formulario">
    <h2>Formulario de Registro - Nueva Franquicia</h2>
    <p>
		<i>Los campos obligatorios están marcados con </i><em>*</em> <i>(asterisco)</i>
    </p>
    
    <form id="Formulario_regf"action="accion_nueva_franquicia.php" method="GET">
        <label for="nombre">Nombre<em>*</em></label>
        <input id="nombre" name="nombre" type="text" value="<?php echo $formulario_REGF['nombre'];?>" required>
        <br>
    
        <label for="propietario">Propietario</label>
        <input id="propietario" name="propietario" type="text" value="<?php echo $formulario_REGF['propietario'];?>">
        <br>

        <label for="direccion">Direccion<em>*</em></label>
        <input id="direccion" name="direccion" type="text" value="<?php echo $formulario_REGF['direccion'];?>" required>
        <br>

        <input type="submit" value="Guardar Franquicia" />
    </form>
    </fieldset>
    
    <?php	
	    include_once("pie.php"); 
    ?>
</body>
</html>