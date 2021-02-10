<?php
session_start();
require_once ("gestionBD.php");
require_once("gestionarClientes.php");
require_once("gestionarFranquicias.php");
$conexion = crearConexionBD();
$dni_click = ($_GET["btn_dni"]);
$cliente = consultarDatosCliente($conexion, $dni_click);
//El objetivo de este bloque de codigo es que si un apartado falla al validar, los que hayan salido bien se muestren
//Si no existen datos del formulario en la sesión, se crea una entrada con valores por defecto
if (!isset($_SESSION["formulario_EC"])) {
    $formulario_EC['nombre'] = $cliente[2];
    $formulario_EC['apellidos'] = $cliente[3];
    $formulario_EC['codpost'] = $cliente[1];
    $formulario_EC['direccion'] = $cliente[11];
    $formulario_EC['sexo'] = $cliente[12];
    $formulario_EC['profesion'] = $cliente[7];
    $formulario_EC['telefono'] = $cliente[8];
    $formulario_EC['dni'] = $dni_click;
    $formulario_EC['email'] = $cliente[9];
    $formulario_EC['fechnaz'] =  date('Y-m-d', strtotime($cliente[4]));
    $formulario_EC['razonvenida'] = $cliente[10];

    require_once("navBar.php");
    include_once("cabecera.php"); 

    $_SESSION["formulario_EC"] = $formulario_EC;
    }
    // Si ya existían valores, los cogemos para inicializar el formulario
    else
    $formulario_EC = $_SESSION["formulario_EC"];

    $array_si_esta = array();
    $data = consultarFranquiciasInscrito($conexion, $cliente[0]);
	foreach($data as $d) {
        array_push($array_si_esta,$d[0]);
    }

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
    <title>Perfil de Cliente</title>

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
   
   <fieldset class="formulario" style="width:750px">
    <h2><?php echo "Perfil del cliente ". $cliente[2] ?></h2>
    <form action="form_graduaciones.php" method="GET">
        <input type="hidden" id="oid_g" name="oid_g" value="">
        <button class="button" name="dni_grad" value="<?php echo $dni_click?>" type="submit">Graduaciones</button>
    </form>
    <br>
    <p>
		<i>Los campos obligatorios están marcados con </i><em>*</em> <i>(asterisco)</i>
    </p>
    <p>
		<i>Los campos no editables están marcados con </i><em>º</em> <i>(ordinal)</i>
    </p>
    
    
    <form method="POST" id="formulario_EC" action="validacion_edicion_cliente.php" enctype="multipart/form-data">

        <label for="nombre">Nombre<em>*</em></label>
        <input id="nombre" name="nombre" type="text" value="<?php echo $formulario_EC['nombre'];?>" required readonly>
        <br>
        
        <label for="apellidos">Apellidos<em>*</em></label>
        <input id="apellidos" name="apellidos" type="text" value="<?php echo $formulario_EC['apellidos'];?>" required readonly>
        <br>

        <label for="codpost">Código Postal<em>*</em></label>
        <input id="codpost" name="codpost" type="text" placeholder="12345" pattern="^[0-9]{5}" value="<?php echo $formulario_EC['codpost'];?>"  required readonly>
        <br>
        
        <label for="direccion">Dirección</label>
        <input id="direccion" name="direccion" type="text" value="<?php echo $formulario_EC['direccion'];?>" readonly>
        <br>

        <label>Sexo<em>*</em></label>
		<label>
			<input id=sexo name="sexo" type="radio" value="Hombre" <?php if($formulario_EC['sexo']=='Hombre')echo ' checked '; else echo 'disabled';?> required/>
			Hombre </label>
		<label>
			<input id=sexo name="sexo" type="radio" value="Mujer" <?php if($formulario_EC['sexo']=='Mujer') echo ' checked '; else echo 'disabled';?> />
			Mujer</label>
		<label>
			<input id=sexo name="sexo" type="radio" value="Otro" <?php if($formulario_EC['sexo']=='Otro') echo ' checked '; else echo 'disabled';?>/>
			Otro</label>
		<br>
        
        <label for="profesion">Profesión</label>
        <input id="profesion" name="profesion" type="text" value="<?php echo $formulario_EC['profesion'];?>" readonly>
        <br>

        <label for="telefono">Teléfono</label>
        <input id="telefono" name="telefono" type="text" placeholder="123456789" pattern="^[0-9]{9}" value="<?php echo $formulario_EC['telefono'];?>" readonly>
        <br>

        <label for="dni">DNI<em>º</em></label>
        <input id="dni" name="dni" type="text" placeholder="12345678X" pattern="^[0-9]{8}[A-Z]" value="<?php echo $formulario_EC['dni'];?>" required readonly>
        <br>

        <label for="email">Email</label>
        <input id="email" name="email" type="email" placeholder="usuario@dominio.extension" value="<?php echo $formulario_EC['email'];?>" readonly>
        <br>

        <label for="fechnaz">Fecha Nacimiento<em>*</em></label>
        <input type="date" id="fechnaz" name="fechnaz" value="<?php echo $formulario_EC['fechnaz'];?>" required readonly>
        <br>

        <label for="fechreg">Fecha Registro<em>º</em></label>
        <?php
            $fecha_registro = $cliente[5];
        ?>
        <input type="text" id="fechreg" name="fechreg" value="<?php  echo $fecha_registro;?>"  readonly required>
        <br>
        
        <label for="razonvenida">Razón de Venida</label>
        <textarea name="razonvenida" id="razonvenida" rows="4" cols="50" placeholder="Describa la razón por la que viene..." readonly ><?php echo $formulario_EC['razonvenida'];?></textarea>
        <br>

        <label for="archivoCara">Foto de Perfil</label>
        <?php
        $nombre_fichero = "images/cara/".$formulario_EC['dni'].".png";
        if (file_exists($nombre_fichero)) {
            ?>
            <img src="images/cara/<?php echo $formulario_EC['dni'];?>.png" width="75" height="75" alt="Foto de Peril">
            <?php
        }
        ?>
        <input type="file" name="archivoCara" id="archivoCara" disabled>
        <br>

        <label for="archivoFirma">Firma</label>
        <img src="images/firma/<?php echo $formulario_EC['dni'];?>.png" width="75" height="75" alt="Firma">
        <input type="file" name="archivoFirma" id="archivoFirma" disabled>
        <br>

        <div><label for="mas">Añadir a Franquicia</label>
				<select name="mas" id="mas" disabled>
                <option value="" >------------</option>
					<?php
						$NombresFranquicias = listarNombreFranquicias($conexion);
				  		foreach($NombresFranquicias as $n) {
                            if(!in_array ($n[0], $array_si_esta)){   
                        ?>
                            <option value="<?php  echo $n[0];?>" ><?php  echo $n[0];?></option>
                        <?php
                            }
						}
					?>
				</select>
		</div>

        <div><label for="menos">Eliminar de Franquicia</label>
				<select name="menos" id="menos" disabled>
                <option value="">------------</option>
					<?php
                        $franquiciasIns2 = consultarFranquiciasInscrito($conexion, $cliente[0]);
				  		foreach($franquiciasIns2 as $f2) {
                        ?>
                        <option value="<?php  echo $f2[0];?>"><?php  echo $f2[0];?></option>
                        <?php
						}
					?>
				</select>
		</div>

        <input id="botonGuardar" type="submit" value="Guardar" disabled/>
    </form>
    <input class="button "id="botonEditar" type="button" value="Editar" />
    <button class="button" onclick="eliminar()">Eliminar</button>
    </fieldset>
    
    <?php	
	    include_once("pie.php"); 
    ?>

    <script>
        document.getElementById('botonEditar').onclick = function() {
            document.getElementById('botonGuardar').removeAttribute('disabled');
            document.getElementById('nombre').removeAttribute('readonly');
            document.getElementById('apellidos').removeAttribute('readonly');
            document.getElementById('codpost').removeAttribute('readonly');
            document.getElementById('direccion').removeAttribute('readonly');
            document.getElementById('sexo').removeAttribute('readonly');
            document.getElementById('profesion').removeAttribute('readonly');
            document.getElementById('telefono').removeAttribute('readonly');
            //document.getElementById('dni').removeAttribute('readonly');
            document.getElementById('email').removeAttribute('readonly');
            document.getElementById('fechnaz').removeAttribute('readonly');
            document.getElementById('razonvenida').removeAttribute('readonly');
            document.getElementById('archivoCara').removeAttribute('disabled');
            document.getElementById('archivoFirma').removeAttribute('disabled');
            document.getElementById('mas').removeAttribute('disabled');
            document.getElementById('menos').removeAttribute('disabled');
            document.getElementById('sexo').removeAttribute('disabled');
            };
    </script>

    <script>
        function eliminar() {
            var confirma = window.confirm("¿Está seguro de querer eliminar el cliente? Se perderán todos sus datos personales, así como sus graduaciones");
            if (confirma) {
                window.location.href = "accion_baja_cliente.php";
            }
        }
    </script>
    <?php
		cerrarConexionBD($conexion);
	?>
</body>
</html>