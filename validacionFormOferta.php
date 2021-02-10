<?php
    session_start();
    require_once("gestionBD.php");
    require_once("gestionarOfertas.php");
    require_once("gestionarSeEnvianA.php");
    $conexion = crearConexionBD();
    $oferta = $_SESSION["oferta"];
    $check = existeOferta($conexion,$oferta);
    $descripcion = $_REQUEST["descripcion"];
    $_SESSION["errorForm"] = "false";
    $ofertaEntera =[
        "NOMBREOFERTA" => $_REQUEST["nombreOferta"],
        "IDREFERENCIAPRODUCTO" => $_REQUEST["producto0"],
        "DESCUENTOOFERTA" => $_REQUEST["descuento0"],
        "DESCRIPCION" => $descripcion,
        "NOMBREFRANQUICA" => $_REQUEST["franquicia"]
    ];
    if(strlen($descripcion)>100){
        Header("Location:ofertas.php");
    }else{
        if($_SESSION["lineasOfertaNum"]>1){
            for($k=0;$k<$_SESSION["lineasOfertaNum"];$k++){
                if(!(preg_match("/^0\,[0-9]+/", $_REQUEST["descuento".$k]))){
                    $checker = false;
                    Header("Location:ofertas.php");
                }else{
                    $checker = true;
                }
            }
            
        }else{
            $checker = preg_match("/^0\,[0-9]+/", $_REQUEST["descuento0"]);
        }
        if($checker){ 
            if(isset($_SESSION["checkValidacion"])){
                if($oferta == ""){
                    crear_oferta($conexion,$ofertaEntera);
                    eliminarEnviarAdeOferta($conexion,$oferta);
                    foreach ($_REQUEST["enviarA"] as $cliente) {
                        enviarA($conexion,$ofertaEntera["NOMBREOFERTA"],$cliente);
                    }
                    Header("Location:ofertas.php");
            
                }else if($check){
                    if($oferta == $_REQUEST["nombreOferta"]){
                        editarOferta($conexion,$ofertaEntera);
                        for($j=1;$j<$_SESSION["lineasOfertaNum"];$j++){
                            $ofertaEntera =[
                                "NOMBREOFERTA" => $_REQUEST["nombreOferta"],
                                "IDREFERENCIAPRODUCTO" => $_REQUEST["producto".$j],
                                "DESCUENTOOFERTA" => $_REQUEST["descuento".$j],
                                "DESCRIPCION" => $_REQUEST["descripcion"]
                            ];
                            unset($_SESSION["lineasOfertaNum"]);
                            if(!(existeProductoEnOferta($conexion,$_REQUEST["nombreOferta"],$_REQUEST["producto".$j]))){
                                añadir_producto_oferta($conexion,$ofertaEntera);
                            }
                        }
                        eliminarEnviarAdeOferta($conexion,$oferta);
                        foreach ($_REQUEST["enviarA"] as $cliente) {
                            enviarA($conexion,$oferta,$cliente);
                        }
                        Header("Location:ofertas.php");
                    }else{
                        Header("Location:ofertas.php");
                    }
                }else{
                    Header("Location:accionOfertas.php");
                }
            }else{
                Header("Location:ofertas.php");
            }
        }else{
            $_SESSION["errorForm"] = "true";
            $_SESSION["errorFormGuardado"] = $ofertaEntera;
            Header("Location:accionOfertas.php");
        }
    }
   
?>