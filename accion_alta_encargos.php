<?php
    session_start();
    require_once("gestionBD.php");
    require_once("gestionarEncargos.php");
    require_once("navBar.php");
    require_once("cabecera.php");

    if(isset($_SESSION["formulario"])){
        //recogiendo datos de formulario
        $nuevoEncargo = $_SESSION["formulario"];
		$_SESSION["formulario"] = null;
		$_SESSION["errores"] = null;

    }else
        Header("Location: formulario_encargos.php");

    $conexion=crearConexionBD();
?>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/formulario.css">
    <title>Alta de Encargos</title>
</head>
<body>

   <main>
   <fieldset class="formulario" style="width:350px">   
   <?php if (RealizarEncargosBD($conexion,$nuevoEncargo))  { 
        echo "El encargo se ha realizado con exito";
		?>
				<div >	
			   		Pulsa <a href="paginacion_encargos.php">aquí</a> para acceder al inicio.
				</div>
		<?php } else { print_r($nuevoEncargo);?>
                <?php echo $nuevoEncargo["fechaEntrega"]; ?>
				<h1>Ha habido un error.</h1>
				<div >	
					Pulsa <a href="formulario_encargos.php">aquí</a> para volver al formulario o <a href="paginacion_encargos.php">aqui</a>
                    para volver al inicio.
				</div>
		<?php } ?>
    </fieldset>
   </main>  
</body>
</html>
<?php 
    include_once("pie.php");
    cerrarConexionBD($conexion); 
?>
