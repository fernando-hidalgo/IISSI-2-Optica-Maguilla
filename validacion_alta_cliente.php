<?php
    session_start();
    require_once("gestionBD.php");

    // Comprobar que hemos llegado a esta página porque se ha rellenado el formulario
	if (isset($_SESSION["formulario_NC"])) {
		// Recogemos los datos del formulario
		$nuevoCliente["nombre"] = $_REQUEST["nombre"];
		$nuevoCliente["apellidos"] = $_REQUEST["apellidos"];
		$nuevoCliente["codpost"] = $_REQUEST["codpost"];
		$nuevoCliente["direccion"] = $_REQUEST["direccion"];
		$nuevoCliente["sexo"] = $_REQUEST["sexo"];
		$nuevoCliente["profesion"] = $_REQUEST["profesion"];
		$nuevoCliente["telefono"] = $_REQUEST["telefono"];
		$nuevoCliente["dni"] = $_REQUEST["dni"];
		$nuevoCliente["email"] = $_REQUEST["email"];
		$nuevoCliente["fechnaz"] = $_REQUEST["fechnaz"];
        $nuevoCliente["razonvenida"] = $_REQUEST["razonvenida"];
        $nuevoCliente["franquicia"] = $_REQUEST["franquicia"];

    // Guardar la variable local con los datos del formulario en la sesión.
        $_SESSION["formulario_NC"] = $nuevoCliente;

    }else{
        Header("Location: form_nuevo_cliente.php");
    }
    // Validamos el formulario en servidor
	$conexion = crearConexionBD(); 
	$errores = validarDatosCliente($conexion, $nuevoCliente);
    cerrarConexionBD($conexion);
    
    // Si se han detectado errores
	if (count($errores)>0) {
		// Guardo en la sesión los mensajes de error y volvemos al formulario
		$_SESSION["errores"] = $errores;
		Header('Location: form_nuevo_cliente.php');
	} else
		// Si todo va bien, vamos a la página de acción (inserción del usuario en la base de datos)
        Header('Location: accion_alta_cliente.php');
        
    //Subida de la imagen de Perfil
    $newfilename = $nuevoCliente['dni'];
    move_uploaded_file($_FILES["archivoCara"]["tmp_name"], "images/cara/" . $newfilename . ".png");

    function validarDatosCliente($conexion, $nuevoCliente){
        $errores=array();
        // Validación del Nombre			
	    if($nuevoCliente["nombre"]=="") 
        $errores[] = "<p>El nombre no puede estar vacío</p>";

        // Validación de los Apellidos		
	    if($nuevoCliente["apellidos"]=="") 
        $errores[] = "<p>Los apellidos no pueden estar vacios</p>";

        // Validación del Sexo		
	    if($nuevoCliente["sexo"]=="") 
        $errores[] = "<p>Debe elegir alguna de las opciones de sexo</p>";

        //Validación del teléfno 
        if(!preg_match("/^[0-9]{9}$/", $nuevoCliente["telefono"]) and $nuevoCliente["telefono"]!=""){
            $errores[] = "<p>El número de teléfono debe ser 9 carácteres numéricos, por ejemplo, 123456789</p>";
        }

        // Validación del DNI
	    if($nuevoCliente["dni"]=="") 
        $errores[] = "<p>El DNI no puede estar vacío</p>";
        else if(!preg_match("/^[0-9]{8}[A-Z]$/", $nuevoCliente["dni"])){
        $errores[] = "<p>El DNI debe contener 8 números y una letra mayúscula, por ejemplo, 12345678X</p>";
        }

        // Validación del email
	    if(!filter_var($nuevoCliente["email"], FILTER_VALIDATE_EMAIL) and $nuevoCliente["email"]!=""){
		    $errores[] = "<p>El email debe seguir la estructura: x@x.xx</p>";
	    }

        //Validación de la Fecha Nacimiento
        if($nuevoCliente["fechnaz"]==""){
        $errores[] = "<p>Debe introducir su fecha de nacimiento</p>";
        }else if($nuevoCliente["fechnaz"]>date('Y-m-d')){
        $errores[] = "<p>No puede haber nacido en el futuro</p>";
        }

        //Validación de la Firma
        if (!empty($_FILES['archivoFirma']['tmp_name'])) {
            //Subida de la imagen de Firma
            $newfilename = $nuevoCliente['dni'];
            move_uploaded_file($_FILES["archivoFirma"]["tmp_name"], "images/firma/" . $newfilename . ".png");
        }else{
            $errores[] = "<p>Suba una foto de su firma </p>";
        }

        // Validación del Franquicia		
	    if($nuevoCliente["franquicia"]=="") 
        $errores[] = "<p>Debe elegir la franquicia en la que se inscribirá</p>";

        // Validación del Código Postal
        if($nuevoCliente["codpost"]==""){
            $errores[] = "<p>Debe introducir un código postal</p>";
        }else if(!preg_match("/^[0-9]{5}$/",$nuevoCliente["codpost"])){
            $errores[] = "<p>El código postal deben ser 5 carácteres numéricos, por ejemplo, 12345</p>";
        }else if(CodpostExiste($conexion, $nuevoCliente["codpost"]) == 0){
            $errores[] = "<p>El código postal no existe</p>";
        }
       

        return $errores;
    }


    function CodpostExiste($conexion, $codpost){
        try {
            $stmt = $conexion -> prepare("SELECT COUNT(*) FROM CodigosPostales WHERE codpostal = :codpost");
            $stmt -> bindParam(":codpost", $codpost);
            $stmt -> execute();
            return $stmt -> FetchColumn();
        } catch(PDOException $e) {
            echo("error: " . $e -> GetMessage());
        }

    }
?>