<?php
session_start();
require_once("gestionBD.php");

// Comprobar que hemos llegado a esta página porque se ha rellenado el formulario
if (isset($_SESSION["formulario_EC"])) {
    // Recogemos los datos del formulario (Falta Fecha Registro porque no hay que validarlo, se coloca siempre automaticamente)
    $editCliente['nombre'] = $_REQUEST["nombre"];
    $editCliente['apellidos'] = $_REQUEST["apellidos"];
    $editCliente['codpost'] = $_REQUEST["codpost"];
    $editCliente['direccion'] = $_REQUEST["direccion"];
    $editCliente['sexo'] = $_REQUEST["sexo"];
    $editCliente['profesion'] = $_REQUEST["profesion"];
    $editCliente['telefono'] = $_REQUEST["telefono"];
    $editCliente['dni'] = $_REQUEST["dni"];
    $editCliente['email'] = $_REQUEST["email"];
    $editCliente['fechnaz'] = $_REQUEST["fechnaz"];
    $editCliente['razonvenida'] = $_REQUEST["razonvenida"];
    $editCliente['mas'] = $_REQUEST["mas"];
    $editCliente['menos'] = $_REQUEST["menos"];

    // Guardar la variable local con los datos del formulario en la sesión.
	$_SESSION["formulario_EC"] = $editCliente;

}
else // En caso contrario (que se ponga la URL de la validacion a mano), vamos al formulario
Header("Location: form_mostrar_editar_cliente.php");

//Validación
$conexion = crearConexionBD(); 
$errores = validarDatosCliente($conexion, $editCliente);
cerrarConexionBD($conexion);

//Subida de la imagen de Perfil
$newfilename = $editCliente['dni'];
move_uploaded_file($_FILES["archivoCara"]["tmp_name"], "images/cara/" . $newfilename . ".png");

//Subida de la imagen de Firma
$newfilename = $editCliente['dni'];
move_uploaded_file($_FILES["archivoFirma"]["tmp_name"], "images/firma/" . $newfilename . ".png");

// Si se han detectado errores
if (count($errores)>0) {
    // Guardo en la sesión los mensajes de error y volvemos al formulario
    $_SESSION["errores"] = $errores;
    Header('Location: form_mostrar_editar_cliente.php');
} else
    // Si todo va bien, vamos a la página de acción (inserción del cliente en la base de datos)
    Header('Location: accion_editar_cliente.php');


///////////////////////////////////////////////////////////
// Validación en servidor del formulario de alta de Cliente
///////////////////////////////////////////////////////////
function validarDatosCliente($conexion, $editCliente){ //Solo se valida lo obligatorio (*)
    $errores=array();

    // Validación del Nombre			
	if($editCliente["nombre"]=="") 
    $errores[] = "<p>El nombre no puede estar vacío</p>";

    // Validación de los Apellidos			
	if($editCliente["apellidos"]=="") 
    $errores[] = "<p>Los apellidos no pueden estar vacíos</p>";

    // Validación del Codigo Postal (Añadir comprobación de que el Codigo Postal está en la BD)
	if($editCliente["codpost"]=="") 
    $errores[] = "<p>El Codigo Postal no puede estar vacío</p>";
    else if(!preg_match("/^[0-9]{5}$/", $editCliente["codpost"])){
    $errores[] = "<p>El Codigo Postal debe contener 5 números: " . $editCliente["Codigo Postal"]. "</p>";
    }

    // Validación del sexo
	if($editCliente["sexo"] != "hombre" &&
    $editCliente["sexo"] != "mujer" && 
    $editCliente["sexo"] != "otro") {
    $errores[] = "<p>El sexo debe ser Hombre, Mujer u Otro</p>";
    }

    // Validación del DNI
	if($editCliente["dni"]=="") 
    $errores[] = "<p>El DNI no puede estar vacío</p>";
    else if(!preg_match("/^[0-9]{8}[A-Z]$/", $editCliente["dni"])){
    $errores[] = "<p>El DNI debe contener 8 números y una letra mayúscula: " . $editCliente["dni"]. "</p>";
    }

    // Validación de la Fecha Nacimiento (Como compruebo que no está despues de Fecha Registro?)		
	if($editCliente["fechnaz"]=="") 
    $errores[] = "<p>Debe seleccionar su fecha de nacimiento</p>";

    // Validación de la Franquicia		
	if($editCliente["franquicia"]=="-----") 
    $errores[] = "<p>Debe seleccionar una franquicia</p>";

}
?>