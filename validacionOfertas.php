<?php
    session_start();
    require_once("gestionBD.php");
    require_once("gestionarOfertas.php");
    $conexion = crearConexionBD();
    $ofertas = todasOfertas($conexion);
    $oferta = $_REQUEST["ofertaSeleccionada"];
    $eliminar = $_REQUEST["eliminar"];
    $editar = $_REQUEST["añadirProductos"];
    $check = !existeOferta($conexion,$oferta);
    cerrarConexionBD($conexion);
    if(!isset($_SESSION["oferta"])){
        Header("Location:ofertas.php");
        
    }else{
        $_SESSION["oferta"] = $oferta;
        if(isset($eliminar)){
            $_SESSION["oferta"] = $eliminar;
            Header("Location:eliminar.php");
        }else if(isset($editar)){
            $_SESSION["oferta"] = $editar;
            Header("Location:addProducto.php");
        }else if($oferta == "")
            Header("Location:accionOfertas.php");
        else if($check)
            Header("Location:ofertas.php");
        else
            Header("Location:accionOfertas.php");       
    }
?>