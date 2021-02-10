<?php 
    session_start();
    require_once("gestionBD.php");

    if(isset($_SESSION["formulario"])){
        $nuevoEncargo["fechaPedida"]=$_REQUEST["fechaPedida"];
        $nuevoEncargo["fechaEntrega"]=$_REQUEST["fechaEntrega"];
        $nuevoEncargo["descripcion"]=$_REQUEST["descripcion"];
        $nuevoEncargo["clientes"]=$_REQUEST["clientes"];
        $nuevoEncargo["cantidadProducto1"]=$_REQUEST["cantidadProducto1"];
        $nuevoEncargo["producto1"]=$_REQUEST["producto1"];
        
        $_SESSION["formulario"]=$nuevoEncargo;
    }else
        Header("Location:formulario_encargos.php");
    $conexion=crearConexionBD();
    $errores= validarDatosEncargos($conexion,$nuevoEncargo);
    
    if(count($errores)>0){
        $_SESSION["errores"]=$errores;
        Header("Location:formulario_encargos.php");
    }else{
        Header("Location:accion_alta_encargos.php");
    }

function validarDatosEncargos($conexion,$nuevoEncargo){
    $errores=array();
    if($nuevoEncargo["descripcion"]==""){
        $errores[]="<p>La descripcion no puede estar vacía</p>";
    }
    if($nuevoEncargo["cantidadProducto1"]==""){
        $errores[]="<p>La cantidad no puede estar vacía</p>";
    }
    return $errores;
}


cerrarConexionBD($conexion);
?>