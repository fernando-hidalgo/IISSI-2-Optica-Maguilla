<?php	
	session_start();	
	require_once("gestionBD.php");
    require_once("gestionarEncargos.php");
    require_once("navBar.php");
    require_once("cabecera.php");    
        
        
    $idref = $_REQUEST["idref"];
    $descripcion = $_REQUEST["descripcion"];
    $clientes = $_REQUEST["clientes"];

    echo $idref."  ";
    echo $descripcion." " ;
    echo $clientes." " ;
        
    $conexion = crearConexionBD(); 
				
	$res= actualizar_encargos($conexion, $idref,$descripcion ,$clientes);	
	
			
		
	
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>actualizar encargo</title>
</head>
<body>
<fieldset class="formulario" style="width:350px">
    <?php if($res){
    Header("Location: paginacion_encargos.php");
    }else{ 
        echo "Ha habido un error";
        ?>
    <div >	
        Pulsa <a href="paginacion_encargos.php">aqui</a> para volver al inicio.
    </div>
        <?php } ?>     
</fieldset>
</body>
</html>

<?php cerrarConexionBD($conexion); ?>