<?php

function Producto($conexion,$producto){
	$funciona = false;
    try {
		$consulta = "CALL PR_registrar_producto(:nombre, :can, :pre, :iva)";
		$stmt=$conexion->prepare($consulta);
		$stmt->bindParam(':nombre',$producto["nombreproducto"]);
		$stmt->bindParam(':can',$producto["cantidad"]);
		$stmt->bindParam(':pre',$producto["precio"]);
		$stmt->bindParam(':iva',$producto["IVA"]);

		
		$stmt->execute();
		$funciona = true;
	}
	catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
	}
	return $funciona;
}

function consultarDatosProducto($conexion, $id_prod) {
    try {
        $stmt = $conexion -> prepare("SELECT * FROM PRODUCTOS WHERE IDREFERENCIAPRODUCTO = :id_prod");
        $stmt -> bindParam(":id_prod", $id_prod);
        $stmt -> execute();
        return $stmt -> Fetch();
    } catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
    }
}
function edicion_Producto($conexion, $edicion_producto) {
	$resultado = false;
	  try {
  
		  $stmt = $conexion -> prepare("UPDATE PRODUCTOS SET NOMBRE = :nombre, CANTIDAD = :CANTIDAD, PRECIO = :PRECIO, IVA = :IVA WHERE IDREFERENCIAPRODUCTO = :id");
		  $stmt->bindParam(':nombre',$edicion_producto["nombreproducto"]);
		  $stmt->bindParam(':CANTIDAD',$edicion_producto["cantidad"]);
		  $stmt->bindParam(':PRECIO',$edicion_producto["precio"]);
		  $stmt->bindParam(':IVA',$edicion_producto["IVA"]);
		  $stmt->bindParam(':id',$edicion_producto["id_prod"]);
		  $stmt -> execute();
		  $resultado = true;
  
	  } catch(PDOException $e) {
		  echo("error: " . $e -> GetMessage());
	  }
  return $resultado;
  }
  function eliminar_prod($conexion,$eleminarProd) {
    $resultado = false; 
      try {
          $consulta = "CALL PR_eliminar_producto(:id_prod)";
          $stmt=$conexion->prepare($consulta);
          $stmt->bindParam(':id_prod',$eleminarProd["ID"]);
          $stmt->execute();
          $resultado = true;
      }catch(PDOException $e) {
          echo("error: " . $e -> GetMessage());
    }
    return $resultado;
}

?>