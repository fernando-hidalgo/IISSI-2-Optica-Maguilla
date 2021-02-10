<?php

  function todosClientes($conexion){
      try{
          $consulta = "SELECT * FROM CLIENTES";
          $stmt = $conexion->query($consulta);
          return $stmt;
      }catch(PDOException $e){
          return array();
      }
      
  }

  function alta_cliente($conexion,$editCliente) {
    $resultado = false; 
    $fechaNacimiento = date('d/m/Y', strtotime($editCliente["fechnaz"]));
    if(clientes_iguales($conexion, $editCliente) == 0){
      try{
        $consulta = "CALL PR_registrar_cliente(:nombreFranquicia, :codigoPostal, :nombre, :apellido, :fechaNacimiento, :dni, :profesion, :telefono, :email, 
                    :razonVenida, :direccion, :sexo)";
        $stmt=$conexion->prepare($consulta);
        $stmt->bindParam(':nombreFranquicia',$editCliente["franquicia"]);
        $stmt->bindParam(':codigoPostal',$editCliente["codpost"]);
        $stmt->bindParam(':nombre',$editCliente["nombre"]);
        $stmt->bindParam(':apellido',$editCliente["apellidos"]);
        $stmt->bindParam(':fechaNacimiento',$fechaNacimiento);
        $stmt->bindParam(':dni',$editCliente["dni"]);
        $stmt->bindParam(':profesion',$editCliente["profesion"]);
        $stmt->bindParam(':telefono',$editCliente["telefono"]);
        $stmt->bindParam(':email',$editCliente["email"]);
        $stmt->bindParam(':razonVenida',$editCliente["razonvenida"]);
        $stmt->bindParam(':direccion',$editCliente["direccion"]);
        $stmt->bindParam(':sexo',$editCliente["sexo"]);
    
        $stmt->execute();
        $resultado = true;
    
      }catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
      }
    }
    return $resultado;
  }
    
    
  function clientes_iguales($conexion, $editCliente){
    try {
          $stmt = $conexion -> prepare("SELECT COUNT(*) FROM CLIENTES WHERE DNI = :dni");
          $stmt -> bindParam(":dni", $editCliente["dni"]);
          $stmt -> execute();
          return $stmt -> FetchColumn();
      } catch(PDOException $e) {
          echo("error: " . $e -> GetMessage());
      }
  }
    
  function baja_cliente($conexion,$oid_c) {
    $resultado_b = false; 
      try {
        $stmt=$conexion->prepare('CALL PR_eliminar_cliente(:oid_c)');
        $stmt->bindParam(':oid_c',$oid_c);
      $stmt->execute();
      $resultado_b = true;
      }catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
    }
    return $resultado_b;
  }
    
  function edicion_cliente($conexion, $editCliente) {
    $resultado = false;
    $fechaNacimiento = date('d/m/Y', strtotime($editCliente["fechnaz"]));
  
      try {
  
        $stmt = $conexion -> prepare("UPDATE CLIENTES SET nombre = :nombre, apellido=:apellidos,codigopostal = :codpost, fechanacimiento=:fechnaz,
        profesion=:profesion, telefono=:telefono, email=:email, direccion=:direccion, sexo=:sexo, RAZONVENIDA=:RAZONVENIDA WHERE dni = :dni");
        //$stmt->bindParam(':nombreFranquicia',$editCliente["franquicia"]);
        $stmt->bindParam(':nombre',$editCliente["nombre"]);
        $stmt->bindParam(':codpost',$editCliente["codpost"]);
        $stmt->bindParam(':apellidos',$editCliente["apellidos"]);
        $stmt->bindParam(':fechnaz',$fechaNacimiento);
        $stmt->bindParam(':profesion',$editCliente["profesion"]);
        $stmt->bindParam(':telefono',$editCliente["telefono"]);
        $stmt->bindParam(':email',$editCliente["email"]);
        $stmt->bindParam(':direccion',$editCliente["direccion"]);
        $stmt->bindParam(':sexo',$editCliente["sexo"]);
        $stmt->bindParam(':RAZONVENIDA',$editCliente["razonvenida"]);
    
        $stmt->bindParam(':dni',$editCliente["dni"]);
        $stmt -> execute();
        $resultado = true;
  
      }catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
      }
  
  return $resultado;
  }
    
    //ESTO SUSTITUYE USAR FOREACH
  function consultarDatosCliente($conexion, $dni) {
    try {
        $stmt = $conexion -> prepare("SELECT * FROM CLIENTES WHERE dni = :dni");
        $stmt -> bindParam(":dni", $dni);
        $stmt -> execute();
        return $stmt -> Fetch();
    } catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
    }
  }
    
    
  function eliminar_cliente_franquicia($conexion,$oid_c,$nF) {
    $resultado = false;
      try{
        $consulta = "CALL PR_elim_cliente_Franquicia(:oid_c, :nF)";
        $stmt=$conexion->prepare($consulta);
        $stmt->bindParam(':oid_c',$oid_c);
        $stmt->bindParam(':nF',$nF);
    
        $stmt->execute();
        $resultado = true;
    
      }catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
      }
    return $resultado;
  }
    
  function numero_inscritas($conexion,$oid_c){
    try {
        $stmt = $conexion -> prepare("SELECT COUNT(*) FROM TIENEN WHERE OID_C = :oid_c");
        $stmt->bindParam(':oid_c',$oid_c);
        $stmt -> execute();
        return $stmt -> FetchColumn();
      } catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
      }
  }
    
  function agregar_cliente_franquicia($conexion,$oid_c,$nF) {
    $resultado = false;
      try{
        
        $consulta = "CALL PR_agre_Cliente_Franquicia(:nF,:oid_c)";
        $stmt=$conexion->prepare($consulta);
        $stmt->bindParam(':oid_c',$oid_c);
        $stmt->bindParam(':nF',$nF);
    
        $stmt->execute();
        $resultado = true;
    
      }catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
      }
    return $resultado;
  }

  function SeleccionarOIDClientes($conexion){
    $consulta="SELECT * FROM CLIENTES";
    return $conexion->query($consulta);
  }
  
  function SeleccionarNombreClientes($conexion,$oid){
    try {
    $stmt = $conexion -> prepare("SELECT NOMBRE FROM CLIENTES WHERE OID_C = :oid");
    $stmt -> bindParam(":oid", $oid);
    $stmt -> execute();
    return $stmt -> Fetch();
    }catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
    }
  }
  function SeleccionarDNIClientes($conexion,$oid){
    try {
    $stmt = $conexion -> prepare("SELECT DNI FROM CLIENTES WHERE OID_C = :oid");
    $stmt -> bindParam(":oid", $oid);
    $stmt -> execute();
    return $stmt -> Fetch();
    }catch(PDOException $e) {
        echo("error: " . $e -> GetMessage());
    }
  }
?>
