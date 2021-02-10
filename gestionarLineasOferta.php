<?php
function descripcionOferta($conexion,$oferta){

    try{
        $res = "error";
        $consulta ="SELECT DESCRIPCION FROM LINEASOFERTA WHERE NOMBREOFERTA =:nomOferta";
        $stmt= $conexion->prepare($consulta);
        $stmt->bindParam(":nomOferta",$oferta);
        $stmt->execute();
        foreach($stmt as $st){
            $res = $st["DESCRIPCION"];
            break;
        }
        return $res;
    }catch(PDOException $e){
        return null;
    }
}

function lineasOferta($conexion,$oferta){

    try{
        $consulta ="SELECT * FROM LINEASOFERTA WHERE NOMBREOFERTA = :nomOferta";
        $stmt= $conexion->prepare($consulta);
        $stmt->bindParam(":nomOferta",$oferta);
        $stmt->execute();
        return $stmt;
    }catch(PDOException $e){
        return null;
    }
}
?>