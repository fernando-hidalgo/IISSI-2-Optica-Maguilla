<?php
session_start();
$_SESSION["formulario_GRAD"] = null;
require_once("gestionBD.php");
require_once("gestionarClientes.php");
require_once("gestionarGraduaciones.php");
$conexion = crearConexionBD();
$dni_perf = ($_GET["dni_grad"]);
$oid_gclick = ($_GET["oid_g"]);
require_once("navBar.php");
include_once("cabecera.php"); 

//Dado el DNI, se obtiene los datos del cliente
$cliente = consultarDatosCliente($conexion, $dni_perf);

//Con el OID_C del cliente, se toman los OID_G de todas sus graduaciones
$array_oidg = array(); 
$data = consultarGraduacionesCliente($conexion,$cliente[0]); //se pasa el oid_c
foreach ($data as $d){
    array_push($array_oidg, $d["OID_G"]);
}
sort($array_oidg);
//Con esos OID_G, se consulta la infromación en la tabla GRADUACIONES
$tabla_graduaciones = consultarGraduacionesClientePorOIDG($conexion,$oid_gclick);

if($oid_gclick!=""){
//Como en una graduación los ojos comparten OID_G, se usa como parametro y se obtiene un array con ambos ojos, de los que se toman los OID_O
    $array_oid_o = array(); 
    $ojos = consultarOjos($conexion,$oid_gclick);
    foreach ($ojos as $ojo){
        array_push($array_oid_o, $ojo["OID_O"]);
    }
    //Con los OID_O (0 es Izq y 1 es Der), se obtiene la ifnromacion de la tabla OJOS
    $Ojo_Izquierdo = ConsultarOjo($conexion, $array_oid_o[0]);
    $Ojo_Derecho = ConsultarOjo($conexion, $array_oid_o[1]);
}

//Si estamos en el formulario en blanco, estás variables toman valor vacio y el día de hoy
else {
    $tabla_graduaciones["GRADUADOPOR"]="";
    $tabla_graduaciones["ATENDIDOPOR"]="";
    $tabla_graduaciones["FECHA"]=date("d/m/y");
    $Ojo_Izquierdo["EJE"]="";
    $Ojo_Izquierdo["LEJOS"]="";
    $Ojo_Izquierdo["CERCA"]="";
    $Ojo_Derecho["EJE"]="";
    $Ojo_Derecho["LEJOS"]="";
    $Ojo_Derecho["CERCA"]="";
    
    
}


