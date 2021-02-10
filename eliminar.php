<?php
    session_start();
    require_once("gestionBD.php");
    require_once("gestionarOfertas.php");
    $conexion = crearConexionBD();
    $oferta = $_SESSION["oferta"];
    if($oferta != "" and isset($oferta)){
        eliminarOFerta($conexion,$oferta);
    }    
    cerrarConexionBD($conexion);
    Header("Location:ofertas.php");
?>