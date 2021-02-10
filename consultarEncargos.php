<?php 


function seleccionarEncargos($conexion){
    $consulta="SELECT * FROM PRODUCTOS";
    return $conexion->query($consulta);
}
?>