<?php

function todosProductos($conexion) {
	try{
		$consulta = "SELECT * FROM Productos";
		$stmt = $conexion->query($consulta);
		return $stmt;
	}catch(PDOException $e){
		return array();
	}
}

?>