if (!isset($_SESSION["formulario_GRAD"])) {
    $formulario_GRAD['oid_g'] = $oid_gclick;
    $formulario_GRAD['dni'] = $cliente[6];
    $formulario_GRAD['graduadoPor'] = $tabla_graduaciones["GRADUADOPOR"];
    $formulario_GRAD['atendidoPor'] = $tabla_graduaciones["ATENDIDOPOR"];
    $formulario_GRAD['fechagrad'] = $tabla_graduaciones["FECHA"];
    $formulario_GRAD['ejeI'] = $Ojo_Izquierdo["EJE"];
    $formulario_GRAD['lejosI'] = $Ojo_Izquierdo["LEJOS"];
    $formulario_GRAD['cercaI'] = $Ojo_Izquierdo["CERCA"];
    $formulario_GRAD['ejeD'] = $Ojo_Derecho["EJE"];
    $formulario_GRAD['lejosD'] = $Ojo_Derecho["LEJOS"];
    $formulario_GRAD['cercaD'] = $Ojo_Derecho["CERCA"];

    $_SESSION["formulario_GRAD"] = $formulario_GRAD;
}else{
    $formulario_GRAD = $_SESSION["formulario_GRAD"];
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/formulario_grad.css">
    <title>Graduación</title>
</head>
<body>
    <fieldset class="formulario" style="width:350px">
    <h2><?php echo "Graduaciones del cliente ". $cliente[2] ?></h2>
    <table class="fixed_header" id="tabla">
        <thead> 
            <tr>
                <th>Numero de Graduacion</th>
            </tr>
        </thead>
        <tbody>
            <?php
            $i=1;
            foreach($array_oidg as $row){
            ?>
                <tr>
                    <th>
                    <form action="form_graduaciones.php" method="GET">
                        <input class="button" type="hidden" id="dni_grad" name="dni_grad" value="<?php echo $dni_perf?>">
                        <button class="button" name="oid_g" type="submit" value="<?php echo $row?>"><?php echo $i?></button>
                    </form>
                    </th>
                </tr>
            <?php
            $i++;
            }
            ?>
        </tbody> 
    </table>

    
    <form method="GET" id="formulario_GRAD" action="accion_graduar.php">
        <input type="hidden" id="custId" name="id_c" value="<?php echo $cliente[0];?>">
        <input type="hidden" id="dni" name="dni" value="<?php echo $cliente[6];?>">

        <label for="graduadoPor">Graduado Por</label>
        <input id="graduadoPor" name="graduadoPor" type="text" value="<?php echo $formulario_GRAD['graduadoPor'];?>">
        <br>

        <label for="atendidoPor">Atendido Por</label>
        <input id="atendidoPor" name="atendidoPor" type="text" value="<?php echo $formulario_GRAD['atendidoPor'];?>">
        <br>

        <label for="fechagrad">Fecha Graduación<em>*</em></label>
        <input type="text" id="fechagrad" name="fechagrad" value="<?php  echo $formulario_GRAD['fechagrad'];?>"  readonly required>
        <br>
        
        <fieldset style="width:350px">
            <legend>Ojo Izquierdo</legend>

            <label for="ejeI">Eje</label>
            <input id="ejeI" name="ejeI" type="text" value="<?php echo $formulario_GRAD['ejeI'];?>" pattern="^[0-9]{1},[0-9]+" placeholder="x,xx">
            <br>

            <label for="lejosI">Lejos</label>
            <input id="lejosI" name="lejosI" type="text" value="<?php echo $formulario_GRAD['lejosI'];?>" pattern="^[0-9]{1},[0-9]+" placeholder="x,xx">
            <br>

            <label for="cercaI">Cerca</label>
            <input id="cercaI" name="cercaI" type="text" value="<?php echo $formulario_GRAD['cercaI'];?>" pattern="^[0-9]{1},[0-9]+" placeholder="x,xx">
            <br>
            
        </fieldset>
        <fieldset style="width:350px">
            <legend>Ojo Derecho</legend>

            <label for="ejeD">Eje</label>
            <input id="ejeD" name="ejeD" type="text" value="<?php echo $formulario_GRAD['ejeD'];?>" pattern="^[0-9]{1},[0-9]+" placeholder="x,xx">
            <br>

            <label for="lejosD">Lejos</label>
            <input id="lejosD" name="lejosD" type="text" value="<?php echo $formulario_GRAD['lejosD'];?>" pattern="^[0-9]{1},[0-9]+" placeholder="x,xx">
            <br>

            <label for="cercaD">Cerca</label>
            <input id="cercaD" name="cercaD" type="text" value="<?php echo $formulario_GRAD['cercaD'];?>" pattern="^[0-9]{1},[0-9]+" placeholder="x,xx">
            <br>
        </fieldset>

    <input class="button" type="submit" name="botonGuardar" value="Guardar" />
    </form>
    <button class="button" onclick="eliminar()">Eliminar</button>
    </fieldset>

    <script>
        function eliminar() {
            var confirma = window.confirm("¿Está seguro de querer eliminar esta graduación? Se perderá la información");
            if (confirma) {
                window.location.href = "accion_eliminar_graduacion.php";
            }
        }
    </script>

    <?php
        include_once("pie.php"); 
		cerrarConexionBD($conexion);
	?>
</body>
</html>