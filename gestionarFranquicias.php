<?php


function alta_franquicia($conexion,$franquicia) {
  $resultado = false; 
  if(franquicias_iguales($conexion, $franquicia) == 0){
    try{
      $consulta = "CALL PR_registrar_franquicia(:nombreFranquicia, :direccion, :propietario)";
      $stmt=$conexion->prepare($consulta);
      $stmt->bindParam(':nombreFranquicia',$franquicia["nombre"]);
      $stmt->bindParam(':direccion',$franquicia["direccion"]);
      $stmt->bindParam(':propietario',$franquicia["propietario"]);
  
      $stmt->execute();
      $resultado = true;
  
    }catch(PDOException $e) {
      echo("error: " . $e -> GetMessage());
    }
  }
  return $resultado;
}

function todasFranquicias($conexion){
    try{
        $stmt = $conexion->prepare("SELECT * FROM FRANQUICIAS");
        $stmt->execute();
        return $stmt;
    }catch(PDOException $e){
        return array();
    }
}

function franquicias_iguales($conexion, $franquicia){
  try {
		$stmt = $conexion -> prepare("SELECT COUNT(*) FROM FRANQUICIAS WHERE nombreFranquicia = :nombre");
		$stmt -> bindParam(":nombre", $franquicia["nombre"]);
		$stmt -> execute();
		return $stmt -> FetchColumn();
	} catch(PDOException $e) {
		echo("error: " . $e -> GetMessage());
	}
}

function consultarDatosFranquicia($conexion, $n_franquicia) {
	try {
		$stmt = $conexion -> prepare("SELECT * FROM FRANQUICIAS WHERE nombreFranquicia = :nombre");
		$stmt -> bindParam(":nombre", $n_franquicia);
		$stmt -> execute();
		return $stmt -> Fetch();
	} catch(PDOException $e) {
		echo("error: " . $e -> GetMessage());
	}
}

function edicion_franquicia($conexion, $editFranquicia) {
  $resultado = false;
	try {
    
		$stmt = $conexion -> prepare("UPDATE FRANQUICIAS SET direccion=:direccion, propietario = :propietario WHERE nombreFranquicia = :nombreFranquicia");
    	$stmt->bindParam(':nombreFranquicia',$editFranquicia["nombre"]);
    	$stmt->bindParam(':direccion',$editFranquicia["direccion"]);
    	$stmt->bindParam(':propietario',$editFranquicia["propietario"]);
		$stmt -> execute();
		$resultado = true;

	} catch(PDOException $e) {
		echo("error: " . $e -> GetMessage());
	}
return $resultado;
}

function eliminar_franquicia($conexion,$n_franquicia) {
	$resultado = false; 
	  try {
		  $consulta = "CALL PR_eliminar_franquicia(:nombreFranquicia)";
		  $stmt=$conexion->prepare($consulta);
		  $stmt->bindParam(':nombreFranquicia',$n_franquicia);
		  $stmt->execute();
		  $resultado = true;
	  }catch(PDOException $e) {
		  echo("error: " . $e -> GetMessage());
	}
	return $resultado;
}

function consultarFranquiciasInscrito($conexion, $oid_c) {
	try {
		$stmt = $conexion -> prepare("SELECT nombreFranquicia FROM TIENEN WHERE OID_C = :oid_c");
		$stmt -> bindParam(":oid_c", $oid_c);
		$stmt -> execute();
		return $stmt;
	} catch(PDOException $e) {
		//echo("error: " . $e -> GetMessage());
		$_SESSION["exception"] = $e -> GetMessage();
		Header("location:exception.php");
	}
}

function listarNombreFranquicias($conexion) {
	try {
		$stmt = $conexion -> prepare("SELECT nombreFranquicia FROM FRANQUICIAS");
		$stmt -> bindParam(":nombre", $n_franquicia);
		$stmt -> execute();
		return $stmt;
	} catch(PDOException $e) {
		echo("error: " . $e -> GetMessage());
	}
}
?>
