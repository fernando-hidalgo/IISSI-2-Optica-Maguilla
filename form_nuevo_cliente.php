<?php
session_start();
require_once ("gestionBD.php");
require_once("navBar.php");

//El objetivo de este bloque de codigo es que si un apartado falla al validar, los que hayan salido bien se muestren
//Si no existen datos del formulario en la sesión, se crea una entrada con valores por defecto
if (!isset($_SESSION["formulario_NC"])) {
    $formulario_NC['nombre'] = "";
    $formulario_NC['apellidos'] = "";
    $formulario_NC['codpost'] = "";
    $formulario_NC['direccion'] = "";
    $formulario_NC['sexo'] = "";
    $formulario_NC['profesion'] = "";
    $formulario_NC['telefono'] = "";
    $formulario_NC['dni'] = "";
    $formulario_NC['email'] = "";
    $formulario_NC['fechnaz'] = ""; 
    $formulario_NC['razonvenida'] = "";
    $formulario_NC['franquicia'] = "";

    $_SESSION["formulario_NC"] = $formulario_NC;
    }
    // Si ya existían valores, los cogemos para inicializar el formulario
    else
    $formulario_NC = $_SESSION["formulario_NC"];

    // Si hay errores de validación, se introducen en una variable
	if (isset($_SESSION["errores"])){
		$errores = $_SESSION["errores"];
		unset($_SESSION["errores"]);
	}

    $conexion = crearConexionBD();
    $select = $conexion->query("select codpostal from codigospostales");
    $contendor = array();
    foreach($select as $row) {
        array_push($contendor, $row[0]);
    }
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/formulario.css">
    <script src = "https://code.jquery.com/jquery-1.10.2.js"></script>
    <script src = "https://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
    <title>Formulario nuevo cliente</title>

    <script>
         $(function() {
            var js_array =<?php echo json_encode($contendor )?>;
            $( "#codpost" ).autocomplete({
               minLength:1,   
               delay:200,   
               source: js_array
            });
         });
    </script>

</head>
<body>
    
    <?php	
	    include_once("cabecera.php"); 
    ?>
    
    <?php 
		//Se usa la variable para mostrar los errores de validación (Si los hay)
		if (isset($errores) && count($errores)>0) { 
	    	echo "<div id=\"div_errores\" class=\"error\">";
			echo "<h4> Errores en el formulario:</h4>";
    		foreach($errores as $error){
    			echo $error;
			} 
    		echo "</div>";
  		}
	?>

    <fieldset class="formulario" style="width:750px">
    <h2>Formulario de Registro - Nuevo Cliente</h2>
    <p>
		<i>Los campos obligatorios están marcados con </i><em>*</em> <i>(asterisco)</i>
    </p>
    
    <form method="POST" id="formulario_NC" novalidate action="validacion_alta_cliente.php"  enctype="multipart/form-data"> <!--nonvalidate-->
        <label for="nombre">Nombre<em>*</em></label>
        <input id="nombre" name="nombre" type="text" value="<?php echo $formulario_NC['nombre'];?>" required>
        <br>
        
        <label for="apellidos">Apellidos<em>*</em></label>
        <input id="apellidos" name="apellidos" type="text" value="<?php echo $formulario_NC['apellidos'];?>" required>
        <br>

        <label for="codpost">Código Postal<em>*</em></label>
        <input id="codpost" name="codpost" type="text" placeholder="12345" pattern="^[0-9]{5}" value="<?php echo $formulario_NC['codpost'];?>"  required>
        <br>
        
        <label for="direccion">Dirección</label>
        <input id="direccion" name="direccion" type="text" value="<?php echo $formulario_NC['direccion'];?>">
        <br>

        <label>Sexo<em>*</em></label>
		<label>
			<input name="sexo" type="radio" value="Hombre" <?php if($formulario_NC['sexo']=='Hombre') echo ' checked ';?> required/>
			Hombre </label>
		<label>
			<input name="sexo" type="radio" value="Mujer" <?php if($formulario_NC['sexo']=='Mujer') echo ' checked ';?> />
			Mujer</label>
		<label>
			<input name="sexo" type="radio" value="Otro" <?php if($formulario_NC['sexo']=='Otro') echo ' checked ';?>/>
			Otro</label>
		<br>
        
        <label for="profesion">Profesión</label>
        <input id="profesion" name="profesion" type="text" value="<?php echo $formulario_NC['profesion'];?>">
        <br>

        <label for="telefono">Teléfono</label>
        <input id="telefono" name="telefono" type="text" placeholder="123456789" pattern="^[0-9]{9}" value="<?php echo $formulario_NC['telefono'];?>">
        <br>

        <label for="dni">DNI<em>*</em></label>
        <input id="dni" name="dni" type="text" placeholder="12345678X" pattern="^[0-9]{8}[A-Z]" value="<?php echo $formulario_NC['dni'];?>" required>
        <br>

        <label for="email">Email</label>
        <input id="email" name="email" type="email" placeholder="usuario@dominio.extension" value="<?php echo $formulario_NC['email'];?>">
        <br>

        <label for="fechnaz">Fecha Nacimiento<em>*</em></label>
        <input type="date" id="fechnaz" name="fechnaz" value="<?php echo $formulario_NC['fechnaz'];?>" required>
        <br>

        <label for="fechreg">Fecha Registro<em>*</em></label>
        <?php
            $fecha_registro = date("j/n/Y");
        ?>
        <input type="text" id="fechreg" name="fechreg" value="<?php  echo $fecha_registro;?>"  readonly required>
        <br>
        
        
        <label for="razonvenida">Razón de Venida</label>
        <textarea name="razonvenida" id="razonvenida" rows="4" cols="50" placeholder="Describa la razón por la que viene..."><?php echo $formulario_NC['razonvenida'];?></textarea>
        
        <br>

        <label for="archivoCara">Foto de Peril</label>
        <input type="file" name="archivoCara" id="archivoCara">
        <br>

        <label for="archivoFirma">Firma<em>*</em></label>
        <input type="file" name="archivoFirma" id="archivoFirma" required>
        <br>

        <label for="franquicia">Franquicia<em>*</em></label>
	    <select  name="franquicia" id="franquicia" value="<?php echo $formulario_NC['franquicia'];?>" required>
        <option value="">-----</option>
        <?php
            $franquicias = $conexion->query("select nombreFranquicia from Franquicias");
            foreach($franquicias as $franquicia){?>
                <option value="<?=$franquicia[0]?>" <?php if($formulario_NC['franquicia']==$franquicia[0]) echo ' selected ';?>     > <?=$franquicia[0]?> </option>
        <?php }?>
        <br>
        
        <input type="hidden">
        <br>
        <button class="button" type="submit">Guardar Cliente</button>
    </form>
    </fieldset>

    <p>
    
    </p>
    <?php	
	    include_once("pie.php"); 
		cerrarConexionBD($conexion);
	?>
</body>
</html>