<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarClientes.php");
require_once("navBar.php");
include_once("cabecera.php");

// Comprobar que hemos llegado a esta página porque se ha rellenado el formulario
if (isset($_SESSION["formulario_EC"])) {
    $editCliente = $_SESSION["formulario_EC"];
    $_SESSION["formulario_EC"] = null;
    $_SESSION["errores"] = null;
}
else 
	Header("Location: tabla_cliente.php");

$conexion = crearConexionBD(); 

$cliente = consultarDatosCliente($conexion, $editCliente["dni"]);
$oid_c_edir=$cliente[0];
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>Resultado de la edición del cliente</title>
</head>
<body>
	<main>
		<?php if (edicion_cliente($conexion, $editCliente)) {
			?>
			<fieldset class="formulario" style="width:350px">
			<?php
				if($editCliente["mas"] != ""){
					agregar_cliente_franquicia($conexion,$oid_c_edir,$editCliente["mas"]);
				}
				if(numero_inscritas($conexion, $oid_c_edir) == 1 and $editCliente["menos"] != ""){	
					echo "No se pudo eliminar la inscripción a la franquicia, pues es su ultima inscripción";
				}else{
					eliminar_cliente_franquicia($conexion,$oid_c_edir,$editCliente["menos"]);
				}
				echo "Cliente ".$editCliente["nombre"].", con DNI ".$editCliente["dni"]." editado";
			?>
			<div >	
			Pulsa <a href="<?php echo "form_mostrar_editar_cliente.php?btn_dni=".$editCliente["dni"]?>">aquí</a> para volver al perfil.
			</fieldset>
			</div>
		<?php } ?>		
	</main>
<?php
	include_once("pie.php");
	cerrarConexionBD($conexion);
?>
</body>
</html>
