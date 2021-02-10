<?php 
function consultarDatosEncargo($conexion, $idrefenc) {
    try {
        $stmt = $conexion -> prepare("SELECT * FROM ENCARGOS WHERE IDREFERENCIAENCARGO = :idrefenc");
        $stmt -> bindParam(":idrefenc", $idrefenc);
        $stmt -> execute();
        return $stmt -> Fetch();
    } catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
    }
}
function consultarLineasEncargo($conexion, $idrefenc) {
    try {
        $stmt = $conexion -> prepare("SELECT * FROM LINEASENCARGO WHERE OID_LE = :idrefenc");
        $stmt -> bindParam(":idrefenc", $idrefenc);
        $stmt -> execute();
        return $stmt -> Fetch();
    } catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
    }
    
}

function eliminarLineasEncargo($conexion,$oid_le){
    
    try {
		$stmt=$conexion->prepare('CALL PR_eliminarProducto_encargo(:oid_le)');
		$stmt->bindParam(':oid_le',$oid_le);
		$stmt->execute();
		return true;
	} catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
		return false;
    }
}

function actualizar_lineas_encargo($conexion,$oid_le,$cantidad){
    try {
		$stmt=$conexion->prepare('UPDATE LINEASENCARGO SET CANTIDAD = :cantidad WHERE OID_LE = :oid_le');
        $stmt->bindParam(':oid_le',$oid_le);
        $stmt->bindParam(':cantidad',$cantidad);
		$stmt->execute();
		return true;
	} catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
		return false;
    }
    
}

function RealizarEncargosBD($conexion,$encargos){
    $fechaEntrega = date('d / m / Y', strtotime($encargos["fechaEntrega"]));
    try {
        $consulta="CALL PR_realizar_encargo(:clientes,:productos,:descripcion,:cantidad)";
        
        $stmt=$conexion->prepare($consulta);
        $stmt->bindParam(':clientes',$encargos["clientes"]);
        $stmt->bindParam(':productos',$encargos["producto1"]);
        $stmt->bindParam(':descripcion',$encargos["descripcion"]);
        $stmt->bindParam(':cantidad',$encargos["cantidadProducto1"]);
        $stmt->execute();

        return true;
    } catch(PDOException $e) {
        return false;
        $e->getMessage();
		// Si queremos visualizar la excepción durante la depuración: $e->getMessage();
    }
}
function cancelarEncargo($conexion,$idref){
    
    try{
        $consulta  = "DELETE FROM ENCARGOS WHERE IDREFERENCIAENCARGO = :idref";
        $stmt = $conexion->prepare($consulta);
        $stmt->bindParam(':idref',$idref);
        $stmt->execute();

        eliminarLineasEncargoDeEncargo($conexion, $idref);
        return true;
    }catch(PDOException $e){
        return false;
    }
}
function actualizar_encargos($conexion, $idref,$descripcion ,$clientes){
    try {
		$stmt=$conexion->prepare('UPDATE ENCARGOS SET DESCRIPCION = :descripcion, OID_C = :clientes WHERE IDREFERENCIAENCARGO = :idref');
        $stmt->bindParam(':idref',$idref);
        $stmt->bindParam(':descripcion',$descripcion);
        $stmt->bindParam(':clientes',$clientes);
		$stmt->execute();
		return true;
	} catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
		return false;
    }
    
}


function eliminarLineasEncargoDeEncargo($conexion,$idref){
    
    try{
        $consulta  = "DELETE FROM LINEASENCARGO WHERE IDREFERENCIAENCARGO = :idref";
        $stmt = $conexion->prepare($consulta);
        $stmt->bindParam(':idref',$idref);
        $stmt->execute();

        return true;
    }catch(PDOException $e){
        return false;
    }
}
function actualizarFechaEntrega($conexion,$idref){
    $fechaPedida = date("j / n / Y");
    $fechaEntrega = date('d / m / Y', strtotime($fechaPedida));
    try{
        $stmt=$conexion->prepare('UPDATE ENCARGOS SET FECHAENTREGA = SYSDATE WHERE IDREFERENCIAENCARGO = :idref');
        $stmt->bindParam(':idref',$idref);
        
        $stmt->execute();
            return true;
        } catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
            return false;
        }
}


function añadirLineaEncargo($conexion,$idreferenciaProducto,$cantidad,$idreferenciaEncargo){
    try {
        $consulta="CALL PR_añadirProducto_encargo(:idprod,:idrefenc,:cantidad)";
        $stmt=$conexion->prepare($consulta);
        $stmt->bindParam(':idprod',$idreferenciaProducto);
        $stmt->bindParam(':idrefenc',$idreferenciaEncargo);
        $stmt->bindParam(':cantidad',$cantidad);
        
        $stmt->execute();

        return true;
    } catch(PDOException $e) {
        return false;
        $e->getMessage();
		// Si queremos visualizar la excepción durante la depuración: $e->getMessage();
    }


}

?>

