<?php
    session_start();
    require_once("gestionBD.php");
    require_once("gestionarOfertas.php");
    require_once("gestionarLineasOferta.php");
    $conexion = crearConexionBD();
    $descripcion = descripcionOferta($conexion,$_SESSION["oferta"]);
    foreach($_REQUEST["check"] as $checker){
        $ofertaExistente = [
            "NOMBREOFERTA" => $_SESSION["oferta"],
            "IDREFERENCIAPRODUCTO" => $_REQUEST["producto$checker"],
            "DESCUENTOOFERTA" => $_REQUEST["descuento$checker"],
            "DESCRIPCION" => $descripcion
        ];
        if(existeProductoEnOferta($conexion,$_SESSION["oferta"], $_REQUEST["producto$checker"])){
            eliminarProductoOferta($conexion,$_SESSION["oferta"],$_REQUEST["producto$checker"]);
        }
        añadir_producto_oferta($conexion,$ofertaExistente); 
    }
    cerrarConexionBD($conexion);
    Header("Location:ofertas.php");



?>