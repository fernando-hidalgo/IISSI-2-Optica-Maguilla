<?php

function todoSeEnvianA($conexion,$oferta){
    try{
        $consulta = "SELECT OID_C FROM SEENVIANA WHERE NOMBREOFERTA = :nomOferta";
        $stmt = $conexion->prepare($consulta);
        $stmt->bindParam(":nomOferta",$oferta);
        $stmt->execute();
        return $stmt;
    }catch(PDOException $e){
        return array();
    }
}

function enviarA($conexion,$oferta,$cliente){
    try{
        $consulta = "INSERT INTO SEENVIANA (NOMBREOFERTA,OID_C) VALUES (:nomOferta,:oidC)";
        $stmt = $conexion->prepare($consulta);
        $stmt->bindParam(":nomOferta",$oferta);
        $stmt->bindParam(":oidC",$cliente);
        $stmt->execute();
        return TRUE;
    }catch(PDOException $e){
        return FALSE;
    }
}

function eliminarEnviarAdeOferta($conexion,$oferta){
    try{
        $consulta = "DELETE FROM SEENVIANA WHERE NOMBREOFERTA = :nomOferta";
        $stmt = $conexion->prepare($consulta);
        $stmt->bindParam(":nomOferta",$oferta);
        $stmt->execute();
        return TRUE;
    }catch(PDOException $e){
        return FALSE;
    }
    
}

?>