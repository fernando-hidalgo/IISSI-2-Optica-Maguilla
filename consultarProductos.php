<?php 


function seleccionarProductos($conexion){
    $consulta="SELECT * FROM PRODUCTOS";
    return $conexion->query($consulta);
}
?>