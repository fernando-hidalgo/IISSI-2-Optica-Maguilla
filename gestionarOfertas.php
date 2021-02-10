<?php
function crear_oferta($conexion,$oferta) {
	try {
		$consulta = "CALL PR_presentar_Oferta(:nombre, :idProducto, :descuento, :descripcion, :franquicia)";
		$stmt=$conexion->prepare($consulta);
		$stmt->bindParam(':nombre',$oferta["NOMBREOFERTA"]);
		$stmt->bindParam(':idProducto',$oferta["IDREFERENCIAPRODUCTO"]);
		$stmt->bindParam(':descuento',$oferta["DESCUENTOOFERTA"]);
		$stmt->bindParam(':descripcion',$oferta["DESCRIPCION"]);
		$stmt->bindParam(':franquicia',$oferta["NOMBREFRANQUICA"]);
		$stmt->execute();
		
		return true;
	} catch(PDOException $e) {
		return false;
    }
}
 
function añadir_producto_oferta($conexion,$oferta) {
	try {
		$consulta = "CALL PR_añadirProducto_Oferta(:nombre, :idProducto, :descuento, :descripcion)";
		$stmt=$conexion->prepare($consulta);
		$stmt->bindParam(':nombre',$oferta["NOMBREOFERTA"]);
		$stmt->bindParam(':idProducto',$oferta["IDREFERENCIAPRODUCTO"]);
		$stmt->bindParam(':descuento',$oferta["DESCUENTOOFERTA"]);
		$stmt->bindParam(':descripcion',$oferta["DESCRIPCION"]);
		$stmt->execute();
		
		return true;
	} catch(PDOException $e) {
		return false;
    }
}

function existeOferta($conexion,$oferta){
	try{
		$consulta ="SELECT COUNT(*) AS TOTAL FROM OFERTAS WHERE NOMBREOFERTA =:nomOferta";
		$stmt = $conexion->prepare($consulta);
		$stmt->bindParam(':nomOferta',$oferta);
		$stmt->execute();
		if($stmt->fetchColumn() > 0){
			return TRUE;
		}
		return FALSE;
	}catch(PDOException $e){
		return FALSE;
	}
}

function editarOferta($conexion,$ofertaEntera){
	try{
		$consulta  = "DELETE FROM LINEASOFERTA WHERE NOMBREOFERTA = :nomOferta";
		$stmt = $conexion->prepare($consulta);
		$stmt->bindParam(':nomOferta',$ofertaEntera["NOMBREOFERTA"]);
		$stmt->execute();

		añadir_producto_oferta($conexion,$ofertaEntera);
		return TRUE;
	}catch(PDOException $e){
		return $e;
	}
}

function eliminarOFerta($conexion,$oferta){
	try{
		$consulta = " CALL PR_eliminar_Oferta (:nomOferta)";
		$stmt= $conexion->prepare($consulta);
		$stmt->bindParam(':nomOferta',$oferta);
		$stmt->execute();
		return TRUE;
	}catch(PDOException $e){
		return FALSE;
	}
}

function todasOfertas($conexion) {
	try{
		$consulta = "SELECT * FROM OFERTAS";
		$stmt= $conexion->query($consulta);
		return $stmt;
	}catch(PDOException $e){
		return array();
	}
}

function existeProductoEnOferta($conexion,$ofertaNombre,$idProducto){
	try{
		$consulta ="SELECT COUNT(*) AS N FROM LINEASOFERTA WHERE NOMBREOFERTA =:nomOferta AND IDREFERENCIAPRODUCTO =:idRef";
		$stmt = $conexion->prepare($consulta);
		$stmt->bindParam(':nomOferta',$ofertaNombre);
		$stmt->bindParam(':idRef',$idProducto);
		$stmt->execute();
		if($stmt->fetchColumn() > 0){
			return TRUE;
		}
		return FALSE;
	}catch(PDOException $e){
		return FALSE;
	}
}

function eliminarProductoOferta($conexion,$ofertaNombre,$idProducto){
	try{
		$consulta ="DELETE FROM LINEASOFERTA WHERE NOMBREOFERTA =:nomOferta AND IDREFERENCIAPRODUCTO =:idRef";
		$stmt = $conexion->prepare($consulta);
		$stmt->bindParam(':nomOferta',$ofertaNombre);
		$stmt->bindParam(':idRef',$idProducto);
		$stmt->execute();
		return TRUE;
	}catch(PDOException $e){
		return FALSE;
	}
}
?>