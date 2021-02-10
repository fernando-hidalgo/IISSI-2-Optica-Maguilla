<?php
  function graduar($conexion,$graduacion) {
    $resultado = false; 
      try{
        $consulta = "CALL PR_graduar_ClienteReducido(:OID_C, :graduadoPor, :atendidoPor, :ejeI, :lejosI, :cercaI, :ejeD, :lejosD, :cercaD)";
        $stmt=$conexion->prepare($consulta);
        $stmt->bindParam(':OID_C',$graduacion["oid_c"]);
        $stmt->bindParam(':graduadoPor',$graduacion["graduadoPor"]);
        $stmt->bindParam(':atendidoPor',$graduacion["atendidoPor"]);
        $stmt->bindParam(':ejeI',$graduacion["ejeI"]);
        $stmt->bindParam(':lejosI',$graduacion["lejosI"]);
        $stmt->bindParam(':cercaI',$graduacion["cercaI"]);
        $stmt->bindParam(':ejeD',$graduacion["ejeD"]);
        $stmt->bindParam(':lejosD',$graduacion["lejosD"]);
        $stmt->bindParam(':cercaD',$graduacion["cercaD"]);
    
        $stmt->execute();
        $resultado = true;
    
      }catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
      }
      return $resultado;
  }

  function consultarGraduacionesCliente($conexion, $oid_c) {
    try {
      $stmt = $conexion -> prepare("SELECT * FROM GRADUACIONES WHERE OID_C = :oid_c");
      $stmt -> bindParam(":oid_c", $oid_c);
      $stmt -> execute();
      return $stmt;
    } catch(PDOException $e) {
      echo("error: " . $e -> GetMessage());
    }
  }

  function consultarGraduacionesClientePorOIDG($conexion, $oid_g) {
    try {
      $stmt = $conexion -> prepare("SELECT * FROM GRADUACIONES WHERE OID_G = :oid_g");
      $stmt -> bindParam(":oid_g", $oid_g);
      $stmt -> execute();
      return $stmt-> Fetch();
    } catch(PDOException $e) {
      echo("error: " . $e -> GetMessage());
    }
  }

  function consultarOjos($conexion, $oid_g) {
    try {
      $stmt = $conexion -> prepare("SELECT * FROM OJOS WHERE OID_G = :oid_g");
      $stmt -> bindParam(":oid_g", $oid_g);
      $stmt -> execute();
      return $stmt;
    } catch(PDOException $e) {
      echo("error: " . $e -> GetMessage());
    }
  }

  function ConsultarOjo($conexion, $oid_o) {
    try {
      $stmt = $conexion -> prepare("SELECT * FROM OJOS WHERE OID_O = :oid_o");
      $stmt -> bindParam(":oid_o", $oid_o);
      $stmt -> execute();
      return $stmt-> Fetch();
    } catch(PDOException $e) {
      echo("error: " . $e -> GetMessage());
    }
  }

  function eliminar_graduacion($conexion, $oid_g){
    $resultado = false;
    try{
      $consulta = "CALL PR_elim_grad_Clie(:oid_g)";
      $stmt=$conexion->prepare($consulta);
      $stmt->bindParam(':oid_g',$oid_g);
  
      $stmt->execute();
      $resultado = true;
    }catch(PDOException $e) {
      echo("error: " . $e -> GetMessage());
    }
  return $resultado;
  }
?>